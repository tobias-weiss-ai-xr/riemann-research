#!/usr/bin/env bash
# status.sh — task status machine for taskfleet.
#
# State lives in $STATUS_JSON. Schema:
#   {
#     "<TASK_ID>": {
#       "status": "ready|running|verifying|done|failed|blocked",
#       "attempts": <int>,
#       "worker": "<name>" | null,
#       "branch": "<branch>" | null,
#       "started_at": "<iso>" | null,
#       "finished_at": "<iso>" | null,
#       "last_error": "<string>" | null,
#       "next_retry_at": "<iso>" | null
#     }, ...
#   }
#
# The orchestrator merges tasks.json (declarative) with STATUS_JSON (runtime)
# to decide what to dispatch next.
#
# All writes to STATUS_JSON are serialised via TF_STATUS_LOCK (flock) because
# concurrent background dispatches do read-modify-write on this file.

# shellcheck source=common.sh
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

TF_STATUS_LOCK="$TF_STATE_DIR/status.lock"

# tf_locked_mv <tmp> <dest>: atomically replace dest under the status lock.
# Refuses to overwrite with empty/invalid JSON — keeps previous state instead
# so a failed jq write can never corrupt the status file.
tf_locked_mv() {
  local tmp="$1" dest="$2"
  if [[ ! -s "$tmp" ]] || ! jq -e . "$tmp" >/dev/null 2>&1; then
    tf_error "refusing invalid JSON write to $dest (tmp empty/unparseable); state unchanged"
    rm -f "$tmp"
    return 1
  fi
  # Ensure the destination directory exists (fresh sandbox / missing dir).
  mkdir -p "$(dirname "$dest")" "$(dirname "$TF_STATUS_LOCK")"
  (
    flock 9
    mv "$tmp" "$dest"
  ) 9>"$TF_STATUS_LOCK"
}

# Initialise STATUS_JSON with every task in "ready" state. Idempotent: keeps
# existing entries, adds missing tasks as ready.
tf_status_init() {
  tf_require_jq || return 1
  local tmp
  tmp="$(mktemp)"
  # Start from existing state (or {}), then ensure every known task exists.
  # If the existing file is corrupted (crash/torn write), fall back to {} so
  # we always rebuild a valid ledger instead of propagating the corruption.
  local existing="{}"
  if [[ -f "$STATUS_JSON" ]]; then
    if jq -e . "$STATUS_JSON" >/dev/null 2>&1; then
      existing="$(cat "$STATUS_JSON")"
    else
      tf_warn "status file corrupt ($STATUS_JSON); rebuilding from tasks.json"
    fi
  fi
  if ! jq --argjson existing "$existing" '
    [ $existing ] as $e
    | reduce .tasks[] as $t ($e[0];
      if has($t.id) then . else
        .[$t.id] = {
          status: "ready", attempts: 0, worker: null, branch: null,
          started_at: null, finished_at: null, last_error: null, next_retry_at: null
        }
      end)
  ' "$TASKS_JSON" > "$tmp"; then
    # Also recover if $existing itself was unparseable (shouldn't happen now).
    tf_warn "rebuilding status from tasks.json only (previous state unusable)"
    jq '
      reduce .tasks[] as $t ({};
        .[$t.id] = {
          status: "ready", attempts: 0, worker: null, branch: null,
          started_at: null, finished_at: null, last_error: null, next_retry_at: null
        })
    ' "$TASKS_JSON" > "$tmp"
  fi
  tf_locked_mv "$tmp" "$STATUS_JSON"
  tf_info "initialised status for $(jq 'length' "$STATUS_JSON") tasks"
}

# tf_status_get <task_id> <field>   (field includes leading dot, e.g. .status)
tf_status_get() {
  tf_require_jq || return 1
  jq -r --arg id "$1" '.[$id] | '"$2"' // empty' "$STATUS_JSON"
}

