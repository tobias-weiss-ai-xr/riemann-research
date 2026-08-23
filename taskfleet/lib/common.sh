#!/usr/bin/env bash
# common.sh — shared constants and helpers for taskfleet.
# Sourced by all other lib/*.sh and orchestrator.sh. Do not execute directly.

set -uo pipefail

# ---------------------------------------------------------------------------
# Paths (resolve relative to this file so the script is location-independent)
# ---------------------------------------------------------------------------
TF_DIR="${TF_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
TF_CONFIG_DIR="${TF_CONFIG_DIR:-$TF_DIR/config}"
TF_LIB_DIR="${TF_LIB_DIR:-$TF_DIR/lib}"
TF_STATE_DIR="${TF_STATE_DIR:-$TF_DIR/state}"
TF_LOG_DIR="${TF_LOG_DIR:-$TF_STATE_DIR/logs}"
TF_PROMPT_DIR="${TF_PROMPT_DIR:-$TF_DIR/prompts}"

# The git repo being modified. Defaults to 2 levels up from taskfleet/ (typical
# layout: repo/scripts/taskfleet/). Override via TF_REPO_DIR env var.
TF_REPO_DIR="${TF_REPO_DIR:-$(cd "$TF_DIR/../.." && pwd)}"

# Worktrees live inside the repo at .tf-worktrees/ (gitignored).
# Override via TF_WORKTREE_ROOT if you prefer them outside the repo.
TF_WORKTREE_ROOT="${TF_WORKTREE_ROOT:-$TF_REPO_DIR/.tf-worktrees}"

# Config files
WORKERS_JSON="${TF_WORKERS_JSON:-$TF_CONFIG_DIR/workers.json}"
TASKS_JSON="${TF_TASKS_JSON:-$TF_CONFIG_DIR/tasks.json}"
STATUS_JSON="${STATUS_JSON:-$TF_STATE_DIR/task-status.json}"
RUNSTATE_JSON="$TF_STATE_DIR/run-state.json"   # pid/workers-in-use, transient
REPOS_JSON="${TF_REPOS_JSON:-$TF_CONFIG_DIR/repos.json}"

# Branch prefix for agent work
TF_BRANCH_PREFIX="${TF_BRANCH_PREFIX:-tf}"

# Base branch that agent worktrees branch from AND merge back into.
# Defaults to 'main'; set to 'master' for repos that deploy from master.
TF_BASE_BRANCH="${TF_BASE_BRANCH:-main}"

# Ensure runtime dirs exist
mkdir -p "$TF_STATE_DIR" "$TF_LOG_DIR" "$TF_WORKTREE_ROOT"

# Optional: export extra env vars for acceptance gates.
# Set TF_GATE_ENV in your project's .env or shell to inject project-specific
# variables (e.g. RUSTUP_TOOLCHAIN=nightly, NODE_ENV=test).
if [[ -n "${TF_GATE_ENV:-}" ]]; then
  eval "export $TF_GATE_ENV"
fi

# ---------------------------------------------------------------------------
# Logging — Stoic discipline
# ---------------------------------------------------------------------------
# A calm tool speaks only when the operator can act. TF_LOG_LEVEL selects the
# threshold; messages at a level BELOW the threshold are silently dropped.
#   silent -> nothing
#   error  -> only ERROR
#   warn   -> ERROR + WARN              (default: quiet by default)
#   info   -> + INFO  (rounds, launches, progress)
#   debug  -> + DEBUG (routine recovery: stale-worktree pruning, zombie reset)
# Recovery from interrupted runs is logged at DEBUG, never WARN — describing
# something the tool already fixed is anger, not information.
TF_LOG_LEVEL="${TF_LOG_LEVEL:-warn}"

