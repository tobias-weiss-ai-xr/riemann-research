#!/usr/bin/env bash
# schedule.sh — scheduling intelligence for taskfleet.
#
# Provides scope contention detection and critical-path priority to the
# orchestrator's dispatch loop. All scheduling decisions should go through
# this module rather than being inlined in orchestrator.sh.
#
# Algorithms:
#   1. Scope contention detection — defers tasks whose scope overlaps with
#      currently running tasks, preventing merge conflicts at dispatch time
#      rather than recovering from them after.
#   2. Critical-path priority — sorts ready tasks by DAG depth (deepest first)
#      so the critical path always gets the best worker assignment.
#   3. Task depth precomputation — BFS at init, cached for O(1) per-task lookup.

# shellcheck source=common.sh
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"
# shellcheck source=status.sh
. "$(dirname "${BASH_SOURCE[0]}")/status.sh"

# ---------------------------------------------------------------------------
# Scope contention detection
# ---------------------------------------------------------------------------

# tf_scope_files_for <task_id> → newline-separated list of scope files
tf_scope_files_for() {
  tf_task_field "$1" '.scope[]'
}

# tf_running_scope_files → newline-separated deduped list of all scope files
# currently being worked on by in-flight tasks.
tf_running_scope_files() {
  local id
  while IFS= read -r id; do
    [[ -z "$id" ]] && continue
    tf_scope_files_for "$id"
  done < <(tf_running_task_ids) | sort -u
}

# tf_scope_conflicts <task_id> → newline-separated list of running task IDs
# that share at least one scope file with the given task.
tf_scope_conflicts() {
  local id="$1"
  local my_files
  my_files="$(tf_scope_files_for "$id" | sort -u)"
  [[ -z "$my_files" ]] && return 0

  local running_id
  while IFS= read -r running_id; do
    [[ -z "$running_id" ]] && continue
    [[ "$running_id" == "$id" ]] && continue
    local their_files
    their_files="$(tf_scope_files_for "$running_id" | sort -u)"
    # Use comm to find intersection
    if comm -12 <(echo "$my_files") <(echo "$their_files") | grep -q .; then
      echo "$running_id"
    fi
  done < <(tf_running_task_ids)
}

# tf_has_scope_conflict <task_id> → exit 0 if any running task shares scope
tf_has_scope_conflict() {
  [[ -n "$(tf_scope_conflicts "$1")" ]]
}

# ---------------------------------------------------------------------------
# Critical-path priority (DAG depth)
# ---------------------------------------------------------------------------

