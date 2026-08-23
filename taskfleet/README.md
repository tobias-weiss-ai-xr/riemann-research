# Taskfleet Orchestration for Riemann Research

Taskfleet dispatches parallel LLM tasks to populate the Riemann research corpus.

## Setup

Taskfleet is pre-configured with 15 tasks across **fx foundations, core requirements**.

- **Task files**: `config/tasks.json` (15 tasks), `config/workers.json` (4 worker types)
- **Runtime**: `orchestrator.sh` + `lib/*` (copied from taskfleet repo)

## Quick Start

```bash
cd taskfleet

# Check status of all tasks
export TF_REPO_DIR=$(cd .. && pwd)
bash orchestrator.sh --status

# Run a single task (dry-run first)
bash orchestrator.sh --task FC-001 --dry-run
bash orchestrator.sh --task FC-001

# Run all ready tasks in parallel
bash orchestrator.sh
```

## Available Tasks

### FOUNDATION (4 tasks) - Corpus Setup

| ID | Title | Deps | Accept |
|----|-------|------|--------|
| FC-001 | Seed RH Corpus with 20+ Key Papers | - | Validate papers |
| FC-002 | Add arXiv RH Papers (last 24 months) | FC-001 | Fetch + validate |
| FC-004 | Validate Entire Corpus | FC-002 | Validation passes |
| FR-001 | Generate Literature Review Report | FC-004 | Reports exist |

### CORE (4 tasks) - Knowledge Foundation

| ID | Title | Deps | Accept |
|----|-------|------|--------|
| CP-001 | Extract Concepts from Neon KG | - | 4+ concept files |
| CP-002 | Extract Findings from Experiments | - | 2+ finding files |
| CP-003 | Document RH Equivalences | - | Equivalences documented |
| CP-004 | Document Open Problems | - | Bridges documented |

### EXTENSION (3 tasks) - Advanced Work

| ID | Title | Deps | Accept |
|----|-------|------|--------|
| EC-001 | Run Exp 16: Spectral Gap Hecke Correlation | - | Manual (requires Docker) |
| EC-002 | Populate Friedli Constant | CP-002 | Friedli documented |
| EF-001 | Link Lean Formalization | CP-001 | Lean status linked |

### NICE TO HAVE (1 task)

| ID | Title | Deps | Accept |
|----|-------|------|--------|
| NH-001 | Add References from Research Notes | FC-004 | 30+ papers |

### INFRASTRUCTURE (3 tasks)

| ID | Title | Deps | Accept |
|----|-------|------|--------|
| KG-001 | Create Dgraph Schema | CP-001,CP-002,CP-003 | Schema valid |
| KG-002 | Export Prethought to Dgraph | KG-001 | Export dry-run OK |
| KG-003 | Sync Neo4j KG | - | 10+ cypher files |

## Worker Types

| Name | Provider | Model | Tiers |
|------|----------|-------|-------|
| riemann-paper-discovery | pi | local | discovery, corpus |
| riemann-concept-extraction | pi | local | concepts, findings, knowledge |
| riemann-kg-builder | pi | local | kg, dgraph, neo4j |
| riemann-report-generator | pi | local | reports, docs |

## Common Commands

```bash
# From taskfleet/ directory, with TF_REPO_DIR set:

# Status
export TF_REPO_DIR=..
bash orchestrator.sh --status

# Run one task
bash orchestrator.sh --task FC-001

# Run in parallel with max 4 workers
bash orchestrator.sh --max-parallel 4

# Dry run (show what would happen)
bash orchestrator.sh --dry-run

# Stop after one dispatch round
bash orchestrator.sh --once

# Watch live output
bash orchestrator.sh attach FC-001

# Force retry a failed task
bash orchestrator.sh --task FC-001 --force
```

## File References

Tasks use scopes like `"../riemann/..."` because the repo structure is:

```
~/git/
├── riemann/         # Parent repo (Lean, KG, experiments)
│   ├── knowledge-graph/
│   ├── lean/
│   ├── experiments/
│   └── scripts/
└── riemann-research/ # This repo (corpus, prethought, KG)
    └── taskfleet/
```

Taskfleet tasks are dispatched from a **worktree** `riemann-research/taskfleet/worktree/`, and scope paths are relative to that worktree. When referencing the parent `riemann/` repo, use `../riemann/...` paths.

## Acceptance Gates

Each task has an `accept` command that determines if the task passes. Common patterns:

- `test -f file` — file exists
- `grep -q pattern file` — file contains pattern
- `python script.py` — script runs successfully
- `expr A \> B` — comparison

Tasks must pass their acceptance gate to be marked complete.

## Environment

| Variable | Purpose | Default |
|----------|---------|---------|
| TF_REPO_DIR | Root of the repo | (required) |
| TF_MAX_PARALLEL | Max concurrent tasks | Number of workers |
| TF_MERGE_LOCK | Merge lock file | state/merge.lock |
