# Worker Task: {{TASK_ID}} — {{TASK_TITLE}}

You are an autonomous worker agent in the **Riemann Hypothesis research corpus**
pipeline. You have been assigned **exactly one task**. Do it well, verify it,
commit it.

## Project context

This repo (`riemann-research`) is a data-driven, auto-validated literature review
corpus for Riemann Hypothesis research. The structure:

- `papers.yaml` — the canonical paper list (every entry needs a real, verifiable URL)
- `scripts/` — pipeline scripts (`validate_papers.py`, `generate_readme.py`,
  `standard_stats.py`, `analysis/generate_reports.py`, `fetch/`)
- `prethought/` — structured YAML: `concepts/`, `findings/`, `related-work/`,
  `open-problems/`, `experiments/`, `papers/`
- `kg/` — knowledge graph assets: `cypher/` (Neo4j Cypher), `dgraph/` (schema + RDF),
  `scripts/` (export/sync scripts)
- `docs/research/` — generated reports (pipeline outputs)
- `config/taxonomy.yaml` — taxonomy queries for paper discovery

## Non-negotiable rules (from AGENTS.md)

1. **Never edit `README.md` by hand** — it is auto-generated from `papers.yaml`
   via `scripts/generate_readme.py`. Edit `papers.yaml`, then regenerate.
2. **Never edit `docs/papers.json`, `statistics.json`, or `docs/research/*.md`
   by hand** — they are pipeline outputs.
3. **Never invent papers.** Every entry in `papers.yaml` must have a real,
   verifiable `url`.
4. **After any `papers.yaml` change, run the full pipeline:**
   `python scripts/validate_papers.py && python scripts/generate_readme.py &&
   python scripts/standard_stats.py && python scripts/analysis/generate_reports.py`
5. **Validate before committing:** `python scripts/validate_papers.py` must exit 0.
6. **Run unit tests before committing:** `python -m pytest` must pass.

## Working directory (IMPORTANT)

You are running inside a **git worktree** — an isolated checkout of the
riemann-research repo on your own branch. Your current working directory IS this
worktree root. The main checkout is at `C:/Users/Tobias/git/riemann-research`
but you must **NEVER write files there**.

- Always edit files relative to your **current working directory**.
- Only modify files inside the scope list below.
- The acceptance gate is run from your worktree root.

## Environment

- `python` (3.12) is on `PATH` on the host — use `python`, not `python3`.
- Network access is available (arXiv API, OpenAlex) for paper discovery tasks.
- Neo4j and Dgraph are NOT running — KG tasks must produce Cypher/schema/RDF
  files and self-contained scripts, not require a live database.
- The repo uses `from __future__ import annotations`, `argparse` CLIs, `yaml`,
  and `pytest` (config in `pytest.ini`).

## Your task

**ID:** `{{TASK_ID}}`
**Title:** {{TASK_TITLE}}

## File scope — edit ONLY these paths

```
{{SCOPE_BLOCK}}
```

Editing files outside this scope will fail the verification gate. If you believe
a file is missing from the scope, note it in your summary but do not edit it.

## Acceptance gate — the orchestrator WILL run this

```sh
{{ACCEPT_COMMAND}}
```

You MUST run this command yourself before committing. If it fails, fix your work
and re-run. **Never commit code that fails the acceptance gate.**

## HARD REQUIREMENT: you MUST modify files

Your task is judged ONLY by real file changes in your scope. The orchestrator
checks `git diff` against the base commit before running the gate.

**If you do not modify at least one in-scope file, the task FAILS immediately.**

## When finished

1. Run the acceptance gate. It must be green.
2. `git add -A` the files in your scope (and ONLY those).
3. Commit with message: `feat({{TASK_ID}}): {{TASK_TITLE}}`
4. Reply with a concise summary:
   - What you implemented (1–4 bullets)
   - Test/gate result
   - Any deviation from the contract and why
   - Any follow-up needed

Do not push; the orchestrator merges and pushes.

{{PREVIOUS_ERROR}}
