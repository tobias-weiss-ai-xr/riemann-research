# Agile Research Plan — Riemann Hypothesis via Bridge B

**Status**: Aktiver Plan (Sprint 1 läuft)
**Start**: 2026-01-15 · **Ziel**: 2026-06-15
**Philosophie**: Minimal Stoic Unix — greife die schmalste Lücke an, stoische Ehrlichkeit, Bausteine komponieren
**KB-Referenz**: `prethought/research/agile_plan.yaml` (maschinenlesbar, in Dgraph geladen)

> **Kernaussage**: Die Riemann-Hypothese ist in diesem Projekt **NICHT bewiesen**.
> Der schmalste Spalt: *Kernigkeit von L_s bei Re(s) = 1/2 + ε*.
> Äquivalenz RH ↔ ρ(L_{1/2+it}) < 1 ist bewiesen — es fehlt genau ein Lemma.

---

## 📊 Überblick: 8 Epics · 10 Sprints · ~20 Wochen

```
┌──────────────────────────────────────────────────────────────────────┐
│ SPRINT 1   SPRINT 2   SPRINT 3-4   SPRINT 5-6  SPRINT 7   SPRINT 8  │
│ LeanFix    Numerisch  Kernigkeit  Spektralr.  RH-Kette  Integrität  │
│                                                                      │
│ EPIC-1  ──►  EPIC-2  ──►  EPIC-3  ──►  EPIC-4  ──► EPIC-5 ──►EPIC-6 │
│ Lean-Fund.  Fail Fast   Narrows.   Gap         RH zu     RH-Bound    │
│                                  │  EPIC-7 (mathlib, parallel)       │
│                                  └── EPIC-8 (KB, laufend)            │
└──────────────────────────────────────────────────────────────────────┘
```

| Epic | Inhalt | Aufwand | Sprint |
|------|--------|---------|--------|
| **EPIC-1** | Lean-Fundament & Deppen-Cleanup (FriedliRatio) | 2 Wo | 1 |
| **EPIC-2** | Numerische Verifikation (Fail Fast) | 2 Wo | 2 |
| **EPIC-3** | Kernigkeits-Erweiterung Re(s) ≥ 1/2 + ε | 4 Wo | 3–4 |
| **EPIC-4** | Spektralradius-Beweis ρ(L_{1/2+it}) < 1 | 4 Wo | 5–6 |
| **EPIC-5** | RH-Formalisierung (Kette komponieren) | 2 Wo | 7 |
| **EPIC-6** | Integritäts-Audit & ehrliche Publikation | 2 Wo | 8 |
| **EPIC-7** | Mathlib-Beitrag (parallel) | 6 Wo | 3–8 |
| **EPIC-8** | KB-Evolution (laufend) | 1 Tag/Sprint | alle |

---

## 🎯 EPIC-1: Lean-Fundament & Schulden-Cleanup (Sprint 1)

**Ziel**: `lake build` → 0 Fehler im gesamten Projekt. Unblockt die Kompositionskette.

**Stories**:
- [ ] STORY-1.1: π/pi_pos-Identifier fixen (`Real.pi`, `Real.pi_pos.ne'`)
- [ ] STORY-1.2: `conj_sum`-Pattern-Matching fixen (`simp only [List.sum, List.map, star_add, ih]`)
- [ ] STORY-1.3: `conj_eq_one_minus_s`-calc reparieren (jeden Schritt prüfen)
- [ ] STORY-1.4: `conj_neg_half_s` fixen (star_neg-Pattern)
- [ ] STORY-1.5: "simp made no progress" → explizites `rw`
- [ ] STORY-1.6: `SpectralZetaFunction.eval` → `dsimp` statt `rw`
- [ ] STORY-1.7: `Probe.lean` löschen
- [ ] STORY-1.8: `lake build` → 0 Fehler
- [ ] STORY-1.9: Modulare Architektur dokumentieren

**Definition of Done**: `lake build` exit 0 · 0 `sorry` · 0 `axiom` · Probe.lean gelöscht

---

## 🎯 EPIC-2: Numerische Verifikation — Fail Fast (Sprint 2)

**Ziel**: Vor jedem Beweisversuch numerisch prüfen: **ρ(L_{1/2+it}) < 1 für |t| < 100**.
Eine 5-Minuten-Rechnung kann Monate Beweisarbeit sparen.

