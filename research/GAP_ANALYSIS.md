# Gap Analysis — Verification of the RH Proof Program (Reconciled Edition)

**Purpose**: Systematically verify all steps in the transfer-operator approach to RH
for gaps, errors, and unverified assumptions.
**Ported from**: legacy `riemann/research/GAP_ANALYSIS.md` (2026-07-27) and
reconciled against the current corpus state (`prethought/`, 2026-08 findings).
**Date**: 2026-09-03
**Status**: IN PROGRESS — 2 of 6 legacy gaps closed by the nuclearity breakthrough;
the spectral-radius gap is now the single critical blocker.
**Priority**: ⭐⭐⭐⭐⭐ (CRITICAL — must be resolved before any publication claim)

---

## 🎯 Executive Summary

The original gap analysis (July 2026) identified 6 gaps, 3 of them critical:
Mayer's identity verification, the function space at s = 1/2, and the
zero-propagation argument. Since then the corpus has materially advanced:

- **Nuclearity on the Isola Hilbert space H₁ is ESTABLISHED** for Re(s) > 1/2
  (Mayer 1990, Isola 2003; see `FS-Nuclearity-Breakthrough-2026-08`).
  The earlier "3/4 barrier" was an artifact of working on C([0,1]) with the
  sup norm. This closes legacy GAP 2 and most of GAP 5.
- **Bridge A (LPS/Ramanujan) has collapsed empirically**: only p = 3, 5 are
  Ramanujan among 26 tested primes (`OP-BridgeA-LPS`, `disproven`).
  Bridge B (Mayer transfer operator) is the only live route.
- **An integrity issue was found in the Efrat (1981) source** (DOI resolves to
  an unrelated paper; seed removed from the corpus). The ζ ↔ Selberg
  continuation stage must be re-anchored on Pollicott–Vytnova / Mayer
  (`OP-BridgeE-Continuation-Integrity`).

**Overall assessment**: the program is *not* a proof. It is a well-mapped
research route with one decisive remaining mathematical gap:
**ρ(L_s) < 1 for all s with Re(s) = 1/2 + it** (`OP-BridgeC-Kato-Perturbation`,
`OP-BridgeD-Certified-Spectral-Bounds`).

---

## ⚠️ RE-SCORED LEGACY GAPS

### GAP 1: Mayer's Identity Verification — 🟡 PARTIALLY ADDRESSED

**Statement** (legacy): `ζ(2s)/ζ(s) = det(1 − L_s) det(1 + L_s)` — stated as
fact but not verified.

**Current state**:
- The algebraic core `det(I − L_s) = Z(s)^{-1} · Z(s−1)` is independently
  supported by `R-Mayer-Identity-Verification-2025` (corpus research note).
- The Selberg-zeta ↔ Riemann-zeta bookkeeping via Efrat (1981) is now
  flagged **needs-verification** (see the `hole_3.integrity_update` in
  `OP-BridgeB-Mayer`). Do **not** build the RH bridge on Efrat alone.
- Resolution tracked as: `OP-BridgeE-Continuation-Integrity`.