# tf_status_set <task_id> <status> [extra-jq-assignments]
# e.g. tf_status_set DM-3 running '.worker="zai"|.branch="agent/DM-3"'
tf_status_set() {
  tf_require_jq || return 1
  local id="$1" status="$2" extra="${3:-}"
  local tmp now
  tmp="$(mktemp)"; now="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  local ts=""
  case "$status" in
    running|verifying) ts=' | .[$id].started_at=$now' ;;
    done|failed|blocked) ts=' | .[$id].finished_at=$now' ;;
  esac
  local ex=""
  [[ -n "$extra" ]] && ex=" | $extra"
  jq --arg id "$id" --arg status "$status" --arg now "$now" \
    '.[$id].status=$status'"$ts""$ex" "$STATUS_JSON" > "$tmp"
  tf_locked_mv "$tmp" "$STATUS_JSON"
}

# Is a task ready to dispatch? ready := status==ready AND all deps done
# (and if it previously failed, next_retry_at has passed).
tf_is_ready() {
  local id="$1"
  local status deps dep_status
  status="$(tf_status_get "$id" .status)"
  [[ "$status" == "ready" ]] || {
    # failed tasks become ready again after cooldown
    [[ "$status" == "failed" ]] || return 1
    local nr
    nr="$(tf_status_get "$id" .next_retry_at)"
    [[ -n "$nr" ]] || return 1
    # if next_retry_at <= now, flip to ready
    if [[ "$nr" < "$(date -u +%Y-%m-%dT%H:%M:%SZ)" ]]; then
      tf_status_set "$id" ready
      return 0
    fi
    return 1
  }
  # all deps must be done
  deps="$(tf_task_field "$id" '.deps[]')"
  local all_done=1
  while IFS= read -r dep; do
    [[ -z "$dep" ]] && continue
    dep_status="$(tf_status_get "$dep" .status)"
    [[ "$dep_status" == "done" ]] || all_done=0
  done <<< "$deps"
  [[ $all_done -eq 1 ]]
}

# tf_ready_task_ids → newline-separated list of task IDs that are currently
# dispatchable (naive: status ready and all deps done). Used for deadlock
# detection alongside the smart scheduler.
tf_ready_task_ids() {
  local id
  while IFS= read -r id; do
    [[ -z "$id" ]] && continue
    tf_is_ready "$id" && echo "$id"
  done < <(jq -r 'to_entries[] | select(.value | type=="object" and has("status")) | .key' "$STATUS_JSON")
}

# Is a task speculatively ready? ready := status==ready AND all deps except
# exactly ONE are done, that ONE is running, and TF_SPECIAL_DISPATCH_ENABLED=1.
tf_is_speculatively_ready() {
  local id="$1"
  local enabled="${TF_SPECULATIVE_DISPATCH_ENABLED:-0}"
  [[ "$enabled" == "1" ]] || return 1

  local status deps dep_status dep
  status="$(tf_status_get "$id" .status)"
  [[ "$status" == "ready" ]] || return 1

  deps="$(tf_task_field "$id" '.deps[]')"
  [[ -n "$deps" ]] || return 1  # no deps = not speculative

  local done_count=0 running_count=0 blocked_count=0 not_done_dep=""
  while IFS= read -r dep; do
    [[ -z "$dep" ]] && continue
    dep_status="$(tf_status_get "$dep" .status)"
    case "$dep_status" in
      done) done_count=$((done_count + 1)) ;;
      running|verifying) running_count=$((running_count + 1)); not_done_dep="$dep" ;;
      *) blocked_count=$((blocked_count + 1)); not_done_dep="$dep" ;;
    esac
  done <<< "$deps"

  # Speculatively ready = exactly one running dep, NO blocked deps,
  # and all other deps (if any) are done.
  # For a task with only one dep: that dep must be running.
  # For a task with multiple deps: exactly one running, rest must be done.
  local total_deps
  total_deps="$(echo "$deps" | wc -l)"
  [[ $running_count -eq 1 ]] && [[ $blocked_count -eq 0 ]] && [[ $((running_count + done_count)) -eq $total_deps ]]
}

