#!/usr/bin/env bash
# receipt.sh — append-only dispatch receipt ledger for taskfleet.
#
# Every dispatch attempt writes a receipt to $TF_RECEIPT_DIR/YYYY-MM-DD.ndjson.
# Receipts capture timing, worker, token usage, cost, and status — providing
# the observability and cost-tracking layer that taskfleet currently lacks.
#
# Inspired by VNX Orchestration's NDJSON receipt stream.

# shellcheck source=common.sh
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

TF_RECEIPT_DIR="${TF_RECEIPT_DIR:-$TF_STATE_DIR/receipts}"
mkdir -p "$TF_RECEIPT_DIR"

# ---------------------------------------------------------------------------
# Token usage pricing table (USD per 1M tokens, as of 2025-01)
# ---------------------------------------------------------------------------
# tf_cost_per_1k <provider> <model> <tokens_in> <tokens_out> → prints USD cost
tf_cost_per_1k() {
  local provider="$1" model="$2" tin="$3" tout="$4"
  local pin pout
  # Simplified pricing table — extend as needed
  case "$provider:$model" in
    *:gpt-4o)            pin=0.0025; pout=0.01 ;;
    *:gpt-4o-mini)       pin=0.00015; pout=0.0006 ;;
    *:gpt-4-turbo)       pin=0.01; pout=0.03 ;;
    *:claude-sonnet-4*)  pin=0.003; pout=0.015 ;;
    *:claude-3*)         pin=0.003; pout=0.015 ;;
    *:claude-2*)         pin=0.008; pout=0.024 ;;
    *:deepseek*)         pin=0.00014; pout=0.00028 ;;
    *) pin=0.001; pout=0.005 ;;  # conservative default
  esac
  echo "$(echo "$tin * $pin + $tout * $pout" | bc -l)"
}

# ---------------------------------------------------------------------------
# Receipt file path for today
# ---------------------------------------------------------------------------
tf_receipt_file() {
  local date="${1:-$(date -u +%Y-%m-%d)}"
  echo "$TF_RECEIPT_DIR/$date.ndjson"
}

# ---------------------------------------------------------------------------
# Token usage extraction from dispatch logs
# ---------------------------------------------------------------------------
# tf_extract_tokens <log_file> → prints "tokens_in tokens_out"
# Parses common patterns from pi/claude/codex output:
#   "usage: { input_tokens: N, output_tokens: N }"
#   "Tokens: N in, N out"
#   "token_usage: { ... }"
tf_extract_tokens() {
  local log="$1"
  [[ -f "$log" ]] || { echo "0 0"; return; }

  # Try JSON usage block first (pi/anthropic format)
  local usage tin tout
  usage="$(grep -oP 'usage\s*[:=]\s*\K\{[^}]+\}' "$log" 2>/dev/null | tail -1)"
  if [[ -n "$usage" ]]; then
    tin="$(echo "$usage" | jq -r '.input_tokens // .prompt_tokens // 0' 2>/dev/null)"
    tout="$(echo "$usage" | jq -r '.output_tokens // .completion_tokens // 0' 2>/dev/null)"
    if [[ -n "$tin" && "$tin" != "null" && "$tin" != "0" ]]; then
      echo "${tin:-0} ${tout:-0}"
      return
    fi
  fi

  echo "0 0"
}

# ---------------------------------------------------------------------------
# Receipt writing
# ---------------------------------------------------------------------------

# tf_receipt_begin <task_id> <worker> <provider> <model> <branch>
#   Opens a receipt record and writes the start event.
tf_receipt_begin() {
  local id="$1" worker="$2" provider="$3" model="$4" branch="$5"
  local receipt_file attempt
  receipt_file="$(tf_receipt_file)"
  attempt="$(tf_status_get "$id" .attempts 2>/dev/null || echo 0)"

  local receipt
  receipt="$(jq -nc \
    --arg id "$id" \
    --arg worker "$worker" \
    --arg provider "$provider" \
    --arg model "$model" \
    --arg branch "$branch" \
    --arg ts "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
    --arg attempt "$attempt" \
    '{
      task_id: $id,
      worker: $worker,
      provider: $provider,
      model: $model,
      branch: $branch,
      attempt: ($attempt|tonumber),
      status: "running",
      dispatch_started_at: $ts,
      dispatch_finished_at: null,
      gate_started_at: null,
      gate_finished_at: null,
      tokens_in: 0,
      tokens_out: 0,
      cost_usd: "0.00",
      gate_command: null,
      gate_verdict: null,
      error_category: null,
      error_summary: null,
      notes: null
    }')"
  echo "$receipt" >> "$receipt_file"
}