tf_log_level_rank() {
  # Levels are passed uppercase by tf_error/tf_info/... and may be set
  # uppercase by the operator, so normalise to lowercase first.
  local lvl="${1:-warn}"; lvl="${lvl,,}"
  case "$lvl" in
    silent|off|none)     echo 0 ;;
    error|err)           echo 1 ;;
    warn|warning)        echo 2 ;;
    info)                echo 3 ;;
    debug|trace|verbose) echo 4 ;;
    *)                   echo 2 ;;   # unknown level -> treat as warn threshold
  esac
}
tf_log() {
  local level="$1"; shift
  local rank threshold
  threshold="$(tf_log_level_rank "$TF_LOG_LEVEL")"
  rank="$(tf_log_level_rank "$level")"
  # Below threshold => remain silent (apatheia). Derived per-call so the level
  # can be raised/lowered at runtime (e.g. TF_LOG_LEVEL=debug ./orchestrator.sh).
  [[ "$rank" -le "$threshold" ]] || return 0
  local ts
  ts="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  printf '%s [%s] %s\n' "$ts" "$level" "$*" >&2
}
tf_debug() { tf_log "DEBUG" "$@"; }
tf_info()  { tf_log "INFO"  "$@"; }
tf_warn()  { tf_log "WARN"  "$@"; }
tf_error() { tf_log "ERROR" "$@"; }

# Backward-compatible aliases (wo_* → tf_*)
wo_log()  { tf_log  "$@"; }
wo_info() { tf_info "$@"; }
wo_warn() { tf_warn "$@"; }
wo_error(){ tf_error "$@"; }

# ---------------------------------------------------------------------------
# JSON helpers (require jq)
# ---------------------------------------------------------------------------
tf_require_jq() {
  if ! command -v jq >/dev/null 2>&1; then
    tf_error "jq is required but not on PATH. Install: apt install jq"
    return 1
  fi
}
wo_require_jq() { tf_require_jq "$@"; }

# Read a field from tasks.json for a given task id (raw, preserving type).
#   tf_task_field <task_id> <jq_path>   e.g. tf_task_field DM-3 .accept
tf_task_field() {
  jq -r --arg id "$1" '.tasks[] | select(.id==$id) | '"$2" "$TASKS_JSON"
}
wo_task_field() { tf_task_field "$@"; }

# Get the full task object as JSON
tf_task_json() {
  jq --arg id "$1" '.tasks[] | select(.id==$id)' "$TASKS_JSON"
}
wo_task_json() { tf_task_json "$@"; }

# List all task ids
tf_all_task_ids() {
  jq -r '.tasks[].id' "$TASKS_JSON"
}
wo_all_task_ids() { tf_all_task_ids "$@"; }

# Worker lookup: tf_worker <name> → JSON object
tf_worker() {
  jq --arg name "$1" '.workers[] | select(.name==$name and .enabled==true)' "$WORKERS_JSON"
}
wo_worker() { tf_worker "$@"; }

tf_worker_field() {
  jq -r --arg name "$1" '.workers[] | select(.name==$name) | '"$2" "$WORKERS_JSON"
}
wo_worker_field() { tf_worker_field "$@"; }

# List enabled worker names
tf_worker_names() {
  jq -r '.workers[] | select(.enabled==true) | .name' "$WORKERS_JSON"
}
wo_worker_names() { tf_worker_names "$@"; }

# Task model tier (booster|fast|standard|deep), default "standard"
tf_task_tier() {
  local t
  t="$(tf_task_field "$1" .model_tier 2>/dev/null || echo '')"
  [[ "$t" == "null" || -z "$t" ]] && echo "standard" || echo "$t"
}

# Worker tier capability. If worker has no "tiers" array, it handles ALL tiers.
# tf_worker_tiers <name> → prints space-separated tier list (default "booster fast standard deep")
tf_worker_tiers() {
  local tiers
  tiers="$(tf_worker_field "$1" '.tiers // [] | .[]' 2>/dev/null)"
  if [[ -n "$tiers" ]]; then
    echo "$tiers"
  else
    echo "booster fast standard deep"
  fi
}

# tf_worker_can_tier <name> <tier> → 0 if capable, 1 otherwise
tf_worker_can_tier() {
  tf_worker_tiers "$1" | grep -qw -- "$2"
}

# ---------------------------------------------------------------------------
# Multi-repo support helpers
# ---------------------------------------------------------------------------

# tf_task_repo <task_id> → prints repo name for task (from 'repo' field,
# default "" for main repo). Empty string means use TF_REPO_DIR.
tf_task_repo() {
  tf_task_field "$1" '.repo // ""' 2>/dev/null | tr -d '"'
}

