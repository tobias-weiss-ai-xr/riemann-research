# Riemann Hypothesis Research Corpus

> **Agentic literature and knowledge management for RH and spectral number theory**

**Status**: 🚀 **ACTIVE** — Corpus repo created from skeleton-research template, taxonomy specialized, prethought space seeded.

**Parent Project**: [riemann](https://github.com/tobias-weiss-ai-xr/riemann) (code, Lean formalization, experiments, knowledge graph)

**Forked from**: [skeleton-research](https://github.com/tobias-weiss-ai-xr/skeleton-research) (generic research corpus template by Tobias Weiss)

---

## 🎯 Purpose

This repository structures the **research corpus** (papers, concepts, findings) for the Riemann Hypothesis project. It is separate from the code/repo ([riemann](https://github.com/tobias-weiss-ai-xr/riemann)) which contains:

- `lean/` — Lean 4 formalization of RH and related results
- `knowledge-graph/` — Neo4j Cypher seed scripts for the SL(2,Z) → ζ(s) theory chain
- `scripts/` — Python experiments (GNN, eigenvalues, LMFDB, Hecke, etc.)
- `experiments/` — 18+ experiment logs (some completed, some planned)
- `research/` — Proof writeups (RH proofs, Mayer identity, pressure function, etc.)

This corpus repo (**riemann-research**) manages:
- `papers.yaml` — Structured bibliography of RH/spectral/number theory literature
- `config/taxonomy.yaml` — Discovery queries, categories, subcategories
- `prethought/` — **Prethought space**: concepts, findings, related work, open problems
- `kg/` — Knowledge graph extensions (Dgraph and Neo4j)
- `docs/` — Auto-generated reports (literature review, trends)

---

## 🏗️ Structure

```
riemann-research/
├── papers.yaml                    # Curated corpus (source of truth)
├── config/
│   ├── taxonomy.yaml               # Categories, subcategories, discovery queries
│   └── other_sources_queries.yaml # dblp, crossref, europepmc queries
├── prethought/                     # 🧠 Prethought Space
│   ├── README.md                   # How to use the prethought space
│   ├── concepts/                   # Core mathematical entities
│   │   ├── cayley-graphs.yaml
│   │   ├── spectral-gaps.yaml
│   │   ├── ramanujan.yaml
│   │   └── transfer-operators.yaml
│   ├── findings/                   # Empirical discoveries
│   │   ├── gnn-failures.yaml       # Vertex-transitive curse, R² < 0
│   │   ├── ml-successes.yaml       # Hecke traces R² 0.73-0.99, ChebConv +4.2%
│   │   └── spectral-constants.yaml # Friedli constant ≈ 1.1367
│   ├── related-work/               # External literature
│   │   └── RH-Equivalences.yaml    # Nyman-Beurling, Weil, Granville, etc.
│   └── open-problems/              # Known gaps, TODOs
│       ├── bridges.yaml            # Bridge A (LPS), Bridge B (Mayer), etc.
│       └── formalization-gaps.yaml # Hadamard product gap in mathlib
├── kg/                              # Knowledge Graph
│   ├── cypher/                      # Neo4j Cypher scripts (mirror/sync)
│   └── dgraph/                      # Dgraph GraphQL schemas + data
├── docs/                            # Auto-generated
│   └── research/
│       ├── literature_review.md   # Grouped by taxonomy
│       └── trends.md               # Statistics, momentum, gaps
├── scripts/                         # Corpus pipeline
│   ├── fetch/                       # Paper discovery
│   ├── analysis/                    # Reports, statistics
│   └── validate_papers.py           # Schema validation
├── tests/                           # Pipeline tests
└── Makefile                         # Pipeline commands
```

---

## 🚀 Quick Start

### 1. Preview the current corpus

```bash
python scripts/generate_readme.py        # Generate README with paper list
python scripts/standard_stats.py        # Compute statistics → statistics.json
python scripts/analysis/generate_reports.py  # Literature review + trends
```

### 2. Discover new papers

```bash
# arXiv
python scripts/fetch/fetch_new_papers.py --months 12 --dry-run

# dblp / crossref / europepmc
python scripts/fetch/fetch_other_sources.py --dry-run

# GitHub repos
python scripts/fetch/fetch_github_repos.py --dry-run
```

### 3. Validate the corpus

```bash
python scripts/validate_papers.py   # Check schema, duplicates, LaTeX, URLs
```

---

## 📊 Current Corpus Statistics

| Metric | Value | Source |
|--------|-------|--------|
| **Papers** | See `papers.yaml` | Curated |
| **Categories** | 7 | `config/taxonomy.yaml` |
| **Subcategories** | 18 | `config/taxonomy.yaml` |
| **Discovery Queries** | 35+ | `config/taxonomy.yaml` |
| **Prethought Concepts** | ~40 | `prethought/concepts/` |
| **Prethought Findings** | ~20 | `prethought/findings/` |
| **Open Problems** | ~10 | `prethought/open-problems/` |

---

## 📚 Key Findings (Honest Assessment)

| ID | Finding | Status | Impact |
|----|---------|--------|--------|
| FG-Vertex-Transitive-Curse | Local GNN features cannot predict global spectral properties for vertex-transitive graphs | **CONFIRMED** | ⭐⭐⭐⭐⭐ Blocks all local GNN approaches on Cayley graphs |
| FS-Hecke-Traces-R2 | sklearn on LMFDB Hecke traces achieves R² 0.73-0.99 | **CONFIRMED** | ⭐⭐⭐⭐⭐ Data quantity (53k) wins over architecture |
| FS-ChebConv-Beats-Baseline | Full-graph ChebConv beats linear baseline by +4.2% R² | **CONFIRMED** | ⭐⭐⭐ Use spectral methods for spectral targets |
| SC-Friedli-Constant | Friedli constant ≈ 1.1367 (spectral zeta derivative at σ=0.5) | **VERIFIED** | ⭐⭐⭐ New empirical constant, confirms theoretical prediction |
| CM-Enrichment | CM forms 3.6× enriched in GUE outliers but only 1.1% of total | **CONFIRMED** | ⭐⭐⭐ Minor contributor, dimension is primary driver |
| OP-BridgeA-Collapsed | Bridge A (LPS/Ramanujan) collapse: p=3,5 Ramanujan; p≥7 are NOT | **DISPROVEN** | ⭐⭐⭐⭐⭐ This approach is HOPELESS |
| OP-BridgeB-Partial | Bridge B (Mayer transfer operator) proven equivalence but gaps remain | **PARTIAL** | ⭐⭐⭐⭐ Needs spectral radius bound ρ(L_s) < 1 for Re(s) > 1/2 |

---

## 🔬 Research Paths (Pfad A, Pfad B)

### Pfad A: LPS Bridge (Cayley → Ramanujan → RH) ❌ **DEAD END**
```
SL(2,F_p) Cayley graph
  ↓
Spectral gap λ₂
  ↓ [Pizer 1981]
Brandt matrix eigenvalues
  ↓
Hecke eigenvalues on S₂(Γ₀(p))
  ↓
L-function zeros
  ↓ [de Branges?]
RH
```
**Status: COLLAPSED** — Only p=3,5 Cayley graphs are Ramanujan; p≥7 are not (λ₂ > 2√3).
**Verdict: DO NOT pursue Pfad A.**

### Pfad B: Hecke GNN → L-Function Zeros → RH ✅ **ACTIVE**
```
LMFDB Hecke traces (53k newforms)
  ↦ [GNN / sklearn] → Predict L-function zeros
  ↦ [Granville 2007] → Averaged Goldbach bound
  ↦ [Granville equivalence] → RH
```
**Status: VIABLE** — sklearn already achieves R² 0.73-0.99 on Hecke traces.
**Next Steps:**
- Exp 16: `scripts/spectral_gap_hecke_correlation.py` (blocked on Docker)
- Formalize Granville's theorem in Lean
- Connect Hecke → L-function zeros → Granville → RH

### Pfad C: Transfer Operator (Mayer) → RH ✅ **PRIMARY**
```
Mayer's transfer operator L_s
  ↓
Spectral radius ρ(L_s) < 1 for Re(s) > 1/2
  ↓ [Mayer+Efrat]
Zeros of ζ(s) all on Re(s) = 1/2
  ↓
RH
```
**Status: PARTIALLY PROVEN** — Equivalence holds, but ρ(L_s) < 1 not proven for Re(s) ∈ (1/2, 1).
**Verdict: This is the MOST PROMISING path.**

---

## 🏆 Integrity Notice

There is a **ثر split between optimistic claims and honest assessments** in the parent riemann repo:

| Document | Claim | Honest Assessment |
|----------|-------|-------------------|
| `riemann/research/README.md` | "RH PROVEN" | ❌ **NOT CREDIBLE** |
| `riemann/FINAL_PROOF_STATUS.md` | "100% confidence, SOLVED" | ❌ **NOT CREDIBLE** |
| `riemann/HONEST_FINAL_STATUS.md` | "Theorem 3.3: Partially Verified, Critical Gaps Remain" | ✅ **HONEST** |
| `riemann/AGENTS.md` | "GNNs consistently fail (R² < 0). sklearn on LMFDB Hecke traces succeeds (R² 0.73–0.99)." | ✅ **HONEST** |

**This corpus repo suppresses the optimistic claims and operates from the honest baseline.**

---

## 🛠️ Workflow

### Add a new paper
1. Append to `papers.yaml`
2. Add discovery query to `config/taxonomy.yaml` (optional, for auto-fetch)
3. Run `python scripts/validate_papers.py`
4. Run `python scripts/generate_readme.py` → updates README
5. Commit with message "Add [Paper Title]"

### Add related work
1. Add to `prethought/related-work/*.yaml`
2. Reference from findings/concepts as needed
3. Add cross-links in `prethought/**/*.yaml` files

### Add a finding
1. Create/edit `prethought/findings/*.yaml`
2. Add `experiment` reference, `results`, `analysis`, `tags`
3. Commit

### Regenerate reports
```bash
python scripts/generate_readme.py
python scripts/standard_stats.py
python scripts/analysis/generate_reports.py
```

---

## 💡 Prethought Space Philosophy

> **"Think meta first"**

Before starting any new experiment, proof, or formalization:

1. **Search prethought/** for the concept or finding
2. **Check prethought/open-problems/** for known gaps
3. **Consult prethought/related-work/** for prior art
4. **Look in kg/** for theory connections

If it's already there, use it. If not, add it.

---

## 📦 Dependencies

```bash
# Core
pip install -r requirements.txt

# Optional (for Dgraph)
pip install dgraph-io
# Add Dgraph server (port 9080 default)
```

---

## 🔗 Links

- **Parent Repo**: https://github.com/tobias-weiss-ai-xr/riemann
- **Docker Setup**: See riemann/Makefile and docker-compose.yml
- **Neo4j KG**: riemann/knowledge-graph/cypher/
- **Lean Project**: riemann/lean/
- **Taskfleet**: https://github.com/tobias-weiss-ai-xr/taskfleet (parallel LLM task dispatch)

---

## 🎓 License & Contribution

- **License**: MIT (same as skeleton-research)
- **Contributing**: See CONTRIBUTING.md
- **Citation**: See CITATION.cff
