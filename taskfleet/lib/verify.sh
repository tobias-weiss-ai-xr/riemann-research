#!/usr/bin/env bash
# verify.sh — acceptance-gate runner + error classifier for taskfleet.
#
# Runs the task's `accept` command inside its worktree. Returns 0 iff green.
# Captures combined stdout+stderr to the task log. On failure, classifies the
# error into a structured category for smart retry.

# shellcheck source=common.sh
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

# ---------------------------------------------------------------------------
# Error classification: parse the gate log and produce a structured verdict.
# Categories:
#   compile_error    — Rust/TS/C/etc syntax or type error
#   test_failure     — tests compiled but some assertion failed
#   missing_package  — crate/npm package not found (often scope/config error)
#   linker_error     — undefined symbols, missing libraries
#   timeout          — gate exceeded time limit
#   unknown          — anything else
# ---------------------------------------------------------------------------

# tf_classify_error <log_file> → prints "category: concise summary"
tf_classify_error() {
  local log="$1"
  [[ -f "$log" ]] || { echo "unknown: no log"; return; }

  local last30
  last30="$(tail -30 "$log" 2>/dev/null)"
  # Empty log → unknown (not "no log" which confuses edge-case tests)
  [[ -z "$last30" ]] && { echo "unknown: empty log"; return; }

  # timeout (caught before classify usually, but as fallback)
  if grep -qi 'timeout\|timed out' <<< "$last30"; then
    echo "timeout: acceptance gate exceeded time limit"
    return
  fi

  # linker error: undefined symbol / ld returned
  if grep -qi 'undefined symbol\|rust-lld: error\|ld returned\|could not compile.*link\|Linker' <<< "$last30"; then
    # Extract first 3 unique symbol names for the summary
    local syms
    syms="$(grep -oP 'undefined symbol: \K\S+' "$log" 2>/dev/null | sort -u | head -3 | tr '\n' ', ')"
    echo "linker_error: undefined symbols (${syms}…) — likely missing or mismatched native library"
    return
  fi

  # missing package: "did not match any packages" / "no such package"
  if grep -qi 'did not match any packages\|no such package\|package .* not found\|not found in registry\|error: no matching package' <<< "$last30"; then
    local pkg
    pkg="$(grep -oP 'package ID specification `\K[^`]+|package `\K[^`]+ not found' "$log" 2>/dev/null | head -1)"
    echo "missing_package: package '${pkg:-unknown}' not found in workspace — crate may need to be created first or added to Cargo.toml [members]"
    return
  fi

  # Rust compile error: "error[E" / "error: mismatched" / "error: could not compile"
  if grep -qP 'error\[E\d+\]|error: mismatched|error: could not compile `|error\[E' <<< "$last30"; then
    # Count errors
    local errs last_err
    errs="$(grep -cP '^error' "$log" 2>/dev/null || echo 0)"
    # Get the last "error:" line for summary
    last_err="$(grep -P '^error' "$log" 2>/dev/null | tail -1)"
    echo "compile_error: ${errs} error(s) — last: ${last_err}"
    return
  fi

  # TypeScript/JS compile error
  if grep -qi 'error TS[0-9]\|Cannot find module\|Type error' <<< "$last30"; then
    local ts_err
    ts_err="$(grep -P 'error TS[0-9]+|Type error' "$log" 2>/dev/null | tail -1)"
    echo "compile_error: TypeScript — ${ts_err}"
    return
  fi

  # test failure: "test result: FAILED" / "FAIL" / "assertion" / panic
  if grep -qi 'test result.*FAILED\|assertion.*failed\|panicked at\|thread .* panicked' <<< "$last30"; then
    local tests
    tests="$(grep -oP 'test result: FAILED\. \K[^.]*' "$log" 2>/dev/null | head -1)"
    local panic
    panic="$(grep 'panicked at' "$log" 2>/dev/null | tail -1)"
    if [[ -n "$panic" ]]; then
      echo "test_failure: test panicked — ${panic#*: }"
    elif [[ -n "$tests" ]]; then
      echo "test_failure: $tests"
    else
      echo "test_failure: some tests failed"
    fi
    return
  fi

  # generic "error: could not compile" (catch-all for Rust)
  if grep -q 'error: could not compile' <<< "$last30"; then
    local crate_err
    crate_err="$(grep -oP 'error: could not compile `\K[^`]+|error: could not compile \K\S+' "$log" 2>/dev/null | tail -1)"
    echo "compile_error: could not compile ${crate_err:-crate}"
    return
  fi

  # npm/pnpm build error
  if grep -qi 'ERR!\|npm ERR\|pnpm ERR\|build failed' <<< "$last30"; then
    local npm_err
    npm_err="$(grep -P 'ERR!\s+\K.*' "$log" 2>/dev/null | tail -1)"
    echo "compile_error: npm/pnpm build — ${npm_err:-check log}"
    return
  fi

  # cargo clippy warning treated as error
  if grep -qi 'warning.*denied\|error:.*clippy\|clippy::' <<< "$last30"; then
    local clip
    clip="$(grep -oP 'error\[\S+\]: \K.*' "$log" 2>/dev/null | tail -1)"
    echo "compile_error: clippy — ${clip:-check log}"
    return
  fi

  echo "unknown: exit non-zero (see log for details)"
}

