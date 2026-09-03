# research/ — CP-004 Deliverables (provenance note)

Task **CP-004 "Document Open Problems from Research Notes"** (2026-09-03).

Committed on branch `tf/CP-004`, commit `feat(CP-004): Document Open
Problems from Research Notes`:

- `research/GAP_ANALYSIS.md` — reconciled gap analysis: 6 legacy gaps
  re-scored + 4 new gaps (source integrity, Lean, data pipeline, doc
  overclaiming); exactly one critical mathematical gap remains:
  **ρ(L_s) < 1 for all Re(s) = 1/2 + it** (equivalent to RH).
- `research/SOLUTION_TO_GAPS.md` — honest re-audit of the legacy
  "solutions"; withdraws the July 2026 "RH IS PROVEN" conclusion as
  overclaiming (`KB-Integrity-Flag`).
- `HONEST_FINAL_STATUS.md` (repo root) — top-level honest verdict:
  RH is NOT proven; scorecard, refuted routes, remaining gaps, roadmap.
- `prethought/open-problems/bridges.yaml` — registry extended with
  `OP-BridgeC-Kato-Perturbation`, `OP-BridgeD-Certified-Spectral-Bounds`,
  `OP-BridgeE-Continuation-Integrity`, `OP-Docs-Integrity-LegacyOverclaim`
  (10 OP entries total).

All claims are traceable to corpus entities (`prethought/research/*.yaml`,
`prethought/findings/*.yaml`) and cited literature (Mayer 1990, Isola 2003,
Bonanno 2022, Moeller–Pohl 2011, Nisoli 2026, Pollicott–Vytnova 2022).

**Standing verdict**: the Riemann Hypothesis is NOT proven. See
`HONEST_FINAL_STATUS.md` before citing any result from this program.

*(This note is intentionally uncommitted provenance metadata; the
deliverables above are the committed artifacts.)*
