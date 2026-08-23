#!/usr/bin/env bash
# orchestrator.sh — main loop for taskfleet.
#
# Continuously dispatches ready tasks to free workers until all are done (or
# permanently failed / blocked). Each worker runs in an isolated git worktree.
#
# Usage:
#   orchestrator.sh                 # run until done
#   orchestrator.sh --once          # one dispatch round, then exit
#   orchestrator.sh --dry-run       # show what would run, change nothing
#   orchestrator.sh --status        # print the status board and exit
#   orchestrator.sh --worker NAME   # restrict to a single worker
#   orchestrator.sh --task ID       # dispatch exactly one task (ignore others)
#   orchestrator.sh --poll SECONDS  # sleep between rounds (default 15)
#   orchestrator.sh --max-parallel N  # max concurrent dispatches
#   orchestrator.sh cost [--last|--since DATE|--task ID]  # receipt cost report
#   orchestrator.sh api add --task <desc> [--priority N] [--scope FILE] [--accept CMD]
#                       # create new task, returns task_id
#   orchestrator.sh api status [--json] [--task ID]
#                       # print status board or JSON for specific task
#   orchestrator.sh api results [--task ID]
#                       # print gate output and diff for completed task
#   orchestrator.sh attach TASK_ID  # stream live output for running task
#
# Env:
#   TF_MAX_PARALLEL  (default = number of enabled workers)
#   TF_MAX_ROUNDS    (default unlimited)
#   TF_MERGE_LOCK    (default state/merge.lock)

set -uo pipefail

TF_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
. "$TF_DIR/lib/common.sh"
# shellcheck source=lib/status.sh
. "$TF_DIR/lib/status.sh"
# shellcheck source=lib/worktree.sh
. "$TF_DIR/lib/worktree.sh"
# shellcheck source=lib/dispatch.sh
. "$TF_DIR/lib/dispatch.sh"
# shellcheck source=lib/schedule.sh
. "$TF_DIR/lib/schedule.sh"
# shellcheck source=lib/receipt.sh
. "$TF_DIR/lib/receipt.sh"
# shellcheck source=lib/affinity.sh
. "$TF_DIR/lib/affinity.sh"
# shellcheck source=lib/sources.sh
. "$TF_DIR/lib/sources.sh"

tf_require_jq || exit 1
command -v pi >/dev/null 2>&1       || { tf_error "pi not on PATH"; exit 1; }
git -C "$TF_REPO_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1 \
  || { tf_error "TF_REPO_DIR ($TF_REPO_DIR) is not a git repository. Set TF_REPO_DIR to the repo root."; exit 1; }

# --- Startup cleanup: ensure main worktree is pristine ---
# Failed merges or interrupted runs can leave modified tracked files and
# untracked artifacts in the main checkout. These block subsequent merges
# ("Your local changes would be overwritten") and cascade into deadlocks.
# worktrees/ and state/ are gitignored, so git clean won't touch them.
(
  cd "$TF_REPO_DIR"
  git checkout --quiet "${TF_BASE_BRANCH}" 2>/dev/null || true
  if [[ -n "$(git status --porcelain)" ]]; then
    tf_warn "main worktree was dirty at startup — cleaning"
    git reset --hard --quiet HEAD
    git clean --quiet -fd
  fi
)

# ---------------------------------------------------------------------------
# Args
# ---------------------------------------------------------------------------
TF_MODE="run"            # run|once|dry-run|status
TF_POLL=15
TF_WORKER_FILTER=""
TF_TASK_FILTER=""
TF_MAX_ROUNDS=0          # 0 = unlimited
TF_MAX_PARALLEL="${TF_MAX_PARALLEL:-$(tf_worker_names | wc -l)}"
TF_AFFINITY="${TF_AFFINITY:-1}"  # 1 = win-rate routing on; 0 = config-order fallback
TF_ROUTING="${TF_ROUTING:-1}"     # 1 = cross-model tier routing on; 0 = ignore worker tiers