# tf_compute_task_depths → writes {task_id: depth} map to stdout as JSON
# Depth = longest path from this task to any leaf (terminal task with no
# dependents). Root tasks in the critical path have the highest depth.
# Computed via fixed-point relaxation over the dependency edges.
tf_compute_task_depths() {
  jq -r '
    # Build edge list: "dep,child" pairs (parent → who depends on it)
    [.tasks[] | .id as $id | (.deps // [])[] | "\(.),\($id)"] as $edge_list
    | ([.tasks[].id]) as $ids
    | ($ids | map({key:., value:1}) | from_entries)
    # Fixed-point relaxation: propagate max(child_depth + 1) upward
    | reduce (range(20)) as $_ (.;
        reduce $edge_list[] as $edge (.;
          ($edge | split(",") | .[0]) as $parent |
          ($edge | split(",") | .[1]) as $child |
          .[$parent] = ([(.[$parent] // 1), ((.[$child] // 1) + 1)] | max)))
    | to_entries | sort_by(-.value)
    | map({(.key): .value}) | add // {}
  ' "$TASKS_JSON"
}

# tf_get_task_depth <task_id> → prints depth (0 if not cached)
tf_get_task_depth() {
  jq -r --arg id "$1" '.[$id] // 0' "$TF_STATE_DIR/task-depths.json" 2>/dev/null
}

# Precompute and cache task depths. Called once at init.
tf_schedule_init() {
  local depths
  depths="$(tf_compute_task_depths)"
  echo "$depths" > "$TF_STATE_DIR/task-depths.json"
  local maxd
  maxd="$(echo "$depths" | jq '[.[] | values] | max // 0')"
  local count
  count="$(echo "$depths" | jq 'length')"
  tf_info "schedule: computed depths for $count tasks (max depth: $maxd)"
}

# ---------------------------------------------------------------------------
# Smart ready-task listing (combines contention + priority)
# ---------------------------------------------------------------------------

# tf_smart_ready_task_ids → ready task IDs sorted by critical-path depth
# (deepest first), excluding tasks with active scope contention.
# This replaces the naive tf_ready_task_ids in the dispatch loop.
tf_smart_ready_task_ids() {
  local regular_ready speculatively_ready
  regular_ready="$(tf_smart_ready_task_ids_impl regular)"
  speculatively_ready="$(tf_smart_ready_task_ids_impl speculative)"
  # Output: speculatively-ready first (they unblock more), then regular-ready
  # Both groups sorted by depth descending
  if [[ -n "$speculatively_ready" && -n "$regular_ready" ]]; then
    echo "$speculatively_ready"
    echo "$regular_ready"
  elif [[ -n "$speculatively_ready" ]]; then
    echo "$speculatively_ready"
  elif [[ -n "$regular_ready" ]]; then
    echo "$regular_ready"
  fi
}

# tf_ready_task_ids → naive ready task IDs (all deps done, no
# contention filtering). Used by the orchestrator's deadlock detection:
# contention-deferred tasks are still technically ready.
tf_ready_task_ids() {
  local id
  while IFS= read -r id; do
    [[ -z "$id" ]] && continue
    tf_is_ready "$id" || continue
    echo "$id"
  done < <(tf_all_task_ids)
}

# Internal: compute ready task ids of a given type
# type=regular: normal ready tasks (all deps done)
# type=speculative: speculatively ready tasks (all deps except one running dep)
tf_smart_ready_task_ids_impl() {
  local ready_type="$1"
  local policy="${TF_CONTENTION_POLICY:-defer}"
  local id depth ready_ids=""
  local conflicts conflicter

  while IFS= read -r id; do
    [[ -z "$id" ]] && continue
    
    local is_ready=0
    if [[ "$ready_type" == "regular" ]]; then
      tf_is_ready "$id" || continue
      is_ready=1
    elif [[ "$ready_type" == "speculative" ]]; then
      tf_is_speculatively_ready "$id" || continue
      is_ready=1
    fi

    # Check contention (unless policy allows it)
    if [[ "$policy" == "defer" ]]; then
      conflicts="$(tf_scope_conflicts "$id")"
      if [[ -n "$conflicts" ]]; then
        conflicter="$(echo "$conflicts" | head -1)"
        tf_info "schedule: $id deferred (scope contention with running task $conflicter)"
        continue
      fi
    fi

    ready_ids+=" $id"
  done < <(tf_all_task_ids)

  # Sort by depth (deepest = highest critical path priority first)
  if [[ -f "$TF_STATE_DIR/task-depths.json" ]]; then
    for id in $ready_ids; do
      depth="$(tf_get_task_depth "$id")"
      echo "$depth $id"
    done | sort -rn | awk '{print $2}'
  else
    # Fallback: no depth data, return in original order
    for id in $ready_ids; do echo "$id"; done
  fi
}

# ---------------------------------------------------------------------------
# Diagnostics
# ---------------------------------------------------------------------------

# Print the contention matrix for all tasks (for debugging)
tf_schedule_debug() {
  echo "=== Task Depths (critical path priority) ==="
  if [[ -f "$TF_STATE_DIR/task-depths.json" ]]; then
    jq -r 'to_entries | sort_by(-.value) | .[] | "  depth \(.value)  \(.key)"' \
      "$TF_STATE_DIR/task-depths.json"
  else
    echo "  (not computed — run tf_schedule_init first)"
  fi

  echo ""
  echo "=== Scope Overlaps (potential contention) ==="
  local all_files file_tasks
  all_files="$(while IFS= read -r id; do
    tf_scope_files_for "$id" | while IFS= read -r f; do
      [[ -n "$f" ]] && echo "$f $id"
    done
  done < <(tf_all_task_ids) | sort | uniq)"

  local prev_file=""
  while IFS=' ' read -r file id; do
    if [[ "$file" != "$prev_file" && "$prev_file" != "" ]]; then
      echo ""
    fi
    printf "  %s ← %s" "$file" "$id"
    prev_file="$file"
  done <<< "$all_files" | awk '
    BEGIN { file="" }
    { if ($1 != file) { if (file != "") print ""; file=$1; printf "  %s ←", file } printf " %s", $NF }
    END { print "" }
  '
}
