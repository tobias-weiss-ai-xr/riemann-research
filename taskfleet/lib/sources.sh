#!/usr/bin/env bash
# sources.sh — external task sources for taskfleet.
#
# Imports tasks from external issue trackers (currently GitHub Issues) into
# tasks.json so a taskfleet run can drive work filed in real workflow tools.
#
# Works purely on the config ledger: it FEEDS tasks.json, and the normal
# scheduler/dispatcher consumes them exactly like hand-authored tasks.

# shellcheck source=common.sh
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

# GitHub API base + auth.
TF_GITHUB_API="${TF_GITHUB_API:-https://api.github.com}"
TF_GITHUB_TOKEN="${TF_GITHUB_TOKEN:-}"

tf_require_curl() {
  command -v curl >/dev/null 2>&1 || { tf_error "curl not found (needed for external task sources)"; return 1; }
}

# ---------------------------------------------------------------------------
# tf_github_auth_args → adds Authorization header if a token is set.
# ---------------------------------------------------------------------------
tf_github_auth_args() {
  if [[ -n "$TF_GITHUB_TOKEN" ]]; then
    echo "-H" "Authorization: Bearer $TF_GITHUB_TOKEN"
  fi
}

# ---------------------------------------------------------------------------
# tf_github_fetch_issues <repo> [--label X] [--state open] [--limit N]
#   Prints raw GitHub Issues JSON array for <owner>/<repo>.
# ---------------------------------------------------------------------------
tf_github_fetch_issues() {
  tf_require_curl || return 1
  local repo="$1"; shift
  local label="" state="open" limit=100
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --label) label="$2"; shift 2 ;;
      --state) state="$2"; shift 2 ;;
      --limit) limit="$2"; shift 2 ;;
      *) shift ;;
    esac
  done

  local url="$TF_GITHUB_API/repos/$repo/issues?state=$state&per_page=$limit"
  [[ -n "$label" ]] && url="$url&labels=$(printf '%s' "$label" | sed 's/ /%20/g')"

  local auth
  auth="$(tf_github_auth_args)"
  # shellcheck disable=SC2086
  curl -sS --max-time 30 $auth "$url" 2>/dev/null
}

# ---------------------------------------------------------------------------
# tf_github_to_task <repo> <number> <title> <body> <labels_csv>
#   Converts a GitHub issue to a taskfleet task JSON object.
#   Returns a single-line JSON task like the ones in tasks.json.
# ---------------------------------------------------------------------------
tf_github_to_task() {
  local repo="$1" number="$2" title="$3" body="$4" labels_csv="$5"
  jq -nc \
    --arg id "GH-$number" \
    --arg title "$title" \
    --arg body "$body" \
    --arg source "github:$repo#$number" \
    --arg engine "issue" \
    --argjson labels "$(printf '%s' "$labels_csv" | jq -R -s 'split(",") | map(select(length>0))' 2>/dev/null || echo '[]')" \
    '{
      id: $id,
      engine: $engine,
      title: $title,
      section: "imported",
      deps: [],
      scope: [],
      accept: "true",
      acceptance_prose: ($body // ""),
      manual: false,
      source: $source,
      labels: $labels
    }'
}

# ---------------------------------------------------------------------------
# tf_source_import_github <owner/repo> [--label X] [--state open] [--dry-run]
#   Fetches issues and merges missing ones into tasks.json.
#   Prints a summary: <imported> new, <skipped> already present.
# ---------------------------------------------------------------------------
tf_source_import_github() {
  local repo="$1"; shift
  local dry_run=0 label="" state="open"
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --dry-run) dry_run=1; shift ;;
      --label) label="$2"; shift 2 ;;
      --state) state="$2"; shift 2 ;;
      *) shift ;;
    esac
  done

  [[ -z "$repo" ]] && { tf_error "repository required: tf_source_import_github <owner/repo>"; return 1; }
  [[ -f "$TASKS_JSON" ]] || { tf_error "no tasks.json at $TASKS_JSON"; return 1; }

  local issues
  issues="$(tf_github_fetch_issues "$repo" --label "$label" --state "$state")"
  if [[ -z "$issues" || "$(echo "$issues" | jq -r 'if type=="array" then length else 0 end' 2>/dev/null)" == "0" ]]; then
    echo "no issues fetched from $repo (state=$state, label=${label:-all})"
    return 0
  fi

  # Build a JSON array of new tasks not already present (by id).
  local new_tasks_json
  new_tasks_json="$(echo "$issues" | jq --arg repo "$repo" '
    [
      .[] |
      select(.pull_request == null) |          # skip PRs, keep issues only
      {
        id: ("GH-" + (.number|tostring)),
        engine: "issue",
        title: .title,
        section: "imported",
        deps: [],
        scope: [],
        accept: "true",
        acceptance_prose: (.body // ""),
        manual: false,
        source: ("github:" + $repo + "#" + (.number|tostring)),
        labels: ([.labels[].name] // [])
      }
    ]')"

  local existing_ids
  existing_ids="$(jq -r '.tasks[].id' "$TASKS_JSON" 2>/dev/null)"

  local to_add
  to_add="$(echo "$new_tasks_json" | jq --argjson existing "$(printf '%s\n' "$existing_ids" | jq -R -s 'split("\n") | map(select(length>0)) | {ids: .}' 2>/dev/null | jq '.ids // []')" '
    [.[] | select(([.id] - $existing) | length > 0)]
  ' 2>/dev/null)"

  local new_count total_count
  new_count="$(echo "$to_add" | jq 'length' 2>/dev/null || echo 0)"
  total_count="$(echo "$new_tasks_json" | jq 'length' 2>/dev/null || echo 0)"

  if [[ "$dry_run" -eq 1 ]]; then
    echo "dry-run: $repo has $total_count issue(s), $new_count would be imported"
    echo "$to_add" | jq -r '.[] | "  \(.id)  \(.title)"'
    return 0
  fi

  if [[ "$new_count" -gt 0 ]]; then
    local tmp
    tmp="$(mktemp)"
    jq --argjson add "$to_add" '.tasks += $add' "$TASKS_JSON" > "$tmp" && mv "$tmp" "$TASKS_JSON"
  fi

  echo "imported $new_count new task(s) from $repo (skipped $((total_count - new_count)) already present)"
}

# ---------------------------------------------------------------------------
# tf_task_source <task_id> → prints the task's source tag, or nothing.
# ---------------------------------------------------------------------------
tf_task_source() {
  tf_task_field "$1" '.source // empty' 2>/dev/null
}