# tf_repo_dir <repo_name> → prints the absolute path for a named repo.
# repo_name="" returns TF_REPO_DIR (default/main repo). Uses REPOS_JSON config:
#   {"repos": {"main": "/path/to/main", "docs": "/path/to/docs"}}
tf_repo_dir() {
  local repo_name="$1"
  if [[ -z "$repo_name" ]]; then
    echo "$TF_REPO_DIR"
    return
  fi
  if [[ -f "$REPOS_JSON" ]]; then
    local dir
    dir="$(jq -r --arg rn "$repo_name" '.repos[$rn] // empty' "$REPOS_JSON" 2>/dev/null)"
    if [[ -n "$dir" && -d "$dir" ]]; then
      echo "$dir"
      return
    fi
  fi
  # Fallback: repo name is interpreted as a relative path from TF_DIR
  if [[ -d "$TF_DIR/$repo_name" ]]; then
    echo "$(cd "$TF_DIR/$repo_name" && pwd)"
    return
  fi
  # Last fallback: repo name is an absolute path
  if [[ -d "$repo_name" ]]; then
    echo "$(cd "$repo_name" && pwd)"
    return
  fi
  # Not found
  tf_error "repo '$repo_name' not found in repos.json and not a valid path"
  echo "$TF_REPO_DIR"
}

# Default config value
tf_default() {
  jq -r --arg k "$1" '.defaults[$k] // empty' "$WORKERS_JSON"
}
wo_default() { tf_default "$@"; }

# ---------------------------------------------------------------------------
# Robustness: stale process lifecycle (L1)
# ---------------------------------------------------------------------------

# Kill stale taskfleet processes from previous runs: orchestrators and their
# pi children. Orphaned dispatch subshells (backgrounded via `&`) survive a
# parent kill and keep polling worktrees + writing run-state, polluting the
# next run. Runs at startup; never kills the current process tree.
tf_kill_stale_processes() {
  local self_pid="$$"
  local kill_list=""
  # Match: orchestrator.sh, wo-orchestrator-wrapper.sh, timeout N pi
  local pats=("orchestrator.sh" "wo-orchestrator-wrapper" "timeout [0-9]* pi")
  local p
  for pat in "${pats[@]}"; do
    while IFS= read -r line; do
      [[ -z "$line" ]] && continue
      local pid
      pid="$(echo "$line" | awk '{print $1}')"
      [[ "$pid" == "$self_pid" ]] && continue
      # skip our own ancestors
      local ppid
      ppid="$(ps -o ppid= -p "$pid" 2>/dev/null | tr -d ' ')"
      [[ "$ppid" == "$self_pid" ]] && continue
      # skip already-dead
      kill -0 "$pid" 2>/dev/null || continue
      kill_list="$kill_list $pid"
    done < <(pgrep -af "$pat" 2>/dev/null || true)
  done
  if [[ -n "$kill_list" ]]; then
    tf_debug "killing $(echo $kill_list | wc -w) stale taskfleet process(es):$kill_list"
    # shellcheck disable=SC2086
    kill -9 $kill_list 2>/dev/null || true
    sleep 1
  fi
}

# ---------------------------------------------------------------------------
# Robustness: stale worktree/branch recovery (L2)
# ---------------------------------------------------------------------------

