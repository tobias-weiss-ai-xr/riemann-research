#!/usr/bin/env bash
# affinity.sh — worker-task affinity routing for taskfleet.
#
# Learns per-worker, per-engine win rates from the receipt ledger and uses
# them to route tasks to the worker most likely to succeed on that task type.
# Falls back to config order when no history exists.
#
# A "win" is a task whose final_status (from the receipt `closed` record) is
# "done". The worker is attributed from the last `begin` record for that task
# (the attempt that produced the final outcome). Engines come from tasks.json.

# shellcheck source=common.sh
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

TF_RECEIPT_DIR="${TF_RECEIPT_DIR:-$TF_STATE_DIR/receipts}"

# ---------------------------------------------------------------------------
# Receipt aggregation: build a per-(worker, engine) outcome table.
# Each line: "worker<TAB>engine<TAB>wins<TAB>total"
# ---------------------------------------------------------------------------
# tf_affinity_table → prints TSV of worker, engine, wins, total across all
# receipt files. Uses only closed records for the outcome and the last begin
# record per task for attribution.
tf_affinity_table() {
  tf_require_jq || return 1
  local files
  files="$(ls "$TF_RECEIPT_DIR"/*.ndjson 2>/dev/null)"
  [[ -z "$files" ]] && return 0

  # Read all receipts into one JSON array, then compute per-task:
  #   final_status from the closed record
  #   worker from the LAST begin record for that task
  # Then join with tasks.json engines and aggregate.
  jq -s --argfile tasks "$TASKS_JSON" '
    def task_engine($id):
      ($tasks.tasks[] | select(.id == $id) | .engine // "unknown") // "unknown";
    # group receipts by task
    map({key: .task_id, val: .}) | group_by(.key)
    | map({
        task_id: .[0].key,
        closed: ([.[].val | select(.type? == "closed")] | last),
        last_begin: ([.[].val | select(.type? == null and .status? == "running")] | last)
      })
    | map(select(.closed != null and .last_begin != null)
      | {
          worker: .last_begin.worker,
          engine: task_engine(.task_id),
          status: .closed.final_status
        })
    | group_by(.worker + "\u0000" + .engine)
    | map({
        worker: .[0].worker,
        engine: .[0].engine,
        wins: ([.[] | select(.status == "done")] | length),
        total: length
      })
    | .[]
    | "\(.worker)\t\(.engine)\t\(.wins)\t\(.total)"
  ' -r $files 2>/dev/null
}

# ---------------------------------------------------------------------------
# tf_affinity_score <worker> <task_id> → prints a fractional score in [0,1].
#
# Returns the win rate for that worker on the task's engine, falling back to:
#   - the worker's overall win rate if no engine-specific history
#   - 0.5 (neutral) if no history at all
# ---------------------------------------------------------------------------
tf_affinity_score() {
  local worker="$1" task_id="$2"
  local engine
  engine="$(tf_task_field "$task_id" .engine 2>/dev/null || echo "unknown")"

  local row engine_wins engine_total all_wins all_total
  row="$(tf_affinity_table | awk -F'\t' -v w="$worker" -v e="$engine" \
    '$1==w && $2==e {print $3"\t"$4}')"
  if [[ -n "$row" ]]; then
    engine_wins="${row%%$'\t'*}"
    engine_total="${row##*$'\t'}"
    if [[ "$engine_total" -gt 0 ]]; then
      echo "$(LC_ALL=C awk "BEGIN{printf \"%.3f\", $engine_wins/$engine_total}")"
      return
    fi
  fi
  # Fall back to worker's overall win rate
  row="$(tf_affinity_table | awk -F'\t' -v w="$worker" \
    '$1==w {wins+=$3; total+=$4} END{print wins"\t"total}')"
  if [[ -n "$row" ]]; then
    all_wins="${row%%$'\t'*}"
    all_total="${row##*$'\t'}"
    if [[ "$all_total" -gt 0 ]]; then
      echo "$(LC_ALL=C awk "BEGIN{printf \"%.3f\", $all_wins/$all_total}")"
      return
    fi
  fi
  echo "0.500"
}

# ---------------------------------------------------------------------------
# tf_best_worker_for <task_id> <candidate workers...> → prints best worker name
#
# Picks the candidate with the highest affinity score for the task. Ties break
# in the order candidates are given (which mirrors config order — a stable
# fallback). If no candidates, prints nothing.
# ---------------------------------------------------------------------------
tf_best_worker_for() {
  local task_id="$1"; shift
  local best="" best_score="-1"
  local cand score
  for cand in "$@"; do
    [[ -z "$cand" ]] && continue
    score="$(tf_affinity_score "$cand" "$task_id")"
    # awk float comparison; score is like 0.500
    if LC_ALL=C awk "BEGIN{exit !($score > $best_score)}"; then
      best="$cand"
      best_score="$score"
    fi
  done
  [[ -n "$best" ]] && echo "$best"
}

# ---------------------------------------------------------------------------
# tf_affinity_rank <task_id> <candidate workers...> → prints ranking (best first)
# ---------------------------------------------------------------------------
tf_affinity_rank() {
  local task_id="$1"; shift
  local cand score
  for cand in "$@"; do
    [[ -z "$cand" ]] && continue
    score="$(tf_affinity_score "$cand" "$task_id")"
    printf '%s\t%s\n' "$cand" "$score"
  done | LC_ALL=C sort -t$'\t' -k2,2nr | cut -f1
}
