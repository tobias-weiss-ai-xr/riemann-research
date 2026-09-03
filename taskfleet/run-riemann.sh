#!/usr/bin/env bash
# Run the riemann-research taskfleet.
set -euo pipefail
cd "$(dirname "$0")"

export TF_REPO_DIR="$(cd /c/Users/Tobias/git/riemann-research && pwd)"
export TF_BASE_BRANCH=master
export TF_TASKS_JSON="$PWD/config/tasks.json"
export TF_WORKERS_JSON="$PWD/config/workers.json"
export TF_PROMPT_DIR="$PWD/prompts-riemann"
export TF_STATE_DIR="$PWD/state"
export TF_LOG_LEVEL=info
export TF_ROUTING=0     # disable compute-tier routing (workers use capability tiers, not model_tier)

exec bash orchestrator.sh "$@"