# Remove stale worktrees from interrupted runs. Killed orchestrators leave
# git worktree metadata + checked-out branches; a fresh run's worktree
# creation then fails ("git branch -f failed") → tasks fail instantly →
# deadlock. Preserves branches listed in $1 (space-separated) — these carry
# preserved work for conflict-retry (--keep-branch).
tf_recover_stale_worktrees() {
  local preserve="$1"
  local wt
  # Normalize TF_REPO_DIR to the canonical path that git worktree list outputs.
  # On Windows/MSYS, TF_REPO_DIR may be /c/Users/... but git outputs C:/Users/...
  local canonical_repo_dir
  canonical_repo_dir="$(cd "$TF_REPO_DIR" 2>/dev/null && git rev-parse --show-toplevel 2>/dev/null || echo "$TF_REPO_DIR")"
  while IFS= read -r wt; do
    [[ -z "$wt" ]] && continue
    # Skip the main worktree — never remove it (path comparison must handle
    # both /c/Users/... and C:/Users/... formats on Windows/MSYS).
    local canonical_wt
    canonical_wt="$(cd "$wt" 2>/dev/null && pwd -W 2>/dev/null || echo "$wt")"
    if [[ "$canonical_wt" == "$canonical_repo_dir" || "$wt" == "$TF_REPO_DIR" ]]; then
      tf_debug "skipping main worktree $wt"
      continue
    fi
    local branch
    branch="$(git -C "$wt" symbolic-ref --short HEAD 2>/dev/null || true)"
    if [[ -n "$preserve" ]] && grep -qw "$branch" <<< "$preserve"; then
      tf_debug "preserving worktree $wt ($branch — conflict-retry work)"
      continue
    fi
    tf_debug "removing stale worktree $wt (branch=${branch:-detached})"
    git worktree remove "$wt" --force 2>/dev/null || rm -rf "$wt" 2>/dev/null
  done < <(git -C "$TF_REPO_DIR" worktree list --porcelain 2>/dev/null \
           | grep '^worktree ' | sed 's/worktree //' || true)
  git -C "$TF_REPO_DIR" worktree prune 2>/dev/null || true
  # Delete stale tf/* branches that have no live worktree and aren't preserved.
  # (Branch deletion requires the branch to not be checked out — pruning above
  #  removes the metadata so git allows deletion.)
  local b
  while IFS= read -r b; do
    [[ -z "$b" ]] && continue
    [[ "$b" == main ]] && continue
    if [[ -n "$preserve" ]] && grep -qw "$b" <<< "$preserve"; then
      continue
    fi
    # only prune branches whose worktree is gone (git says "not a working tree")
    local wtpath
    wtpath="$(git -C "$TF_REPO_DIR" worktree list --porcelain 2>/dev/null | grep -B1 "branch refs/heads/$b$" | head -1 | sed 's/worktree //')"
    if [[ -z "$wtpath" ]]; then
      tf_debug "deleting stale branch $b (no live worktree)"
      git -C "$TF_REPO_DIR" branch -D "$b" 2>/dev/null || true
    fi
  done < <(git -C "$TF_REPO_DIR" branch --list 'tf/*' 'agent/*' 2>/dev/null | sed 's/^[*+ ]*//' || true)
}

# Reset run-state entries whose process is dead (task marked running but the
# dispatch pid no longer exists). Prevents "phantom running" tasks that block
# their slot forever.
tf_reset_dead_runstate() {
  [[ -f "$RUNSTATE_JSON" ]] || return 0
  local id pid
  local ids
  ids="$(jq -r 'keys[]' "$RUNSTATE_JSON" 2>/dev/null)" || return 0
  while IFS= read -r id; do
    [[ -z "$id" ]] && continue
    pid="$(jq -r --arg id "$id" '.[$id].pid' "$RUNSTATE_JSON" 2>/dev/null)"
    if [[ -z "$pid" ]] || ! kill -0 "$pid" 2>/dev/null; then
      tf_debug "resetting $id: run-state pid $pid is dead (stale from interrupted run)"
      tf_status_set "$id" ready 2>/dev/null || true
      tf_runstate_clear "$id" 2>/dev/null || true
    fi
  done <<< "$ids"

  # Complement: a reaped dispatch subshell can clear its run-state entry
  # while the task status stays in a transient state (running/verifying).
  # Any transient-status task WITHOUT a live run-state pid is a zombie.
  local transient
  transient="$(jq -r 'to_entries[] | select(.value.status == "running" or .value.status == "verifying") | .key' "$STATUS_JSON" 2>/dev/null)" || return 0
  while IFS= read -r id; do
    [[ -z "$id" ]] && continue
    pid="$(jq -r --arg id "$id" '.[$id].pid // empty' "$RUNSTATE_JSON" 2>/dev/null)"
    if [[ -z "$pid" ]] || ! kill -0 "$pid" 2>/dev/null; then
      tf_debug "resetting $id: transient status without live dispatch pid (zombie task)"
      tf_status_set "$id" ready '.last_error="recovered: dispatch pid gone while status was transient"' 2>/dev/null || true
      tf_runstate_clear "$id" 2>/dev/null || true
    fi
  done <<< "$transient"
}

# ---------------------------------------------------------------------------
# Robustness: task/gate validation (L3)
# ---------------------------------------------------------------------------

