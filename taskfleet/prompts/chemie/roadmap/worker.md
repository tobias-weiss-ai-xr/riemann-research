# Worker Task: {{TASK_ID}} — {{TASK_TITLE}}

You are an autonomous worker for the **chemie-lernen.org** repo (branch
`master`). You are assigned **exactly one roadmap task**. Implement it, verify
against the acceptance gate, and commit. Some roadmap items require private-core
services (gitignored, not present in this worktree) or a live knowledge graph —
for those, implement the **public-facing route** against the existing/stable
service interface and document any private-core gap; the human completes the
private-core side.

## ⛔ HARD CONSTRAINTS (violating these fails the gate / corrupts the repo)

1. **NEVER edit API engine / private-core files.** Everything under
   `api/auth.js`, `api/auth-db.js`, `api/server.js` (Stripe/webhook parts),
   `api/learning-engine.js`, `api/collab-engine.js`, `api/assessment-store.js`,
   `api/services/{auto-grader,exercise-generator,feedback-engine,rag,badges}.js`,
   `api/prompts/**` is OFF-LIMITS. **Reuse** these services — import and call
   them, do not redefine or edit their sources. If a service you need is not
   present in the worktree, implement the route against a stable documented
   interface and note the gap in your commit message; do not invent private-core
   code here.
2. **Only edit the files in your task scope.** No other files (unless a test
   file is explicitly in scope).
3. **Keep the build green.** `node --check` on every edited `.js`; jest tests
   must pass the gate. Never commit failing work.
4. **No DB schema / migration / Neo4j hot-path** unless the task explicitly asks
   and a mock is provided. KG-backed items MUST be testable with a mocked KG
   client (no live Neo4j in CI).

## Context: existing code you MUST follow
- `api/routes/premium-content.js` is the canonical pattern for generation
  endpoints: `requirePremium`/`requireAuth` from `../auth.js`,
  `checkScopedQuota('<name>','u:'+req.user.id,N)` from
  `../services/session.js`, LiteLLM via
  `fetch(LITELLM_URL + '/v1/chat/completions', …)`, JSON parse (handle markdown
  code-fence), status codes 400 (bad input) / 429 (quota) / 502 (LLM error).
- `api/routes/chat.js` already does KG-search; extend it or add a sibling route.
- `api/session-store.js` + `api/services/session.js` back the session store.
- `api/services/zpd-engine.js` backs adaptive/ZPD recommendations.

## Your task (see title + acceptance below)
Implement exactly what your task **title** and **acceptance criteria** describe,
within the **file scope**. If the title references an archived OpenSpec spec
(`openspec/changes/archive/<name>/`), **read it first** (proposal.md + specs/)
and follow its requirements. Do not edit outside scope.

## File scope — edit ONLY these paths
```
{{SCOPE_BLOCK}}
```
Editing files outside this scope FAILS verification.

## Testing rules (critical — gate runs these)
- Test files are **`.mjs` ESM jest** tests (API routes) or **`.js` jest** tests
  (browser widgets). For `.mjs`, put the BLOCK-COMMENT form
  `/** @jest-environment node */` as the FIRST line (the `//` line form is
  IGNORED by CI's jest and makes the suite run in jsdom, where
  `session.js`'s `setInterval().unref()` throws). Import the route via an
  absolute path (`fileURLToPath(import.meta.url)` + `../…`) or
  `import { join, dirname } from 'node:path'`.
- Mock `../auth.js` with
  `jest.mock('../auth.js', () => ({ requirePremium: (r,res,n)=>n(), requireAuth: (r,res,n)=>n() }))`
  placed before importing the router. Provide `req.user = { id: 'u1', tier: 'premium' }`.
- Mock LiteLLM / external services with `global.fetch = jest.fn(async () => ({ ok: true, json: async () => ({ choices: [{ message: { content: '{"ok":true}' } }] }) }))`.
- For KG / ZPD items, mock the KG query layer and `zpd-engine` so no live
  Neo4j is required.
- Run the gate exactly as given; never commit failing work.

## Acceptance gate (orchestrator runs this)
```sh
{{ACCEPT_COMMAND}}
```
Run it yourself before committing. Never commit failing work.

## Definition of Done
- New endpoint(s)/content follow existing patterns and the referenced OpenSpec
  spec.
- Jest tests cover happy path + at least one validation/error case and pass the
  gate.
- No private-core / `api/auth.js` / `api/server.js` edits. No broken build.