while [[ $# -gt 0 ]]; do
  case "$1" in
    --once)     TF_MODE="once"; shift ;;
    --dry-run)  TF_MODE="dry-run"; shift ;;
    --status)   TF_MODE="status"; shift ;;
    --worker)   TF_WORKER_FILTER="$2"; shift 2 ;;
    --task)     TF_TASK_FILTER="$2"; shift 2 ;;
    --poll)     TF_POLL="$2"; shift 2 ;;
    --max-rounds) TF_MAX_ROUNDS="$2"; shift 2 ;;
    --max-parallel) TF_MAX_PARALLEL="$2"; shift 2 ;;
    cost) TF_MODE="cost" TF_COST_ARGS=(); shift ;;
    api) TF_MODE="api" TF_API_CMD="$2"; shift 2; TF_API_ARGS=("$@"); shift $# ;;
    attach) TF_MODE="attach" TF_ATTACH_TASK="$2"; shift 2 ;;
    import) TF_MODE="import" TF_IMPORT_SRC="$2"; shift 2; TF_IMPORT_ARGS=("$@"); shift $# ;;
    -h|--help)
      sed -n '2,/^$/p' "$0" | sed 's/^# \?//'
      exit 0 ;;
    *) tf_error "unknown arg: $1"; exit 2 ;;
  esac
done
# Collect remaining args for cost subcommand
if [[ "$TF_MODE" == "cost" ]]; then
  TF_COST_ARGS=("$@")
fi

# ---------------------------------------------------------------------------
# Entry
# ---------------------------------------------------------------------------

# Robustness: kill stale orchestrator/pi processes from interrupted runs
# BEFORE touching any state, so orphaned dispatch subshells can't pollute
# this run (duplicate work, phantom run-state, deadlocks).
#
# ONLY dispatch modes (run/once) take ownership of the state — read-only
# modes (status/dry-run/attach/cost/api/import) must NOT kill a live run.
if [[ "$TF_MODE" == "run" || "$TF_MODE" == "once" ]]; then
  tf_kill_stale_processes
fi

tf_status_init
tf_schedule_init

if [[ "$TF_MODE" == "status" ]]; then
  tf_status_board
  exit 0
fi

if [[ "$TF_MODE" == "cost" ]]; then
  tf_require_jq || exit 1
  tf_cost_summary "${TF_COST_ARGS[@]}"
  exit 0
fi

if [[ "$TF_MODE" == "api" ]]; then
  tf_require_jq || exit 1
  case "$TF_API_CMD" in
    add) tf_api_add "${TF_API_ARGS[@]}" ;;
    status) tf_api_status "${TF_API_ARGS[@]}" ;;
    results) tf_api_results "${TF_API_ARGS[@]}" ;;
    *) tf_error "unknown api command: $TF_API_CMD"; exit 1 ;;
  esac
  exit 0
fi

if [[ "$TF_MODE" == "attach" ]]; then
  tf_attach "$TF_ATTACH_TASK"
  exit 0
fi

if [[ "$TF_MODE" == "import" ]]; then
  tf_require_curl || exit 1
  case "$TF_IMPORT_SRC" in
    github)
      tf_source_import_github "${TF_IMPORT_ARGS[@]}"
      exit $? ;;
    *) tf_error "unknown import source: $TF_IMPORT_SRC (expected: github)"; exit 1 ;;
  esac
fi

# Robustness: recover from interrupted-run artifacts — stale worktrees and
# branches (kill -9 leftovers break fresh worktree creation) and run-state
# entries whose dispatch process is dead (phantom "running" tasks).
# Preserve branches flagged for conflict-retry (keep-branch).
local_preserved="$(jq -r 'to_entries[] | select(.value.last_error != null and (.value.last_error | contains("merge"))) | .value.branch' "$STATUS_JSON" 2>/dev/null | grep -v '^null$' | tr '\n' ' ')"
tf_recover_stale_worktrees "$local_preserved"
tf_reset_dead_runstate

# Robustness: validate the task ledger (broken gates / unknown deps cost
# attempts otherwise). Advisory — warn but don't abort.
tf_validate_tasks || true

TF_MERGE_LOCK="${TF_MERGE_LOCK:-$TF_STATE_DIR/merge.lock}"
mkdir -p "$TF_STATE_DIR"

tf_info "taskfleet starting — mode=$TF_MODE poll=${TF_POLL}s parallel=$TF_MAX_PARALLEL"

# ---------------------------------------------------------------------------
# Worker availability: a worker is free iff not currently assigned to a
# running/verifying task. We track in-process pids in run-state.json.
# ---------------------------------------------------------------------------
tf_runstate_init() {
  [[ -f "$RUNSTATE_JSON" ]] || echo '{}' > "$RUNSTATE_JSON"
}