# Validate the whole task ledger at startup. Catches problems that would
# otherwise burn attempts: invalid gate syntax, deps referencing unknown
# tasks, empty gates. Prints findings; returns 1 if any are fatal.
tf_validate_tasks() {
  local issues=0
  local id accept deps dep
  while IFS= read -r id; do
    [[ -z "$id" ]] && continue
    accept="$(tf_task_field "$id" .accept)"
    if [[ -z "$accept" || "$accept" == "null" ]]; then
      tf_warn "task $id: no accept command (manual sign-off)"
      continue
    fi
    # cargo test with TWO bare test-name patterns is invalid: `cargo test a:: b::`.
    # Flags (-p, --lib, -- --list) are fine. Match two consecutive bare patterns
    # (alphanumeric/underscore/colon), i.e. no leading dash.
    if echo "$accept" | grep -qP 'cargo test -p \S+ [a-zA-Z0-9_:]+ [a-zA-Z0-9_:]+'; then
      local bad
      bad="$(echo "$accept" | grep -oP 'cargo test -p \S+ [a-zA-Z0-9_:]+ [a-zA-Z0-9_:]+' | head -1)"
      tf_warn "task $id: gate likely invalid (cargo test takes one test-name pattern): $bad"
      issues=$((issues + 1))
    fi
    # deps must reference known task ids
    while IFS= read -r dep; do
      [[ -z "$dep" ]] && continue
      if ! grep -qxF "$dep" < <(tf_all_task_ids); then
        tf_warn "task $id: dependency '$dep' does not match any task id"
        issues=$((issues + 1))
      fi
    done < <(tf_task_field "$id" '.deps[]')
  done < <(tf_all_task_ids)
  if [[ $issues -gt 0 ]]; then
    tf_warn "task validation: $issues issue(s) found (see above)"
    return 1
  fi
  tf_info "task validation: all $(( $(jq '.tasks | length' "$TASKS_JSON") )) tasks OK"
  return 0
}

# ---------------------------------------------------------------------------
# Robustness: provider health (L4)
# ---------------------------------------------------------------------------

# Cheap liveness probe for a worker endpoint (GET /models, 5s timeout).
# Returns 0 if the endpoint responds, non-zero otherwise. Used before
# dispatch to avoid wasting a 1h attempt on a dead/rate-limited provider.
tf_worker_healthy() {
  local worker="$1"
  local endpoint provider
  endpoint="$(tf_worker_field "$worker" .endpoint)"
  provider="$(tf_worker_field "$worker" .provider)"
  [[ -z "$endpoint" || "$endpoint" == "null" ]] && return 0   # no endpoint → assume OK
  case "$provider" in
    zai)  return 0 ;;  # needs auth header; probe via real dispatch only
    tud)  return 0 ;;
    saia) return 0 ;;  # SAIA cluster — probe via real dispatch only
    google) return 0 ;;  # Google AI — pi handles auth internally
    opencode) return 0 ;;  # OpenCode — pi handles auth internally
    litellm)
      # LiteLLM gateway requires the API key on /v1/models; without it the
      # probe 401s forever and the worker looks permanently unhealthy.
      local key="${TF_LITELLM_API_KEY:-}"
      if [[ -z "$key" && -f "$HOME/.pi/agent/models.json" ]]; then
        key="$(jq -r '.providers.litellm.apiKey // empty' "$HOME/.pi/agent/models.json" 2>/dev/null)"
      fi
      if [[ -n "$key" ]]; then
        timeout 5 curl -sf -o /dev/null -H "Authorization: Bearer $key" "$endpoint/models" 2>/dev/null && return 0
      fi
      ;;
    *) ;;
  esac
  timeout 5 curl -sf -o /dev/null "$endpoint/models" 2>/dev/null && return 0
  # LiteLLM gateway uses /v1/models
  timeout 5 curl -sf -o /dev/null "$endpoint/v1/models" 2>/dev/null && return 0
  return 1
}

# Classify a dispatch log for provider-level failures (rate limit, auth).
# Prints the category or empty. Called after a failed dispatch attempt.
tf_classify_dispatch_failure() {
  local log="$1"
  [[ -f "$log" ]] || return 0
  if grep -qiE 'rate.?limit|usage limit|quota|429|1308' "$log"; then
    echo "rate_limit"
  elif grep -qiE 'unauthorized|invalid api key|401|403|authentication' "$log"; then
    echo "auth_error"
  elif grep -qiE 'connection refused|timed out|network|ECONNREFUSED' "$log"; then
    echo "network_error"
  fi
}