# Get the single running dependency for a speculatively-ready task.
# Only valid if tf_is_speculatively_ready returns true.
tf_speculative_base_dep() {
  local id="$1"
  deps="$(tf_task_field "$id" '.deps[]')"
  local running_dep=""
  while IFS= read -r dep; do
    [[ -z "$dep" ]] && continue
    dep_status="$(tf_status_get "$dep" .status)"
    if [[ "$dep_status" == "running" || "$dep_status" == "verifying" ]]; then
      running_dep="$dep"
      break
    fi
  done <<< "$deps"
  echo "$running_dep"
}

# List ids of all currently-running/verifying tasks.
tf_running_task_ids() {
  tf_require_jq || return 1
  jq -r 'to_entries[] | select(.value | type=="object" and has("status")) | select(.value.status=="running" or .value.status=="verifying") | .key' "$STATUS_JSON"
}

# Count tasks by status. Usage: tf_count_status done
# Robust: only counts entries that are objects with a status field (ignores
# any stray metadata keys).
tf_count_status() {
  tf_require_jq || return 1
  jq -r --arg s "$1" '[to_entries[] | select(.value | type=="object" and has("status")) | select(.value.status==$s)] | length' "$STATUS_JSON"
}

# Pretty-print the current status board.
tf_status_board() {
  tf_require_jq || return 1
  {
    printf '%-8s %-12s %-10s %-8s %s\n' "TASK" "STATUS" "WORKER" "ATTMP" "ENGINE/TITLE"
    printf '%-8s %-12s %-10s %-8s %s\n' "----" "------" "-------" "-----" "------------"
    jq -r --slurpfile tasks "$TASKS_JSON" '
      ($tasks[0].tasks | map({key:.id, value:.}) | from_entries) as $meta
      | [to_entries[] | select(.value | type=="object" and has("status"))] | sort_by(.key)
      | .[] | "\(.key)\t\(.value.status)\t\(.value.worker // "-")\t\(.value.attempts)\t\($meta[.key].engine // "?")/\($meta[.key].title // "?")"
    ' "$STATUS_JSON" | while IFS=$'\t' read -r id status worker attempts title; do
      printf '%-8s %-12s %-10s %-8s %s\n' "$id" "$status" "${worker:- -}" "${attempts:-0}" "$title"
    done
  }
}