# record a running task: tf_runstate_set <task_id> <pid> <worker>
tf_runstate_set() {
  local id="$1" pid="$2" worker="$3"
  local tmp
  tmp="$(mktemp)"
  jq --arg id "$id" --arg pid "$pid" --arg w "$worker" \
    '.[$id] = {pid: ($pid|tonumber), worker: $w, started: now | todate}' \
    "$RUNSTATE_JSON" > "$tmp"
  mv "$tmp" "$RUNSTATE_JSON"
}

# remove a task from run-state
tf_runstate_clear() {
  local id="$1"
  local tmp
  tmp="$(mktemp)"
  jq --arg id "$id" 'del(.[$id])' "$RUNSTATE_JSON" > "$tmp"
  mv "$tmp" "$RUNSTATE_JSON"
}

# list worker names currently busy
tf_busy_workers() {
  tf_require_jq || return 1
  jq -r '[.[] | .worker] | unique | .[]' "$RUNSTATE_JSON" 2>/dev/null
}

# count in-flight tasks
tf_inflight_count() {
  jq 'length' "$RUNSTATE_JSON" 2>/dev/null || echo 0
}

# A worker is free if enabled, in filter, and not busy.
tf_free_workers() {
  local busy
  busy="$(tf_busy_workers)"
  while IFS= read -r w; do
    [[ -z "$w" ]] && continue
    [[ -n "$TF_WORKER_FILTER" && "$w" != "$TF_WORKER_FILTER" ]] && continue
    # not in busy list?
    if ! grep -qxF "$w" <<< "$busy"; then
      echo "$w"
    fi
  done < <(tf_worker_names)
}

# ---------------------------------------------------------------------------
# Reap finished background dispatches.
# ---------------------------------------------------------------------------
tf_reap() {
  local id pid status
  # iterate over a snapshot so we can mutate run-state
  local ids
  ids="$(jq -r 'keys[]' "$RUNSTATE_JSON" 2>/dev/null)" || return 0
  while IFS= read -r id; do
    [[ -z "$id" ]] && continue
    pid="$(jq -r --arg id "$id" '.[$id].pid' "$RUNSTATE_JSON")"
    if ! kill -0 "$pid" 2>/dev/null; then
      # process finished — wait to reap zombie + get status
      wait "$pid" 2>/dev/null
      local rc=$?
      status="$(tf_status_get "$id" .status)"
      tf_info "reaped $id (pid $pid, rc=$rc, status=$status)"
      # Deterministic zombie guard: a dispatch that exited non-zero WITHOUT
      # reaching a definitive status (done/failed) must go back to ready —
      # the EXIT-trap guard can be bypassed by kill -9 and some crash paths.
      if [[ $rc -ne 0 ]] && { [[ "$status" == "running" ]] || [[ "$status" == "verifying" ]]; }; then
        tf_debug "$id: dispatch exited rc=$rc in transient status '$status' — resetting to ready (reap guard)"
        tf_status_set "$id" ready '.last_error="dispatch crashed before definitive status (reap guard)"' 2>/dev/null || true
      fi
      tf_runstate_clear "$id"
    fi
  done <<< "$ids"
}

