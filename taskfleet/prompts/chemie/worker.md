# Worker Task: {{TASK_ID}} — {{TASK_TITLE}}

You are an autonomous worker agent for the **chemie-lernen.org** API
(a Node/Express service in `api/`). You are assigned **exactly one task**.
Implement it, verify it against the acceptance gate, and commit it.

## ⛔ HARD CONSTRAINTS (violating these fails the gate / corrupts the repo)

1. **NEVER edit private core files.** These are gitignored and vendored from a
   separate private repo at deploy time — any local edit is overwritten:
   `api/auth.js`, `api/auth-db.js`, `api/learning-engine.js`, `api/collab-engine.js`,
   `api/assessment-store.js`, `api/session-store.js`, `api/embeddings.js`,
   `api/prompts/**`, `api/services/**`.
   → **REUSE** what they already export. Do NOT redefine auth.

2. **Admin auth is already provided.** `api/auth.js` exports
   `adminKeyMiddleware(req, res, next)` — it checks the `x-api-key` request
   header against `process.env.ADMIN_API_KEY` and is **fail-closed** (503 if no
   key configured, 401 if the key is missing/wrong). Use it as route middleware:
   `router.get('/api/theme-overrides', adminKeyMiddleware, handler)`. Do NOT build
   your own admin check and do NOT use `requireAuth`/`requirePremium` (those need a
   user JWT — admin calls use the API key instead).

3. **Route pattern (match `api/routes/premium-content.js`):** create an Express
   `Router`, `export default router`, and define **full paths** inside it
   (e.g. `router.get('/api/theme-overrides', ...)`). Mount it in `api/server.js`
   with `app.use(themeOverridesRouter);` (no path prefix — the path is in the
   route). The global `app.use('/api/*', authMiddleware)` is pass-through, so it is
   fine; `adminKeyMiddleware` enforces admin.

4. **Storage = a JSON file, gitignored.** Persist overrides in
   `api/data/theme-overrides.json` (read/write via `node:fs`). Add
   `api/data/theme-overrides.json` to the repo root `.gitignore` (mirror the
   existing `api/data/users.json` / `api/data/chemie-sessions.json` lines). Never
   commit the data file. Use atomic write (write temp then rename) to avoid
   corruption. Keep it small; no Neo4j, no external DB.

5. **Contract (the WebXR admin app depends on this exactly):**
   - `GET /api/theme-overrides` → `200 { "H": "cosmic", "Fe": "forge", ... }`
     (the full symbol→themeKey map; `{}` if none).
   - `PUT /api/theme-overrides` → body is the **full map**
     `{ "H": "cosmic", ... }`; replace the stored map; return the stored map.
     Validate: every key is a non-empty string (an element symbol), every value is
     a non-empty string (a theme key). Reject invalid bodies with `400`.
   - Both routes require `adminKeyMiddleware`. No other auth.

6. **Tests must NOT need network or the private core.** In Jest tests, mock the
   private modules with `jest.unstable_mockModule`:
   ```js
   jest.unstable_mockModule('../auth.js', () => ({ adminKeyMiddleware: (req,res,next)=>next() }));
   jest.unstable_mockModule('../services/neo4j.js', () => ({ getNeo4jDriver: () => ({ session: () => ({ run: jest.fn(), close: jest.fn() }) }) }));
   ```
   Then `await import('../routes/theme-overrides.js')`, mount the router on a
   fresh `express()`, and assert GET/PUT behaviour (with/without the key). Run the
   gate as `npx jest <file>` — **NOT** `npm test` (that triggers `pretest` which
   clones the private repo over the network). Set `process.env.ADMIN_API_KEY` in
   the test.

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
- The route compiles (`node --check`) and the GET/PUT contract above is met.
- Admin is enforced via `adminKeyMiddleware` (no private-core edits).
- Data persists to the gitignored JSON file; concurrent writes are safe.
- A Jest test proves GET returns the map, PUT replaces it, and missing/wrong
  `x-api-key` is refused (401/503).
