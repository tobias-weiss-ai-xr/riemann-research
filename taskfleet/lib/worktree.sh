#!/usr/bin/env bash
# worktree.sh — git worktree lifecycle for taskfleet.
#
# Each task runs in its own worktree on branch "$TF_BRANCH_PREFIX/<TASK_ID>",
# branched from origin/main (or local main). This gives full isolation:
# concurrent workers never touch each other's files.

# shellcheck source=common.sh
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

# --- Merge lock configuration ---
# TF_MERGE_LOCK_MODE: "global" (default) or "per-file"
#   global: single lock file for all merges (backward compatible)
#   per-file: one lock per scope file; tasks with disjoint scope merge in parallel
TF_MERGE_LOCK_MODE="${TF_MERGE_LOCK_MODE:-global}"

# Ensure the worktree root is gitignored at the repo root — but ONLY when the
# worktree root lives INSIDE the repo (out-of-repo roots can't pollute status).
# Idempotent.
tf_worktree_ensure_gitignore() {
  local repo_dir="${1:-$TF_REPO_DIR}"
  case "$TF_WORKTREE_ROOT" in
    "$repo_dir"/*) : ;;  # inside repo → must be ignored
    *) return 0 ;;          # outside repo → no pollution, nothing to do
  esac
  local gi="$repo_dir/.gitignore"
  local rel="${TF_WORKTREE_ROOT#"$repo_dir/"}"
  if (cd "$repo_dir" && git check-ignore -q "$rel" 2>/dev/null); then
    return 0
  fi
  tf_info "adding $rel to .gitignore (worktree root was not ignored)"
  {
    printf '\n# taskfleet worktrees (do not commit)\n%s/\n' "$rel"
  } >> "$gi"
}

# tf_worktree_create <task_id> [base_ref] [--keep-branch]
#   Prints the worktree path. Creates branch $TF_BRANCH_PREFIX/<task_id>.
#   --keep-branch: reuse an existing branch (its commits are preserved) instead
#   of resetting it to the base — used when retrying a merge-conflict failure so
#   the agent resumes its own work rather than starting from scratch.
tf_worktree_create() {
  local id="$1" base="${2:-${TF_BASE_BRANCH}}" keep=0
  [[ "${3:-}" == "--keep-branch" ]] && keep=1
  local branch="$TF_BRANCH_PREFIX/$id"
  local wt="$TF_WORKTREE_ROOT/$id"
  
  # Multi-repo: resolve repo directory for this task
  local task_repo
  task_repo="$(tf_task_repo "$id")"
  local repo_dir
  repo_dir="$(tf_repo_dir "$task_repo")"
  
  tf_worktree_ensure_gitignore "$repo_dir"

  if [[ -d "$wt" ]]; then
    tf_debug "$id: worktree exists at $wt, removing stale copy"
    tf_worktree_remove "$id" --force || true
  fi

  # Update base ref so we branch from the latest merged state.
  (cd "$repo_dir" && git fetch --quiet github 2>/dev/null || true)
  (cd "$repo_dir" && git rev-parse --verify --quiet "$base" >/dev/null) || base="${TF_BASE_BRANCH}"

  if ! (cd "$repo_dir" && git rev-parse --verify --quiet "$branch" >/dev/null); then
    (cd "$repo_dir" && git worktree add -b "$branch" "$wt" "$base" >/dev/null 2>&1) || {
      tf_error "$id: git worktree add failed for $branch from $base"
      return 1
    }
  elif [[ "$keep" == "1" ]]; then
    # Resume preserved work: attach a worktree to the existing branch. The
    # agent (guided by PREVIOUS_ERROR) will rebase onto main and resolve the
    # conflict in-place.
    tf_debug "$id: resuming preserved branch $branch (merge-conflict retry)"
    (cd "$repo_dir" && git worktree add "$wt" "$branch" >/dev/null 2>&1) || {
      tf_error "$id: git worktree add (preserved branch) failed"
      return 1
    }
  else
    # branch exists (interrupted prior run) — reset to fresh base so the retry
    # starts from current main, NOT stale state. A stale branch would re-conflict
    # on merge because main has advanced since the branch was created.
    (cd "$repo_dir" && git branch -f "$branch" "$base" >/dev/null 2>&1) || {
      tf_error "$id: git branch -f (reset stale branch) failed"
      return 1
    }
    (cd "$repo_dir" && git worktree add "$wt" "$branch" >/dev/null 2>&1) || {
      tf_error "$id: git worktree add (existing branch) failed"
      return 1
    }
  fi
  # Symlink node_modules so acceptance gates (npx jest / npx openspec) work
  # inside the isolated worktree without a full npm install. The chemie repo
  # keeps node_modules at the repo root; a symlink is sufficient and cheap.
  if [[ -d "$repo_dir/node_modules" && ! -e "$wt/node_modules" ]]; then
    ln -s "$repo_dir/node_modules" "$wt/node_modules" 2>/dev/null \
      || tf_warn "$id: could not symlink node_modules into worktree"
  fi

  echo "$wt"
}

# tf_worktree_remove <task_id> [--force]
tf_worktree_remove() {
  local id="$1"; shift
  local force=""
  [[ "${1:-}" == "--force" ]] && force="--force"
  local wt="$TF_WORKTREE_ROOT/$id"
  
  # Multi-repo: resolve repo directory for this task
  local task_repo
  task_repo="$(tf_task_repo "$id")"
  local repo_dir
  repo_dir="$(tf_repo_dir "$task_repo")"
  
  if [[ -d "$wt" ]]; then
    (cd "$repo_dir" && git worktree remove $force "$wt" 2>/dev/null) || {
      # worktree may have untracked files; prune metadata instead
      rm -rf "$wt"
      (cd "$repo_dir" && git worktree prune)
    }
  fi
}

# tf_checkout_base
#   Check out the configured base branch as a real (symbolic) local branch.
#   tf_worktree_merge needs a local branch so merge commits advance the ref;
#   checking out a fully-qualified ref (e.g. refs/heads/nix, origin/main)
#   detaches HEAD and silently orphans merges.
tf_checkout_base() {
  local base_ref="${TF_BASE_BRANCH:-main}"
  local short="${base_ref##*/}"
  if [[ -n "$short" && "$base_ref" != "$short" ]]; then
    git checkout --quiet -B "$short" "$base_ref"
  else
    git checkout --quiet -B "$base_ref" "$base_ref"
  fi
}