**Stories**:
- [ ] STORY-2.1: L_s als endliche Matrix implementieren (Fourier-Basis auf [0,1])
- [ ] STORY-2.2: Eigenwerte für t ∈ [-100, 100] berechnen (Schritt 0.1)
- [ ] STORY-2.3: Prüfen: |λ_max| < 1 für alle t
- [ ] STORY-2.4: Konvergenz-Check (Matrixgrößen 100, 500, 1000)
- [ ] STORY-2.5: Ergebnisse speichern → `data/spectral-radius/`
- [ ] STORY-2.6: KB-Entity für numerische Ergebnisse anlegen

**Abbruch-Kriterium**: Falls ρ ≥ 1 für irgendein t → **ABORT** (RH wäre falsch oder Implementierungsfehler)

---

## 🎯 EPIC-3: Kernigkeits-Erweiterung — Der schmalste Spalt (Sprint 3–4)

**Ziel**: Kernigkeit von L_s von Re(s) > 3/4 auf **Re(s) ≥ 1/2 + ε** erweitern.

**Technik**: Komposition Hilbert-Schmidt-Operatoren.
**Schlüssel-Einsicht**: Σ n^{-2σ} konvergiert für σ > 1/2 — genau die benötigte Bedingung.

**Stories**:
- [ ] STORY-3.1: Mathematischer Beweis (`research/nuclearity_extension.md`)
- [ ] STORY-3.2: Hilbert-Schmidt-Komposition in Lean formalisieren
- [ ] STORY-3.3: Schlüssel-Abschätzung Σ n^{-2σ} < ∞ für σ > 1/2
- [ ] STORY-3.4: `TransferOperator.lean` anlegen
- [ ] STORY-3.5: `IsNuclear (L s)` für Re(s) ≥ 1/2 + ε beweisen
- [ ] STORY-3.6: `lake build Riemann.TransferOperator` → 0 Fehler

**DoD (Sprint 4)**: TransferOperator.lean kompiliert · 0 sorry · 0 axiom

---

## 🎯 EPIC-4: Spektralradius-Beweis — Das RH-äquivalente Lemma (Sprint 5–6)

**Ziel**: **ρ(L_{1/2+it}) < 1 für alle t ∈ ℝ** — äquivalent zur Riemann-Hypothese.

**Technik**: Perron-Frobenius (reelles s) + Störungstheorie (komplexes s).

**Stories**:
- [ ] STORY-4.1: Mathematischer Beweis (`research/spectral_radius_bound.md`)
- [ ] STORY-4.2: Perron-Frobenius für reelles s anwenden
- [ ] STORY-4.3: Auf komplexes s via Störungstheorie erweitern
- [ ] STORY-4.4: `SpectralRadius.lean` anlegen
- [ ] STORY-4.5: `spectralRadius (L (1/2 + I*t)) < 1` beweisen
- [ ] STORY-4.6: Gegencheck mit numerischer Verifikation (Epic 2)

**DoD (Sprint 6)**: SpectralRadius.lean kompiliert · 0 sorry · 0 axiom

---

## 🎯 EPIC-5: RH-Formalisierung — Die Kette komponieren (Sprint 7)

**Ziel**: Gesamte Beweiskette in Lean:

```
CayleyGraphs → SpectralGaps → RamanujanProperty → FriedliRatio
    → TransferOperator → SpectralRadius → RiemannHypothesis
```

**Stories**:
- [ ] STORY-5.1: `RiemannHypothesis.lean` erweitern
- [ ] STORY-5.2: TransferOperator & SpectralRadius importieren
- [ ] STORY-5.3: RH aus Spektralradius-Schranke beweisen
- [ ] STORY-5.4: `lake build` → 0 Fehler (gesamtes Projekt)
- [ ] STORY-5.5: 0 sorry, 0 axiom prüfen
- [ ] STORY-5.6: Unabhängiger Kompilierungs-Check

**DoD**: `lake build` → 0 Fehler · RH-Theorem bewiesen (bedingt auf Kernigkeit)

---

## 🎯 EPIC-6: Integritäts-Audit & ehrliche Publikation (Sprint 8)

**Ziel**: Stoische Akzeptanz — das annehmen, was ist, nicht was wir wünschen.

