# Worker Task: {{TASK_ID}} — {{TASK_TITLE}}

You are an autonomous worker for the **chemie-lernen.org** repo. You are assigned
**exactly one task** about **expanding the premium-content API** (adding a catalog
endpoint + one more generation endpoint). Implement it, verify against the
acceptance gate, and commit.

## ⛔ HARD CONSTRAINTS (violating these fails the gate / corrupts the repo)

1. **NEVER edit API engine / private-core files.** Everything under `api/auth.js`,
   `api/auth-db.js`, `api/server.js` (Stripe/webhook parts), `api/learning-engine.js`,
   `api/services/{auto-grader,exercise-generator,feedback-engine,rag,badges}.js`,
   `api/prompts/**` is OFF-LIMITS. The premium entitlement (`requirePremium`) and
   quota (`checkScopedQuota`) are ALREADY imported/used in `premium-content.js` —
   **reuse them, do not redefine or edit their sources.**
2. **Only edit the files in your task scope.** No other files.
3. **No new Stripe / payment code.** No DB schema. No migration.
4. **Tests must be real and pass the gate.** See testing rules below.

## Context: existing code you MUST follow
`api/routes/premium-content.js` already implements `POST /api/premium/lesson-plan`
and `POST /api/premium/worksheet`. They:
- import `{ requirePremium }` from `'../auth.js'` and
  `{ checkScopedQuota }` from `'../services/session.js'`,
- call `checkScopedQuota('<name>', 'u:' + req.user.id, 10)` for a daily quota,
- call LiteLLM via `fetch(LITELLM_URL + '/v1/chat/completions', …)` and parse JSON
  from the response (handle markdown code-fence),
- return 400 on bad input, 429 on quota, 502 on LLM error.

**Copy this exact pattern** for any new endpoint. Reuse `VALID_GRADES`,
`VALID_DURATIONS`, `VALID_DIFFICULTIES` already defined in the file.

## Your task (see title + acceptance below)
Implement exactly what your task **title** and **acceptance criteria** describe,
within the **file scope**. Do not edit outside scope.

## File scope — edit ONLY these paths
```
{{SCOPE_BLOCK}}
```
Editing files outside this scope FAILS verification.

## Testing rules (critical — gate runs these)
- Test files are **`.mjs` ESM jest** tests. Put `// @jest-environment node` as the
  FIRST line. Import the route via `import router from '<repo>/api/routes/premium-content.js'`
  using an absolute path (`fileURLToPath(import.meta.url)` + `../` resolution) or
  `import { join, dirname } from 'node:path'`.
- Mock `../auth.js` with `jest.mock('../auth.js', () => ({ requirePremium: (r,res,n)=>n(), requireAuth: (r,res,n)=>n() }))`
  (place the mock at the top, before importing the router — use `jest.mock` hoisting
  or `require` inside the test). Provide a fake `req.user = { id: 'u1', tier: 'premium' }`.
- Mock LiteLLM by setting `global.fetch = jest.fn(async () => ({ ok: true, json: async () => ({ choices: [{ message: { content: '{"ok":true}' } }] }) }))`
  for the success case, and a 400/`ok:false` variant for failure cases.
- Do NOT hit a real Neo4j or LiteLLM in tests. The `exam-simulator` endpoint must
  NOT perform a Neo4j lookup (keep it testable without a live graph).
- Run the gate exactly as given; never commit failing work.

## Acceptance gate (orchestrator runs this)
```sh
{{ACCEPT_COMMAND}}
```
Run it yourself before committing. Never commit failing work.

## Definition of Done
- New endpoint(s) follow the existing pattern (requirePremium/requireAuth +
  checkScopedQuota + LiteLLM fetch + JSON parse + correct status codes).
- Jest tests cover happy path + at least one validation error (400) and pass the gate.
- No private-core / api/auth.js / api/server.js edits. The gate passes.