# ---------------------------------------------------------------------------
# Main loop
# ---------------------------------------------------------------------------
tf_run() {
  local round=0
  while true; do
    round=$((round + 1))
    tf_reap

    # termination check
    local done_n failed_n running_n ready_n total_n
    done_n="$(tf_count_status done)"
    failed_n="$(tf_count_status failed)"
    running_n="$(tf_count_status running)"
    total_n="$(jq '[to_entries[] | select(.value | type=="object" and has("status"))] | length' "$STATUS_JSON")"

    tf_info "round $round — done=$done_n failed=$failed_n running=$running_n total=$total_n"

    if [[ $done_n -eq $total_n ]]; then
      tf_info "ALL TASKS DONE 🎉"
      tf_status_board
      return 0
    fi

    # detect deadlock: nothing running, nothing ready, not all done
    # Use smart scheduling for dispatch, but naive ready-list for deadlock
    # detection (contention-deferred tasks are still technically ready).
    local ready_ids_smart naive_ready_ids
    if [[ -n "$TF_TASK_FILTER" ]]; then
      tf_is_ready "$TF_TASK_FILTER" && ready_ids_smart="$TF_TASK_FILTER" || ready_ids_smart=""
      naive_ready_ids="$ready_ids_smart"
    else
      ready_ids_smart="$(tf_smart_ready_task_ids)"
      naive_ready_ids="$(tf_ready_task_ids)"
    fi
    local inflight
    inflight="$(tf_inflight_count)"

    if [[ -z "$naive_ready_ids" && "$inflight" -eq 0 ]]; then
      # Nothing dispatchable and nothing in flight.
      # Check whether this is a true deadlock (failed tasks blocking ready)
      # or just permanent failures (no tasks can ever become ready).
      local blocked_by_failed blocked_n perm_failed_n
      perm_failed_n="$(tf_count_status failed)"

      if [[ $perm_failed_n -gt 0 ]]; then
        # Robustness (L6): before declaring deadlock, give INFRA-failed tasks
        # (worktree creation, gate env, provider health) a graceful retry —
        # these are transient and shouldn't permanently block the pipeline.
        # Only model-failure categories (compile/test/no_op) stay failed.
        local auto_retry=0
        while IFS= read -r fid; do
          [[ -z "$fid" ]] && continue
          local cat2 att2
          cat2="$(tf_status_get "$fid" .error_category)"
          att2="$(tf_status_get "$fid" .attempts)"
          # Reset anything that is NOT a definitive model failure. Merge
          # conflicts (branch preserved), unknown, empty, infra/provider
          # categories are transient and deserve a graceful retry.
          case "$cat2" in
            compile_error|test_failure|no_op|missing_package)
              ;;  # definitive model failure — stays failed
            *)
              tf_debug "$fid: transient failure category [$cat2] — auto-resetting for graceful retry"
              tf_status_set "$fid" ready '.attempts=0 | .last_error=null | .next_retry_at=null | .error_category=null | .error_summary=null' 2>/dev/null || true
              auto_retry=1
              ;;
          esac
        done < <(jq -r 'to_entries[] | select(.value.status=="failed") | .key' "$STATUS_JSON")
        if [[ "$auto_retry" -eq 1 ]]; then
          tf_debug "auto-reset infra-failed tasks; continuing (round $round)"
          continue
        fi
        tf_error "DEADLOCK: $perm_failed_n task(s) permanently failed, blocking $((total_n - done_n - perm_failed_n)) remaining"
        tf_status_board

        # Print per-failure diagnosis
        tf_info "=== Failure diagnosis ==="
        while IFS= read -r fid; do
          [[ -z "$fid" ]] && continue
          local cat sum att
          cat="$(tf_status_get "$fid" .error_category)"
          sum="$(tf_status_get "$fid" .error_summary)"
          att="$(tf_status_get "$fid" .attempts)"
          tf_info "$fid (attempt $att): [$cat] $sum"
          # Show what downstream tasks are blocked
          while IFS= read -r tid2; do
            [[ -z "$tid2" ]] && continue
            local deps2
            deps2="$(tf_task_field "$tid2" '.deps[]')"
            grep -qxF "$fid" <<< "$deps2" && tf_info "  └─ blocks $tid2"
          done < <(tf_all_task_ids)
        done < <(jq -r 'to_entries[] | select(.value.status=="failed") | .key' "$STATUS_JSON")
        tf_info "=== End diagnosis ==="
        return 1
      else
        tf_warn "no ready or running tasks but not all done — possible blocked dependency"
        tf_status_board
        return 1
      fi
    fi

    # dispatch: pair ready tasks with free workers, up to TF_MAX_PARALLEL
    # Uses smart_ready_task_ids (contention-aware + depth-sorted)
    if [[ "$TF_MODE" == "dry-run" ]]; then
      local printed=0
      while IFS= read -r tid; do
        [[ -z "$tid" ]] && continue
        local fw_dry
        fw_dry="$(tf_free_workers | head -1)"
        tf_dispatch_one_dryrun "$tid" "${fw_dry:-<any>}"
        printed=$((printed + 1))
      done <<< "$ready_ids_smart"
      [[ $printed -eq 0 ]] && tf_info "(no ready tasks right now)"
      return 0
    fi

    while IFS= read -r tid; do
      [[ -z "$tid" ]] && continue
      [[ "$inflight" -ge "$TF_MAX_PARALLEL" ]] && break
      # pick the HEALTHY free worker with the best affinity for this task
      # (win-rate routing backed by the receipt ledger). Falls back to
      # config order when there's no history or an explicit --worker override
      # is set.
      local fw=""
      if [[ -n "$TF_WORKER_FILTER" ]]; then
        # explicit worker override — honor it if healthy
        if tf_worker_healthy "$TF_WORKER_FILTER"; then
          fw="$TF_WORKER_FILTER"
        else
          tf_warn "worker $TF_WORKER_FILTER endpoint unhealthy — skipping this round"
        fi
      else
        # cross-model routing: only workers capable of this task's model_tier
        # can run it. Collect healthy + capable candidates, then rank by
        # affinity (win-rate routing). Falls back to config order when there's
        # no history.
        local tier
        tier="$(tf_task_tier "$tid")"
        local healthy_cands=()
        while IFS= read -r cand; do
          [[ -z "$cand" ]] && continue
          if ! tf_worker_healthy "$cand"; then
            tf_warn "worker $cand endpoint unhealthy — skipping this round"
            continue
          fi
          if [[ -n "$TF_ROUTING" ]] && ! tf_worker_can_tier "$cand" "$tier"; then
            tf_info "worker $cand cannot handle $tier tasks — skipping (tiers: $(tf_worker_tiers "$cand" | tr '\n' ' '))"
            continue
          fi
          healthy_cands+=("$cand")
        done < <(tf_free_workers)
        if [[ $TF_AFFINITY -eq 1 && ${#healthy_cands[@]} -gt 0 ]]; then
          fw="$(tf_best_worker_for "$tid" "${healthy_cands[@]}")"
        else
          fw="${healthy_cands[0]:-}"
        fi
      fi
      [[ -z "$fw" ]] && { tf_info "no free healthy workers, waiting"; break; }
      # dispatch in background. Fine-grained locks (status + merge) protect
      # the shared state; the long pi run is fully parallel across worktrees.
      tf_dispatch_one "$tid" "$fw" &
      local bg_pid=$!
      tf_runstate_set "$tid" "$bg_pid" "$fw"
      tf_info "launched $tid on worker=$fw (pid $bg_pid)"
      inflight=$((inflight + 1))
      sleep 1   # stagger launches so worktree creation doesn't race
    done <<< "$ready_ids_smart"
    if [[ "$TF_MODE" == "once" ]]; then
      tf_info "--once: dispatched one round, exiting"
      return 0
    fi
    if [[ "$TF_MAX_ROUNDS" -gt 0 && "$round" -ge "$TF_MAX_ROUNDS" ]]; then
      tf_info "reached --max-rounds $TF_MAX_ROUNDS, exiting"
      return 0
    fi

    sleep "$TF_POLL"
  done
}

# ---------------------------------------------------------------------------
# API: taskfleet api add --task <desc> [--priority N] [--scope FILE] [--accept CMD]
# ---------------------------------------------------------------------------
tf_api_add() {
  local task_desc="" priority=5 scope="" accept="true"
  
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --task) task_desc="$2"; shift 2 ;;
      --priority) priority="$2"; shift 2 ;;
      --scope) scope="$2"; shift 2 ;;
      --accept) accept="$2"; shift 2 ;;
      *) tf_error "unknown arg: $1"; return 1 ;;
    esac
  done
  
  [[ -z "$task_desc" ]] && { tf_error "--task is required"; return 1; }
  
  # Generate task_id: T-<timestamp>-<random>
  local task_id="T-$(date +%s%N | md5sum | head -c8)"
  
  # Create task JSON
  local task_json
  task_json=$(jq -n \
    --arg id "$task_id" \
    --arg title "$task_desc" \
    --argjson priority "$priority" \
    --arg scope "$scope" \
    --arg accept "$accept" \
    '{
      id: $id,
      engine: "t",
      title: $title,
      section: "§api",
      deps: [],
      scope: (if $scope == "" then [] else [$scope] end),
      accept: $accept,
      manual: false,
      priority: $priority
    }')
  
  # Append to tasks.json
  local tmp
  tmp=$(mktemp)
  jq --argjson task "$task_json" '.tasks += [$task]' "$TASKS_JSON" > "$tmp"
  mv "$tmp" "$TASKS_JSON"
  
  tf_info "Created task $task_id: $task_desc"
  echo "$task_id"
}