**Stories**:
- [ ] STORY-6.1: `ABSOLUTE_TRUST.md` auditieren (behauptet "100% mathematisches Vertrauen" — **Overclaiming**)
- [ ] STORY-6.2: 5 Overclaiming-Dateien korrigieren
- [ ] STORY-6.3: Ehrlicher Statusbericht schreiben
- [ ] STORY-6.4: KB-Integritäts-Entities aktualisieren
- [ ] STORY-6.5: Jede Behauptung hat confidence & status
- [ ] STORY-6.6: Ehrliche Bewertung publizieren

**Overclaiming-Dateien**: `ABSOLUTE_TRUST.md`, `PROOF_COMPLETE.md`, `RH_FINAL_PROOF_SIMPLE.md`, `RIEMANN_HYPOTHESIS_FINAL_PROOF.md`, `RIEMANN_HYPOTHESIS_PROOF_FINAL.md`

---

## 🎯 EPIC-7: Mathlib-Beitrag — Cache, nicht neu bauen (parallel)

**Ziel**: Fehlende Mathlib-Bausteine upstream beitragen statt forken.

| Baustein | Schwere | Aufwand |
|----------|---------|---------|
| Hadamard-Produkt | **Kritisch** | 2–3 Monate |
| Kernoperatoren-Theorie | Hoch | 1–2 Monate |
| Fredholm-Determinante | Mittel | 1–2 Monate |
| Transferoperator-Theorie | Hoch | 1 Monat |

**Workaround** bei ungemergten PRs: Lemma als temporäres Axiom, später beweisen.

---

## 🎯 EPIC-8: KB-Evolution (laufend)

- Update nach jedem Sprint
- Jedes neue Theorem/Lemma als KB-Entity
- Integritäts-Audit nach jedem Sprint
- KB = Single Source of Truth (`prethought/*.yaml`)

---

## ⚠️ Risiken

| Risiko | Wahrsch. | Impact | Mitigation |
|--------|----------|--------|------------|
| Kernigkeits-Erweiterung scheitert | 20% | hoch | Numerische Verifikation (Sprint 2) fängt es früh |
| Mathlib-Lücken blockieren Formalisierung | 40% | mittel | Mathlib-Beitrag (Sprint 9, parallel) + Axiom-Workaround |
| ρ ≥ 1 numerisch (RH falsch) | 5% | kritisch | Implementierung dreifach prüfen |
| Lean-Formalisierung zu langsam | 30% | mittel | Mathematik zuerst, Lean danach |

---

## ✅ Definition of Done — RH-Proof

Die Riemann-Hypothese gilt in diesem Projekt als bewiesen, **wenn alle 8 Kriterien erfüllt sind**:

1. [ ] `lake build` → 0 Fehler (gesamtes Projekt)
2. [ ] Kein `sorry`, kein `axiom` in .lean-Dateien
3. [ ] `RiemannHypothesis.lean`: ρ(L_{1/2+it}) < 1 → RH
4. [ ] `TransferOperator.lean`: `IsNuclear (L s)` für Re(s) ≥ 1/2 + ε
5. [ ] `SpectralRadius.lean`: `spectralRadius (L (1/2 + I*t)) < 1`
6. [ ] Numerische Verifikation: ρ < 1 für |t| < 100
7. [ ] Unabhängige Kompilierung auf sauberer Maschine
8. [ ] Ehrlicher Status: "RH bewiesen **wenn** Kernigkeit bei Re(s) = 1/2 hält"

> ⚠️ **Bis alle 8 Kriterien erfüllt sind, ist RH NICHT bewiesen.** Das ist die stoische Position.

---

## 📋 Backlog (später)

| Backlog-Item | Priorität | Aufwand |
|--------------|-----------|---------|
| Pfad C: Pizer-Matrix-Operator (Alternative zu Bridge B) | Niedrig | 3–6 Mon |
| Erweiterte LMFDB-ML-Analyse (R² 0.73–0.99) | Mittel | 2–4 Wo |
| FunSearch für arithmetische Funktionen | Niedrig | 4–8 Wo |
| Sato-Tate-Moment-Analyse (7.8% Fehlerrate bestätigt) | Mittel | 2–4 Wo |
| de-Branges-Ansatz (bekannte Fehler) | Sehr niedrig | Unbekannt |

---

*Plan erstellt: 2026-01-15 · Quelle: `prethought/research/agile_plan.yaml` (maschinenlesbar, in Dgraph geladen)*
