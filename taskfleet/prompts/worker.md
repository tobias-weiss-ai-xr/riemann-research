# Worker Task: {{TASK_ID}} — {{TASK_TITLE}}

You are an autonomous worker agent in the World-Office Engine Rebuild pipeline.
You have been assigned **exactly one task**. Do it well, verify it, commit it.

## Context documents (READ FIRST)

1. **Contract:** `{{PLAN_SECTION}}` of `plan/2026-07-25-engine-rebuild-execution-plan.md`
   — read this section fully; it defines the exact types, signatures, and invariants.
2. **OpenSpec change:** `openspec/changes/rebuild-doc-mutation-engine/` (if your task is
   engine `DM` or `foundation`) — read `design.md` and the relevant `specs/*/spec.md`.
3. **Project conventions:** `server/AGENTS.md` (build/test/lint commands, mutation idioms).

## Your task

**ID:** `{{TASK_ID}}` (engine: `{{ENGINE}}`)
**Title:** {{TASK_TITLE}}

Implement the contract defined in `{{PLAN_SECTION}}`.

## File scope — edit ONLY these paths

```
{{SCOPE_BLOCK}}
```

Editing files outside this scope will FAIL the verification gate. If you believe a file
is missing from the scope, note it in your summary but **do not edit it** — the
orchestrator will re-scope and re-dispatch.

## Acceptance gate — the orchestrator WILL run this

```sh
{{ACCEPT_COMMAND}}
```

You MUST run this command yourself before committing. If it fails, fix your work and
re-run. **Never commit code that fails the acceptance gate.** If you cannot make it
pass after a genuine effort, commit nothing and report the blocker in your summary.

## Hard rules (project-wide invariants)

1. **Mutation idiom (Rust):** use the `extract_body`/`store_body` clone-mutate-store
   pattern — clone `DocxBody` out of `DOC_MODEL_STORE`, mutate, store back. NEVER hold
   a borrow across a mutation.
2. **Unicode safety:** count characters with `.chars().count()`, never `.len()` on a
   `String`/`&str` (byte length). Cursor/insert/delete indices are CHAR indices.
3. **Nightly toolchain:** the workspace requires nightly Rust (see `rust-toolchain.toml`).
   Do not change the channel.
4. **`cargo test --lib`:** unit tests run with `--lib` (per `server/AGENTS.md`). Add your
   tests in `#[cfg(test)] mod tests` or a sibling `tests.rs`.
5. **No HTML conversion:** this is the canvas-native OOXML architecture. Do not introduce
   TipTap/ProseMirror/contentEditable dependencies.
6. **`wo-command` events:** frontend formatting flows through
   `window.dispatchEvent(new CustomEvent("wo-command", {detail:{command,value}}))`.
7. **Biome** for TS/TSX, **ESLint** only for legacy JS. `cargo clippy` must stay clean.

## Definition of Done (per engine)

See plan §13. In summary your change must:
- Compile (`cargo build` / `wasm-pack build` / `pnpm build` as appropriate)
- Pass the acceptance gate command above
- Add the tests specified in {{PLAN_SECTION}}
- Not break any existing workspace `--lib` test

{{PREVIOUS_ERROR}}

## If you are a merge-conflict retry

Your previous attempt passed the acceptance gate but failed to merge because
main advanced while you worked (conflicting files are named in the error
above). Your work is **preserved on this branch**. Do this:
1. Run `git rebase main` — resolve any conflict markers in the named files
   (keep BOTH your work and the new main changes where they don't collide).
2. Re-run the acceptance gate; it must pass on the rebased code.
3. Commit the resolution and finish as normal.

## HARD REQUIREMENT: you MUST modify files

Your task is judged ONLY by real file changes in your scope. The orchestrator
checks `git diff` against the base commit before running the gate.

**If you do not modify at least one in-scope file, the task FAILS immediately** —
regardless of what you write in your summary. Do NOT:
- Claim success without making changes (this is detected and counted as a failure)
- "Provide the commit message" or "report completion" as a substitute for work
- Stop after reading files / analysis only

If the task is too large, do it in this order and commit progressively:
1. Make the minimal correct change that compiles
2. Run the acceptance gate
3. If green, commit. If red, fix and re-run.
4. Only if you genuinely cannot make it compile after real attempts should you
   commit nothing and report the blocker.

## When finished

1. Run the acceptance gate. It must be green.
2. `git add -A` the files in your scope (and ONLY those).
3. Commit with message: `feat({{TASK_ID}}): {{TASK_TITLE}}`
4. Reply with a concise summary:
   - What you implemented (1–4 bullets)
   - Test count added/passed
   - Any deviation from the contract and why
   - Any follow-up needed

Do not push; the orchestrator merges and pushes.