# Mark a task failed and schedule a retry if attempts remain.
# Enriches the error with classification from verify.sh.
# Applies category-specific retry policies (configurable via retry_policies).
tf_fail_task() {
  local id="$1" err="${2:-unknown error}"
  local attempts max cooldown
  attempts="$(tf_status_get "$id" .attempts)"
  attempts=$((attempts + 1))
  max="$(tf_default max_attempts)"; max="${max:-2}"
  cooldown="$(tf_default retry_cooldown_s)"; cooldown="${cooldown:-30}"

  # Enrich error with classification from verify.sh (lazy source to avoid circular dep)
  local category summary _tf_verify_sourced
  _tf_verify_sourced="${_TF_VERIFY_SOURCED:-0}"
  if [[ "$_tf_verify_sourced" == "0" ]]; then
    # shellcheck source=verify.sh
    . "$(dirname "${BASH_SOURCE[0]}")/verify.sh"
    _TF_VERIFY_SOURCED=1
  fi
  category="$(tf_get_error_category "$id")"
  summary="$(tf_get_error_summary "$id")"
  [[ "$category" == "none" ]] && category="unknown"
  local enriched_err="$err [$category] $summary"

  # --- Category-specific early termination ---
  # no_op: the LLM produced no changes. If this is the second consecutive no_op,
  # permanently fail — the same prompt will likely produce the same result.
  local no_op_max
  no_op_max="$(tf_default no_op_max_attempts)"; no_op_max="${no_op_max:-2}"
  if [[ "$category" == "no_op" && $attempts -ge $no_op_max ]]; then
    local tmp now
    tmp="$(mktemp)"; now="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
    jq --arg id "$id" --arg a "$attempts" --arg e "$enriched_err" \
      --arg cat "$category" --arg sum "$summary" --arg now "$now" \
      '.[$id].status="failed" | .[$id].attempts=($a|tonumber) | .[$id].last_error=$e
       | .[$id].error_category=$cat | .[$id].error_summary=$sum
       | .[$id].worker=null | .[$id].next_retry_at=null | .[$id].finished_at=$now' \
       "$STATUS_JSON" > "$tmp"
    tf_locked_mv "$tmp" "$STATUS_JSON"
    tf_error "$id: FAILED permanently — $attempts consecutive no_op(s) (prompt likely cannot elicit changes)"
    return 0
  fi

  # timeout: store a multiplier so next dispatch gets more time.
  if [[ "$category" == "timeout" ]]; then
    local multiplier
    multiplier="$(tf_default timeout_retry_multiplier)"; multiplier="${multiplier:-1.5}"
    local current_mult
    current_mult="$(tf_status_get "$id" .timeout_multiplier)"
    current_mult="${current_mult:-1}"
    local new_mult
    new_mult="$(echo "$current_mult * $multiplier" | bc -l 2>/dev/null)"
    new_mult="${new_mult:-1.5}"
    local tmp
    tmp="$(mktemp)"
    jq --arg id "$id" --arg m "$new_mult" '.[$id].timeout_multiplier = ($m|tonumber)' \
      "$STATUS_JSON" > "$tmp"
    tf_locked_mv "$tmp" "$STATUS_JSON"
    tf_info "$id: timeout retry — dispatch timeout multiplier set to $new_mult"
  fi

  if [[ $attempts -ge $max ]]; then
    local tmp now
    tmp="$(mktemp)"; now="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
    jq --arg id "$id" --arg a "$attempts" --arg e "$enriched_err" \
      --arg cat "$category" --arg sum "$summary" --arg now "$now" \
      '.[$id].status="failed" | .[$id].attempts=($a|tonumber) | .[$id].last_error=$e
       | .[$id].error_category=$cat | .[$id].error_summary=$sum
       | .[$id].worker=null | .[$id].next_retry_at=null | .[$id].finished_at=$now' \
       "$STATUS_JSON" > "$tmp"
    tf_locked_mv "$tmp" "$STATUS_JSON"
    tf_error "$id: FAILED permanently after $attempts attempts — $enriched_err"
  else
    local tmp now retry_at
    tmp="$(mktemp)"; now="$(date -u +%s)"
    retry_at="$(date -u -d "@$((now + cooldown))" +%Y-%m-%dT%H:%M:%SZ)"
    jq --arg id "$id" --arg a "$attempts" --arg e "$enriched_err" \
      --arg cat "$category" --arg sum "$summary" --arg r "$retry_at" \
      '.[$id].status="failed" | .[$id].attempts=($a|tonumber) | .[$id].last_error=$e
       | .[$id].error_category=$cat | .[$id].error_summary=$sum
       | .[$id].worker=null | .[$id].next_retry_at=$r' \
       "$STATUS_JSON" > "$tmp"
    tf_locked_mv "$tmp" "$STATUS_JSON"
    tf_warn "$id: failed (attempt $attempts/$max), retry after $retry_at — $enriched_err"
  fi
}

# Mark done
tf_done_task() {
  local id="$1"
  local tmp now
  tmp="$(mktemp)"; now="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  jq --arg id "$id" --arg now "$now" \
    '.[$id].status="done" | .[$id].finished_at=$now | .[$id].worker=null
     | .[$id].last_error=null | .[$id].next_retry_at=null' \
     "$STATUS_JSON" > "$tmp"
  tf_locked_mv "$tmp" "$STATUS_JSON"
  tf_info "$id: DONE"
}