# tf_worktree_merge <task_id>
#   Merge the task branch into main under a lock.
#   In global mode (default), only one merge can happen at a time.
#   In per-file mode, tasks with disjoint scope can merge in parallel.
#
#   Lock modes:
#     TF_MERGE_LOCK_MODE=global (default): uses $TF_MERGE_LOCK (state/merge.lock)
#     TF_MERGE_LOCK_MODE=per-file: uses per-scope-file locks under
#         $TF_STATE_DIR/merge-locks/.  Tasks only block on their scope files.
#
#   Returns 0 on successful merge, 1 on failure.
#   In per-file mode with lock contention, retry up to 3 times (1s intervals).
tf_worktree_merge() {
  local branch="$TF_BRANCH_PREFIX/$id"
  
  # Multi-repo: resolve repo directory for this task
  local task_repo
  task_repo="$(tf_task_repo "$id")"
  local repo_dir
  repo_dir="$(tf_repo_dir "$task_repo")"
  
  local id="$1"
  local branch="$TF_BRANCH_PREFIX/$id"

  if [[ "$TF_MERGE_LOCK_MODE" == "per-file" ]]; then
    # Per-file locking: tasks sharing a scope file serialize; disjoint tasks
    # merge in parallel. Retry on contention up to 3 times.
    local acquired_lock_dir
    acquired_lock_dir="$(mktemp)"
    local max_retries=3 retry_delay=1 attempt=1

    while [[ $attempt -le $max_retries ]]; do
      if _tf_merge_acquire_per_file_locks "$id" "$acquired_lock_dir"; then
        # Successfully acquired all locks — run the merge
        local rc=1
        local merge_output
        merge_output=$(
          cd "$repo_dir" || return 1
          tf_checkout_base
          git reset --hard --quiet "${TF_BASE_BRANCH}"
          git clean --quiet -fd
          local before
          before="$(git rev-parse HEAD)"
          if git merge --ff-only "$branch" >/dev/null 2>&1; then
            if [[ "$before" != "$(git rev-parse HEAD)" ]]; then
              rc=0
            else
              tf_warn "$id: ff-only merge was no-op (branch HEAD == main HEAD); skipping"
              rc=1
            fi
          else
            local wt="$TF_WORKTREE_ROOT/$id"
            if [[ -d "$wt" ]] && (cd "$wt" && git rebase --autostash "${TF_BASE_BRANCH}" >/dev/null 2>&1); then
              cd "$repo_dir"
              if git merge --ff-only "$branch" >/dev/null 2>&1; then
                if [[ "$before" != "$(git rev-parse HEAD)" ]]; then
                  tf_info "$id: rebased onto main and merged (ff-only)"
                  rc=0
                fi
              fi
              (cd "$wt" 2>/dev/null && git rebase --abort 2>/dev/null) || true
              cd "$repo_dir"
            fi
            if [[ $rc -ne 0 ]] && git merge --no-ff -m "merge($id): agent task completed" "$branch" >/dev/null 2>&1; then
              if [[ "$before" != "$(git rev-parse HEAD)" ]]; then
                rc=0
              fi
            fi
            if [[ $rc -ne 0 ]]; then
              git merge --abort 2>/dev/null || true
              tf_checkout_base
              git reset --hard --quiet "${TF_BASE_BRANCH}"
              git clean --quiet -fd
            fi
          fi
          echo "$rc"
        )
        rc="$merge_output"
        _tf_merge_release_per_file_locks "$acquired_lock_dir"
        return $rc
      else
        # Contention on lock(s) — wait and retry
        if [[ $attempt -lt $max_retries ]]; then
          tf_info "$id: merge lock contention, retry $((attempt + 1))/$max_retries in ${retry_delay}s"
          sleep "$retry_delay"
        else
          tf_error "$id: merge lock contention after $max_retries attempts"
        fi
        attempt=$((attempt + 1))
      fi
    done
    return 1
  else
    # Global locking (default, backward compatible)
    local merge_lock="${TF_MERGE_LOCK:-$TF_STATE_DIR/merge.lock}"
    mkdir -p "$(dirname "$merge_lock")"
    (
      flock 9
      cd "$repo_dir" || return 1
      tf_checkout_base
      git reset --hard --quiet "${TF_BASE_BRANCH}"
      git clean --quiet -fd
      local before
      before="$(git rev-parse HEAD)"
      if git merge --ff-only "$branch" >/dev/null 2>&1; then
        if [[ "$before" == "$(git rev-parse HEAD)" ]]; then
          tf_warn "$id: ff-only merge was no-op (branch HEAD == main HEAD); skipping"
          return 1
        fi
        return 0
      fi
      local wt="$TF_WORKTREE_ROOT/$id"
      if [[ -d "$wt" ]] && (cd "$wt" && git rebase --autostash "${TF_BASE_BRANCH}" >/dev/null 2>&1); then
        cd "$repo_dir"
        if git merge --ff-only "$branch" >/dev/null 2>&1; then
          if [[ "$before" != "$(git rev-parse HEAD)" ]]; then
            tf_info "$id: rebased onto main and merged (ff-only)"
            return 0
          fi
        fi
        (cd "$wt" 2>/dev/null && git rebase --abort 2>/dev/null) || true
        cd "$repo_dir"
      fi
      if git merge --no-ff -m "merge($id): agent task completed" "$branch" >/dev/null 2>&1; then
        if [[ "$before" != "$(git rev-parse HEAD)" ]]; then
          return 0
        fi
      fi
      git merge --abort 2>/dev/null || true
      tf_checkout_base
      git reset --hard --quiet "${TF_BASE_BRANCH}"
      git clean --quiet -fd
      return 1
    ) 9>"$merge_lock"
    return $?
  fi
}