# ---------------------------------------------------------------------------
# API: taskfleet api status [--json] [--task ID]
# ---------------------------------------------------------------------------
tf_api_status() {
  local json_output=0 task_id=""
  
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --json) json_output=1; shift ;;
      --task) task_id="$2"; shift 2 ;;
      *) tf_error "unknown arg: $1"; return 1 ;;
    esac
  done
  
  if [[ -n "$task_id" ]]; then
    # Return status for specific task
    if [[ "$json_output" -eq 1 ]]; then
      jq --arg id "$task_id" '.[$id] // {error: "task not found"}' "$STATUS_JSON"
    else
      local status title
      status=$(jq -r --arg id "$task_id" '.[$id].status // "not found"' "$STATUS_JSON")
      title=$(jq -r --arg id "$task_id" '.[$id].title // "unknown"' "$STATUS_JSON")
      echo "$task_id: $status ($title)"
    fi
  else
    # Return full status board
    if [[ "$json_output" -eq 1 ]]; then
      jq '.' "$STATUS_JSON"
    else
      tf_status_board
    fi
  fi
}

# ---------------------------------------------------------------------------
# API: taskfleet api results [--task ID]
# ---------------------------------------------------------------------------
tf_api_results() {
  local task_id=""
  
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --task) task_id="$2"; shift 2 ;;
      *) tf_error "unknown arg: $1"; return 1 ;;
    esac
  done
  
  [[ -z "$task_id" ]] && { tf_error "--task is required"; return 1; }
  
  local status
  status=$(jq -r --arg id "$task_id" '.[$id].status // "not found"' "$STATUS_JSON")
  
  if [[ "$status" != "done" ]]; then
    tf_error "Task $task_id is not done (status: $status)"
    return 1
  fi
  
  # Output gate output and diff
  echo "=== Task $task_id Results ==="
  echo "Status: $status"
  echo "Worker: $(jq -r --arg id "$task_id" '.[$id].last_worker // "unknown"' "$STATUS_JSON")"
  echo "Attempts: $(jq -r --arg id "$task_id" '.[$id].attempts // 0' "$STATUS_JSON")"
  
  local gate_output diff_file
  gate_output=$(jq -r --arg id "$task_id" '.[$id].gate_output // "none"' "$STATUS_JSON")
  [[ "$gate_output" != "none" ]] && echo "\n=== Gate Output ===" && echo "$gate_output"
  
  diff_file="$TF_REPO_DIR/../worktrees/$task_id/diff.patch"
  if [[ -f "$diff_file" ]]; then
    echo "\n=== Diff ==="
    cat "$diff_file"
  fi
}