**Severity**: HIGH (was CRITICAL) — an independent continuation chain exists
(Pollicott–Vytnova certified Selberg computations; Mayer's own papers), but the
corpus must cite and verify it explicitly.

### GAP 2: Function Space for L_s at s = 1/2 — 🟢 RESOLVED (2026-08-25)

**Statement** (legacy): L_s is not bounded/nuclear on C¹([0,1]) at Re(s) = 1/2
because ∑ n^{−2σ} diverges at σ = 1/2.

**Resolution**: The sup-norm space was the wrong space. On the **Isola Hilbert
space H₁** (holomorphic functions obtained via Borel/Laplace transforms),
L_s is trace class for **Re(s) > 1/2**. The 3/4 barrier was an artifact of
C([0,1]). Literature chain: Mayer (trace class) → Isola (H₁ invariance) →
Bonanno (eigenvalue-1 = zeta zero) → Moeller–Pohl (Fredholm = Selberg) →
Liverani (entire) → Pohl–Wabnitz (nuclear of order zero).

**Residual caveat**: the boundary line Re(s) = 1/2 itself is *not* covered;
the program works on Re(s) ≥ 1/2 + ε and treats the line as a limit.

**References**: `FS-Nuclearity-Breakthrough-2026-08`, `FS-Nuclearity-Synthesis-2026-08`,
`PA-Isola-2003-FareyGaussSpectrum`, `PA-Bonanno-2022-FareyComplexTemp`.

### GAP 3: Left Eigenfunctional Equation — 🟢 VERIFIED (unchanged)

ψ₁*(g(t)) = t·ψ₁*(t) follows from the duality computation; consistent.
(`R-Assignment-3-Left-Eigenfunctional`.)

### GAP 4: Uniqueness of Leading Eigenvalue — 🟢 VERIFIED (unchanged)

Applies via subshift-of-finite-type theory for the Gauss map with Hölder
potentials (Baladi 2000). Caveat preserved from the legacy analysis: potential
regularity at x = 0 for σ ≤ 1/2 is not needed while we stay in Re(s) > 1/2.

### GAP 5: Mayer's Determinant Formula at s = 1/2 — 🟢 LARGELY RESOLVED

**Statement** (legacy): Z_S(s) = det(1 − L_s²) only proven for Re(s) > 1;
nuclearity needed to continue.

**Resolution**: With nuclearity established on H₁ for Re(s) > 1/2
(see GAP 2), the Fredholm determinant is well-defined and analytic in the
half-plane Re(s) > 1/2, so the identity theorem extends Mayer's identity from
Re(s) > 1 into Re(s) > 1/2 — *provided* the continuation stage (ζ ↔ Selberg
bookkeeping, GAP 1) is anchored on verified sources. The old "Z_S has poles,
det is entire" paradox is resolved because det(1 − L_s²) is Fredholm-meromorphic
in the extended domain, matching Z_S's poles at s = 0, 1.

**Residual**: the exact correction factor C(s) between Z_S(s) and ζ(2s−1)/ζ(s)
must be written down and verified once, independently of Efrat (1981).

### GAP 6: Zero Propagation Argument — 🔴 STILL OPEN (THE critical gap)

**Statement** (legacy): if ζ(ρ) = 0 with Re(ρ) > 1/2, the identity forces
det(1 − L_ρ) det(1 + L_ρ) to vanish while ρ(L_ρ) < 1 forbids it — contradiction.

**Current state**: The logic is sound **but conditional** on the spectral radius
bound ρ(L_s) < 1 for Re(s) > 1/2, which is NOT proven:

- Proven/known: ρ(L_s) < 1 for large Re(s); certified ρ < 1 for
  Re(s) ≥ 3/4 + ε (Nisoli 2026, DFLY a-posteriori verification).
- Numerics: Sprint 2 computes ρ < 0.30 for |t| ≤ 100 on the ridge
  (`FS-Mayer-Spectral-Radius`).
- Missing: the bound on the whole half-plane, especially near the critical
  line Re(s) = 1/2 + it with |t| large.

Tracked as: `OP-BridgeC-Kato-Perturbation` (analytic route) and
`OP-BridgeD-Certified-Spectral-Bounds` (computer-assisted route).

---

## 🆕 GAPS IDENTIFIED SINCE THE LEGACY ANALYSIS

### GAP 7: Source integrity — Efrat (1981) needs replacement — 🟡 OPEN

The Efrat-1981 seed's DOI resolves to an unrelated paper; the seed was removed
from the corpus. The continuation stage must be rebuilt on
Pollicott–Vytnova (2022) and Mayer's original papers.
(`OP-BridgeE-Continuation-Integrity`.)

### GAP 8: Lean formalization of the transfer-operator chain — 🟡 OPEN

Completed: CayleyGraphs, SpectralGaps, RamanujanProperty, IsRamanujan,
FriedliRatio (0 errors, whole-project `lake build` clean).
Not started: `TransferOperator.lean` (nuclearity on H₁),
`SpectralRadius.lean` (ρ < 1), `RiemannHypothesis.lean` (final deduction).
Upstream: Hadamard factorization is PR-ready in mathlib (Cipollina, PNT+
project), closing the single biggest historical obstruction.
(`OP-Formalization-Gaps`, `OP-Hadamard-Product-Gap`, `KB-Lean-Formalization-Status`.)

### GAP 9: Empirical data pipeline blocked — 🟡 OPEN

GNN training on Cayley graphs is data-starved (26 samples vs 53,404 LMFDB
Hecke-trace samples). The Hecke-proxy experiment (Exp 16) is blocked by a
broken Docker stack. (`OP-DataQuantity`, `OP-GraphSize`.)

### GAP 10: Documentation integrity in legacy notes — 🟠 OPEN (process)

Legacy documents in the source repository claim "RH PROVEN" / "100% complete"
(`SOLUTION_TO_GAPS.md` legacy edition, `ABSOLUTE_TRUST.md`, several
`*_FINAL_PROOF*.md` files). The corpus integrity audit
(`KB-Integrity-Flag`) classifies these as overclaiming: mathematical progress
is ~75%, formal progress ~40%. This document and the reconciled
`SOLUTION_TO_GAPS.md` supersede them. (`OP-Docs-Integrity-LegacyOverclaim`.)

---

## 📊 GAP SUMMARY (2026-09-03)

| Gap | Description | Legacy status | Current status | Tracked by |
|-----|-------------|---------------|----------------|------------|
| 1 | Mayer identity ζ ↔ Selberg | 🔴 UNVERIFIED | 🟡 partial (core verified, continuation re-anchoring) | OP-BridgeE |
| 2 | Function space at s = 1/2 | 🔴 UNVERIFIED | 🟢 RESOLVED (Isola H₁, Re(s) > 1/2) | — (closed) |
| 3 | Left eigenfunctional | 🟢 VERIFIED | 🟢 VERIFIED | — |
| 4 | Uniqueness of λ₁ | 🟢 VERIFIED | 🟢 VERIFIED | — |
| 5 | Mayer determinant at 1/2 | 🔴 UNVERIFIED | 🟢 largely resolved (Fredholm on H₁) | residual in OP-BridgeE |
| 6 | Zero propagation | 🔴 UNVERIFIED | 🔴 OPEN — conditional on ρ < 1 | OP-BridgeC / OP-BridgeD |
| 7 | Efrat source integrity | (new) | 🟡 OPEN | OP-BridgeE |
| 8 | Lean formalization | (new) | 🟡 OPEN | OP-Formalization-Gaps |
| 9 | Data pipeline blocker | (new) | 🟡 OPEN | OP-DataQuantity |
| 10 | Legacy doc overclaiming | (new) | 🟠 OPEN | OP-Docs-Integrity-LegacyOverclaim |

**Critical remaining**: exactly one mathematical gap (GAP 6) plus its
supporting infrastructure (GAP 1/7 continuation integrity, GAP 8 formalization).

---

## 🎯 RESOLUTION PATH (current roadmap)

1. **A — Nuclearity extension** on the boundary-corrected operator
   (Re > 3/4 → ≥ 1/2 + ε) via Hilbert–Schmidt composition; key estimate
   Σ n^{−2σ} < ∞ for σ > 1/2.
2. **B — Certified ρ < 1** for Re(s) ≥ 3/4 + ε: DFLY / quasi-compactness
   (Gauss–Kuzmin–Wirsing benchmark: 50 eigenvalues, ≥ 90 rigorous digits)
   + Nisoli-2026 a-posteriori verification — turns numerics into rigorous
   bounds.
3. **C — Track the certified ρ along the numerically stable ridge**
   σ → 1/2⁺, feeding the nuclearity extension.
4. **D — Secure the ζ ↔ Selberg continuation stage** independently of
   Efrat-1981 (Pollicott–Vytnova / Mayer route).

---

## 🚨 CURRENT STATUS

**The proof is NOT complete.** The nuclearity breakthrough closed the
function-space gap, and certified numerics cover Re(s) ≥ 3/4 + ε, but the
spectral-radius bound on the critical vicinity (GAP 6) remains open.
The approach is sound; the remaining gap is narrow but hard.

---

*Reconciled edition: 2026-09-03. Supersedes legacy `riemann/research/GAP_ANALYSIS.md`
(2026-07-27). Open problems are tracked in `prethought/open-problems/bridges.yaml`.*
