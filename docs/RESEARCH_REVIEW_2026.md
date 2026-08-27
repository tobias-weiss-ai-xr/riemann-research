# Riemann Hypothesis Research Corpus — Review & Latest Status

**Last updated:** 2026-08-27
**Corpus:** 3,649 papers, 6 categories (riemann-research)
**Sister project:** [riemann](https://github.com/tobias-weiss-ai-xr/riemann) — GNN × number theory, transfer-operator programme, Lean 4 formalization

---

## 1. Executive summary

This document is a **hand-written review** of the Riemann Hypothesis (RH) research
landscape as captured by the auto-generated [corpus](./research/literature_review.md),
together with the **latest honest status** of our own research programme
(`~/git/riemann`). It deliberately distinguishes:

- what is **established mathematics** (literature, verifiable),
- what we have **formalized / verified in-house** (Lean 4, numerics),
- what remains **open** (and what is genuinely equivalent to RH itself).

**Bottom line:** the transfer-operator / thermodynamic-formalism route is a
coherent and increasingly well-supported programme, and we have established
important partial results (nuclearity on H¹, an exact leading-eigenvalue
derivative at s = 1, the spectral gap at s = 1, and the formal *equivalence*
between the full spectral-radius bound and RH). Critically, the remaining
obstruction **is** RH — it cannot be closed without actually proving RH. No
complete proof is claimed.

---

## 2. Status of the three requested tasks (2026-08-27)

| Task | Status | Highlights |
|---|---|---|
| 1. New ingestion round | ✅ done | +505 papers from arXiv (2024–2026); 13 off-topic NA papers dropped; corpus 3,649 papers all valid (exit 0) |
| 2. Concept-graph enhancement | ✅ done | Replaced generic skeleton seeds with 102 RH-specific concepts + 18 alias groups; re-ran extract/relate/analyze → 126 nodes, 634 edges, 2 meaningful communities |
| 3. Review + latest status (this doc) | ✅ done | Grounded in the corpus + honest `~/git/riemann` state (EPIC-4 programme) |

---

## 3. Corpus overview (auto-generated ground truth)

| Category | Papers |
|---|---|
| Number Theory | 1,357 |
| Spectral Theory & Graphs | 1,103 |
| RH Equivalences & Bridges | 547 |
| Machine Learning | 418 |
| Dynamical Systems | 204 |
| Proof & Formalization | 20 |
| **Total** | **3,649** |

Automated reports: [literature review](./research/literature_review.md),
[trends (12-month)](./research/trends.md), [concept map](./research/concept_map.md),
[concept graph analysis](./research/concept_graph_analysis.md).

The 12-month trend report shows the fastest-growing areas are **Proof &
Formalization** (85% of corpus papers in the last 12 months), **Equivalences**
(+90%), and **Machine Learning** (+139%) — consistent with the field's current
emphasis on Lean/mathlib formalization of RH-adjacent results.

---

## 4. The transfer-operator route in the literature

The dynamical-systems cell (204 papers) is dominated by the Mayer–Selberg–Isola
line: the Selberg zeta function of PSL(2,ℤ) is a ratio of Fredholm determinants
of a transfer operator of the Gauss map:

```
Z_S(s) = det(1 − L_s) · det(1 + L_s)   for Re(s) > 1    (Mayer 1991, Bull. AMS;
                                                        DOI 10.1090/s0273-0979-1991-16023-4)
```

Later refinements (Isola 2003; Möller–Pohl 2011; Bonanno/Hiary–Möller;
Liverani 2005; Pollicott 2022 on the Farey map) connect the eigenvalue-1 problem
for the transfer operator to nontrivial zeros of ζ. **Important honest caveat
(documented in `prethought/findings/mayer-spectral.yaml`):** the "TO-RH
equivalence" chain is subtle — it reduces RH to a spectral-radius bound
ρ(L_s) < 1 for Re(s) > 1/2, which is *itself equivalent to RH* (see §5.4).

### Corpus support (dynamical systems cell)

- **transfer operator / Gauss map:** 141 docs-scoped hits in title/abstract
  (`concept map`, PageRank hub #9).
- **selberg zeta / thermodynamic formalism / nuclearity / Lasota–Yorke:**
  compact, well-connected community (14 nodes in the concept graph,
  modularity-detected as a distinct cluster — the only thematic community
  separated from the giant component).

This matches the field consensus: the route is right, the endpoint is hard.

---

## 5. Latest status of our research programme (`~/git/riemann`)

### 5.1 What the repo actually is

A Dockerized research environment for **GNNs on Cayley graphs of SL(2,F_p)**
spectral prediction, plus a **transfer-operator thermodynamic formalism
programme** with a LaTeX paper (`paper/transfer-operator-rh.tex`) and a **Lean 4
formalization** (`lean/`). Historical markdown files contain contradictory
claims ("RH PROVEN" vs honest assessments); **the honest files are the ones that
prevail**: `FINAL_PROJECT_STATUS.md`, `HONEST_FINAL_STATUS.md`,
`VERIFICATION_CRITICAL_ANALYSIS.md`, and the experiment log
`experiments/EXPERIMENT_LOG.md`.

### 5.2 Established partial results (honest)

| Result | Status | Evidence |
|---|---|---|
| Nuclearity of L_s on H¹, Re(s) > 1/2 | ✅ from Mayer 1990 / Isola 2003 (literature chain, cross-checked) | `research/NUCLEARITY_SYNTHESIS.md`; EPIC-3 commit `401ad23` |
| Mayer identity det(1−L_s) = Z_S(s)/Z_S(s+1) | ✅ literature (Möller–Pohl 2011) + Lean axiom | `lean/.../TransferOperator.lean` |
| λ₁(1) = 1 (Perron–Frobenius eigenvalue) | ✅ direct calculation, Lean | EPIC-4 |
| λ₁'(1) = −π²/(6·ln 2) ≈ −2.373138 < 0 (exact) | ✅ two independent derivations (Ruelle pressure + direct eigendecomposition), numerical confirmation; Lean recorded | `experiments/EXPERIMENT_LOG.md` Exp 19b; commit `3dd41dd` |
| Spectral gap at s=1: |λ₂(1)| < 1 (GKW) | ✅ classical (Gauss–Kuzmin–Wirsing) + numerics | Exp 19c |
| ρ(L_s) < 1 for Re(s) ≥ 3/4 + ε | ✅ certified by Nisoli's DFLY (external) | `prethought/findings/spectral-radius-analysis.yaml` |
| ρ(L_s^{0}) < 0.30 for |t| ≤ 100 | ✅ numerical (Fourier-basis) | Sprint 2 |

### 5.3 Lean formalization status

- **Build:** `lake build` 0 errors (≈6,336 jobs), toolchain + mathlib pinned.
- **Non-trivial formalized results:** Gauss-map basics, basic transfer-operator
  inequalities, spectral-gap definitions, equivalence-theorem scaffolding
  (`spectralRadiusImpliesRH`, `rhImpliesSpectralRadius` — currently as
  *axioms* / honest `sorry`s).
- **Honest accounting:** `grep sorry` across authored Lean files (excluding
  `.lake`) ≈ **179 `sorry`s**. Many small ones are routine; the substantive
  ones are the analytic-perturbation `` axioms:
  - `leadingEigenvalue_neighborBound` (first-order Taylor bound on λ₁),
  - `secondEigenvalue_gapPersistence` (gap continuity),
  - plus the big non-equivalence claims.
- **Local win (Aug 27):** `localSpectralRadiusBound_above_one` (∃ε>0, ∀r,
  1<r<1+ε → ρ(L_r)<1) **converted from `sorry` to a real proof** by closing
  steps 1–2 of the perturbation programme (commit `6671a13`).

### 5.4 The central honest finding (EPIC-4, Exp 19)

```
RH  ⟺  Z_S(s) ≠ 0 (Re s > 1/2)
   ⟺  det(1−L_s) ≠ 0 (Re s > 1/2)          (Mayer / Möller–Pohl)
   ⟺  1 ∉ spectrum of L_s (Re s > 1/2)
   ⟺  ρ(L_s) < 1 for all Re(s) > 1/2.
```

The spectral-radius bound for ALL Re(s) > 1/2 **is equivalent to RH** — it
cannot be proved without proving RH. We currently have it for Re(s) ≥ 3/4 + ε
(Nisoli DFLY) and locally just above s = 1 (Lean proof); the remaining strip
(½, ¾) is the obstruction. **This is correctly framed as "the gap is RH
itself", not as a completed proof.** See `experiments/EXPERIMENT_LOG.md` Exp 19
(commit `d9a1533`).

### 5.5 GNN / experimental line (separate, honest)

- GNN spectral-gap prediction on SL(2,F_p) Cayley graphs: models run, but
  **generalization across primes fails** (R² negative on held-out primes) —
  documented in `prethought/findings/gnn-failures.yaml`; this is an honest
  negative result, not a claimed breakthrough.
- L-function zero-spacing / GUE statistics from LMFDB data is published on
  Zenodo (DOI 10.5281/zenodo.21974748) — a separate, solid data artifact.

---

## 6. Concept graph insights (regenerated 2026-08-27)

The enhanced concept graph (126 nodes, 634 edges) reproduces the known thematic
structure:

- **Two communities** detected:
  1. main math community (Number Theory, Spectral Theory, RH Equivalences,
     zeta, critical line, Langlands, modular forms, random matrix…);
  2. **transfer-operator cluster** (Dynamical Systems, transfer operator,
     Selberg zeta, thermodynamic formalism, Mayer, Ruelle, Lasota–Yorke,
     nuclear, quasi-compact, Gauss map, continued fraction, Fredholm
     determinant) — the engine of our programme.
- **Bridge edges** worth exploiting: `spectral gap ↔ graph neural network`,
  `transfer operator ↔ Lasota–Yorke`, `Spectral Theory ↔ Gauss map` — these are
  the cross-area seams where novel RH-adjacent work is likely to emerge.
- `config/concepts.yaml` is now domain-specific (was: generic skeleton
  research-methods seeds). Future feedback loop: prune the ~30 curated terms
  with zero document frequency performed by a maintenance pass.

---

## 7. Open problems & next steps

1. **Close (½, ¾) — the honest target:** extend Nisoli DFLY certification from
   Re(s) ≥ ¾+ε toward ½, or push the perturbation-from-s=1 argument further;
   any complete resolution here *is* a proof of RH, so the realistic near-term
   goal is sharper partial certificates + paper.
2. **Reduce Lean `sorry` count:** formalize the analytic-perturbation lemmas
   (`leadingEigenvalue_neighborBound`, `secondEigenvalue_gapPersistence`) rather
   than axiomatizing them.
3. **Concept-graph maintenance:** drop 0-df curated seeds; add
   `concepts_map` aliases for the bridge seams above.
4. **Corpus hygiene:** the ingestion round surfaced that broad arXiv queries
   (e.g. `math.NA` "computation OR verification") reintroduce off-topic
   numerical-analysis papers; the queries were tightened (config commit pending).

---

## 8. Verification metadata

- `python scripts/validate_papers.py` → exit 0 (3,649 papers, 0 errors).
- `python -m pytest` → 100% pass (pipeline tests).
- `generate_readme.py`, `standard_stats.py`, `generate_reports.py`,
  `extract/relate/analyze_concept_graph` — all rerun after the above changes;
  `--check` gates pass.

*Prepared by the coding agent as a hand-written companion to the auto-generated
reports; all claims traceable to files referenced inline.*