# ---------------------------------------------------------------------------
# Attach: taskfleet attach TASK_ID
# Streams live output for a running task by tailing its log file
# ---------------------------------------------------------------------------
tf_attach() {
  local task_id="$1"
  
  [[ -z "$task_id" ]] && { tf_error "TASK_ID required"; return 1; }
  
  # Check if task exists
  if ! jq -e --arg id "$task_id" '.[$id]' "$STATUS_JSON" >/dev/null 2>&1; then
    tf_error "Task $task_id not found"
    return 1
  fi
  
  local status
  status=$(jq -r --arg id "$task_id" '.[$id].status' "$STATUS_JSON")
  
  if [[ "$status" == "done" ]]; then
    tf_error "Task $task_id is already done. Use 'taskfleet api results --task $task_id' to see results."
    return 1
  fi
  
  if [[ "$status" == "failed" ]]; then
    tf_error "Task $task_id has failed. Use 'taskfleet api results --task $task_id' to see error details."
    return 1
  fi
  
  local log_file="$TF_LOG_DIR/$task_id.log"
  
  if [[ ! -f "$log_file" ]]; then
    tf_warn "No log file yet for $task_id (dispatch may not have started)"
    tf_info "Task status: $status"
    return 0
  fi
  
  tf_info "Attaching to task $task_id (status: $status) — tailing $log_file (Ctrl-C to detach)"
  tail -f "$log_file"
}

tf_runstate_init
tf_run