# ---------------------------------------------------------------------------
# Per-file merge lock helpers (internal; used when TF_MERGE_LOCK_MODE=per-file)
# ---------------------------------------------------------------------------

# _tf_merge_lock_dir <scope_file> → prints the lock directory path
# Encodes the file path to be filesystem-safe: / → _, . → -, space → __
_tf_merge_lock_dir() {
  local scope_file="$1"
  # Replace /, ., and spaces with filesystem-safe characters
  local safe
  safe="$(printf '%s' "$scope_file" | sed 's/[\/.]/_/g; s/  /__/g; s/^ *//; s/ *$//')"
  echo "$TF_STATE_DIR/merge-locks/$safe"
}

# _tf_merge_acquire_per_file_locks <task_id> <acquired_list_file>
#   Acquires a lock directory for each file in the task's scope.
#   If any lock is held (mkdir fails), releases ALL lock dirs and returns 1.
#   On success, writes the list of acquired lock dirs to <acquired_list_file>
#   (one per line) so they can be released later.
#   Returns 0 on success (all locks acquired), 1 on contention.
_tf_merge_acquire_per_file_locks() {
  local id="$1" acquired_list_file="$2"
  > "$acquired_list_file"  # truncate
  local lock_dir lock_path scope_file
  local acquired=()
  local contention=0

  while IFS= read -r scope_file; do
    [[ -z "$scope_file" ]] && continue
    lock_dir="$(_tf_merge_lock_dir "$scope_file")"
    mkdir -p "$(dirname "$lock_dir")"
    if mkdir "$lock_dir" 2>/dev/null; then
      acquired+=("$lock_dir")
      echo "$lock_dir" >> "$acquired_list_file"
    else
      contention=1
      break
    fi
  done < <(tf_task_field "$id" '.scope[]' 2>/dev/null || true)

  if [[ $contention -ne 0 ]]; then
    # Release all lock dirs we did acquire
    for lock_path in "${acquired[@]}"; do
      rmdir "$lock_path" 2>/dev/null || true
    done
    > "$acquired_list_file"  # clear the partial list
    return 1
  fi

  return 0
}

