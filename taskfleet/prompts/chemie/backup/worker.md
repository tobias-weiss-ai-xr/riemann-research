# Worker Task: {{TASK_ID}} — {{TASK_TITLE}}

You are an autonomous worker for the **chemie-lernen.org** repo. You are assigned
**exactly one task** about **automating Neo4j knowledge-graph backups**. Implement
it, verify it against the acceptance gate, and commit it.

## ⛔ HARD CONSTRAINTS (violating these fails the gate / corrupts the repo)

1. **NEVER edit API engine / private-core files.** Everything under `api/` is
   off-limits for this task — backups live in `scripts/` and `docs/`. Do NOT touch
   `api/auth.js`, `api/*.js`, `api/services/**`, `api/prompts/**`, or any other
   `api/` file.

2. **Reuse existing scripts — do NOT reinvent backup/restore logic.**
   - `scripts/backup-chemie-neo4j.sh` already dumps the `chemie-neo4j` container
     (database `chemie`) with daily/weekly/monthly rotation + logging.
   - `scripts/restore-neo4j.sh` already restores a `.dump` (requires `--confirm`).
   Read both and build ON TOP of them.

3. **No docker / neo4j execution at test or build time.** The CI has no docker
   daemon. Your acceptance gate must ONLY do syntax checks (`bash -n`) and
   file-existence checks. Never run `docker`, `neo4j-admin`, or any backup script
   inside the gate.

4. **Idempotent & safe:** every script uses `set -euo pipefail`, quotes paths,
   and never deletes data. The systemd enable helper must be safely re-runnable.

## Context: the goal (split across tasks)
Make Neo4j backups **automatic** (scheduled) and **documented** (runbook). They
must cover BOTH containers:
- `chemie-neo4j` — legacy graph (database `chemie`)
- `chemie-kg`    — the live API knowledge graph (database `chemie`)

Both use the same `neo4j-admin database dump` approach inside the container.

## Your task
Implement exactly what your task **title** and **acceptance criteria** below
describe, within the given **file scope**. Do not edit outside the scope.

## File scope — edit ONLY these paths
```
{{SCOPE_BLOCK}}
```
Editing files outside this scope FAILS verification. If a file is missing from
scope, note it and stop — do not edit it.

## Acceptance gate (orchestrator runs this)
```sh
{{ACCEPT_COMMAND}}
```
Run it yourself before committing. Never commit failing work.

## Definition of Done
- Scripts are `bash -n` clean and idempotent; systemd units are valid unit files;
  the runbook is accurate and references the existing restore script.
- No `api/` / private-core files touched.
- The gate passes without docker.