# tf_receipt_finish_dispatch <task_id> <log_file> <rc>
#   Updates the running receipt with dispatch completion data and token usage.
tf_receipt_finish_dispatch() {
  local id="$1" log="$2" rc="$3"
  local receipt_file tokens tin tout cost provider model
  receipt_file="$(tf_receipt_file)"

  # Get worker info from status
  provider="$(tf_status_get "$id" .provider 2>/dev/null || echo "")"
  model="$(tf_status_get "$id" .model 2>/dev/null || echo "")"

  # Extract tokens from dispatch log
  tokens="$(tf_extract_tokens "$log")"
  tin="${tokens%% *}"
  tout="${tokens##* }"

  # Calculate cost
  cost="$(LC_ALL=C printf '%.4f' "$(tf_cost_per_1k "${provider:-unknown}" "${model:-unknown}" "$tin" "$tout")")"

  # Append an update record (immutable ledger — don't mutate in place)
  local update
  update="$(jq -nc \
    --arg id "$id" \
    --arg ts "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
    --arg rc "$rc" \
    --arg tin "$tin" \
    --arg tout "$tout" \
    --argjson cost "$cost" \
    '{type: "dispatch_finished", task_id: $id, finished_at: $ts,
      exit_code: ($rc|tonumber), tokens_in: ($tin|tonumber),
      tokens_out: ($tout|tonumber), cost_usd: $cost}')"
  echo "$update" >> "$receipt_file"
}