# _tf_merge_release_per_file_locks <acquired_list_file>
#   Releases all lock directories listed in the file.
_tf_merge_release_per_file_locks() {
  local acquired_list_file="$1"
  local lock_path
  while IFS= read -r lock_path; do
    [[ -z "$lock_path" ]] && continue
    rmdir "$lock_path" 2>/dev/null || true
  done < "$acquired_list_file"
  rm -f "$acquired_list_file"
}

# tf_worktree_conflicts <task_id> → names of files with unresolved conflict
# markers in the task's worktree (empty if none). Run AFTER a failed merge
# but BEFORE aborting, or in the worktree after a conflicted rebase.
tf_worktree_conflicts() {
  local id="$1"
  local wt="$TF_WORKTREE_ROOT/$id"
  (cd "$wt" 2>/dev/null && git diff --name-only --diff-filter=U 2>/dev/null) || true
}

# Delete the task branch (after successful merge). Keeps the reflog for recovery.
tf_worktree_delete_branch() {
  local id="$1"
  local branch="$TF_BRANCH_PREFIX/$id"
  
  # Multi-repo: resolve repo directory for this task
  local task_repo
  task_repo="$(tf_task_repo "$id")"
  local repo_dir
  repo_dir="$(tf_repo_dir "$task_repo")"
  
  (cd "$repo_dir" && git branch --quiet -D "$branch" 2>/dev/null) || true
}

# List active worktrees (for diagnostics)
tf_worktree_list() {
  (cd "$TF_REPO_DIR" && git worktree list)
}