# ---------------------------------------------------------------------------
# Extract a concise error snippet for injection into retry prompts.
# Shows the last ~20 lines of actual error output (skip pass lines).
# ---------------------------------------------------------------------------
tf_error_snippet() {
  local log="$1"
  [[ -f "$log" ]] || return
  # Get lines after the last "error:" or "FAIL" occurrence, up to 20 lines
  local start_line
  start_line="$(grep -n -P '^error|^FAIL|error\[' "$log" 2>/dev/null | tail -1 | cut -d: -f1)"
  if [[ -n "$start_line" ]]; then
    tail -n +"$start_line" "$log" | head -25
  else
    tail -20 "$log"
  fi
}

# ---------------------------------------------------------------------------
# tf_verify <task_id> <worktree_path>
# Echoes "PASS" or "FAIL: <reason>". Exit code mirrors pass/fail.
# On failure, writes structured classification to $TF_LOG_DIR/$id.error.json
# ---------------------------------------------------------------------------
tf_verify() {
  local id="$1" wt="$2"
  local accept timeout_s log
  accept="$(tf_task_field "$id" .accept)"
  timeout_s="$(tf_default accept_timeout_s)"; timeout_s="${timeout_s:-900}"
  log="$TF_LOG_DIR/$id.verify.log"

  if [[ -z "$accept" || "$accept" == "null" ]]; then
    tf_warn "$id: no accept command defined — skipping gate (manual sign-off)"
    echo "SKIP: no accept command (manual task)"
    return 0
  fi

  tf_info "$id: running acceptance gate (${timeout_s}s): $accept"
  {
    echo "=== $id acceptance gate: $accept ==="
    echo "=== worktree: $wt ==="
    echo "=== started: $(date -u +%Y-%m-%dT%H:%M:%SZ) ==="
  } > "$log"

  local rc=0
  (
    cd "$wt" || exit 127
    # Write the accept command to a temp file to avoid quoting issues with
    # backticks and special characters inside bash -lc "...$accept...".
    local gate_script="$TF_STATE_DIR/.gate-$id.sh"
    { echo '#!/bin/bash'; echo "export PATH=\$HOME/.cargo/bin:\$PATH"; [[ -n "${TF_GATE_ENV:-}" ]] && echo "export $TF_GATE_ENV"; echo "$accept"; } > "$gate_script"
    chmod +x "$gate_script"
    timeout "$timeout_s" bash -l "$gate_script"
    rm -f "$gate_script"
  ) >> "$log" 2>&1 || rc=$?

  if [[ $rc -eq 0 ]]; then
    tf_info "$id: gate PASS"
    # Remove any previous error classification
    rm -f "$TF_LOG_DIR/$id.error.json"
    echo "PASS"
    return 0
  elif [[ $rc -eq 124 ]]; then
    tf_error "$id: gate TIMEOUT after ${timeout_s}s"
    tf_write_error_json "$id" "timeout" "acceptance gate exceeded time limit"
    echo "FAIL: timeout after ${timeout_s}s"
    return 1
  else
    tf_error "$id: gate FAIL (exit $rc) — see $log"
    local classification
    classification="$(tf_classify_error "$log")"
    local category="${classification%%:*}"
    local summary="${classification#*: }"
    tf_write_error_json "$id" "$category" "$summary"
    echo "FAIL: exit $rc — $classification"
    return 1
  fi
}