# tf_receipt_finish_gate <task_id> <worktree> <verdict> <gate_command>
#   Updates the receipt with gate outcome.
tf_receipt_finish_gate() {
  local id="$1" verdict="$2" gate_cmd="$3"
  local receipt_file category summary
  receipt_file="$(tf_receipt_file)"

  category="$(tf_get_error_category "$id" 2>/dev/null || echo "")"
  summary="$(tf_get_error_summary "$id" 2>/dev/null || echo "")"

  local update
  update="$(jq -nc \
    --arg id "$id" \
    --arg ts "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
    --arg verdict "$verdict" \
    --arg gate "$gate_cmd" \
    --arg cat "$category" \
    --arg sum "$summary" \
    '{type: "gate_finished", task_id: $id, finished_at: $ts,
      verdict: $verdict, gate_command: $gate,
      error_category: ($cat // null), error_summary: ($sum // null)}')"
  echo "$update" >> "$receipt_file"
}

# tf_receipt_close <task_id> <final_status> [notes]
#   Writes the final receipt closing record.
tf_receipt_close() {
  local id="$1" final_status="$2" notes="${3:-}"
  local receipt_file
  receipt_file="$(tf_receipt_file)"

  # Calculate cumulative cost from all records for this task
  local total_tin total_tout total_cost
  total_tin="$(tf_receipt_total "$id" .tokens_in)"
  total_tout="$(tf_receipt_total "$id" .tokens_out)"
  total_cost="$(tf_receipt_total "$id" .cost_usd)"

  local closing
  closing="$(jq -nc \
    --arg id "$id" \
    --arg ts "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
    --arg status "$final_status" \
    --arg notes "$notes" \
    --argjson tin "$total_tin" \
    --argjson tout "$total_tout" \
    --argjson cost "$total_cost" \
    '{type: "closed", task_id: $id, finished_at: $ts,
      final_status: $status, notes: ($notes // null),
      total_tokens_in: $tin, total_tokens_out: $tout,
      total_cost_usd: $cost}')"
  echo "$closing" >> "$receipt_file"
}

# ---------------------------------------------------------------------------
# Receipt querying
# ---------------------------------------------------------------------------

# tf_receipt_total <task_id> <field> → sum of field across all records for task
# Field can be passed as ".tokens_in" or "tokens_in" (leading dot stripped).
tf_receipt_total() {
  local id="$1" field="${2#.}"  # strip leading dot
  local receipt_file
  receipt_file="$(tf_receipt_file)"
  [[ -f "$receipt_file" ]] || { echo "0"; return; }
  [[ -s "$receipt_file" ]] || { echo "0"; return; }
  jq -s --arg id "$id" --arg f "$field" \
    '[.[] | select(.task_id == $id) | .[$f] // "0" | tonumber? // 0] | add // 0' \
    "$receipt_file" 2>/dev/null || echo "0"
}

# tf_receipt_last <task_id> → latest receipt object for a task
tf_receipt_last() {
  local id="$1"
  local receipt_file
  receipt_file="$(tf_receipt_file)"
  [[ -f "$receipt_file" ]] || return 1
  jq -c --arg id "$id" '[.[] | select(.task_id == $id)] | last' "$receipt_file" 2>/dev/null
}

# tf_cost_summary [--last | --since DATE | --task ID] → prints cost table
tf_cost_summary() {
  local mode="all" filter=""
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --last)  mode="last"; shift ;;
      --since) mode="since"; filter="$2"; shift 2 ;;
      --task)  mode="task"; filter="$2"; shift 2 ;;
      *) shift ;;
    esac
  done

  local receipt_files
  case "$mode" in
    last)  receipt_files="$(tf_receipt_file)" ;;
    since)
      receipt_files="$(find "$TF_RECEIPT_DIR" -name '*.ndjson' -newermt "$filter" 2>/dev/null | sort)"
      [[ -z "$receipt_files" ]] && receipt_files="$(tf_receipt_file)"
      ;;
    task)  receipt_files="$(tf_receipt_file)" ;;
    *)     receipt_files="$(find "$TF_RECEIPT_DIR" -name '*.ndjson' 2>/dev/null | sort)" ;;
  esac

  if [[ -z "$receipt_files" ]]; then
    tf_info "no receipts found"
    return 0
  fi

  # Aggregate from all receipt files
  local data
  data="$(cat $receipt_files 2>/dev/null)"

  if [[ "$mode" == "task" ]]; then
    # Single task detail
    echo "$data" | jq -r --arg id "$filter" '
      [.[] | select(.task_id == $id)]
      | if length == 0 then "no receipts for task \($id)"
        else
          (map(.tokens_in // 0 | tonumber?) | add // 0) as $tin |
          (map(.tokens_out // 0 | tonumber?) | add // 0) as $tout |
          (map(.cost_usd // "0" | tonumber?) | add // 0) as $cost |
          "Task: \($id)",
          "  Attempts: \(length)",
          "  Tokens in:  \($tin)",
          "  Tokens out: \($tout)",
          "  Cost: $\($cost | . * 1000 | round / 1000 | tostring)"
        end
    ' 2>/dev/null
  else
    # Summary table
    echo "$data" | jq -r --slurpfile tasks "$TASKS_JSON" '
      ($tasks[0].tasks | map({key:.id, value:.}) | from_entries) as $meta
      | [.[] | select(.type == "closed")]
      | group_by(.task_id)
      | map({
          id: .[0].task_id,
          title: ($meta[.[0].task_id].title // "?"),
          status: .[0].final_status,
          attempts: length,
          tokens_in: (map(.total_tokens_in // 0) | add),
          tokens_out: (map(.total_tokens_out // 0) | add),
          cost: (map(.total_cost_usd // "0" | tonumber?) | add)
        })
      | sort_by(-.cost)
      | (["TASK", "TITLE", "STATUS", "ATT", "T-IN", "T-OUT", "COST"] | @tsv),
        (["----", "-----", "------", "---", "----", "-----", "----"] | @tsv),
        (.[] | [.id, (.title[:30]), .status, (.attempts|tostring),
                 (.tokens_in|tostring), (.tokens_out|tostring),
                 (.cost * 1000 | round / 1000 | tostring)] | @tsv)
      | @tsv
    ' 2>/dev/null | column -t -s $'\t'
  fi
}