# tf_write_error_json <task_id> <category> <summary>
#   Writes structured error classification for use by retry/dispatch logic.
tf_write_error_json() {
  local id="$1" category="$2" summary="$3"
  local errfile="$TF_LOG_DIR/$id.error.json"
  jq -n --arg cat "$category" --arg sum "$summary" \
    --arg now "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
    '{category: $cat, summary: $sum, classified_at: $now}' \
    > "$errfile"
}

# tf_get_error_category <task_id> → prints category or "none"
tf_get_error_category() {
  local errfile="$TF_LOG_DIR/$1.error.json"
  if [[ -f "$errfile" ]]; then
    jq -r '.category // "none"' "$errfile"
  else
    tf_status_get "$1" .error_category 2>/dev/null || echo "none"
  fi
}

# tf_get_error_summary <task_id> → prints summary or ""
tf_get_error_summary() {
  local errfile="$TF_LOG_DIR/$1.error.json"
  if [[ -f "$errfile" ]]; then
    jq -r '.summary // ""' "$errfile"
  else
    tf_status_get "$1" .error_summary 2>/dev/null || echo ""
  fi
}

# tf_get_last_attempt <task_id> → prints attempt number
tf_get_last_attempt() {
  tf_status_get "$1" .attempts
}

# ---------------------------------------------------------------------------
# tf_verify_scope <task_id> <worktree_path>
#   Advisory check: did the worker edit only in-scope files? Prints warnings
#   for out-of-scope edits but does NOT fail the task (the acceptance gate is
#   authoritative). Helps catch scope drift.
# ---------------------------------------------------------------------------
tf_verify_scope() {
  local id="$1" wt="$2"
  local log="$TF_LOG_DIR/$id.scope.log"
  {
    echo "=== $id scope check ==="
  } > "$log"

  local changed
  changed="$(cd "$wt" && git diff --name-only "${TF_BASE_BRANCH}"...HEAD 2>/dev/null)" || true
  [[ -z "$changed" ]] && { echo "none"; return 0; }

  local allowed
  allowed="$(tf_task_field "$id" '.scope[]')" || true

  local violations=()
  while IFS= read -r f; do
    [[ -z "$f" ]] && continue
    local ok=0
    while IFS= read -r pat; do
      [[ -z "$pat" ]] && continue
      case "$pat" in
        */) [[ "$f" == "$pat"* ]] && ok=1 ;;
        *)  [[ "$f" == "$pat" ]] && ok=1 ;;
      esac
    done <<< "$allowed"
    [[ $ok -eq 0 ]] && violations+=("$f")
  done <<< "$changed"

  if [[ ${#violations[@]} -gt 0 ]]; then
    {
      echo "OUT-OF-SCOPE edits (advisory, non-blocking):"
      printf '  %s\n' "${violations[@]}"
    } >> "$log"
    tf_warn "$id: ${#violations[@]} out-of-scope file(s) edited — see $log"
    printf '%s\n' "${violations[@]}"
  else
    echo "all in-scope" >> "$log"
  fi
}
