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

## 📚 Paper list

- [📚 Spectral Theory & Graphs](#spectral-theory-&-graphs)
  - [Cayley Graphs](#cayley-graphs)
  - [Spectral Gaps](#spectral-gaps)
  - [Ramanujan Property](#ramanujan-property)
  - [Brandt & Pizer Matrices](#brandt-&-pizer-matrices)
- [📚 Number Theory](#number-theory)
  - [Hecke Operators](#hecke-operators)
  - [L-Functions & Zeta](#l-functions-&-zeta)
  - [Modular Forms](#modular-forms)
- [📚 Dynamical Systems](#dynamical-systems)
  - [Transfer Operators](#transfer-operators)
  - [Selberg Zeta & Trace Formulas](#selberg-zeta-&-trace-formulas)
- [📚 Machine Learning](#machine-learning)
  - [GNNs on Cayley Graphs](#gnns-on-cayley-graphs)
  - [Full-Graph GNNs](#full-graph-gnns)
  - [ML on Hecke Traces](#ml-on-hecke-traces)
  - [L-Function Zero Classification](#l-function-zero-classification)
- [📚 RH Equivalences & Bridges](#rh-equivalences-&-bridges)
  - [Nyman-Beurling Criterion](#nyman-beurling-criterion)
  - [Hilbert-Pólya Conjecture](#hilbert-pólya-conjecture)
  - [Weil Criterion](#weil-criterion)
  - [Granville / Goldbach-Bridge](#granville-/-goldbach-bridge)
- [📚 Proof & Formalization](#proof-&-formalization)
  - [Lean & Mathlib](#lean-&-mathlib)
  - [Formal Verification](#formal-verification)

### Spectral Theory & Graphs

#### Cayley Graphs

##### 2026

- [2026] **Ramanujan Cayley Graphs with Normal Connection Sets in Ratio-One Frobenius Groups** [[paper](https://arxiv.org/abs/2608.19905)]
- [2026] **On the Laplacian spectral gap of generalized pancake graphs** [[paper](https://arxiv.org/abs/2608.15398)]
- [2026] **Perfect state transfer and Cayley presentations** [[paper](https://arxiv.org/abs/2608.20476)]
- [2026] **Minimal Cayley graphs with large chromatic number** [[paper](https://arxiv.org/abs/2608.06254)]
- [2026] **From algebraic orthogonality to RAAG embedding obstructions in hierarchically hyperbolic groups** [[paper](https://arxiv.org/abs/2608.09535)]
- [2026] **Random walks on wreath products and spectral gaps for coloured interchange processes** [[paper](https://arxiv.org/abs/2608.20613)]
- [2026] **Uniform expansion in finite groups of Lie type** [[paper](https://arxiv.org/abs/2608.00755)]
- [2026] **Analytic rank one propagation in Hida families** [[paper](https://arxiv.org/abs/2608.13145)]
- [2026] **On the L^6-norm of holomorphic Hecke eigenforms** [[paper](https://arxiv.org/abs/2608.02234)]
- [2026] **The Local Langlands Correspondence for Middle Supercuspidal Representations of p-adic GL(2n)** [[paper](https://arxiv.org/abs/2608.20225)]
- [2026] **The extended Fargues--Scholze spectral action** [[paper](https://arxiv.org/abs/2608.02708)]
- [2026] **A central limit theorem for prime geodesics on random surfaces of large genus** [[paper](https://arxiv.org/abs/2608.17265)]
- [2026] **An intermediate conjecture between Goldbach and Dubner: every even number is the sum of a prime and a twin prime** [[paper](https://arxiv.org/abs/2608.02381)]
- [2026] **The distribution and the structure of the maximum of partial sums in families of trace functions** [[paper](https://arxiv.org/abs/2608.04249)]
- [2026] **Bottleneck Paths Reduce to Deterministic Graphical Games and a Counterexample to a Claimed Linear-Time Algorithm** [[paper](https://arxiv.org/abs/2608.04279)]
- [2026] **The Aldous property for normal Cayley graphs on symmetric groups** [[paper](https://arxiv.org/abs/2607.29018)]
- [2026] **Perfect state transfer in Grover walks on normal Cayley graphs** [[paper](https://arxiv.org/abs/2607.19309)]
- [2026] **Coloring semiminimal Cayley Graphs** [[paper](https://arxiv.org/abs/2607.26942)]
- [2026] **Cayley Graphs Of Order pqrs Are Hamiltonian** [[paper](https://arxiv.org/abs/2607.14440)]
- [2026] **Learning the Graphical Nature of Symmetries** [[paper](https://arxiv.org/abs/2607.12026)]
- [2026] **Eternal domination in Cayley graphs** [[paper](https://arxiv.org/abs/2607.04024)]
- [2026] **Disproof of the tree product conjecture via the Heisenberg group** [[paper](https://arxiv.org/abs/2607.03041)]
- [2026] **Fusion Systems on Sylow 3-subgroups of Fischer and Monster sporadic groups -- II** [[paper](https://arxiv.org/abs/2607.24674)]
- [2026] **Murmurations of quadratic Hecke L-functions of the Gaussian field** [[paper](https://arxiv.org/abs/2607.20853)]
- [2026] **Associated graded modules for modular representations of quaternion algebras** [[paper](https://arxiv.org/abs/2607.28748)]
- [2026] **Schwartz spaces on L-monoids: non-Archimedean** [[paper](https://arxiv.org/abs/2607.28507)]
- [2026] **Statistical periodicity in noise-induced order from Ruelle-Pollicott resonances** [[paper](https://arxiv.org/abs/2607.18771)]
- [2026] **A finite Guinand-Weil dictionary and archimedean tail order for the truncated Weil quadratic form** [[paper](https://arxiv.org/abs/2607.02828)]
- [2026] **Multiplicative dependence modulo subsets** [[paper](https://arxiv.org/abs/2607.19917)]
- [2026] **From a Windowed Square Wave to the Hyperbolic Tangent, Even Zeta Values, and Dirichlet L-Values** [[paper](https://arxiv.org/abs/2607.15304)]
- [2026] **Derivative Sums of Balanced Gamma Quotients and Multiple Zeta Values: Five Conjectures of Zhi-Wei Sun** [[paper](https://arxiv.org/abs/2607.27229)]
- [2026] **Structure of Cayley Codes** [[paper](https://arxiv.org/abs/2606.28611)]
- [2026] **Non-Isomorphic Optimal Cayley Graphs** [[paper](https://arxiv.org/abs/2606.10954)]
- [2026] **Lin--Lu--Yau Ricci Curvature of Digraphs via Optimal Transport Couplings** [[paper](https://arxiv.org/abs/2606.16530)]
- [2026] **Cayley graphs of quasirandom groups** [[paper](https://arxiv.org/abs/2606.03801)]
- [2026] **Spectral properties of the Schreier graphs of the basilica group** [[paper](https://arxiv.org/abs/2606.07430)]
- [2026] **Improved algebraic fibrations of high-dimensional hyperbolic groups** [[paper](https://arxiv.org/abs/2606.05091)]
- [2026] **A dynamical proof of non-arithmeticity of Jordan spectra** [[paper](https://arxiv.org/abs/2606.11528)]
- [2026] **Shadowing and Hyperbolicity for Endomorphisms of Locally Compact Groups** [[paper](https://arxiv.org/abs/2606.27647)]
- [2026] **Correspondence of discrete series representations of GSp_{2n} and its inner form** [[paper](https://arxiv.org/abs/2606.04760)]
- [2026] **Spectral Intertwining Operators** [[paper](https://arxiv.org/abs/2606.17560)]
- [2026] **Rankin--Selberg Subconvexity via Spectral Reciprocity** [[paper](https://arxiv.org/abs/2606.11451)]
- [2026] **Expander Evolution Algebras** [[paper](https://arxiv.org/abs/2605.12672)]
- [2026] **Perfect state transfer in Grover walks on dihedral Cayley graphs** [[paper](https://arxiv.org/abs/2605.02254)]
- [2026] **Almost planar finitely presented groups** [[paper](https://arxiv.org/abs/2605.03040)]
- [2026] **The (n-2,2)-Spectrum of a Graph** [[paper](https://arxiv.org/abs/2605.17501)]
- [2026] **Ordinal semigroups** [[paper](https://arxiv.org/abs/2605.28419)]
- [2026] **On quantitative aspects of trace polynomials** [[paper](https://arxiv.org/abs/2605.25265)]
- [2026] **One-level densities of large even and odd orthogonal families of automorphic L-functions** [[paper](https://arxiv.org/abs/2605.17012)]
- [2026] **On the Goldbach problem with restricted primes** [[paper](https://arxiv.org/abs/2605.19566)]
- [2026] **On the Sum of a Prime and a Number that is not Square-Free** [[paper](https://arxiv.org/abs/2605.02426)]
- [2026] **Local newforms for generic representations of p-adic {\rm SO}_{2n+1}: Reduction** [[paper](https://arxiv.org/abs/2605.15678)]
- [2026] **A Structure Sheaf for Kirch Topology** [[paper](https://arxiv.org/abs/2605.05515)]
- [2026] **Producing Quality Pseudorandomness with a Generalized Gauss Continued-Fraction Map** [[paper](https://arxiv.org/abs/2605.05378)]
- [2026] **On the structure of fine Mordell-Weil groups over a \mathbb{Z}_p-extension and its intermediate subextensions** [[paper](https://arxiv.org/abs/2605.22063)]
- [2026] **The Arithmetic Geometry of Square-Sided Heron Triangles** [[paper](https://arxiv.org/abs/2605.22458)]
- [2026] **An update on the Linnik--Goldbach problem** [[paper](https://arxiv.org/abs/2605.17825)]
- [2026] **On arc-transitive inner-automorphic Cayley graphs on dihedral groups** [[paper](https://arxiv.org/abs/2604.04366)]
- [2026] **The Cayley graph of a quandle** [[paper](https://arxiv.org/abs/2604.17011)]
- [2026] **Separation profiles of free products** [[paper](https://arxiv.org/abs/2604.24462)]
- [2026] **Normality Of Quartic Cayley Graphs On Regular p-Groups: A CFSG-Free Approach** [[paper](https://arxiv.org/abs/2604.10220)]
- [2026] **Prime Square Order Cayley Graph of Cyclic Groups of Particular Valency** [[paper](https://arxiv.org/abs/2604.23603)]
- [2026] **On (distance) Laplacian characteristic polynomials of power graphs** [[paper](https://arxiv.org/abs/2604.17607)]
- [2026] **CaTherine wheels** [[paper](https://arxiv.org/abs/2604.24619)]
- [2026] **Spectral Dehn functions and a characterisation of word-hyperbolicity** [[paper](https://arxiv.org/abs/2604.09014)]
- [2026] **Construction Methods for Space-Filling Heterogeneous Topological Interlocking Assemblies** [[paper](https://arxiv.org/abs/2604.22475)]
- [2026] **Simultaneous non-vanishing of Dirichlet L-functions** [[paper](https://arxiv.org/abs/2604.11941)]
- [2026] **Computer vision and converse theorems** [[paper](https://arxiv.org/abs/2604.15155)]
- [2026] **Settled Elements in Arboreal Galois Groups of Quadratic PCF Polynomials** [[paper](https://arxiv.org/abs/2604.04524)]
- [2026] **Rank jumps for Jacobians of Hyperelliptic curves on K3 surfaces** [[paper](https://arxiv.org/abs/2604.03639)]
- [2026] **A new equivalence to the Riemann Hypothesis by means of the Salem integral equation** [[paper](https://arxiv.org/abs/2604.15396)]
- [2026] **Isomorphism factorizations of the complete graph into Cayley graphs on CI-groups** [[paper](https://arxiv.org/abs/2603.05847)]
- [2026] **On Some Bi-Cayley Graphs over Cyclic Groups of Order p^2 q^2 and Related Extensions** [[paper](https://arxiv.org/abs/2603.09575)]
- [2026] **The Lovász conjecture holds for moderately dense Cayley graphs** [[paper](https://arxiv.org/abs/2603.08675)]
- [2026] **Cocycles and positive functionals in higher cohomology** [[paper](https://arxiv.org/abs/2603.21431)]
- [2026] **The zeta function of regular trees, their special values and functional equations** [[paper](https://arxiv.org/abs/2603.11359)]
- [2026] **Congruences and ramified primes in fields of coefficients of newforms** [[paper](https://arxiv.org/abs/2603.29468)]
- [2026] **Proportion of periodic points in reduction of polynomials** [[paper](https://arxiv.org/abs/2603.21620)]
- [2026] **Period integrals of distinguished polarised strongly tempered hyperspherical varieties** [[paper](https://arxiv.org/abs/2603.23895)]
- [2026] **Expanding groups with large diameter** [[paper](https://arxiv.org/abs/2602.13582)]
- [2026] **On Neumaier Cayley graphs** [[paper](https://arxiv.org/abs/2602.05412)]
- [2026] **Certain topological indices and spectral properties of SGB-graphs of finite cyclic groups** [[paper](https://arxiv.org/abs/2602.07587)]
- [2026] **Non-linearizable Root Group Data** [[paper](https://arxiv.org/abs/2602.21005)]
- [2026] **Mertens products in arithmetic progressions over function fields** [[paper](https://arxiv.org/abs/2602.05788)]
- [2026] **4-rank distribution of Picard groups of hyperelliptic curves via C-symmetric matrices** [[paper](https://arxiv.org/abs/2602.23707)]
- [2026] **A Functorial Refinement of the Franke Filtration and the Jacquet--Langlands Correspondence for Spaces of Automorphic Forms** [[paper](https://arxiv.org/abs/2602.23936)]
- [2026] **Courbes et fibrés vectoriels en théorie de Hodge z-adique globale** [[paper](https://arxiv.org/abs/2602.04978)]
- [2026] **The Global Jacquet-Langlands Correspondence via Tensor Products** [[paper](https://arxiv.org/abs/2602.08053)]
- [2026] **Primes represented by quadratic forms and the Weil abscissa of abelian profinite groups** [[paper](https://arxiv.org/abs/2602.09797)]
- [2026] **Invertible Calabi-Yau Orbifolds over Finite Fields II** [[paper](https://arxiv.org/abs/2602.23173)]
- [2026] **Siegel modular forms associated to Weil representations: \operatorname{SL}_2(\mathbb{R}) \&amp; \operatorname{GL}_2(\mathbb{R}) cases** [[paper](https://arxiv.org/abs/2602.10769)]
- [2026] **The Riemann Ξ-function from primitive Markovian cycles I: A canonical construction** [[paper](https://arxiv.org/abs/2602.01248)]
- [2026] **Almost all standard double covers of abelian Cayley graphs have smallest possible automorphism groups** [[paper](https://arxiv.org/abs/2601.20214)]
- [2026] **Isospectral Cayley graphs with even and odd spectrum** [[paper](https://arxiv.org/abs/2601.05510)]
- [2026] **Low-Bit Quantization of Bandlimited Graph Signals via Iterative Methods** [[paper](https://arxiv.org/abs/2601.18782)]
- [2026] **The discrete second moment of mixed derivatives of the Riemann zeta function** [[paper](https://arxiv.org/abs/2601.06292)]
- [2026] **Jacob's ladders, point of contact of the remainder in the prime-number law with the Fermat-Wiles theorem and multiplicative puzzles on some sets of integrals** [[paper](https://arxiv.org/abs/2601.13855)]
- [2026] **Periodicity of traces of Hecke operators modulo prime powers** [[paper](https://arxiv.org/abs/2601.03029)]
- [2026] **L^2-property for algebraic stacks over local non-archimedean fields** [[paper](https://arxiv.org/abs/2601.14557)]
- [2026] **Frostman dimension of Furstenberg measure for SL(2,\mathbb{R}) random matrix products** [[paper](https://arxiv.org/abs/2601.14061)]
- [2026] **Kummer-faithful fields with finitely generated absolute Galois group** [[paper](https://arxiv.org/abs/2601.10298)]
- [2026] **Regional and temporal patterns of partisan polarization during the COVID-19 pandemic in the United States and Canada.** *MED* [[paper](https://doi.org/10.1371/journal.pone.0347327)]
- [2026] **Landau-Siegel zeros of Rankin-Selberg L-functions** [[paper](https://arxiv.org/abs/2601.04189)]
- [2026] **The Riemann Ξ-Function as a Characteristic Function** *SSRN Electronic Journal* [[paper](https://doi.org/10.2139/ssrn.7277559)]

##### 2025

- [2025] **Uniform spectral gaps, non-abelian Littlewood-Offord and anti-concentration for random walks** [[paper](https://arxiv.org/abs/2512.15364)]
- [2025] **A census of Cayley graphs** [[paper](https://arxiv.org/abs/2512.05406)]
- [2025] **On Matrix Product Factorization of Cayley graphs** [[paper](https://arxiv.org/abs/2512.17110)]
- [2025] **L_1 and L_2 embeddings of the symmetric group** [[paper](https://arxiv.org/abs/2512.09226)]
- [2025] **Group Contractions via Infinite-Dimensional Lie Theory** [[paper](https://arxiv.org/abs/2512.18530)]
- [2025] **Large values of quadratic character sums revisited** [[paper](https://arxiv.org/abs/2512.24147)]
- [2025] **Representing integers as sums of mixed powers of primes** [[paper](https://arxiv.org/abs/2512.05154)]
- [2025] **A note on the Cramér-Granville model** [[paper](https://arxiv.org/abs/2512.16557)]
- [2025] **Some Series Related to Extended Riemann Hypothesis for Dedekind Zeta Functions** [[paper](https://arxiv.org/abs/2512.19761)]
- [2025] **Quadratic-Phase Dunkl Transform: Fundamental properties, translation operators, convolution product and HUP** [[paper](https://arxiv.org/abs/2512.22325)]
- [2025] **Automorphism Groups and Structure of 4-Valent Cayley Graphs on Dihedral Groups** [[paper](https://arxiv.org/abs/2511.04151)]
- [2025] **Four plane unit vectors generate a 3-colorable graph** [[paper](https://arxiv.org/abs/2511.10813)]
- [2025] **Groups that produce expander graphs** [[paper](https://arxiv.org/abs/2511.16479)]
- [2025] **A family of analogues to the Robin criterion** [[paper](https://arxiv.org/abs/2511.02106)]
- [2025] **A random polynomial with multiplicative coefficients is almost surely irreducible** [[paper](https://arxiv.org/abs/2511.04240)]
- [2025] **Modular forms for GL(r, \mathbb{F}_{q}[T]): Hecke operators and growth of expansion coefficients** [[paper](https://arxiv.org/abs/2511.01712)]
- [2025] **Hecke Eigenvalue Equidistribution over the Newspaces with Nebentypus** [[paper](https://arxiv.org/abs/2511.13966)]
- [2025] **Sparse Modular Forms, Lattices, and Codes** [[paper](https://arxiv.org/abs/2511.13816)]
- [2025] **The semi-stable Local Langlands Correspondence** [[paper](https://arxiv.org/abs/2511.14382)]
- [2025] **The continuum limit of some products of random matrices associated with renewing flows** [[paper](https://arxiv.org/abs/2511.18472)]
- [2025] **Parity and symmetry of polarized endomorphisms on cohomology** [[paper](https://arxiv.org/abs/2511.17109)]
- [2025] **Spectral and combinatorial methods for efficiently computing the rank of unambiguous finite automata** [[paper](https://arxiv.org/abs/2511.09703)]
- [2025] **Uniform mixing in continuous-time quantum walks on oriented, nonabelian Cayley graphs** [[paper](https://arxiv.org/abs/2510.08376)]
- [2025] **Geometry over finite local rings: Rigidity and Isospectrality** [[paper](https://arxiv.org/abs/2510.09324)]
- [2025] **Note on large quadratic character sums** [[paper](https://arxiv.org/abs/2510.09005)]
- [2025] **On the Least Colossally Abundant Exception to Robin's Inequality** [[paper](https://arxiv.org/abs/2510.23889)]
- [2025] **The n^{th} centered moments of a large orthogonal family of automorphic L-functions** [[paper](https://arxiv.org/abs/2510.07647)]
- [2025] **The local Langlands conjecture** [[paper](https://arxiv.org/abs/2510.00632)]
- [2025] **The List-distinguishing chromatic number of graphs containing only small complete bigraphs** [[paper](https://arxiv.org/abs/2509.11992)]
- [2025] **Wulff Isoperimetry on Cayley Graphs: Submodular BV, Tempered Følner, and Profile Ratio Bounds** [[paper](https://arxiv.org/abs/2509.22260)]
- [2025] **Rotation sets and axes in the fine curve graph for torus homeomorphisms** [[paper](https://arxiv.org/abs/2509.26156)]
- [2025] **First moment of quadratic Dirichlet L-functions with secondary terms** [[paper](https://arxiv.org/abs/2509.03197)]
- [2025] **On Hardy's Z-function and its derivatives associated with the extended Selberg class** [[paper](https://arxiv.org/abs/2509.06248)]
- [2025] **Large quadratic character sums with multiplicative coefficients** [[paper](https://arxiv.org/abs/2509.20192)]
- [2025] **Siegel Eisenstein Series with Paramodular Level** [[paper](https://arxiv.org/abs/2509.04395)]
- [2025] **Chebyshev's bias for modular forms** [[paper](https://arxiv.org/abs/2509.04187)]
- [2025] **Fundamental Fourier coefficients of Siegel modular forms of higher degrees and levels** [[paper](https://arxiv.org/abs/2509.12148)]
- [2025] **Hyperelliptic Shimura curves and L-functions of central vanishing order at least 3** [[paper](https://arxiv.org/abs/2509.06175)]
- [2025] **Generalized Sato-Tate and quadratic residues** [[paper](https://arxiv.org/abs/2509.07183)]
- [2025] **A vertical Sato-Tate law for GL(4)** [[paper](https://arxiv.org/abs/2509.13256)]
- [2025] **Jacquet-Langlands correspondence for non-Eichler orders** [[paper](https://arxiv.org/abs/2509.02985)]
- [2025] **Sparsifying Cayley Graphs on Every Group** [[paper](https://arxiv.org/abs/2508.08078)]
- [2025] **Enumeration of Cayley graphs over a nonabelian group of order 8p** [[paper](https://arxiv.org/abs/2508.17035)]
- [2025] **Integral Cayley graphs over a nonabelian group of order 8n** [[paper](https://arxiv.org/abs/2508.10653)]
- [2025] **Involutory Cayley graphs of polynomial and power series rings over the ring of integers modulo n** [[paper](https://arxiv.org/abs/2508.01202)]
- [2025] **Edge pancyclic Cayley graphs on symmetric group** [[paper](https://arxiv.org/abs/2508.12618)]
- [2025] **Pretty good state transfer in Grover walks on abelian Cayley graphs** [[paper](https://arxiv.org/abs/2508.09711)]
- [2025] **Various spectral aspects of NCCC-graphs of certain finite non-abelian groups** [[paper](https://arxiv.org/abs/2508.19616)]
- [2025] **Prime Order Element Graph of a Group -- II** [[paper](https://arxiv.org/abs/2508.06222)]
- [2025] **Detecting zeros of Dirichlet L-functions via the Riemann zeta-function** [[paper](https://arxiv.org/abs/2508.17701)]
- [2025] **Breaking Universality in the Lower Order Terms in the 1-level and 2-level Density of Holomorphic Cusp Newforms** [[paper](https://arxiv.org/abs/2508.21691)]
- [2025] **Finite Langlands correspondence** [[paper](https://arxiv.org/abs/2508.15101)]
- [2025] **Ruelle's zeta function for non-Archimedean rational maps** [[paper](https://arxiv.org/abs/2508.19374)]
- [2025] **On the density version of quadratic Waring's problem and the quadratic Waring--Goldbach problem** [[paper](https://arxiv.org/abs/2508.14939)]
- [2025] **Additive Problems with Primes from a Thin Bohr Set** [[paper](https://arxiv.org/abs/2508.12139)]
- [2025] **Tatuzawa's theorem for Rankin-Selberg L-functions** [[paper](https://arxiv.org/abs/2508.10844)]
- [2025] **On the subdirect product of graph bundles** [[paper](https://arxiv.org/abs/2507.14530)]
- [2025] **On Similarity Structure Groups and their W^* and C^*-Algebras** [[paper](https://arxiv.org/abs/2507.18821)]
- [2025] **Relatively hyperbolic groups, Grothendieck pairs, and uncountable profinite ambiguity among fibre products** [[paper](https://arxiv.org/abs/2507.15009)]
- [2025] **Selberg's Central Limit Theorem weighted by Linear Statistics of Zeta Zeros** [[paper](https://arxiv.org/abs/2507.04150)]
- [2025] **Component groups for non-supercuspidal L-parameters for p-adic SL_3** [[paper](https://arxiv.org/abs/2507.20946)]
- [2025] **Structure of (Fine) Mordell--Weil Groups** [[paper](https://arxiv.org/abs/2507.20341)]
- [2025] **Higher Siegel--Weil formula for unitary groups II: corank one terms** [[paper](https://arxiv.org/abs/2507.13473)]
- [2025] **Infinitely many pairs of non-isomorphic elliptic curves sharing the same BSD invariants** [[paper](https://arxiv.org/abs/2507.18574)]
- [2025] **What is and is not inside a Cayley graph?** [[paper](https://arxiv.org/abs/2506.14088)]
- [2025] **Deza Cayley graphs from difference sets** [[paper](https://arxiv.org/abs/2506.10440)]
- [2025] **Quasi-isometric embeddings of Ramanujan complexes** [[paper](https://arxiv.org/abs/2506.23585)]
- [2025] **Hecke polynomials for the mock modular form arising from the Delta-function** [[paper](https://arxiv.org/abs/2506.17178)]
- [2025] **Motivic action conjecture for Doi-Naganuma lifts** [[paper](https://arxiv.org/abs/2506.01699)]
- [2025] **Langlands parameters for reductive groups over finite fields** [[paper](https://arxiv.org/abs/2506.06961)]
- [2025] **What are the extended pure inner forms of a cover?** [[paper](https://arxiv.org/abs/2506.08696)]
- [2025] **Weil polynomials of abelian varieties over finite fields** [[paper](https://arxiv.org/abs/2506.13706)]
- [2025] **Infinite integrals in terms of series** [[paper](https://arxiv.org/abs/2506.19867)]
- [2025] **New zero-free regions for Dedekind zeta-functions at small and large ordinates** [[paper](https://arxiv.org/abs/2506.19319)]
- [2025] **Gauss sum with principal multiplicative character** [[paper](https://arxiv.org/abs/2505.09996)]
- [2025] **Monotonic normalized heat diffusion for distance-regular graphs with classical parameters of diameter 3** [[paper](https://arxiv.org/abs/2505.04314)]
- [2025] **Spectral selections, commutativity preservation and Coxeter-Lipschitz maps** [[paper](https://arxiv.org/abs/2505.19393)]
- [2025] **On The Relative Cohomology For Algebraic Groups** [[paper](https://arxiv.org/abs/2505.00833)]
- [2025] **Pullbacks of Saito-Kurokawa lifts of square-free levels, their non-vanishing and the L^2-mass** [[paper](https://arxiv.org/abs/2505.08660)]
- [2025] **Stable Harmonic Analysis and Stable Transfer** [[paper](https://arxiv.org/abs/2505.04910)]
- [2025] **Raabe's Formula For Gamma Function Via Riemann-Liouville Fractional Integrals And Generalized Glaisher Constants** [[paper](https://arxiv.org/abs/2505.22666)]
- [2025] **Soft bounds for local triple products and the subconvexity-QUE implication for GL_2** [[paper](https://arxiv.org/abs/2505.13256)]
- [2025] **A generalization of Ramanujan's sum over finite groups** [[paper](https://arxiv.org/abs/2504.20916)]
- [2025] **Iwasawa theory and the representations of finite groups** [[paper](https://arxiv.org/abs/2504.09236)]
- [2025] **Spectra and eigenspaces of non-normal Cayley graphs** [[paper](https://arxiv.org/abs/2504.04134)]
- [2025] **Embedding Higman-Thompson groups of unfolding trees into the Leavitt path algebras** [[paper](https://arxiv.org/abs/2504.01363)]
- [2025] **The singularity category and duality for complete intersection groups** [[paper](https://arxiv.org/abs/2504.03050)]
- [2025] **Symmetric square type L-series** [[paper](https://arxiv.org/abs/2504.00972)]
- [2025] **Arithmetic and Geometric Langlands Program** [[paper](https://arxiv.org/abs/2504.07502)]
- [2025] **Shimura varieties and gerbes** [[paper](https://arxiv.org/abs/2504.18119)]
- [2025] **Categorical local Langlands for GL_n for parameters of Langlands-Shahidi type with integral coefficients** [[paper](https://arxiv.org/abs/2504.06499)]
- [2025] **Carmichael Numbers in All Possible Arithmetic Progressions** [[paper](https://arxiv.org/abs/2504.09056)]
- [2025] **On the Isomorphism Problem of Cayley Graphs of Graph Products** [[paper](https://arxiv.org/abs/2503.15165)]
- [2025] **Edge isoperimetry of lattices** [[paper](https://arxiv.org/abs/2503.09591)]
- [2025] **The generic extension map and modular standard modules** [[paper](https://arxiv.org/abs/2503.08475)]
- [2025] **Local Langlands correspondence for covering groups of tori, and the packet-indexing groups** [[paper](https://arxiv.org/abs/2503.21375)]
- [2025] **Discrete series representations of quaternionic {\rm GL}_n(D) with symplectic periods** [[paper](https://arxiv.org/abs/2503.08955)]
- [2025] **Fractional revival on quasi-abelian Cayley graphs** [[paper](https://arxiv.org/abs/2502.14330)]
- [2025] **State transfer in Grover walks on unitary and quadratic unitary Cayley graphs over finite commutative rings** [[paper](https://arxiv.org/abs/2502.10217)]
- [2025] **Quantum fractional revival on unitary Cayley graphs over finite commutative rings** [[paper](https://arxiv.org/abs/2504.03644)]
- [2025] **A new measure of robustness of Erdős--Ko--Rado Theorems on permutation groups** [[paper](https://arxiv.org/abs/2502.14582)]
- [2025] **Free Semigroups of Large Critical Exponent** [[paper](https://arxiv.org/abs/2502.02003)]
- [2025] **On linguistic subsets of groups and monoids** [[paper](https://arxiv.org/abs/2502.14329)]
- [2025] **On an unconditional \rm GL_3 analog of Selberg's result** [[paper](https://arxiv.org/abs/2502.01288)]
- [2025] **Refinements of Artin's primitive root conjecture** [[paper](https://arxiv.org/abs/2502.19601)]
- [2025] **Drinfeld Quasi-Modular Forms of Higher Level** [[paper](https://arxiv.org/abs/2502.08263)]
- [2025] **On depth-zero characters of p-adic groups** [[paper](https://arxiv.org/abs/2502.01505)]
- [2025] **Inductive construction of supercuspidal L-packets** [[paper](https://arxiv.org/abs/2502.20611)]
- [2025] **Non-Isomorphic Abelian Varieties with the Same Arithmetic** [[paper](https://arxiv.org/abs/2502.02254)]
- [2025] **Sums of Powers of Sine and Generalized Bernoulli Polynomials** [[paper](https://arxiv.org/abs/2502.15966)]
- [2025] **Hybrid subconvexity bounds for twists of \rm GL_2\times\rm GL_2 L-functions** [[paper](https://arxiv.org/abs/2502.05611)]
- [2025] **Master List of Examples in Complexity Theory of Finite Semigroup Theory** [[paper](https://arxiv.org/abs/2501.18300)]
- [2025] **Spectral Bounds of the Generating Graph of \mathbb{Z}_n.** [[paper](https://arxiv.org/abs/2501.09771)]
- [2025] **Proportion of Nilpotent Subgroups in Finite Groups and Their Properties** [[paper](https://arxiv.org/abs/2501.11724)]
- [2025] **Two Generalizations of co-Hopfian Abelian Groups** [[paper](https://arxiv.org/abs/2501.11452)]
- [2025] **Zeros of symmetric power period polynomials** [[paper](https://arxiv.org/abs/2501.18024)]
- [2025] **Siegel modular forms associated to Weil representations** [[paper](https://arxiv.org/abs/2501.12140)]
- [2025] **Phase variation and angular momentum of the Riemann, and, Dirichlet Xi functions** [[paper](https://arxiv.org/abs/2501.10826)]

##### 2024

- [2024] **On symmetric Cayley graphs of valency thirteen** [[paper](https://arxiv.org/abs/2412.18562)]
- [2024] **Sparsest cut and eigenvalue multiplicities on low degree Abelian Cayley graphs** [[paper](https://arxiv.org/abs/2412.17115)]
- [2024] **On the clique number of random Cayley graphs and related topics** [[paper](https://arxiv.org/abs/2412.21194)]
- [2024] **Exploiting \vartheta -functions for the identification of topological materials** [[paper](https://arxiv.org/abs/2412.02347)]
- [2024] **Eventually Self-Similar Groups acting on Fractals** [[paper](https://arxiv.org/abs/2412.04138)]
- [2024] **The p-adic constant for mock modular forms associated to CM forms II** [[paper](https://arxiv.org/abs/2412.12811)]
- [2024] **On the Arakawa lifting Part I: Eichler commutation relations** [[paper](https://arxiv.org/abs/2412.11570)]
- [2024] **Residual paramodularity of a certain Calabi-Yau threefold** [[paper](https://arxiv.org/abs/2412.14289)]
- [2024] **Exotic newforms constructed from a linear combination of eta quotients** [[paper](https://arxiv.org/abs/2412.05067)]
- [2024] **Sato-Tate Groups and Distributions of y^\ell=x(x^\ell-1)** [[paper](https://arxiv.org/abs/2412.02522)]
- [2024] **Relative Langlands duality for \mathfrak{osp}(2n + 1|2n)** [[paper](https://arxiv.org/abs/2412.20544)]
- [2024] **Goldbach's Problem in short intervals for numbers with a missing digit** [[paper](https://arxiv.org/abs/2412.19975)]
- [2024] **A formula for eigenvalues of integral Cayley graphs over abelian groups** [[paper](https://arxiv.org/abs/2411.06386)]
- [2024] **On the BCI Problem** [[paper](https://arxiv.org/abs/2411.07652)]
- [2024] **Laplacian Spectrum of Super Graphs defined on Certain Non-abelian Groups** [[paper](https://arxiv.org/abs/2411.16734)]
- [2024] **Packing sets under finite groups via algebraic incidence structures** [[paper](https://arxiv.org/abs/2411.05377)]
- [2024] **On variants of Chebyshev's conjecture** [[paper](https://arxiv.org/abs/2411.07436)]
- [2024] **Pair Correlation of zeros of Dirichlet L-Functions: A possible path towards the conjectures of Chowla, Elliott-Halberstam and Montgomery** [[paper](https://arxiv.org/abs/2411.19762)]
- [2024] **Modified Dirichlet character sums over the k-free integers** [[paper](https://arxiv.org/abs/2411.08268)]
- [2024] **Maximal order for divisor functions and zeros of the Riemann zeta-function** [[paper](https://arxiv.org/abs/2411.19259)]
- [2024] **Sums of Hurwitz Class Numbers and newform of weight 2 and level 49** [[paper](https://arxiv.org/abs/2411.16894)]
- [2024] **Formes modulaires modulo 2 : L'ordre de nilpotence des opérateurs de Hecke (version développée)** [[paper](https://arxiv.org/abs/2411.12754)]
- [2024] **Non-repetition of second coefficients of Hecke polynomials** [[paper](https://arxiv.org/abs/2411.18419)]
- [2024] **Hecke algebras and local Langlands correspondence for non-singular depth-zero representations** [[paper](https://arxiv.org/abs/2411.19846)]
- [2024] **Anisotropic spaces for the bilateral shift** [[paper](https://arxiv.org/abs/2411.15050)]
- [2024] **Heights and morphisms in number fields** [[paper](https://arxiv.org/abs/2411.13522)]
- [2024] **S-invariant and S-multinvariant functions and some symmetry groups of algebraic sieves** [[paper](https://arxiv.org/abs/2411.17168)]
- [2024] **Zero-density estimates and the optimality of the error term in the prime number theorem** [[paper](https://arxiv.org/abs/2411.13791)]
- [2024] **Conditional Non-Soficity of p-adic Deligne Extensions: on a Theorem of Gohla and Thom** [[paper](https://arxiv.org/abs/2410.02913)]
- [2024] **On the distribution of \log |L(σ, χ)| and \log L(σ, χ_D) in the modulus aspect** [[paper](https://arxiv.org/abs/2410.20341)]
- [2024] **Murmurations and Sato-Tate Conjectures for High Rank Zetas of Elliptic Curves** [[paper](https://arxiv.org/abs/2410.04952)]
- [2024] **Arithmetic constants for symplectic variances of the divisor function** [[paper](https://arxiv.org/abs/2410.17939)]
- [2024] **A remark on the Langlands correspondence for tori** [[paper](https://arxiv.org/abs/2410.06346)]
- [2024] **The distribution of the maximum of cubic character sums** [[paper](https://arxiv.org/abs/2410.22305)]
- [2024] **Grüss inequalities for the β-integral associated with the general quantum operator** [[paper](https://arxiv.org/abs/2410.12838)]
- [2024] **On the gcd graphs over polynomial rings** [[paper](https://arxiv.org/abs/2409.01929)]
- [2024] **A complete classification of perfect unitary Cayley graphs** [[paper](https://arxiv.org/abs/2409.01922)]
- [2024] **On the fractional matching extendability of Cayley graphs of Abelian groups** [[paper](https://arxiv.org/abs/2409.01729)]
- [2024] **Isomorphisms of bi-Cayley graphs on generalized quaternion groups** [[paper](https://arxiv.org/abs/2409.11918)]
- [2024] **M-functions and screw functions originating from Goldbach's problem and zeros of the Riemann zeta function** [[paper](https://arxiv.org/abs/2409.00888)]
- [2024] **The stack of spherical Langlands parameters** [[paper](https://arxiv.org/abs/2409.09522)]
- [2024] **Local converse theorems and Langlands parameters** [[paper](https://arxiv.org/abs/2409.20240)]
- [2024] **Local theta correspondences and Langlands parameters for rigid inner twists** [[paper](https://arxiv.org/abs/2409.00805)]
- [2024] **Shadow line distributions** [[paper](https://arxiv.org/abs/2409.00891)]
- [2024] **On pseudo-nullity of fine Mordell-Weil group** [[paper](https://arxiv.org/abs/2409.03546)]
- [2024] **Goldbach Representations with several primes** [[paper](https://arxiv.org/abs/2409.13368)]
- [2024] **Periodicity and perfect state transfer of Grover walks on quadratic unitary Cayley graphs** [[paper](https://arxiv.org/abs/2408.08715)]
- [2024] **Fat minors in finitely presented groups** [[paper](https://arxiv.org/abs/2408.10748)]
- [2024] **Boundary representations of hyperbolic groups: the log-Sobolev case** [[paper](https://arxiv.org/abs/2408.06446)]
- [2024] **Topological and Dynamic Properties of the Sublinearly Morse Boundary and the Quasi-Redirecting Boundary** [[paper](https://arxiv.org/abs/2408.10105)]
- [2024] **A non-ordinary (prime) note** [[paper](https://arxiv.org/abs/2409.00384)]
- [2024] **Zeros of even and odd period polynomials** [[paper](https://arxiv.org/abs/2408.05670)]
- [2024] **Mordell--Weil groups over large algebraic extensions of fields of characteristic zero** [[paper](https://arxiv.org/abs/2408.03495)]
- [2024] **Zeros of L-functions and large partial sums of Dirichlet coefficients** [[paper](https://arxiv.org/abs/2408.03938)]
- [2024] **Moments of random multiplicative functions over function fields** [[paper](https://arxiv.org/abs/2408.08309)]
- [2024] **Hybrid subconvexity for Maass form symmetric-square L-functions** [[paper](https://arxiv.org/abs/2408.06735)]
- [2024] **Finding automorphism groups of double coset graphs and Cayley graphs are equivalent** [[paper](https://arxiv.org/abs/2407.02316)]
- [2024] **Fourier analysis on distance-regular Cayley graphs over abelian groups** [[paper](https://arxiv.org/abs/2407.08763)]
- [2024] **One more proof about the spectrum of Transposition graph** [[paper](https://arxiv.org/abs/2407.14948)]
- [2024] **Uniform waist inequalities in codimension two for manifolds with Kazhdan fundamental group** [[paper](https://arxiv.org/abs/2407.19783)]
- [2024] **Things we can learn by considering random locally symmetric manifolds** [[paper](https://arxiv.org/abs/2407.21208)]
- [2024] **On the average size of the eigenvalues of the Hecke operators** [[paper](https://arxiv.org/abs/2407.19076)]
- [2024] **Level one automorphic representations of an anisotropic exceptional group over \mathbb{Q} of type F_{4}** [[paper](https://arxiv.org/abs/2407.05859)]
- [2024] **Average orders of Goldbach Estimates in Arithmetic Progressions** [[paper](https://arxiv.org/abs/2407.18266)]
- [2024] **About zero counting of Riemann Z function** [[paper](https://arxiv.org/abs/2407.07910)]
- [2024] **Higher Dimensional Fourier Quasicrystals from Lee-Yang Varieties** [[paper](https://arxiv.org/abs/2407.11184)]
- [2024] **Spectral properties of Cayley graphs over finite commutative rings** [[paper](https://arxiv.org/abs/2406.16080)]
- [2024] **The Lamplighter groups have infinite weak cop number** [[paper](https://arxiv.org/abs/2406.11996)]
- [2024] **Joint distribution of Hecke eigenforms** [[paper](https://arxiv.org/abs/2406.03073)]
- [2024] **Spectral Flow for the Riemann zeros** [[paper](https://arxiv.org/abs/2406.01828)]
- [2024] **Equidistribution of Kloosterman sums over function fields** [[paper](https://arxiv.org/abs/2406.10106)]
- [2024] **Local Langlands in families: The banal case** [[paper](https://arxiv.org/abs/2406.09283)]
- [2024] **\infty-Categorical Generalized Langlands Correspondence III: \infty-Stackification** [[paper](https://arxiv.org/abs/2406.16757)]
- [2024] **Oriented or signed Cayley graphs with all eigenvalues integer multiples of \sqrtΔ** [[paper](https://arxiv.org/abs/2405.14140)]
- [2024] **Grover walks on unitary Cayley graphs and integral regular graphs** [[paper](https://arxiv.org/abs/2405.01020)]
- [2024] **Generalized Cayley graphs of complete groups** [[paper](https://arxiv.org/abs/2405.00297)]
- [2024] **On the Iwasawa theory of Cayley graphs** [[paper](https://arxiv.org/abs/2405.04361)]
- [2024] **Coloring minimal Cayley graphs** [[paper](https://arxiv.org/abs/2405.19543)]
- [2024] **Derandomized Non-Abelian Homomorphism Testing in Low Soundness Regime** [[paper](https://arxiv.org/abs/2405.18998)]
- [2024] **Projective connections and extremal domains for analytic content** [[paper](https://arxiv.org/abs/2405.06171)]
- [2024] **Mass equidistribution for Poincaré series of large index** [[paper](https://arxiv.org/abs/2405.01414)]
- [2024] **Some Singular Examples of Relative Langlands Duality** [[paper](https://arxiv.org/abs/2405.18212)]
- [2024] **An Arithmetic Invariant of the Jacquet-Langlands correspondence** [[paper](https://arxiv.org/abs/2405.18372)]
- [2024] **On certain Gram matrices and their associated series** [[paper](https://arxiv.org/abs/2405.06349)]
- [2024] **Tate-Shafarevich results for quartic twists in characteristic 2** [[paper](https://arxiv.org/abs/2405.13408)]
- [2024] **Co-rank 1 Arithmetic Siegel--Weil III: Geometric local-to-global** [[paper](https://arxiv.org/abs/2405.01428)]
- [2024] **Sesquilinear pairings on elliptic curves** [[paper](https://arxiv.org/abs/2405.14167)]
- [2024] **On the invariants of L-functions of degree 2, I: twisted degree and internal shift** [[paper](https://arxiv.org/abs/2405.03186)]
- [2024] **Formulas of special polynomials involving Bernoulli polynomials derived from matrix equations and Laplace transform** [[paper](https://arxiv.org/abs/2406.08503)]
- [2024] **The A-philosophy for the Hardy Z-Function** [[paper](https://arxiv.org/abs/2406.06548)]
- [2024] **Cayley graphs and G-graphs of Gyro-groups** [[paper](https://arxiv.org/abs/2404.19741)]
- [2024] **Well-covered Unit Graphs of Finite Rings** [[paper](https://arxiv.org/abs/2404.07189)]
- [2024] **Property (NL) in Coexeter groups** [[paper](https://arxiv.org/abs/2404.15459)]
- [2024] **Some conjectures around magnetic modular forms** [[paper](https://arxiv.org/abs/2404.04085)]
- [2024] **A Shintani lift for rigid cocycles** [[paper](https://arxiv.org/abs/2404.12936)]
- [2024] **On converse theorems for Hilbert modular forms assuming unramified twists** [[paper](https://arxiv.org/abs/2404.01449)]
- [2024] **Generic representations, open parameters and ABV-packets for p-adic groups** [[paper](https://arxiv.org/abs/2404.07463)]
- [2024] **Odometers in non-compact spaces** [[paper](https://arxiv.org/abs/2404.03768)]
- [2024] **Local factors and Cuntz-Pimsner algebras** [[paper](https://arxiv.org/abs/2404.12179)]
- [2024] **A question of Erdös on 3-powerful numbers and an elliptic curve analogue of the Ankeny-Artin-Chowla conjecture** [[paper](https://arxiv.org/abs/2404.03970)]
- [2024] **A mean value inequalities for the polygamma and zeta functions** [[paper](https://arxiv.org/abs/2405.05271)]
- [2024] **On certain properties of the p-unitary Cayley graph over a finite ring** [[paper](https://arxiv.org/abs/2403.05635)]
- [2024] **Common neighborhood Laplacian and signless Laplacian spectra and energies of commuting graphs** [[paper](https://arxiv.org/abs/2403.01082)]
- [2024] **Common neighborhood (signless) Laplacian spectrum and energy of CCC-graph** [[paper](https://arxiv.org/abs/2403.02703)]
- [2024] **Homeomorphism groups of telescoping 2-manifolds are strongly distorted** [[paper](https://arxiv.org/abs/2403.03887)]
- [2024] **Homogeneous quandles with abelian inner automorphism groups and vertex-transitive graphs** [[paper](https://arxiv.org/abs/2403.06209)]
- [2024] **Size of discriminants of periodic geodesics of the modular surface** [[paper](https://arxiv.org/abs/2403.13383)]
- [2024] **Moduli stacks of Galois representations and the p-adic local Langlands correspondence for GL_2(\mathbb{Q}_p)** [[paper](https://arxiv.org/abs/2403.19565)]
- [2024] **AdAM: Adaptive Fault-Tolerant Approximate Multiplier for Edge DNN Accelerators** [[paper](https://arxiv.org/abs/2403.02936)]
- [2024] **List Coloring of some Cayley graphs using Kernel perfections** [[paper](https://arxiv.org/abs/2402.16047)]
- [2024] **Phase transitions in isoperimetric problems on the integers** [[paper](https://arxiv.org/abs/2402.14087)]
- [2024] **Spectra of infinite Cayley graphs, examples with pure band spectra** [[paper](https://arxiv.org/abs/2402.06279)]
- [2024] **On ordered groups of regular growth rates** [[paper](https://arxiv.org/abs/2402.00549)]
- [2024] **Polymatroids are to finite groups as matroids are to finite fields** [[paper](https://arxiv.org/abs/2402.17582)]
- [2024] **Relatively endotrivial complexes** [[paper](https://arxiv.org/abs/2402.08042)]
- [2024] **Explicit reciprocity laws for diagonal classes: higher level cases** [[paper](https://arxiv.org/abs/2402.13648)]
- [2024] **A Quadratic Curve Analogue of the Taniyama-Shimura Conjecture** [[paper](https://arxiv.org/abs/2402.05599)]
- [2024] **Integral Cayley graphs over a group of order 6n** [[paper](https://arxiv.org/abs/2401.07069)]
- [2024] **Generalized Cayley graphs and perfect code** [[paper](https://arxiv.org/abs/2401.11180)]
- [2024] **On prime Cayley graphs** [[paper](https://arxiv.org/abs/2401.06062)]
- [2024] **Automorphism groups of Cayley graphs generated by general transposition sets** [[paper](https://arxiv.org/abs/2401.17860)]
- [2024] **On 2-integral Cayley graphs** [[paper](https://arxiv.org/abs/2401.15306)]
- [2024] **Determination of a pair of newforms from the product of their twisted central values** [[paper](https://arxiv.org/abs/2401.12891)]
- [2024] **On Signs of Hecke eigenvalues of Ikeda lifts** [[paper](https://arxiv.org/abs/2401.08855)]
- [2024] **Global and local minima of α-Brjuno functions** [[paper](https://arxiv.org/abs/2401.17679)]
- [2024] **On a conjecture of Mazur predicting the growth of Mordell--Weil ranks in \mathbb{Z}_p-extensions** [[paper](https://arxiv.org/abs/2401.07792)]

##### 2023

- [2023] **Ramanujan Bigraphs** [[paper](https://arxiv.org/abs/2312.06507)]
- [2023] **Pretty good fractional revival on Cayley graphs over dicyclic groups** [[paper](https://arxiv.org/abs/2312.10985)]
- [2023] **On the spectral gap of Cayley graphs** [[paper](https://arxiv.org/abs/2312.06604)]
- [2023] **Spectrum of conjugacy and order super commuting graphs of some finite groups** [[paper](https://arxiv.org/abs/2312.08930)]
- [2023] **The super approximation property of SL_2(\mathbb{Z}/q\mathbb{Z}) \times SL_2(\mathbb{Z}/q\mathbb{Z}) \times SL_2(\mathbb{Z}/q\mathbb{Z})** [[paper](https://arxiv.org/abs/2402.08612)]
- [2023] **Effective generation of Hecke algebras and explicit estimates of Sato--Tate type** [[paper](https://arxiv.org/abs/2312.03021)]
- [2023] **Diophantine approximation with prime denominator in quadratic number fields under GRH** [[paper](https://arxiv.org/abs/2312.02628)]
- [2023] **Generalized triple product p-adic L-functions and rational points on elliptic curves** [[paper](https://arxiv.org/abs/2312.06565)]
- [2023] **On p-divisibility of Fourier coefficients of Hermitian modular forms** [[paper](https://arxiv.org/abs/2312.06318)]
- [2023] **Modular forms for the Weil representation induced from isotropic subgroups** [[paper](https://arxiv.org/abs/2312.01443)]
- [2023] **Hausdorff dimension and exact approximation order in \mathbb{R}^n** [[paper](https://arxiv.org/abs/2312.10255)]
- [2023] **On the multiplicity formula for discrete automorphic representations of disconnected tori** [[paper](https://arxiv.org/abs/2312.16389)]
- [2023] **Artin L-functions and noncommutative tori** [[paper](https://arxiv.org/abs/2312.17638)]
- [2023] **Equivariant divergence formula for chaotic flows** [[paper](https://arxiv.org/abs/2312.12171)]
- [2023] **Indecomposable continua and the Julia sets of polynomial-like mappings** [[paper](https://arxiv.org/abs/2312.17447)]
- [2023] **Student as an Inherent Denoiser of Noisy Teacher** [[paper](https://arxiv.org/abs/2312.10185)]
- [2023] **Drinfeld Module and Weil pairing over Dedekind domain of class number two** [[paper](https://arxiv.org/abs/2312.16919)]
- [2023] **Small generators of abelian number fields** [[paper](https://arxiv.org/abs/2312.02044)]
- [2023] **On some algebraic and geometric extensions of Goldbach's conjecture** [[paper](https://arxiv.org/abs/2312.16524)]
- [2023] **A Goldbach theorem for Laurent polynomials with positive integer coefficients** [[paper](https://arxiv.org/abs/2312.01189)]
- [2023] **An extended version of the _{r+1}R_{s,k}(B,C,z) matrix function** [[paper](https://arxiv.org/abs/2403.09664)]
- [2023] **Well-covered Unitary Cayley Graphs of Matrix Rings over Finite Fields and Applications** [[paper](https://arxiv.org/abs/2311.15255)]
- [2023] **Distance-regular Cayley graphs over (pseudo-) semi-dihedral groups** [[paper](https://arxiv.org/abs/2311.08128)]
- [2023] **Counting tilings of the n \times m grid, cylinder, and torus** [[paper](https://arxiv.org/abs/2311.13072)]
- [2023] **Word Measures on Wreath Products II** [[paper](https://arxiv.org/abs/2311.11316)]
- [2023] **Thermodynamic formalism for correspondences** [[paper](https://arxiv.org/abs/2311.09397)]
- [2023] **Local newforms and spherical characters for unitary groups** [[paper](https://arxiv.org/abs/2311.17700)]
- [2023] **Unit Reducible Cyclotomic Fields** [[paper](https://arxiv.org/abs/2311.16870)]
- [2023] **Fonctions d'une variable p-adique et représentations de {\rm GL}_2(Q_p)** [[paper](https://arxiv.org/abs/2311.15457)]
- [2023] **Rationality of \mbox{dlog} \mathbb{A}^1-zeta functions** [[paper](https://arxiv.org/abs/2311.06793)]
- [2023] **A visual perspective on the Birch and Swinnerton-Dyer conjecture through a family of approximations of L-functions** [[paper](https://arxiv.org/abs/2311.07641)]
- [2023] **Intersection formulas on moduli spaces of unitary shtukas** [[paper](https://arxiv.org/abs/2311.08161)]
- [2023] **Hamiltonian Cycles for Finite Weyl Groupoids** [[paper](https://arxiv.org/abs/2310.12543)]
- [2023] **Some properties of generalized Cayley graphs** [[paper](https://arxiv.org/abs/2310.19370)]
- [2023] **A Note on Eigenvalues of Cayley Graphs** [[paper](https://arxiv.org/abs/2310.09058)]
- [2023] **Bakry-Émery and Ollivier Ricci Curvature of Cayley Graphs** [[paper](https://arxiv.org/abs/2310.15953)]
- [2023] **On the average hitting times of weighted Cayley graphs** [[paper](https://arxiv.org/abs/2310.16571)]
- [2023] **A Contracting Fractal Group, Schreier Graphs and The Spectra** [[paper](https://arxiv.org/abs/2310.14145)]
- [2023] **Restrictions on local embeddability into finite semigroups** [[paper](https://arxiv.org/abs/2310.04235)]
- [2023] **Indeed, the Monster has no almost simple maximal subgroup with socle PSL_2(16)** [[paper](https://arxiv.org/abs/2310.03317)]
- [2023] **Extensions realizing affine datum : the Wells derivation** [[paper](https://arxiv.org/abs/2310.00921)]
- [2023] **Further results on generalized cellular automata** [[paper](https://arxiv.org/abs/2310.04926)]
- [2023] **Ordinality and Riemann Hypothesis I** [[paper](https://arxiv.org/abs/2311.00003)]
- [2023] **Smooth linear eigenvalue statistics on random covers of compact hyperbolic surfaces -- A central limit theorem and almost sure RMT statistics** [[paper](https://arxiv.org/abs/2310.18663)]
- [2023] **A central limit theorem for Hilbert modular forms** [[paper](https://arxiv.org/abs/2310.19154)]
- [2023] **Homological stability for generalized Hurwitz spaces and Selmer groups in quadratic twist families over function fields** [[paper](https://arxiv.org/abs/2310.16286)]
- [2023] **Simple cuspidal representations of symplectic groups: Langlands parameter** [[paper](https://arxiv.org/abs/2310.20455)]
- [2023] **Quantitative characterization of finite simple groups: a complement** [[paper](https://arxiv.org/abs/2309.06362)]
- [2023] **Ratios conjecture for primitive quadratic Hecke L-functions** [[paper](https://arxiv.org/abs/2309.13811)]
- [2023] **On the Connection Between Riemann Hypothesis and a Special Class of Neural Networks** [[paper](https://arxiv.org/abs/2309.09171)]
- [2023] **Averages over the Gaussian Primes: Goldbach's Conjecture and Improving Estimates** [[paper](https://arxiv.org/abs/2309.14249)]
- [2023] **Effectiveness of Walker's Cancellation Theorem** [[paper](https://arxiv.org/abs/2309.01844)]
- [2023] **The Generalized Riemann Hypothesis from zeros of a single L-function** [[paper](https://arxiv.org/abs/2309.03817)]
- [2023] **Heisenberg varieties and the existence of de Rham lifts** [[paper](https://arxiv.org/abs/2309.00761)]
- [2023] **Neumaier Cayley graphs** [[paper](https://arxiv.org/abs/2308.11572)]
- [2023] **Fractional revival on semi-Cayley graphs over abelian groups** [[paper](https://arxiv.org/abs/2308.02371)]
- [2023] **Distance-regular Cayley graphs over \mathbb{Z}_{p^s}\oplus\mathbb{Z}_{p}** [[paper](https://arxiv.org/abs/2308.14368)]
- [2023] **Laplacian Eigen values of character degree graphs of solvable groups** [[paper](https://arxiv.org/abs/2308.03719)]
- [2023] **Strong almost finiteness** [[paper](https://arxiv.org/abs/2308.14554)]
- [2023] **Strongly convergent unitary representations of right-angled Artin groups** [[paper](https://arxiv.org/abs/2308.00863)]
- [2023] **Hecke eigenspaces for the projective line** [[paper](https://arxiv.org/abs/2308.08720)]
- [2023] **Sato-Tate Type Distributions for Matrix Points on Elliptic Curves and Some K3 Surfaces** [[paper](https://arxiv.org/abs/2308.02683)]
- [2023] **A density version of Waring-Goldbach problem** [[paper](https://arxiv.org/abs/2308.06286)]
- [2023] **Generating Graphs of Finite Dihedral Groups** [[paper](https://arxiv.org/abs/2307.11802)]
- [2023] **Finite Stature in Artin groups** [[paper](https://arxiv.org/abs/2307.15209)]
- [2023] **A probabilistic interpretation for central zeros of L-functions in the Selberg class** [[paper](https://arxiv.org/abs/2307.02027)]
- [2023] **The eighth moment of Dirichlet L-functions II** [[paper](https://arxiv.org/abs/2307.13194)]
- [2023] **Eigenspaces of Newforms with Nontrivial Character** [[paper](https://arxiv.org/abs/2307.07804)]
- [2023] **The p-adic constant for mock modular forms associated to CM forms** [[paper](https://arxiv.org/abs/2307.01450)]
- [2023] **Equidistribution of high traces of random matrices over finite fields and cancellation in character sums of high conductor** [[paper](https://arxiv.org/abs/2307.01344)]
- [2023] **Geodesic flows and slow downs of continued fraction maps** [[paper](https://arxiv.org/abs/2307.11700)]
- [2023] **Algebraic structure and characteristic ideals of fine Mordell--Weil groups and plus/minus Mordell--Weil groups** [[paper](https://arxiv.org/abs/2307.12054)]
- [2023] **Extended Weil representations: the real field case** [[paper](https://arxiv.org/abs/2307.01581)]
- [2023] **A Cheeger inequality for the lower spectral gap** [[paper](https://arxiv.org/abs/2306.04436)]
- [2023] **Optimization in graphical small cancellation theory** [[paper](https://arxiv.org/abs/2306.03474)]
- [2023] **On a smoothed average of the number of Goldbach representations** [[paper](https://arxiv.org/abs/2306.04807)]
- [2023] **Central L-values of newforms and local polynomials** [[paper](https://arxiv.org/abs/2306.15519)]
- [2023] **Discontinuities cause essential spectrum on surfaces** [[paper](https://arxiv.org/abs/2306.00484)]
- [2023] **Some discussions on the Goldbach conjecture** [[paper](https://arxiv.org/abs/2306.17769)]
- [2023] **The Average Number of Goldbach Representations and Zero-Free Regions of the Riemann Zeta-Function** [[paper](https://arxiv.org/abs/2306.09102)]
- [2023] **Colorings of some Cayley graphs** [[paper](https://arxiv.org/abs/2305.11623)]
- [2023] **Binomial Cayley Graphs and Applications to Dynamics on Finite Spaces** [[paper](https://arxiv.org/abs/2305.11249)]
- [2023] **Explicit spectral gap for Hecke congruence covers of arithmetic Schottky surfaces** [[paper](https://arxiv.org/abs/2305.02228)]
- [2023] **Arithmetic Fundamental Lemma for the spherical Hecke algebra** [[paper](https://arxiv.org/abs/2305.14465)]
- [2023] **Infinite volume and atoms at the bottom of the spectrum** [[paper](https://arxiv.org/abs/2304.14565)]
- [2023] **Ratios conjecture for quadratic twist of modular L-functions** [[paper](https://arxiv.org/abs/2304.14600)]
- [2023] **Equilibrium States for Non-Uniformly Expanding Skew Products** [[paper](https://arxiv.org/abs/2304.02529)]
- [2023] **Motivating Motives** [[paper](https://arxiv.org/abs/2304.08737)]
- [2023] **Frames for signal processing on Cayley graphs** [[paper](https://arxiv.org/abs/2303.02812)]
- [2023] **Signless Laplacian energies of non-commuting graphs of finite groups and related results** [[paper](https://arxiv.org/abs/2303.17795)]
- [2023] **Actions of higher rank groups on uniformly convex Banach spaces** [[paper](https://arxiv.org/abs/2303.01405)]
- [2023] **The Generalized Riemann Hypothesis from zeros of the zeta function** [[paper](https://arxiv.org/abs/2303.09510)]
- [2023] **Negative first moment of quadratic twists of L-functions** [[paper](https://arxiv.org/abs/2303.05055)]
- [2023] **Hecke Actions on Loops and Periods of Iterated Shimura Integrals** [[paper](https://arxiv.org/abs/2303.00143)]
- [2023] **Constructing Galois representations with prescribed Iwasawa λ-invariant** [[paper](https://arxiv.org/abs/2303.06706)]
- [2023] **Every real-rooted exponential polynomial is the restriction of a Lee-Yang polynomial** [[paper](https://arxiv.org/abs/2303.03201)]
- [2023] **Hecke operators for higher rank Drinfeld modular forms** [[paper](https://arxiv.org/abs/2302.06316)]
- [2023] **Spectral decomposition of genuine cusp forms over global function fields** [[paper](https://arxiv.org/abs/2302.13023)]
- [2023] **Prime numbers as a uniqueness set of the parallelogram equation via the Goldbach's conjecture** [[paper](https://arxiv.org/abs/2302.04037)]
- [2023] **Double Sum involving Product of Appell-Type Bernoulli and Euler Polynomials** [[paper](https://arxiv.org/abs/2302.14508)]
- [2023] **Jacob's ladders and vector operator producing new generations of L_2-orthogonal systems connected with the Riemann's ζ(\frac 12+it) function** [[paper](https://arxiv.org/abs/2302.07508)]
- [2023] **Self-complementary distance-regular Cayley graphs over abelian groups** [[paper](https://arxiv.org/abs/2301.06569)]
- [2023] **The Critical Groups of Adinkras up to 2-Rank of Cayley Graphs** [[paper](https://arxiv.org/abs/2301.02517)]
- [2023] **On order units in the augmentation ideal** [[paper](https://arxiv.org/abs/2301.07590)]
- [2023] **Li coefficients as norms of functions in a model space** [[paper](https://arxiv.org/abs/2301.05779)]
- [2023] **The Harris-Venkatesh conjecture for derived Hecke operators III: local constants** [[paper](https://arxiv.org/abs/2301.00612)]
- [2023] **The Harris-Venkatesh conjecture for derived Hecke operators I: imaginary dihedral forms** [[paper](https://arxiv.org/abs/2301.00570)]
- [2023] **Pseudorandomness of Sato-Tate Distributions for Elliptic Curves** [[paper](https://arxiv.org/abs/2301.12823)]
- [2023] **Specialization of Mordell-Weil ranks of abelian schemes over surfaces to curves** [[paper](https://arxiv.org/abs/2301.12816)]
- [2023] **Extended Watson-Harkins Sum** [[paper](https://arxiv.org/abs/2302.01907)]
- [2023] **Streaming Zero-Knowledge Proofs** [[paper](https://arxiv.org/abs/2301.02161)]

##### 2022

- [2022] **Asymptotic enumeration of graphical regular representations** [[paper](https://arxiv.org/abs/2212.01875)]
- [2022] **Smooth integers and de Bruijn's approximation Λ** [[paper](https://arxiv.org/abs/2212.01949)]
- [2022] **A group from a map and orbit equivalence** [[paper](https://arxiv.org/abs/2211.00637)]
- [2022] **Mean values of the logarithmic derivative of the Riemann zeta-function near the critical line** [[paper](https://arxiv.org/abs/2211.08571)]
- [2022] **On the number variance of zeta zeros and a conjecture of Berry** [[paper](https://arxiv.org/abs/2211.14918)]
- [2022] **Smooth integers and the Dickman ρ function** [[paper](https://arxiv.org/abs/2211.08973)]
- [2022] **A conditional result on exponential sums over primes in short intervals** [[paper](https://arxiv.org/abs/2211.15546)]
- [2022] **Riesz type criteria for L-functions in the Selberg class** [[paper](https://arxiv.org/abs/2211.02954)]
- [2022] **The first negative Fourier coefficient of an Eisenstein series newform** [[paper](https://arxiv.org/abs/2211.12985)]
- [2022] **An Exploration of Degeneracy in Abelian Varieties of Fermat Type** [[paper](https://arxiv.org/abs/2211.03909)]
- [2022] **A problem of Erdős-Graham-Granville-Selfridge on integral points on hyperelliptic curves** [[paper](https://arxiv.org/abs/2211.12467)]
- [2022] **On the zeroes of hypergraph independence polynomials** [[paper](https://arxiv.org/abs/2211.00464)]
- [2022] **Lower Bounds for Rankin-Selberg L-functions on the Edge of the Critical Strip** [[paper](https://arxiv.org/abs/2211.05747)]
- [2022] **Symmetric property and edge-disjoint Hamiltonian cycles of the spined cube** [[paper](https://arxiv.org/abs/2210.16603)]
- [2022] **Ollivier Ricci curvature of Cayley graphs for dihedral groups, generalized quaternion groups, and cyclic groups** [[paper](https://arxiv.org/abs/2210.00860)]
- [2022] **Tame automorphism groups of polynomial rings with property (T) and infinitely many alternating group quotients** [[paper](https://arxiv.org/abs/2210.00730)]
- [2022] **Limit trees for free group automorphisms: universality** [[paper](https://arxiv.org/abs/2210.01275)]
- [2022] **Ratios conjecture for quadratic Hecke L-functions in the Gaussian field** [[paper](https://arxiv.org/abs/2210.08840)]
- [2022] **Expected Mordell-Weil rank heuristics through Sato-Tate, Birch and Swinnerton-Dyer conjectures** [[paper](https://arxiv.org/abs/2210.12028)]
- [2022] **On the local Langlands conjectures for disconnected groups** [[paper](https://arxiv.org/abs/2210.02519)]
- [2022] **On the complex zeros of the Riemann Zeta-function** [[paper](https://arxiv.org/abs/2210.03121)]
- [2022] **Almost Ramanujan Expanders from Arbitrary Expanders via Operator Amplification** [[paper](https://arxiv.org/abs/2209.07024)]
- [2022] **On directed strongly regular Cayley graphs over non-abelian groups with an abelian subgroup of index 2** [[paper](https://arxiv.org/abs/2209.10352)]
- [2022] **An Update On The L^p-L^q Norms of Spectral Multipliers on Unimodular Lie Groups** [[paper](https://arxiv.org/abs/2209.12532)]
- [2022] **The Local Langlands Conjecture for G_2** [[paper](https://arxiv.org/abs/2209.07346)]
- [2022] **Matching of orbits of certain N-expansions with a finite set of digits** [[paper](https://arxiv.org/abs/2209.08882)]
- [2022] **Variations on theorems of Mertens** [[paper](https://arxiv.org/abs/2209.07707)]
- [2022] **Iterating sum of power divisor function and New equivalence to the Riemann hypothesis** [[paper](https://arxiv.org/abs/2209.13010)]
- [2022] **Fractional revival on abelian Cayley graphs** [[paper](https://arxiv.org/abs/2208.05107)]
- [2022] **Functional graphs of families of quadratic polynomials** [[paper](https://arxiv.org/abs/2208.01885)]
- [2022] **Gelfand-Kirillov dimension of representations of GL_n over a non-archimedean local field** [[paper](https://arxiv.org/abs/2208.05139)]
- [2022] **Spectral gap for the cohomological Laplacian of \operatorname{SL}_3(\mathbb{Z})** [[paper](https://arxiv.org/abs/2207.02783)]
- [2022] **Banach property (T) for \rm SL_n (\mathbb{Z}) and its applications** [[paper](https://arxiv.org/abs/2207.04407)]
- [2022] **634 vertex-transitive and more than 10^{103} non-vertex-transitive 27-vertex triangulations of manifolds like the octonionic projective plane** [[paper](https://arxiv.org/abs/2207.08507)]
- [2022] **Compatibility of the Fargues--Scholze correspondence for unitary groups** [[paper](https://arxiv.org/abs/2207.13193)]
- [2022] **Fractional revival on Cayley graphs over abelian groups** [[paper](https://arxiv.org/abs/2206.12584)]
- [2022] **Coarse embeddings at infinity and generalized expanders at infinity** [[paper](https://arxiv.org/abs/2206.11151)]
- [2022] **One-level density of quadratic twists of L-functions** [[paper](https://arxiv.org/abs/2206.02302)]
- [2022] **Rational points on quadratic elliptic surfaces** [[paper](https://arxiv.org/abs/2207.00114)]
- [2022] **The relative class number one problem for function fields, II** [[paper](https://arxiv.org/abs/2206.02084)]
- [2022] **Cayley graphs on non-isomorphic groups** [[paper](https://arxiv.org/abs/2205.01299)]
- [2022] **Non-vanishing of quadratic twists of modular L-functions of prime-related moduli** [[paper](https://arxiv.org/abs/2205.01824)]
- [2022] **Towards the Generalized Riemann Hypothesis using only zeros of the Riemann zeta function** [[paper](https://arxiv.org/abs/2205.04576)]
- [2022] **On the value-distribution of the logarithms of symmetric square L-functions in the level aspect** [[paper](https://arxiv.org/abs/2205.00601)]
- [2022] **Unicity of types and local Jacquet--Langlands correspondence** [[paper](https://arxiv.org/abs/2205.05252)]
- [2022] **Topological Necessary Conditions for Control Dynamics** [[paper](https://arxiv.org/abs/2205.05893)]
- [2022] **Almost all of the nontrivial zeros of the Riemann zeta-function are on the critical line** [[paper](https://arxiv.org/abs/2205.09042)]
- [2022] **Reconfiguration of Digraph Homomorphisms** [[paper](https://arxiv.org/abs/2205.09210)]
- [2022] **On state transfer in Cayley graphs for abelian groups** [[paper](https://arxiv.org/abs/2204.09802)]
- [2022] **Hamiltonicity in generalized quasi-dihedral groups** [[paper](https://arxiv.org/abs/2204.05484)]
- [2022] **A remark on the component group of the Sato-Tate group** [[paper](https://arxiv.org/abs/2204.08388)]
- [2022] **On Signs of Fourier Coefficients of Hecke-Maass Cusp Forms on GL_3** [[paper](https://arxiv.org/abs/2204.06261)]
- [2022] **Can we dream of a 1-adic Langlands correspondence?** [[paper](https://arxiv.org/abs/2204.00658)]
- [2022] **Parity of conjugate self-dual representations of inner forms of GL_n over p-adic fields** [[paper](https://arxiv.org/abs/2204.08830)]
- [2022] **Northcott numbers for the weighted Weil heights** [[paper](https://arxiv.org/abs/2204.04446)]
- [2022] **The average Mordell-Weil rank of elliptic surfaces over number fields** [[paper](https://arxiv.org/abs/2204.12102)]
- [2022] **Aldous' spectral gap property for normal Cayley graphs on symmetric groups** [[paper](https://arxiv.org/abs/2203.06789)]
- [2022] **The generalized X-join of Cayley graphs** [[paper](https://arxiv.org/abs/2203.07819)]
- [2022] **Nowhere-zero 3-flows in Cayley graphs on supersolvable groups** [[paper](https://arxiv.org/abs/2203.02971)]
- [2022] **Fourier coefficients of Hilbert modular forms at cusps** [[paper](https://arxiv.org/abs/2203.14096)]
- [2022] **Chebotarev-Sato-Tate distribution for abelian surfaces potentially of \rm{GL}_2-type** [[paper](https://arxiv.org/abs/2203.11498)]
- [2022] **On Galois inertial types of elliptic curves over \mathbb{Q}_\ell** [[paper](https://arxiv.org/abs/2203.07787)]
- [2022] **Distance-regular Cayley graphs over dicyclic groups** [[paper](https://arxiv.org/abs/2202.02939)]
- [2022] **Perfect state transfer on semi-Cayley graphs over abelian groups** [[paper](https://arxiv.org/abs/2202.03062)]
- [2022] **On chromatic parameters of some Regular graphs** [[paper](https://arxiv.org/abs/2202.03181)]
- [2022] **On Cayley graphs over generalized dicyclic groups** [[paper](https://arxiv.org/abs/2202.11398)]
- [2022] **Dimension expanders via quiver representations** [[paper](https://arxiv.org/abs/2202.07334)]
- [2022] **Zeros of derivatives of L-functions in the Selberg class on \Re(s)&lt;1/2** [[paper](https://arxiv.org/abs/2202.12126)]
- [2022] **The trace of T_2 takes no repeated values** [[paper](https://arxiv.org/abs/2202.03461)]
- [2022] **Values of zeta-one functions at positive even integers** [[paper](https://arxiv.org/abs/2202.11835)]
- [2022] **HS-integral and Eisenstein integral normal mixed Cayley graphs** [[paper](https://arxiv.org/abs/2201.08160)]
- [2022] **Godement-Jacquet L-function, some conjectures and some consequences** [[paper](https://arxiv.org/abs/2201.02000)]
- [2022] **Generalizations of results of Friedman and Washington on cokernels of random p-adic matrices** [[paper](https://arxiv.org/abs/2201.08777)]
- [2022] **Effective decorrelation of Hecke eigenforms** [[paper](https://arxiv.org/abs/2201.12481)]
- [2022] **Representations of reductive groups over local fields** [[paper](https://arxiv.org/abs/2201.07741)]
- [2022] **Polynomial-Time Approximation of Zero-Free Partition Functions** [[paper](https://arxiv.org/abs/2201.12772)]

##### 2021

- [2021] **On Cayley representations of central Cayley graphs over almost simple groups** [[paper](https://arxiv.org/abs/2112.05838)]
- [2021] **Spectral gap and origami expanders** [[paper](https://arxiv.org/abs/2112.11864)]
- [2021] **Equivalent criterion for the grand Riemann hypothesis associated to Maass cusp forms** [[paper](https://arxiv.org/abs/2112.08143)]
- [2021] **On Shafarevich-Tate groups and analytic ranks in families of modular forms, II. Coleman families** [[paper](https://arxiv.org/abs/2112.11847)]
- [2021] **On Deligne's conjecture for symmetric fifth L-functions of modular forms** [[paper](https://arxiv.org/abs/2112.12978)]
- [2021] **Chaotic sets and Hausdorff dimension for Lüroth expansions** [[paper](https://arxiv.org/abs/2112.04714)]
- [2021] **Siegel zeros, twin primes, Goldbach's conjecture, and primes in short intervals** [[paper](https://arxiv.org/abs/2112.11412)]
- [2021] **Nabla Fractional Derivative and Fractional Integral on Time Scales** [[paper](https://arxiv.org/abs/2112.13083)]
- [2021] **Locally Testable Codes with constant rate, distance, and locality** [[paper](https://arxiv.org/abs/2111.04808)]
- [2021] **Monstrous Moonshine for integral group rings** [[paper](https://arxiv.org/abs/2111.09404)]
- [2021] **Kodaira-Spencer isomorphisms and degeneracy maps on Iwahori-level Hilbert modular varieties: the saving trace** [[paper](https://arxiv.org/abs/2111.10160)]
- [2021] **Combinatorial Relationship Between Finite Fields and Fixed Points of Functions Going Up and Down** [[paper](https://arxiv.org/abs/2111.13745)]
- [2021] **Bertrand's Postulate for Carmichael Numbers** [[paper](https://arxiv.org/abs/2111.06963)]
- [2021] **Cyclic arcs of Singer type and strongly regular Cayley graphs over finite fields** [[paper](https://arxiv.org/abs/2110.10959)]
- [2021] **On A_α-spectrum of joined union of graphs and its applications to power graphs of finite groups** [[paper](https://arxiv.org/abs/2110.12476)]
- [2021] **The Ratios conjecture for real Dirichlet characters and multiple Dirichlet series** [[paper](https://arxiv.org/abs/2110.04409)]
- [2021] **Minimal Integral Models for Principal Series Weil Characters** [[paper](https://arxiv.org/abs/2110.14556)]
- [2021] **On the distribution of large values of |ζ(1+{\rm i}t)|** [[paper](https://arxiv.org/abs/2110.03293)]
- [2021] **Hypothesis of Riemann is rejected by definition** [[paper](https://arxiv.org/abs/2110.03253)]
- [2021] **On bipartite distance-regular Cayley graphs with small diameter** [[paper](https://arxiv.org/abs/2109.13849)]
- [2021] **Strongly cospectral vertices in normal Cayley graphs** [[paper](https://arxiv.org/abs/2109.07568)]
- [2021] **Counting chains in the noncrossing partition lattice via the W-Laplacian** [[paper](https://arxiv.org/abs/2109.04341)]
- [2021] **The boundary rigidity of lattices in products of trees** [[paper](https://arxiv.org/abs/2109.09175)]
- [2021] **A weighted one-level density of families of L-functions** [[paper](https://arxiv.org/abs/2109.07244)]
- [2021] **Representation of even integers as a sum of squares of primes and powers of two** [[paper](https://arxiv.org/abs/2109.13174)]
- [2021] **A common generalization of infinite sum, unordered sum and integral** [[paper](https://arxiv.org/abs/2109.02423)]
- [2021] **Enhanced Power Graph of Certain Non-abelian Groups** [[paper](https://arxiv.org/abs/2108.13006)]
- [2021] **Bianchi modular symbols and p-adic L-functions** [[paper](https://arxiv.org/abs/2108.05592)]
- [2021] **On the regularized L^4-norm for Eisenstein series in the level aspect, Part II** [[paper](https://arxiv.org/abs/2108.13532)]
- [2021] **Special values of L-functions on regular arithmetic schemes of dimension 1** [[paper](https://arxiv.org/abs/2108.00811)]
- [2021] **How to Verify the Riemann Hypothesis** [[paper](https://arxiv.org/abs/2108.06860)]
- [2021] **Refinements to the prime number theorem for arithmetic progressions** [[paper](https://arxiv.org/abs/2108.10878)]
- [2021] **New constructions of divisible design Cayley graphs** [[paper](https://arxiv.org/abs/2107.08536)]
- [2021] **Effective construction of Hilbert modular forms of half-integral weight** [[paper](https://arxiv.org/abs/2107.04483)]
- [2021] **Local Statistics for Zeros of Artin-Schreier L-functions** [[paper](https://arxiv.org/abs/2107.02131)]
- [2021] **The arithmetic of a twist of the Fermat quartic** [[paper](https://arxiv.org/abs/2107.05902)]
- [2021] **Integral mixed cayley graph over abelian group** [[paper](https://arxiv.org/abs/2106.14458)]
- [2021] **Precisely monotone sets in step-2 rank-3 Carnot algebras** [[paper](https://arxiv.org/abs/2106.13490)]
- [2021] **On normalized Laplacian eigenvalues of power graphs associated to finite cyclic groups** [[paper](https://arxiv.org/abs/2106.15072)]
- [2021] **Analytic Langlands correspondence for PGL(2) on P^1 with parabolic structures over local fields** [[paper](https://arxiv.org/abs/2106.05243)]
- [2021] **The plectic conjecture over function fields** [[paper](https://arxiv.org/abs/2106.05382)]
- [2021] **Random Schreier graphs and expanders** [[paper](https://arxiv.org/abs/2105.06378)]
- [2021] **Characterization of Collective Behaviors for Directed Signed Networks** [[paper](https://arxiv.org/abs/2105.02402)]
- [2021] **Note on a note of Goldston and Suriajaya** [[paper](https://arxiv.org/abs/2105.09038)]
- [2021] **Averaging functors in Fargues' program for GL_n** [[paper](https://arxiv.org/abs/2104.04701)]
- [2021] **Note on the Goldbach Conjecture and Landau-Siegel Zeros** [[paper](https://arxiv.org/abs/2104.09407)]
- [2021] **Expansion in Cayley graphs, Cayley sum graphs and their twists** [[paper](https://arxiv.org/abs/2103.05935)]
- [2021] **2-Arc-transitive Cayley graphs on alternating groups** [[paper](https://arxiv.org/abs/2103.14784)]
- [2021] **Symmetric graphs of prime valency with a transitive simple group** [[paper](https://arxiv.org/abs/2103.16870)]
- [2021] **Towards optimal spectral gaps in large genus** [[paper](https://arxiv.org/abs/2103.07496)]
- [2021] **Definite integrals involving combinations of powers and logarithmic functions of complicated arguments expressed in terms of the Hurwitz zeta function** [[paper](https://arxiv.org/abs/2103.03110)]
- [2021] **Multiple zeros of nonlinear systems** [[paper](https://arxiv.org/abs/2103.05738)]
- [2021] **Hybrid subconvexity bounds for twists of \rm GL (3)\times GL(2) L-functions** [[paper](https://arxiv.org/abs/2103.11361)]
- [2021] **Geometry of Random Cayley Graphs of Abelian Groups** [[paper](https://arxiv.org/abs/2102.02801)]
- [2021] **Cutoff for Almost All Random Walks on Abelian Groups** [[paper](https://arxiv.org/abs/2102.02809)]
- [2021] **Train track maps on graphs of groups** [[paper](https://arxiv.org/abs/2102.02848)]
- [2021] **Superexponential Dehn functions inside CAT(0) groups** [[paper](https://arxiv.org/abs/2102.13572)]
- [2021] **Fermat's Last Theorem and modular curves over real quadratic fields** [[paper](https://arxiv.org/abs/2102.11699)]
- [2021] **Micro-local analysis of contact Anosov flows and band structure of the Ruelle spectrum** [[paper](https://arxiv.org/abs/2102.11196)]
- [2021] **Weil-étale cohomology and zeta-values of arithmetic schemes at negative integers** [[paper](https://arxiv.org/abs/2102.12114)]
- [2021] **Khinchin-type inequalities via Hadamard's factorisation** [[paper](https://arxiv.org/abs/2102.09500)]
- [2021] **On finite subnormal Cayley graphs** [[paper](https://arxiv.org/abs/2101.04313)]
- [2021] **Twist-minimal trace formula for holomorphic cusp forms** [[paper](https://arxiv.org/abs/2101.05663)]
- [2021] **On the maximum of cotangent sums related to the Riemann Hypothesis in rational numbers in short intervals** [[paper](https://arxiv.org/abs/2101.01089)]
- [2021] **Weil polynomials of abelian varieties over finite fields with many rational points** [[paper](https://arxiv.org/abs/2101.12664)]
- [2021] **An M-function associated with Goldbach's problem** [[paper](https://arxiv.org/abs/2101.07446)]
- [2021] **On zeros of the Riemann zeta function** [[paper](https://arxiv.org/abs/2102.00822)]

##### 2020

- [2020] **A note on some p-adic analytic Hecke actions** [[paper](https://arxiv.org/abs/2012.11845)]
- [2020] **The Life and Death of SSDs and HDDs: Similarities, Differences, and Prediction Models** [[paper](https://arxiv.org/abs/2012.12373)]
- [2020] **A focus on the Riemann's Hypothesis** [[paper](https://arxiv.org/abs/2012.02793)]
- [2020] **Subconvexity for GL(3) \times GL(2) L-functions in the depth aspect** [[paper](https://arxiv.org/abs/2012.12674)]
- [2020] **Domination parameters and diameter of Abelian Cayley graphs** [[paper](https://arxiv.org/abs/2011.05754)]
- [2020] **Uniform effective estimates for \vert L(1,χ)\vert** [[paper](https://arxiv.org/abs/2011.08348)]
- [2020] **On local zeta-integrals for GSp(4) and GSp(4) x GL(2)** [[paper](https://arxiv.org/abs/2011.15106)]
- [2020] **Derived Langlands VI: Monomial resolutions and 2-variable L-functions** [[paper](https://arxiv.org/abs/2011.12054)]
- [2020] **Screening for an Infectious Disease as a Problem in Stochastic Control** [[paper](https://arxiv.org/abs/2011.00635)]
- [2020] **Time Series Forecasting with Stacked Long Short-Term Memory Networks** [[paper](https://arxiv.org/abs/2011.00697)]
- [2020] **Local and Global Analysis** [[paper](https://arxiv.org/abs/2011.02058)]
- [2020] **t-aspect subconvexity for GL(2) \times GL(2) L-function** [[paper](https://arxiv.org/abs/2011.01172)]
- [2020] **Cayley graphs with few automorphisms: the case of infinite groups** [[paper](https://arxiv.org/abs/2010.06020)]
- [2020] **A note on the structure of expanders** [[paper](https://arxiv.org/abs/2010.08944)]
- [2020] **One Lie group to define them all** [[paper](https://arxiv.org/abs/2010.10579)]
- [2020] **Self-similar groups and holomorphic dynamics: Renormalization, integrability, and spectrum** [[paper](https://arxiv.org/abs/2010.00675)]
- [2020] **Fast computation of half-integral weight modular forms** [[paper](https://arxiv.org/abs/2010.11239)]
- [2020] **The transport of images method: computing all zeros of harmonic mappings by continuation** [[paper](https://arxiv.org/abs/2011.00079)]
- [2020] **Special values of L-functions of one-motives over function fields** [[paper](https://arxiv.org/abs/2009.14504)]
- [2020] **On sensitivity in bipartite Cayley graphs** [[paper](https://arxiv.org/abs/2009.00554)]
- [2020] **Comparing anticyclotomic Selmer groups of positive coranks for congruent modular forms -- Part II** [[paper](https://arxiv.org/abs/2009.03772)]
- [2020] **Jensen polynomials are not a plausible route to proving the Riemann Hypothesis** [[paper](https://arxiv.org/abs/2008.07206)]
- [2020] **Generalized Heegner cycles and p-adic L-functions in a quaternionic setting** [[paper](https://arxiv.org/abs/2008.13500)]
- [2020] **Local Langlands Correspondence for Even Orthogonal Groups via Theta Lifts** [[paper](https://arxiv.org/abs/2008.02632)]
- [2020] **Rankin-Selberg integrals for local symmetric square factors on GL(2)** [[paper](https://arxiv.org/abs/2008.07379)]
- [2020] **On an inequality of Bushnell--Henniart for Rankin--Selberg conductors** [[paper](https://arxiv.org/abs/2008.09489)]
- [2020] **Integral equienergetic non-isospectral unitary Cayley graphs** [[paper](https://arxiv.org/abs/2007.01300)]
- [2020] **On spectra and spectral measures of Schreier and Cayley graphs** [[paper](https://arxiv.org/abs/2007.03309)]
- [2020] **Universal inequalities for Dirichlet eigenvalues on discrete groups** [[paper](https://arxiv.org/abs/2007.13157)]
- [2020] **Low-lying zeros of a family of quadratic Hecke L-functions via ratios conjecture** [[paper](https://arxiv.org/abs/2007.13265)]
- [2020] **The error term in the Cesàro mean of the prime pair singular series** [[paper](https://arxiv.org/abs/2007.14616)]
- [2020] **Subconvexity for L-Functions on GL_3 over Number Fields** [[paper](https://arxiv.org/abs/2007.10949)]
- [2020] **Auto-correlation functions of Sato-Tate distributions and identities of symplectic characters** [[paper](https://arxiv.org/abs/2006.06116)]
- [2020] **Flat traces for a random partially hyperbolic map** [[paper](https://arxiv.org/abs/2006.14753)]
- [2020] **Compactness of Transfer Operators and Spectral Representation of Ruelle Zeta Functions for Super-continuous Functions** [[paper](https://arxiv.org/abs/2006.01564)]
- [2020] **Cayley graphs without a bounded eigenbasis** [[paper](https://arxiv.org/abs/2005.04502)]
- [2020] **One level density of low-lying zeros of quadratic Hecke L-functions to prime moduli** [[paper](https://arxiv.org/abs/2005.04811)]
- [2020] **On the connection between the Goldbach conjecture and the Elliott-Halberstam conjecture** [[paper](https://arxiv.org/abs/2005.03811)]
- [2020] **The Distribution of the Nontrivial Zeros of Riemann Zeta Function** [[paper](https://arxiv.org/abs/2005.04568)]
- [2020] **Counterexamples to "A Conjecture on Induced Subgraphs of Cayley Graphs" [arXiv:2003.13166]** [[paper](https://arxiv.org/abs/2004.01327)]
- [2020] **Vertex-transitive covers of semi-equivelar toroidal maps** [[paper](https://arxiv.org/abs/2004.09953)]
- [2020] **Sato-Tate Distributions of y^2=x^p-1 and y^2=x^{2p}-1** [[paper](https://arxiv.org/abs/2004.10583)]
- [2020] **Construction and Random Generation of Hypergraphs with Prescribed Degree and Dimension Sequences** [[paper](https://arxiv.org/abs/2004.05429)]
- [2020] **Spectrum and energies of commuting conjugacy class graph of a finite group** [[paper](https://arxiv.org/abs/2003.07142)]
- [2020] **Co-Prime Order graph of a finite abelian Group and Dihedral Group** [[paper](https://arxiv.org/abs/2003.09850)]
- [2020] **Spectral aspects of commuting conjugacy class graph of finite groups** [[paper](https://arxiv.org/abs/2003.05762)]
- [2020] **Virtues of Priority** [[paper](https://arxiv.org/abs/2003.08242)]
- [2020] **Towards a resolution of the Riemann hypothesis** [[paper](https://arxiv.org/abs/2003.14241)]
- [2020] **Spectrum and energy of non-commuting graphs of finite groups** [[paper](https://arxiv.org/abs/2002.10146)]
- [2020] **Effective forms of the Sato--Tate conjecture** [[paper](https://arxiv.org/abs/2002.10450)]
- [2020] **Joint distribution of eigenvalues of Hecke and Casimir operators for Hilbert Maass forms** [[paper](https://arxiv.org/abs/2002.05144)]
- [2020] **On Transfer Operators for Markovian Products of Invertible Random Matrices** [[paper](https://arxiv.org/abs/2001.06865)]
- [2020] **Some arithmetic properties of Weil polynomials of the form t^{2g}+at^g+q^g** [[paper](https://arxiv.org/abs/2001.01104)]

##### 2019

- [2019] **The p-adic Riemann Hypothesis For Expnonential Sums** [[paper](https://arxiv.org/abs/1912.04503)]
- [2019] **Lower order terms of the one level density of a family of quadratic Hecke L-functions** [[paper](https://arxiv.org/abs/1912.05041)]
- [2019] **Local Langlands correspondence for regular supercuspidal representations of GL(n)** [[paper](https://arxiv.org/abs/1912.07851)]
- [2019] **The Spectral Hecke Algebra** [[paper](https://arxiv.org/abs/1912.04413)]
- [2019] **Supercuspidal L-packets** [[paper](https://arxiv.org/abs/1912.03274)]
- [2019] **Probabilistic models for Gram's Law** [[paper](https://arxiv.org/abs/1911.03190)]
- [2019] **Hausdorff dimension for the set of points connected with the generalized Jarník-Besicovitch set** [[paper](https://arxiv.org/abs/1911.12550)]
- [2019] **On a Hilbert Space Reformulation of Riemann Hypothesis** [[paper](https://arxiv.org/abs/1911.04029)]
- [2019] **On Landau-Siegel zeros and heights of singular moduli** [[paper](https://arxiv.org/abs/1911.07215)]
- [2019] **Closed-form formula of Riemann zeta function and eta function for all non-zero given complex numbers via sums of powers of complex functions to disprove Riemann Hypothesis** [[paper](https://arxiv.org/abs/1911.10934)]
- [2019] **Cayley Graphs on Billiard Surfaces, and Their Genus** [[paper](https://arxiv.org/abs/1910.06377)]
- [2019] **Cheeger-Gromoll Splitting Theorem for groups** [[paper](https://arxiv.org/abs/1910.05822)]
- [2019] **On the structure of asymptotic expanders** [[paper](https://arxiv.org/abs/1910.13320)]
- [2019] **Representation Theory and Differential Equations** [[paper](https://arxiv.org/abs/1910.12497)]
- [2019] **Universal Fourier expansions of Bianchi modular forms** [[paper](https://arxiv.org/abs/1910.12356)]
- [2019] **Arithmetic invariants from Sato--Tate moments** [[paper](https://arxiv.org/abs/1910.00518)]
- [2019] **Tractable Minor-free Generalization of Planar Zero-field Ising Models** [[paper](https://arxiv.org/abs/1910.11142)]
- [2019] **Ramanujan Graphs and the Spectral Gap of Supercomputing Topologies** [[paper](https://arxiv.org/abs/1909.11694)]
- [2019] **Cops and robbers on directed and undirected abelian Cayley graphs** [[paper](https://arxiv.org/abs/1909.05342)]
- [2019] **Meyniel Extremal Families of Abelian Cayley Graphs** [[paper](https://arxiv.org/abs/1909.03027)]
- [2019] **Quasi-vertex-transitive Maps on the Plane** [[paper](https://arxiv.org/abs/1909.09042)]
- [2019] **Tate module tensor decompositions and the Sato-Tate conjecture for certain abelian varieties potentially of GL_2-type** [[paper](https://arxiv.org/abs/1909.11712)]
- [2019] **The distribution of the maximum of partial sums of Kloosterman sums and other trace functions** [[paper](https://arxiv.org/abs/1909.03266)]
- [2019] **Spectral properties of graphs associated to the Basilica group** [[paper](https://arxiv.org/abs/1908.10505)]
- [2019] **On Drinfeld cusp forms of prime level** [[paper](https://arxiv.org/abs/1908.09768)]
- [2019] **On the distribution of products of two primes** [[paper](https://arxiv.org/abs/1908.09503)]
- [2019] **A Cheeger type inequality in finite Cayley sum graphs** [[paper](https://arxiv.org/abs/1907.07710)]
- [2019] **Mean values of derivatives of L-functions in function fields: IV** [[paper](https://arxiv.org/abs/1906.10373)]
- [2019] **The error term in the Sato-Tate theorem of Birch** [[paper](https://arxiv.org/abs/1906.03534)]
- [2019] **The Explicit Sato-Tate Conjecture For Primes In Arithmetic Progressions** [[paper](https://arxiv.org/abs/1906.07903)]
- [2019] **Shintani lifts for Weil representations of unitary groups over finite fields** [[paper](https://arxiv.org/abs/1906.03615)]
- [2019] **The Zeta Quotient ζ(3)/ π^3 is Irrational** [[paper](https://arxiv.org/abs/1906.10618)]
- [2019] **The Jensen-Pólya program for various L-functions** [[paper](https://arxiv.org/abs/1905.11269)]
- [2019] **Modelling conditional probabilities with Riemann-Theta Boltzmann Machines** [[paper](https://arxiv.org/abs/1905.11313)]
- [2019] **A Generative Model for Sampling High-Performance and Diverse Weights for Neural Networks** [[paper](https://arxiv.org/abs/1905.02898)]
- [2019] **On Expected Accuracy** [[paper](https://arxiv.org/abs/1905.00448)]
- [2019] **Zeros and approximations of Holant polynomials on the complex plane** [[paper](https://arxiv.org/abs/1905.03194)]
- [2019] **X-Ramanujan Graphs** [[paper](https://arxiv.org/abs/1904.03500)]
- [2019] **Semi-equivelar maps of Euler characteristics -2 with few vertices** [[paper](https://arxiv.org/abs/1904.07696)]
- [2019] **Girth, words and diameter** [[paper](https://arxiv.org/abs/1903.00748)]
- [2019] **Shrinking targets and eventually always hitting points for interval maps** [[paper](https://arxiv.org/abs/1903.06977)]
- [2019] **On expander Cayley graphs from Galois rings** [[paper](https://arxiv.org/abs/1902.03423)]
- [2019] **Euler Product Asymptotics for Dirichlet L-Functions** [[paper](https://arxiv.org/abs/1902.04203)]
- [2019] **Jensen polynomials for the Riemann zeta function and other sequences** [[paper](https://arxiv.org/abs/1902.07321)]
- [2019] **Discorrelation between primes in short intervals and polynomial phases** [[paper](https://arxiv.org/abs/1902.04708)]
- [2019] **Divisor sums representable as the sum of two squares** [[paper](https://arxiv.org/abs/1902.11171)]
- [2019] **Cutoff on Ramanujan complexes and classical groups** [[paper](https://arxiv.org/abs/1901.09383)]
- [2019] **Inapproximability of actions and Kazhdan's property (T)** [[paper](https://arxiv.org/abs/1901.03963)]
- [2019] **Approximation forte sur un produit de variétés abéliennes épointé en des points de torsion** [[paper](https://arxiv.org/abs/1901.00118)]
- [2019] **Goldbach's like conjectures arising from arithmetic progressions whose first two terms are primes** [[paper](https://arxiv.org/abs/1901.07882)]
- [2019] **Prime product formulas for the Riemann zeta function and related identities** [[paper](https://arxiv.org/abs/1901.09519)]

##### 2018

- [2018] **Orbit Expandability of Automaton Semigroups and Groups** [[paper](https://arxiv.org/abs/1812.07359)]
- [2018] **Values of Harmonic Weak Maass forms on Hecke orbits** [[paper](https://arxiv.org/abs/1812.01326)]
- [2018] **Surface Algebras and Surface Orders II: Affine Bundles on Curves** [[paper](https://arxiv.org/abs/1812.00621)]
- [2018] **Dimension of Gibbs measures with infinite entropy** [[paper](https://arxiv.org/abs/1812.04612)]
- [2018] **Using Selmer Groups to compute Mordell-Weil Groups of Elliptic Curves** [[paper](https://arxiv.org/abs/1812.10415)]
- [2018] **On the p-adic Langlands correspondence for algebraic tori** [[paper](https://arxiv.org/abs/1811.04819)]
- [2018] **Affine Deligne-Lusztig varieties at infinite level** [[paper](https://arxiv.org/abs/1811.11204)]
- [2018] **An analogue of the Erdős-Kac theorem for the special linear group over the integers** [[paper](https://arxiv.org/abs/1811.01919)]
- [2018] **The Weyl bound for Dirichlet L-functions of cube-free conductor** [[paper](https://arxiv.org/abs/1811.02452)]
- [2018] **Ramanujan complexes and Golden Gates in PU(3)** [[paper](https://arxiv.org/abs/1810.04710)]
- [2018] **Local Langlands correspondence for Asai L-functions and epsilon factors** [[paper](https://arxiv.org/abs/1810.11852)]
- [2018] **La Zeta de Riemann est irrationnelle aux impairs positifs** [[paper](https://arxiv.org/abs/1810.02361)]
- [2018] **Supersymmetry and the Riemann zeros on the critical line** [[paper](https://arxiv.org/abs/1810.02204)]
- [2018] **Eigenvalues of Cayley graphs** [[paper](https://arxiv.org/abs/1809.09829)]
- [2018] **Infinite classes of strongly regular graphs derived from GL(n,F_2)** [[paper](https://arxiv.org/abs/1809.06084)]
- [2018] **Asymptotics of Goldbach Representations** [[paper](https://arxiv.org/abs/1809.06920)]
- [2018] **Pair correlation statistics for Sato-Tate sequences** [[paper](https://arxiv.org/abs/1809.10863)]
- [2018] **Structure of Mordell-Weil groups over \mathbb{Z}_p-extensions** [[paper](https://arxiv.org/abs/1809.10351)]
- [2018] **On root-ratio multipoint methods for finding multiple zeros of univariate functions** [[paper](https://arxiv.org/abs/1809.09518)]
- [2018] **Distance-regular Cayley graphs with small valency** [[paper](https://arxiv.org/abs/1808.01428)]
- [2018] **A magnetic modular form** [[paper](https://arxiv.org/abs/1808.04157)]
- [2018] **Sato-Tate Distributions on Abelian Surfaces** [[paper](https://arxiv.org/abs/1808.00243)]
- [2018] **Computing abelian varieties over finite fields isogenous to a power** [[paper](https://arxiv.org/abs/1808.03673)]
- [2018] **On the spectral gap of some Cayley graphs on the Weyl group W(B_n)** [[paper](https://arxiv.org/abs/1807.11833)]
- [2018] **On the Local Geometry of Graphs in Terms of Their Spectra** [[paper](https://arxiv.org/abs/1807.06034)]
- [2018] **Fundamental groups and group presentations with bounded relator lengths** [[paper](https://arxiv.org/abs/1807.08827)]
- [2018] **The absolute of finitely generated groups: II. The Laplacian and degenerate parts** [[paper](https://arxiv.org/abs/1807.05129)]
- [2018] **Rationality and p-adic properties of reduced forms of half-integral weight** [[paper](https://arxiv.org/abs/1807.02454)]
- [2018] **Depth preserving property of the local Langlands correspondence for non-quasi-split unitary groups** [[paper](https://arxiv.org/abs/1807.08232)]
- [2018] **On Studying the Phase Behavior of the Riemann Zeta Function Along the Critical Line** [[paper](https://arxiv.org/abs/1806.01148)]
- [2018] **Approximation Algorithms for Complex-Valued Ising Models on Bounded Degree Graphs** [[paper](https://arxiv.org/abs/1806.11282)]
- [2018] **Divergence and quasi-isometry classes of random Gromov's monsters** [[paper](https://arxiv.org/abs/1805.04039)]
- [2018] **On probabilistic generalizations of the Nyman-Beurling criterion for the zeta function** [[paper](https://arxiv.org/abs/1805.06733)]
- [2018] **Ramanujan Graphs and Digraphs** [[paper](https://arxiv.org/abs/1804.08028)]
- [2018] **Wave equations on graded groups and hypoelliptic Gevrey spaces** [[paper](https://arxiv.org/abs/1804.03544)]
- [2018] **Platonic solids, Archimedean solids and semi-equivelar maps on the sphere** [[paper](https://arxiv.org/abs/1804.06692)]
- [2018] **Examples of genuine QM abelian surfaces which are modular** [[paper](https://arxiv.org/abs/1804.07225)]
- [2018] **On some consequences of a theorem of J. Ludwig** [[paper](https://arxiv.org/abs/1804.07567)]
- [2018] **Contributions to the study of the non-trivial roots of the Riemann zeta-function** [[paper](https://arxiv.org/abs/1804.00913)]
- [2018] **Weak Siegel-Weil formula for M_2(Q) and arithmetic on quaternions** [[paper](https://arxiv.org/abs/1804.05247)]
- [2018] **An investigation of the non-trivial zeros of the Riemann zeta function** [[paper](https://arxiv.org/abs/1804.04700)]
- [2018] **On a cheeger type inequality in Cayley graphs of finite groups** [[paper](https://arxiv.org/abs/1803.03969)]
- [2018] **An efficient algorithm to test forcibly-connectedness of graphical degree sequences** [[paper](https://arxiv.org/abs/1803.00673)]
- [2018] **Contragredient representations over local fields of positive characteristic** [[paper](https://arxiv.org/abs/1802.08999)]
- [2018] **Fujii's development on Chebyshev's conjecture** [[paper](https://arxiv.org/abs/1802.00089)]

##### 2017

- [2017] **The Sato-Tate conjecture and Nagao's conjecture** [[paper](https://arxiv.org/abs/1712.02775)]
- [2017] **A Siegel-Weil formula for (U(1,1), U(V)) over a function field with \dim V greater than 2** [[paper](https://arxiv.org/abs/1712.06010)]
- [2017] **The Fourier transform of the non-trivial zeros of the zeta function** [[paper](https://arxiv.org/abs/1712.08434)]
- [2017] **Matrix methods for Padé approximation: numerical calculation of poles, zeros and residues** [[paper](https://arxiv.org/abs/1712.01155)]
- [2017] **Regularity of the spectrum for expanding maps** [[paper](https://arxiv.org/abs/1711.05647)]
- [2017] **Average Goldbach and the Quasi-Riemann Hypothesis** [[paper](https://arxiv.org/abs/1711.06442)]
- [2017] **Riemann hypothesis** [[paper](https://arxiv.org/abs/1711.11416)]
- [2017] **Explicit local Jacquet-Langlands correspondence: the non-dyadic wild case** [[paper](https://arxiv.org/abs/1709.09609)]
- [2017] **From cycles to circles in Cayley graphs** [[paper](https://arxiv.org/abs/1708.03476)]
- [2017] **All Zeros of the Riemann Zeta Function in the Critical Strip are Located on the Critical Line and are Simple** [[paper](https://arxiv.org/abs/1708.01209)]
- [2017] **Arc-transitive Cayley graphs on non-ableian simple groups with soluble vertex stabilizers and valency seven** [[paper](https://arxiv.org/abs/1707.09785)]
- [2017] **On groups all of whose Haar graphs are Cayley graphs** [[paper](https://arxiv.org/abs/1707.03090)]
- [2017] **Bipartite bi-Cayley graphs over metacyclic groups of odd prime-power order** [[paper](https://arxiv.org/abs/1707.02790)]
- [2017] **Superexpanders from group actions on compact manifolds** [[paper](https://arxiv.org/abs/1707.01399)]
- [2017] **Réponse linéaire et points périodiques : cas analytique** [[paper](https://arxiv.org/abs/1707.02751)]
- [2017] **Strongly regular Cayley graphs from partitions of subdifference sets of the Singer difference sets** [[paper](https://arxiv.org/abs/1706.05460)]
- [2017] **The Smith group and the critical group of the Grassmann graph of lines in finite projective space and of its complement** [[paper](https://arxiv.org/abs/1706.01294)]
- [2017] **Quantum modular forms and Hecke operators** [[paper](https://arxiv.org/abs/1706.05824)]
- [2017] **Quantum Chaos on random Cayley graphs of {\rm SL}_2[\mathbb{Z}/p\mathbb{Z}]** [[paper](https://arxiv.org/abs/1705.02993)]
- [2017] **Construction of strongly regular Cayley graphs based on three-valued Gauss periods** [[paper](https://arxiv.org/abs/1705.07623)]
- [2017] **On Laplacian energy of non-commuting graphs of finite groups** [[paper](https://arxiv.org/abs/1705.10611)]
- [2017] **Banach space actions and L^2-spectral gap** [[paper](https://arxiv.org/abs/1705.03296)]
- [2017] **Small cancellation theory over Burnside groups** [[paper](https://arxiv.org/abs/1705.09651)]
- [2017] **Laplacian Spectrum of non-commuting graphs of finite groups** [[paper](https://arxiv.org/abs/1705.01275)]
- [2017] **Semi-equivelar maps on the torus are Archimedean** [[paper](https://arxiv.org/abs/1705.05236)]
- [2017] **Explicit formulas and vanishing conditions for certain coefficients of Drinfeld-Goss Hecke eigenforms** [[paper](https://arxiv.org/abs/1705.09795)]
- [2017] **Fluctuations in the distribution of Hecke eigenvalues about the Sato-Tate measure** [[paper](https://arxiv.org/abs/1705.04115)]
- [2017] **Super-expanders and warped cones** [[paper](https://arxiv.org/abs/1704.03865)]
- [2017] **Various energies of some super integral groups** [[paper](https://arxiv.org/abs/1705.00137)]
- [2017] **Restriction estimates for the free two step nilpotent group on three generators** [[paper](https://arxiv.org/abs/1704.07876)]
- [2017] **Jordan blocks of cuspidal representations of symplectic groups** [[paper](https://arxiv.org/abs/1704.03545)]
- [2017] **Dynamics of a family of continued fraction maps** [[paper](https://arxiv.org/abs/1704.06912)]
- [2017] **Distribution of the periodic points of the Farey map** [[paper](https://arxiv.org/abs/1704.08971)]
- [2017] **Statistical distribution of the Stern sequence** [[paper](https://arxiv.org/abs/1704.05253)]
- [2017] **Solving Zero-sum Games using Best Response Oracles with Applications to Search Games** [[paper](https://arxiv.org/abs/1704.02657)]
- [2017] **Cayley graphs and symmetric interconnection networks** [[paper](https://arxiv.org/abs/1703.08109)]
- [2017] **Most Rigid Representations and Cayley index** [[paper](https://arxiv.org/abs/1703.09299)]
- [2017] **Effective joint distribution of eigenvalues of Hecke operators** [[paper](https://arxiv.org/abs/1703.07944)]
- [2017] **Arithmetic families of (\varphi, Γ)-modules and locally analytic representations of GL_2(Q_p)** [[paper](https://arxiv.org/abs/1703.01627)]
- [2017] **Local Root Numbers and Spectrum of the Local Descents for Orthogonal Groups: p-adic case** [[paper](https://arxiv.org/abs/1703.06451)]
- [2017] **On Gibbs measures and spectra of Ruelle transfer operators** [[paper](https://arxiv.org/abs/1703.04276)]
- [2017] **Il Fattore di Sylvester** [[paper](https://arxiv.org/abs/1703.06467)]
- [2017] **Computing Simple Multiple Zeros of Polynomial Systems** [[paper](https://arxiv.org/abs/1703.03981)]
- [2017] **Arc-transitive pentavalent Cayley graphs with soluble vertex stabilizer on finite nonabelian simple groups** [[paper](https://arxiv.org/abs/1702.05754)]
- [2017] **Asai cube L-functions and the local Langlands conjecture** [[paper](https://arxiv.org/abs/1701.01516)]

##### 2016

- [2016] **Lp expander Complexes** [[paper](https://arxiv.org/abs/1701.00154)]
- [2016] **Central Limit Theorems for series of Dirichlet characters** [[paper](https://arxiv.org/abs/1612.09237)]
- [2016] **Box spaces of the free group that neither contain expanders nor embed into a Hilbert space** [[paper](https://arxiv.org/abs/1611.08451)]
- [2016] **Newforms in the Kohnen plus space** [[paper](https://arxiv.org/abs/1611.08810)]
- [2016] **On depth zero L-packets for classical groups** [[paper](https://arxiv.org/abs/1611.08421)]
- [2016] **A variant of Bombieri-Vinogradov theorem with explicit constants** [[paper](https://arxiv.org/abs/1610.05344)]
- [2016] **Semi-equivelar and vertex-transitive maps on the torus** [[paper](https://arxiv.org/abs/1610.01830)]
- [2016] **A Connection between the Riemann Hypothesis and Uniqueness of the Riemann zeta function** [[paper](https://arxiv.org/abs/1610.01583)]
- [2016] **A Note on Spectral Analysis in Automorphic Representation Theory for {\rm GL}_2: II** [[paper](https://arxiv.org/abs/1610.00230)]
- [2016] **Spectral properties of the Cayley Graphs of split metacyclic groups** [[paper](https://arxiv.org/abs/1609.06022)]
- [2016] **Cayley graphs with metric dimension two - A characterization** [[paper](https://arxiv.org/abs/1609.06565)]
- [2016] **Structural characterization of Cayley graphs** [[paper](https://arxiv.org/abs/1609.08272)]
- [2016] **Shifted Convolution L-Series Values for Elliptic Curves** [[paper](https://arxiv.org/abs/1608.05462)]
- [2016] **The twisting Sato-Tate group of the curve y^2 = x^{8} - 14x^4 + 1** [[paper](https://arxiv.org/abs/1608.06784)]
- [2016] **An extremal problem related to generalizations of the Nyman-Beurling and Báez-Duarte criteria** [[paper](https://arxiv.org/abs/1608.07887)]
- [2016] **The rightness of the Riemann Hypothesis** [[paper](https://arxiv.org/abs/1608.03199)]
- [2016] **Some relations on Fourier coefficients of degree 2 Siegel forms of arbitrary level** [[paper](https://arxiv.org/abs/1608.00158)]
- [2016] **Chaotic and Topological Properties of Continued Fractions** [[paper](https://arxiv.org/abs/1607.07339)]
- [2016] **Series expansions for Maass forms on the full modular group from the Farey transfer operators** [[paper](https://arxiv.org/abs/1607.03414)]
- [2016] **Waring-Goldbach Problem with Piatetski-Shapiro Primes** [[paper](https://arxiv.org/abs/1607.08745)]
- [2016] **Deterministic polynomial-time approximation algorithms for partition functions and graph polynomials** [[paper](https://arxiv.org/abs/1607.01167)]
- [2016] **Integral Cayley Graphs over Dihedral Groups** [[paper](https://arxiv.org/abs/1606.02184)]
- [2016] **On sofic approximations of Property (T) groups** [[paper](https://arxiv.org/abs/1606.04471)]
- [2016] **The unicity of types for depth-zero supercuspidal representations** [[paper](https://arxiv.org/abs/1606.01691)]
- [2016] **Admitting a coarse embedding is not preserved under group extensions** [[paper](https://arxiv.org/abs/1605.01192)]
- [2016] **Sato-Tate Distributions** [[paper](https://arxiv.org/abs/1604.01256)]
- [2016] **Eta quotients, Eisenstein series and Elliptic Curves** [[paper](https://arxiv.org/abs/1604.07774)]
- [2016] **Parity of the Langlands parameters of conjugate self-dual representations of GL(n) and the local Jacquet-Langlands correspondence** [[paper](https://arxiv.org/abs/1603.04691)]
- [2016] **A functional relation for L-functions of graphs equivalent to the Riemann Hypothesis for Dirichlet L-functions** [[paper](https://arxiv.org/abs/1601.04573)]
- [2016] **Researchers to your Driving Seats: Building a Graphical User Interface for Multilingual Topic-Modelling in R with Shiny.** *DH* [[paper](https://dblp.org/rec/conf/dihu/Kontges16)]

##### 2015

- [2015] **Conductors in p-adic families** [[paper](https://arxiv.org/abs/1512.03004)]
- [2015] **Diameter of Ramanujan Graphs and Random Cayley Graphs** [[paper](https://arxiv.org/abs/1511.09340)]
- [2015] **On automorphisms and structural properties of generalized Cayley graphs** [[paper](https://arxiv.org/abs/1511.09467)]
- [2015] **Connections between Double Zeta Values relative to μ_N, Hecke Operators T_N, and Newforms of Level Γ_0(N) for N=2,3** [[paper](https://arxiv.org/abs/1511.06102)]
- [2015] **Centre de Bernstein dual pour les groupes classiques** [[paper](https://arxiv.org/abs/1511.02521)]
- [2015] **The local Langlands conjecture for the p-adic inner form of Sp(4)** [[paper](https://arxiv.org/abs/1510.00900)]
- [2015] **p-adic properties of certain half-integral weight modular forms** [[paper](https://arxiv.org/abs/1509.00383)]
- [2015] **The Sato-Tate Distribution in Thin Parametric Families of Elliptic Curves** [[paper](https://arxiv.org/abs/1509.03009)]
- [2015] **All of zeros of Riemann's Zeta-Function are on σ=1/2** [[paper](https://arxiv.org/abs/1508.02932)]
- [2015] **Sato-Tate equidistribution of certain families of Artin L-functions** [[paper](https://arxiv.org/abs/1507.07031)]
- [2015] **Nilprogressions and groups with moderate growth** [[paper](https://arxiv.org/abs/1506.00886)]
- [2015] **Motivic Serre group, algebraic Sato-Tate group and Sato-Tate conjecture** [[paper](https://arxiv.org/abs/1506.02177)]
- [2015] **Sato-Tate equidistribution for families of Hecke-Maass forms on SL(n,R)/SO(n)** [[paper](https://arxiv.org/abs/1505.07285)]
- [2015] **Quadratic unitary Cayley graphs of finite commutative rings** [[paper](https://arxiv.org/abs/1504.02934)]
- [2015] **Ramanujan Cayley graphs of Frobenius groups** [[paper](https://arxiv.org/abs/1503.04075)]
- [2015] **Two estimates on the distribution of zeros of the first derivative of Dirichlet L-functions under the generalized Riemann hypothesis** [[paper](https://arxiv.org/abs/1503.05701)]
- [2015] **Divisibility properties for weakly holomorphic modular forms with sign vectors** [[paper](https://arxiv.org/abs/1503.01134)]
- [2015] **Foliations and webs inducing Galois coverings** [[paper](https://arxiv.org/abs/1503.04627)]
- [2015] **Homomorphisms of binary Cayley graphs** [[paper](https://arxiv.org/abs/1502.00776)]
- [2015] **Discrete curvature and abelian groups** [[paper](https://arxiv.org/abs/1501.00516)]
- [2015] **Expansion, Random Walks and Sieving in SL_2 (\mathbb{F}_p [t])** [[paper](https://arxiv.org/abs/1501.03199)]
- [2015] **The Milnor-Thurston determinant and the Ruelle transfer operator** [[paper](https://arxiv.org/abs/1501.00294)]
- [2015] **New simultaneous methods for finding all zeros of a polynomial** [[paper](https://arxiv.org/abs/1501.05033)]

##### 2014

- [2014] **Spectra of Schreier graphs of Grigorchuk's group and Schroedinger operators with aperiodic order** [[paper](https://arxiv.org/abs/1412.6822)]
- [2014] **Brownian motion on treebolic space: positive harmonic functions** [[paper](https://arxiv.org/abs/1412.2218)]
- [2014] **A continuum of expanders** [[paper](https://arxiv.org/abs/1410.0246)]
- [2014] **The Sato-Tate conjecture for a Picard curve with Complex Multiplication** [[paper](https://arxiv.org/abs/1409.6020)]
- [2014] **The Tail of the Singular Series for the Prime Pair and Goldbach Problems** [[paper](https://arxiv.org/abs/1409.2151)]
- [2014] **Maximum ATSP with Weights Zero and One via Half-Edges** [[paper](https://arxiv.org/abs/1408.1431)]
- [2014] **Sectional curvature of polygonal complexes with planar substructures** [[paper](https://arxiv.org/abs/1407.4024)]
- [2014] **Strong local-global compatibility in the p-adic Langlands program for U(2)** [[paper](https://arxiv.org/abs/1406.1828)]
- [2014] **On the reduction modulo p of representations of a quaternion division algebra over a p-adic field** [[paper](https://arxiv.org/abs/1405.0463)]
- [2014] **On distance two in Cayley graphs of Coxeter groups** [[paper](https://arxiv.org/abs/1404.1479)]
- [2014] **Local heuristics and an exact formula for abelian surfaces over finite fields** [[paper](https://arxiv.org/abs/1403.3037)]
- [2014] **Relative expanders** [[paper](https://arxiv.org/abs/1402.1481)]
- [2014] **Group approximation in Cayley topology and coarse geometry, Part III: Geometric property (T)** [[paper](https://arxiv.org/abs/1402.5105)]
- [2014] **Two-sided Cayley graphs** [[paper](https://arxiv.org/abs/1401.2741)]
- [2014] **L'espace symétrique de Drinfeld et correspondance de Langlands locale I** [[paper](https://arxiv.org/abs/1401.0530)]
- [2014] **Farey map, Diophantine approximation and Bruhat-Tits tree** [[paper](https://arxiv.org/abs/1401.5866)]
- [2014] **The zeros of the Riemann-zeta function and the transition from pseudo-random to harmonic behavior** [[paper](https://arxiv.org/abs/1401.3620)]

##### 2013

- [2013] **Expanders, exact crossed products, and the Baum-Connes conjecture** [[paper](https://arxiv.org/abs/1311.2343)]
- [2013] **A few remarks on the octopus inequality and Aldous' spectral gap conjecture** [[paper](https://arxiv.org/abs/1310.6156)]
- [2013] **Automorphisms of Cayley graphs on generalised dicyclic groups** [[paper](https://arxiv.org/abs/1310.0618)]
- [2013] **Semi-equivelar maps on the surface of Euler characteristic -1** [[paper](https://arxiv.org/abs/1310.5219)]
- [2013] **On a canonical construction of tesselated surfaces via finite group theory, Part II** [[paper](https://arxiv.org/abs/1310.3871)]
- [2013] **On a canonical construction of tesselated surfaces via finite group theory, Part I** [[paper](https://arxiv.org/abs/1310.3848)]
- [2013] **On Solving Some Trigonometric Series** [[paper](https://arxiv.org/abs/1308.2626)]
- [2013] **On the Sato-Tate conjecture for non-generic abelian surfaces** [[paper](https://arxiv.org/abs/1307.6478)]
- [2013] **Rectifiers and the local Langlands correspondence: the unramified case** [[paper](https://arxiv.org/abs/1307.0469)]
- [2013] **Simple zeros of modular L-functions** [[paper](https://arxiv.org/abs/1306.0854)]
- [2013] **Analytic expanding circle maps with explicit spectra** [[paper](https://arxiv.org/abs/1306.0445)]
- [2013] **Numerical Verification of the Ternary Goldbach Conjecture up to 8.875e30** [[paper](https://arxiv.org/abs/1305.3062)]
- [2013] **The Riemann hypothesis proved** [[paper](https://arxiv.org/abs/1305.6845)]

##### 2012

- [2012] **Sato-Tate groups of some weight 3 motives** [[paper](https://arxiv.org/abs/1212.0256)]
- [2012] **A torsion Jacquet--Langlands correspondence** [[paper](https://arxiv.org/abs/1212.3847)]
- [2012] **The highest lowest zero of general L-functions** [[paper](https://arxiv.org/abs/1211.5996)]
- [2012] **Simple zeros of primitive Dirichlet L-functions and the asymptotic large sieve** [[paper](https://arxiv.org/abs/1211.6725)]
- [2012] **An infinite family of tight triangulations of manifolds** [[paper](https://arxiv.org/abs/1210.1045)]
- [2012] **A classification of the irreducible mod-p representations of U(1,1)(Q_p^2/Q_p)** [[paper](https://arxiv.org/abs/1210.0646)]
- [2012] **Transfer operator for the Gauss' continued fraction map. I. Structure of the eigenvalues and trace formulas** [[paper](https://arxiv.org/abs/1210.4083)]
- [2012] **Poincaré series for non-Riemannian locally symmetric spaces** [[paper](https://arxiv.org/abs/1209.4075)]
- [2012] **A Real Groups Construction of the Tame Local Langlands Correspondence for PGSp(4,F)** [[paper](https://arxiv.org/abs/1209.6045)]
- [2012] **A positive answer to the Riemann hypothesis: A new result predicting the location of zeros** [[paper](https://arxiv.org/abs/1210.1517)]
- [2012] **A footnote on Expanding maps** [[paper](https://arxiv.org/abs/1207.3982)]
- [2012] **Infinite Dimensional Forward-Backward Stochastic Differential Equations and the KPZ Equation** [[paper](https://arxiv.org/abs/1207.5568)]
- [2012] **Distance Powers and Distance Matrices of Integral Cayley Graphs over Abelian Groups** [[paper](https://arxiv.org/abs/1206.4398)]
- [2012] **Distinct zeros and simple zeros of Dirichlet L-functions** [[paper](https://arxiv.org/abs/1206.1679)]
- [2012] **Exponential sums with Dirichlet coefficients of L-functions** [[paper](https://arxiv.org/abs/1206.5039)]
- [2012] **Prequantum transfer operator for symplectic Anosov diffeomorphism** [[paper](https://arxiv.org/abs/1206.0282)]
- [2012] **Locally trivial torsors that are not Weil-Châtelet divisible** [[paper](https://arxiv.org/abs/1206.2420)]
- [2012] **Spectral properties of unitary Cayley graphs of finite commutative rings** [[paper](https://arxiv.org/abs/1205.5932)]
- [2012] **Expanders graphs and sieving in combinatorial structures** [[paper](https://arxiv.org/abs/1205.0631)]
- [2012] **A finite field hypergeometric function associated to eigenvalues of a Siegel eigenform** [[paper](https://arxiv.org/abs/1205.1006)]
- [2012] **Formes modulaires modulo 2 : l'ordre de nilpotence des opérateurs de Hecke** [[paper](https://arxiv.org/abs/1204.1036)]
- [2012] **Goldbach's Problem in Primes with Binary Expansions of a Special Form** [[paper](https://arxiv.org/abs/1204.4605)]
- [2012] **A Tight Linearization Strategy for Zero-One Quadratic Programming Problems** [[paper](https://arxiv.org/abs/1204.4562)]
- [2012] **Anosov Flows and Dynamical Zeta Functions** [[paper](https://arxiv.org/abs/1203.0904)]
- [2012] **Generators for modules of vector-valued Picard modular forms** [[paper](https://arxiv.org/abs/1202.0131)]
- [2012] **Perturbation of zeros of the Selberg zeta-function for Γ_0(4)** [[paper](https://arxiv.org/abs/1201.2324)]

##### 2011

- [2011] **The measurable Kesten theorem** [[paper](https://arxiv.org/abs/1111.2080)]
- [2011] **Weil-étale Cohomology over p-adic Fields** [[paper](https://arxiv.org/abs/1111.6710)]
- [2011] **Regular graphs of large girth and arbitrary degree** [[paper](https://arxiv.org/abs/1110.5259)]
- [2011] **Sato-Tate distributions and Galois endomorphism modules in genus 2** [[paper](https://arxiv.org/abs/1110.6638)]
- [2011] **An algebraic Sato-Tate group and Sato-Tate conjecture** [[paper](https://arxiv.org/abs/1109.4449)]
- [2011] **Trace formulas of the Hecke operator on the spaces of newforms** [[paper](https://arxiv.org/abs/1108.4774)]
- [2011] **Lee-Yang-Fisher zeros for DHL and 2D rational dynamics, II. Global Pluripotential Interpretation** [[paper](https://arxiv.org/abs/1107.5764)]
- [2011] **On Hilbert-Polya conjecture: Hermitian operator naturally associated to L-functions** [[paper](https://arxiv.org/abs/1105.1500)]
- [2011] **L^2-Betti Numbers of Locally Compact Groups** [[paper](https://arxiv.org/abs/1104.3294)]
- [2011] **Hecke operators on differential modular forms mod p** [[paper](https://arxiv.org/abs/1104.0129)]
- [2011] **The local Langlands correspondence for GL_n in families** [[paper](https://arxiv.org/abs/1104.0321)]
- [2011] **Aspherical groups and manifolds with extreme properties** [[paper](https://arxiv.org/abs/1103.3873)]
- [2011] **Period functions for Hecke triangle groups, and the Selberg zeta function as a Fredholm determinant** [[paper](https://arxiv.org/abs/1103.5235)]
- [2011] **Finite generation conjectures for cohomology over finite fields** [[paper](https://arxiv.org/abs/1103.5544)]
- [2011] **Channel Assignment via Fast Zeta Transform** [[paper](https://arxiv.org/abs/1103.2275)]
- [2011] **Uniform Embeddability into Hilbert Space** [[paper](https://arxiv.org/abs/1101.0951)]
- [2011] **Some Semi - Equivelar Maps** [[paper](https://arxiv.org/abs/1101.0671)]
- [2011] **Decomposition theorems for Hilbert modular newforms** [[paper](https://arxiv.org/abs/1101.3344)]

##### 2010

- [2010] **Higher index theory for certain expanders and Gromov monster groups I** [[paper](https://arxiv.org/abs/1012.4150)]
- [2010] **The Prime Geodesic Theorem** [[paper](https://arxiv.org/abs/1011.5486)]
- [2010] **Symmetries of the transfer operator for Γ_0(N) and a character deformation of the Selberg zeta function for Γ_0(4)** [[paper](https://arxiv.org/abs/1011.4441)]
- [2010] **On the Local Langlands Correspondences of DeBacker/Reeder and Reeder for GL(\ell,F), where \ell is prime** [[paper](https://arxiv.org/abs/1010.6059)]
- [2010] **Combinatorics of finite abelian groups and Weil representations** [[paper](https://arxiv.org/abs/1010.3528)]
- [2010] **Expander graphs from Curtis Tits groups** [[paper](https://arxiv.org/abs/1009.0667)]
- [2010] **Supplemental material to the article "Partitions of the triangles of the cross polytope into surfaces''** [[paper](https://arxiv.org/abs/1009.2640)]
- [2010] **Partitioning the triangles of the cross polytope into surfaces** [[paper](https://arxiv.org/abs/1009.2642)]
- [2010] **Lee-Yang zeros for DHL and 2D rational dynamics, I. Foliation of the physical cylinder** [[paper](https://arxiv.org/abs/1009.4691)]
- [2010] **Endoscopy and the automorphic tensor product on the unitary group** [[paper](https://arxiv.org/abs/1007.0356)]
- [2010] **A generalization of the Artin-Tate formula for fourfolds** [[paper](https://arxiv.org/abs/1007.1310)]
- [2010] **An Inaccessible Graph** [[paper](https://arxiv.org/abs/1006.3852)]
- [2010] **Un cas simple de correspondance de Jacquet-Langlands modulo l** [[paper](https://arxiv.org/abs/1006.5371)]
- [2010] **On the Weil-étale cohomology of number fields** [[paper](https://arxiv.org/abs/1006.0521)]
- [2010] **Congruent number and Elliptic curves** [[paper](https://arxiv.org/abs/1003.4813)]
- [2010] **Expansion in SL_d(O_K/I), I square-free** [[paper](https://arxiv.org/abs/1001.3664)]
- [2010] **Growth in finite simple groups of Lie type** [[paper](https://arxiv.org/abs/1001.4556)]
- [2010] **Equivelar and d-Covered Triangulations of Surfaces. II. Cyclic Triangulations and Tessellations** [[paper](https://arxiv.org/abs/1001.2779)]
- [2010] **Non vanishing of Central values of modular L-functions for Hecke eigenforms of level one** [[paper](https://arxiv.org/abs/1001.5181)]
- [2010] **A Subconvexity Bound for Automorphic L-functions for SL(3,Z)** [[paper](https://arxiv.org/abs/1001.2910)]

##### 2009

- [2009] **Perturbations of L-functions with or without non-trivial zeros off the critical line** [[paper](https://arxiv.org/abs/0911.5135)]
- [2009] **Notes on the Zeros of Riemann's Zeta Function** [[paper](https://arxiv.org/abs/0911.1332)]
- [2009] **An equation satisfied by all non-trivial zeros ρ of the Riemann zeta function ζ** [[paper](https://arxiv.org/abs/0911.5572)]
- [2009] **Quotient Representations of Uniform Tilings** [[paper](https://arxiv.org/abs/0910.4207)]
- [2009] **The trace of Hecke operators on the space of classical holomorphic Siegel modular forms of genus two** [[paper](https://arxiv.org/abs/0909.1744)]
- [2009] **Strong homotopy types, nerves and collapses** [[paper](https://arxiv.org/abs/0907.2954)]
- [2009] **The Sato-Tate conjecture for modular forms of weight 3** [[paper](https://arxiv.org/abs/0906.0614)]
- [2009] **A Brief note on the Riemann hypothesis** [[paper](https://arxiv.org/abs/0906.1099)]
- [2009] **Discrete Components of Some Complementary Series (II)** [[paper](https://arxiv.org/abs/0905.3140)]
- [2009] **Semigroups of locally injective maps and transfer operators** [[paper](https://arxiv.org/abs/0905.2778)]
- [2009] **Cayley graphs on the symmetric group generated by initial reversals have unit spectral gap** [[paper](https://arxiv.org/abs/0904.1800)]
- [2009] **On arithmetic in Mordell-Weil groups** [[paper](https://arxiv.org/abs/0904.2848)]
- [2009] **The ternary Goldbach problem with arithmetic weights attached to two of the variables** [[paper](https://arxiv.org/abs/0904.3526)]
- [2009] **The binary Goldbach problem with arithmetic weights attached to one of the variables** [[paper](https://arxiv.org/abs/0903.3128)]
- [2009] **Concerning Riemann Hypothesis** [[paper](https://arxiv.org/abs/0903.3973)]
- [2009] **The subconvexity problem for \GL_{2}** [[paper](https://arxiv.org/abs/0903.3591)]
- [2009] **On the eigenvalues of Cayley graphs on the symmetric group generated by a complete multipartite set of transpositions** [[paper](https://arxiv.org/abs/0902.0727)]
- [2009] **Trading degree for dimension in the section conjecture: The non-abelian Shapiro Lemma** [[paper](https://arxiv.org/abs/0902.1653)]
- [2009] **The ternary Goldbach problem with primes from arithmetic progressions** [[paper](https://arxiv.org/abs/0902.2669)]
- [2009] **Binary Additive Problems: Theorems of Landau and Hardy-Littlwood Type** [[paper](https://arxiv.org/abs/0902.1046)]
- [2009] **Is the critical percolation probability local?** [[paper](https://arxiv.org/abs/0901.4616)]
- [2009] **Binary Additive Problems: Recursions for Numbers of Representations** [[paper](https://arxiv.org/abs/0901.3102)]

##### 2008

- [2008] **Ternary Goldbach's Problem Involving Primes of a Special Type** [[paper](https://arxiv.org/abs/0812.4606)]
- [2008] **On k-free-like groups** [[paper](https://arxiv.org/abs/0811.1607)]
- [2008] **On the Distribution of the Euler Function of Shifted Smooth Numbers** [[paper](https://arxiv.org/abs/0810.1093)]
- [2008] **An upper bound on the number of zeros of a piecewise polinomial function** [[paper](https://arxiv.org/abs/0810.2634)]
- [2008] **Cayley Graph Expanders and Groups of Finite Width** [[paper](https://arxiv.org/abs/0809.1560)]
- [2008] **Jump transformations and an embedding of {\cal O}_{\infty} into {\cal O}_{2}** [[paper](https://arxiv.org/abs/0809.4800)]
- [2008] **Weighted sum formula for multiple zeta values** [[paper](https://arxiv.org/abs/0809.5110)]
- [2008] **Cerny's conjecture, synchronizing automata, group representation theory** [[paper](https://arxiv.org/abs/0808.1429)]
- [2008] **The local Langlands conjecture for Sp(4)** [[paper](https://arxiv.org/abs/0805.2731)]
- [2008] **Hyperelliptic curves, L-polynomials, and random matrices** [[paper](https://arxiv.org/abs/0803.4462)]
- [2008] **Differentiating polynomials, and zeta(2)** [[paper](https://arxiv.org/abs/0803.3592)]
- [2008] **Trimmed Moebius Inversion and Graphs of Bounded Degree** [[paper](https://arxiv.org/abs/0802.2834)]

##### 2007

- [2007] **Character sums to smooth moduli are small** [[paper](https://arxiv.org/abs/0712.1574)]
- [2007] **The cycle problem: an intriguing periodicity to the zeros of the Riemann zeta function** [[paper](https://arxiv.org/abs/0712.0934)]
- [2007] **Explicit matrices for Hecke operators on Siegel modular forms** [[paper](https://arxiv.org/abs/0711.1747)]
- [2007] **Hecke operators on Hilbert-Siegel modular forms** [[paper](https://arxiv.org/abs/0710.4224)]
- [2007] **Renewal-type Limit Theorem for the Gauss Map and Continued Fractions** [[paper](https://arxiv.org/abs/0710.1283)]
- [2007] **A Numerical Algorithm for Zero Counting. I: Complexity and Accuracy** [[paper](https://arxiv.org/abs/0710.4508)]
- [2007] **Theta Series Associated with the Weil-Schroedinger Representation** [[paper](https://arxiv.org/abs/0709.0071)]
- [2007] **Semilocal convergence of two iterative methods for simultaneous computation of polynomial zeros** [[paper](https://arxiv.org/abs/0709.1068)]
- [2007] **A Remark on the Conjectures of Lang-Trotter and Sato-Tate on Average** [[paper](https://arxiv.org/abs/0708.2535)]
- [2007] **Equality of Lifshitz and van Hove exponents on amenable Cayley graphs** [[paper](https://arxiv.org/abs/0706.2844)]
- [2007] **Chen's double sieve, Goldbach's conjecture and the twin prime problem** [[paper](https://arxiv.org/abs/0705.1652)]
- [2007] **On the Riemann zeta-function, Parts IV-V** [[paper](https://arxiv.org/abs/0705.4593)]
- [2007] **On the Riemann zeta-function, Part I: Outline** [[paper](https://arxiv.org/abs/0705.1854)]
- [2007] **On the Riemann zeta-function, Part III** [[paper](https://arxiv.org/abs/0705.2995)]
- [2007] **The Weil representation and Hecke operators for vector valued modular forms** [[paper](https://arxiv.org/abs/0704.1868)]
- [2007] **Global Jacquet-Langlands correspondence, multiplicity one and classification of automorphic representations** [[paper](https://arxiv.org/abs/0704.2920)]
- [2007] **A Weil pairing on the p-torsion of ordinary elliptic curves over the dual numbers of K** [[paper](https://arxiv.org/abs/math/0703906)]

##### 2006

- [2006] **Sato--Tate, cyclicity, and divisibility statistics on average for elliptic curves of small height** [[paper](https://arxiv.org/abs/math/0609144)]
- [2006] **The Sato-Tate Conjecture on Average for Small Angles** [[paper](https://arxiv.org/abs/math/0608318)]
- [2006] **Differential eigenforms** [[paper](https://arxiv.org/abs/math/0606701)]
- [2006] **Escape from a circle and Riemann hypotheses** [[paper](https://arxiv.org/abs/math/0603373)]

##### 2005

- [2005] **Finite Simple Groups as Expanders** [[paper](https://arxiv.org/abs/math/0510562)]
- [2005] **Weight decompositions on etale fundamental groups** [[paper](https://arxiv.org/abs/math/0510245)]
- [2005] **Degree-regular triangulations of the double-torus** [[paper](https://arxiv.org/abs/math/0508106)]
- [2005] **A q-analogue of Lehmer's congruence** [[paper](https://arxiv.org/abs/math/0507511)]
- [2005] **Triangulated Manifolds with Few Vertices: Vertex-Transitive Triangulations I** [[paper](https://arxiv.org/abs/math/0506520)]
- [2005] **Fredholm determinants, Anosov maps and Ruelle resonances** [[paper](https://arxiv.org/abs/math/0505049)]
- [2005] **Hecke actions on certain strongly modular genera of lattices** [[paper](https://arxiv.org/abs/math/0503447)]
- [2005] **Diameters of Cayley graphs of SL_n(Z/kZ)** [[paper](https://arxiv.org/abs/math/0502221)]
- [2005] **Universal lattices and unbounded rank expanders** [[paper](https://arxiv.org/abs/math/0502237)]
- [2005] **Elliptic K3 surfaces with geometric Mordell-Weil rank 15** [[paper](https://arxiv.org/abs/math/0502439)]

##### 2004

- [2004] **On the nonvanishing of elliptic curve L-functions at the central point** [[paper](https://arxiv.org/abs/math/0412464)]
- [2004] **Simple Permutations Mix Even Better** [[paper](https://arxiv.org/abs/math/0411098)]
- [2004] **Hypercube embedding of Wythoffians** [[paper](https://arxiv.org/abs/math/0407527)]
- [2004] **Li Coefficients for Automorphic L-Functions** [[paper](https://arxiv.org/abs/math/0404394)]
- [2004] **Weil-etale cohomology over finite fields** [[paper](https://arxiv.org/abs/math/0404425)]
- [2004] **Numerical algorithms for the real zeros of hypergeometric functions** [[paper](https://arxiv.org/abs/math/0401116)]

##### 2003

- [2003] **Kazhdan Constants for SL_n(Z)** [[paper](https://arxiv.org/abs/math/0311487)]
- [2003] **On the spectrum of Farey and Gauss maps** [[paper](https://arxiv.org/abs/math/0308017)]
- [2003] **New results based on Riemann hypothesis is tenable** [[paper](https://arxiv.org/abs/math/0307160)]
- [2003] **Computing sharp and scalable bounds on errors in approximate zeros of univariate polynomials** [[paper](https://arxiv.org/abs/cs/0306015)]
- [2003] **A Local-global Summation Formula for Abelian Varieties** [[paper](https://arxiv.org/abs/math/0302266)]

##### 2002

- [2002] **A strengthening of the Nyman-Beurling criterion for the Riemann hypothesis, 2** [[paper](https://arxiv.org/abs/math/0205003)]
- [2002] **Weil-etale motivic cohomology** [[paper](https://arxiv.org/abs/math/0205337)]
- [2002] **A strengthening of the Nyman-Beurling criterion for the Riemann Hypothesis** [[paper](https://arxiv.org/abs/math/0202141)]
- [2002] **The non-amenability of Schreier graphs for infinite index quasiconvex subgroups of hyperbolic groups** [[paper](https://arxiv.org/abs/math/0201076)]

[⬆ Back to top](#paper-list)

#### Spectral Gaps

##### 2026

- [2026] **Near optimal spectral gaps for line bundles on hyperbolic three-manifolds** [[paper](https://arxiv.org/abs/2608.00386)]
- [2026] **Cheeger-type inequalities for the second largest spectral gap from 1 of the normalized Laplacian** [[paper](https://arxiv.org/abs/2606.08061)]
- [2026] **A Proof of the Riemann Hypothesis via Even Dominance of the Weil Quadratic Form** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.19536076)]
- [2026] **Partial-Fraction Constraints on Hypothetical Off-Line Zeros of the Riemann Zeta Function** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.19205813)]
- [2026] **The Chain: Hurwitz Convergence from Finite Primes to Zeta Zeros via the Connes–van Suijlekom Construction** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.18919629)]
- [2026] **Information-Geometric Confinement of Riemann Zeros: Spectral Rigidity from Fisher Quantization on the Bures Manifold** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.19354342)]
- [2026] **Spinel: A Post-Quantum Signature Scheme Based on SL_n(\mathbb{F}_p) Hashing** [[paper](https://arxiv.org/abs/2602.09882)]

##### 2025

- [2025] **Geometric property (T) for box spaces and sofic approximations** [[paper](https://arxiv.org/abs/2511.16515)]
- [2025] **Skeletons and Spectra: Bernoulli graphings are relatively Ramanujan** [[paper](https://arxiv.org/abs/2510.13323)]
- [2025] **Cocycle stability in permutations of random simplicial complexes** [[paper](https://arxiv.org/abs/2509.21566)]
- [2025] **Expansion of Integer Matrices over Various Rings** [[paper](https://arxiv.org/abs/2509.17823)]
- [2025] **Lie type quotients of the maximal unipotent subgroup of Kac-Moody groups of type HB_{2}^{(2)}** [[paper](https://arxiv.org/abs/2508.08070)]
- [2025] **Hausdorff Dimension of non-conical and Myrberg limit sets** [[paper](https://arxiv.org/abs/2506.04955)]
- [2025] **New cosystolic high-dimensional expanders from KMS groups** [[paper](https://arxiv.org/abs/2504.05823)]
- [2025] **Explicit Lossless Vertex Expanders** [[paper](https://arxiv.org/abs/2504.15087)]
- [2025] **Inducing spectral gaps for the cohomological Laplacians of \operatorname{Sp}_{2n}(\mathbb{Z})** [[paper](https://arxiv.org/abs/2504.16625)]
- [2025] **Non-geometric property (T) of warped cones** [[paper](https://arxiv.org/abs/2503.04578)]
- [2025] **Exponentially slow thermalization in 1D fragmented dynamics** [[paper](https://arxiv.org/abs/2501.13930)]

##### 2024

- [2024] **Minimal Submanifolds and Waists of Locally Symmetric Spaces** [[paper](https://arxiv.org/abs/2412.01510)]
- [2024] **Coboundary expansion of coset complexes** [[paper](https://arxiv.org/abs/2411.02819)]
- [2024] **Topological expanders, coarse geometry and thick embeddings of complexes** [[paper](https://arxiv.org/abs/2411.13294)]
- [2024] **Coboundary expansion inside Chevalley coset complex HDXs** [[paper](https://arxiv.org/abs/2411.05916)]
- [2024] **Expanders and growth of normal subsets in finite simple groups of Lie type** [[paper](https://arxiv.org/abs/2406.12506)]
- [2024] **Small-ball estimates for random walks on groups** [[paper](https://arxiv.org/abs/2406.17587)]
- [2024] **Inducing spectral gaps for the cohomological Laplacians of \operatorname{SL}_n(\mathbb{Z}) and \operatorname{SAut}(F_n)** [[paper](https://arxiv.org/abs/2404.10287)]
- [2024] **High-dimensional expansion and soficity of groups** [[paper](https://arxiv.org/abs/2403.09582)]
- [2024] **Low Acceptance Agreement Tests via Bounded-Degree Symplectic HDXs** [[paper](https://arxiv.org/abs/2402.01078)]
- [2024] **High-dimensional expanders from Kac--Moody--Steinberg groups** [[paper](https://arxiv.org/abs/2401.05197)]

##### 2023

- [2023] **Stability of Homomorphisms, Coverings and Cocycles II: Examples, Applications and Open problems** [[paper](https://arxiv.org/abs/2311.06706)]
- [2023] **Coboundary expansion and Gromov hyperbolicity** [[paper](https://arxiv.org/abs/2309.06215)]
- [2023] **Homological algebra and poset versions of the Garland method** [[paper](https://arxiv.org/abs/2308.00972)]
- [2023] **New Codes on High Dimensional Expanders** [[paper](https://arxiv.org/abs/2308.15563)]
- [2023] **The natural flow and the critical exponent** [[paper](https://arxiv.org/abs/2302.12665)]

##### 2022

- [2022] **Computation of Laplacian eigenvalues of two-dimensional shapes with dihedral symmetry** [[paper](https://arxiv.org/abs/2210.13229)]
- [2022] **Boundary rigidity of Gromov hyperbolic spaces** [[paper](https://arxiv.org/abs/2209.03747)]
- [2022] **Quantitative nonembeddability of groups of polynomial growth into uniformly convex spaces** [[paper](https://arxiv.org/abs/2207.11305)]
- [2022] **High-Dimensional Expanders from Chevalley Groups** [[paper](https://arxiv.org/abs/2203.03705)]

##### 2021

- [2021] **Nilpotent groups and biLipschitz embeddings into L^1** [[paper](https://arxiv.org/abs/2112.11402)]
- [2021] **n-Kazhdan groups and higher spectral expanders** [[paper](https://arxiv.org/abs/2112.09431)]
- [2021] **Higher dimensional digraphs from cube complexes and their spectral theory** [[paper](https://arxiv.org/abs/2111.09120)]
- [2021] **Property {A} and duality in linear programming** [[paper](https://arxiv.org/abs/2109.04891)]
- [2021] **On Distribution of Laplacian Eigenvalues of Graphs** [[paper](https://arxiv.org/abs/2107.09161)]

##### 2020

- [2020] **Constructing highly regular expanders from hyperbolic Coxeter groups** [[paper](https://arxiv.org/abs/2009.08548)]
- [2020] **An Alon-Boppana theorem for powered graphs and generalized Ramanujan graphs** [[paper](https://arxiv.org/abs/2006.11248)]
- [2020] **Expanders and right-angled Artin groups** [[paper](https://arxiv.org/abs/2005.06143)]
- [2020] **From the coarse geometry of warped cones to the measured coupling of groups** [[paper](https://arxiv.org/abs/2004.10000)]

##### 2019

- [2019] **Free flags over local rings and powering of high dimensional expanders** [[paper](https://arxiv.org/abs/1909.02473)]
- [2019] **Random growth on a Ramanujan graph** [[paper](https://arxiv.org/abs/1908.09575)]
- [2019] **Coboundary and cosystolic expansion from strong symmetry** [[paper](https://arxiv.org/abs/1907.01259)]

##### 2018

- [2018] **Expansion in simple groups** [[paper](https://arxiv.org/abs/1807.03879)]

##### 2017

- [2017] **High Dimensional Expanders** [[paper](https://arxiv.org/abs/1712.02526)]
- [2017] **The fundamental Laplacian eigenvalue of the regular polygon with Dirichlet boundary conditions** [[paper](https://arxiv.org/abs/1712.06082)]
- [2017] **High dimensional expanders and coset geometries** [[paper](https://arxiv.org/abs/1710.05304)]
- [2017] **Rigidity of warped cones and coarse geometry of expanders** [[paper](https://arxiv.org/abs/1710.03085)]
- [2017] **Gromov's random monsters do not act non-elementarily on hyperbolic spaces** [[paper](https://arxiv.org/abs/1705.10258)]

##### 2015

- [2015] **A splitting theorem for good complexifications** [[paper](https://arxiv.org/abs/1503.08006)]

##### 2014

- [2014] **Isoperimetric Inequalities for Ramanujan Complexes and Topological Expanders** [[paper](https://arxiv.org/abs/1409.1397)]
- [2014] **Ramanujan Complexes and bounded degree topological expanders** [[paper](https://arxiv.org/abs/1408.6351)]
- [2014] **Approximation properties for noncommutative L^p-spaces of high rank lattices and nonembeddability of expanders** [[paper](https://arxiv.org/abs/1403.6415)]

##### 2013

- [2013] **Geometric Property (T)** [[paper](https://arxiv.org/abs/1311.6197)]
- [2013] **Boundary values, random walks and \ell^p-cohomology in degree one** [[paper](https://arxiv.org/abs/1303.4091)]
- [2013] **Ramanujan Complexes and High Dimensional Expanders** [[paper](https://arxiv.org/abs/1301.1028)]

##### 2012

- [2012] **A generalization of expander graphs and local reflexivity of uniform Roe algebras** [[paper](https://arxiv.org/abs/1208.5642)]
- [2012] **The maximal coarse Baum-Connes conjecture for spaces which admit a fibred coarse embedding into Hilbert space** [[paper](https://arxiv.org/abs/1208.4543)]

##### 2011

- [2011] **Expanders and Property A** [[paper](https://arxiv.org/abs/1108.6232)]

##### 2010

- [2010] **Poincaré inequalities, embeddings, and wild groups** [[paper](https://arxiv.org/abs/1005.4084)]

##### 2007

- [2007] **Cheeger constants of surfaces and isoperimetric inequalities** [[paper](https://arxiv.org/abs/0706.4449)]

##### 2005

- [2005] **Cheeger constant and algebraic entropy of linear groups** [[paper](https://arxiv.org/abs/math/0507441)]
- [2005] **Sparse equidistribution problems, period bounds, and subconvexity** [[paper](https://arxiv.org/abs/math/0506224)]

##### 2003

- [2003] **L^2-Betti Numbers of Discrete Measured Groupoids** [[paper](https://arxiv.org/abs/math/0312411)]

[⬆ Back to top](#paper-list)

#### Ramanujan Property

##### 2024

- [2024] **On the generalized Dirichlet beta and Riemann zeta functions and Ramanujan-type formulae for beta and zeta values** [[paper](https://arxiv.org/abs/2405.03294)]

##### 2022

- [2022] **Hybrid subconvexity and the partition function** [[paper](https://arxiv.org/abs/2204.14196)]

##### 2020

- [2020] **Riemann Hypothesis, Modified Morse Potential and Supersymmetric Quantum Mechanics** [[paper](https://arxiv.org/abs/2002.12825)]

##### 2018

- [2018] **Weak subconvexity without a Ramanujan hypothesis** [[paper](https://arxiv.org/abs/1804.03654)]

##### 2015

- [2015] **Koshliakov kernel and identities involving the Riemann zeta function** [[paper](https://arxiv.org/abs/1505.01552)]

##### 2014

- [2014] **Subconvexity for sup-norms of automorphic forms on PGL(n)** [[paper](https://arxiv.org/abs/1405.6691)]

##### 2013

- [2013] **Explicit formulas of a generalized Ramanujan sum** [[paper](https://arxiv.org/abs/1311.2816)]

##### 2008

- [2008] **Sums of Zeros for Certain Special Functions** [[paper](https://arxiv.org/abs/0804.4210)]

##### 2005

- [2005] **Series acceleration formulas for Dirichlet series with periodic coefficients** [[paper](https://arxiv.org/abs/math/0505078)]

[⬆ Back to top](#paper-list)

#### Brandt & Pizer Matrices

##### 2026

- [2026] **On the Spectral theory of Isogeny Graphs and Quantum Sampling of Secure Supersingular Elliptic curves** [[paper](https://arxiv.org/abs/2602.02263)]

[⬆ Back to top](#paper-list)

### Number Theory

#### Hecke Operators

##### 2026

- [2026] **Universality for Random p-adic Polynomials and Random Matrices Via the Resultant Distribution Method** [[paper](https://arxiv.org/abs/2608.06576)]
- [2026] **Hybrid Weyl Subconvexity over Imaginary Quadratic Fields** [[paper](https://arxiv.org/abs/2608.05934)]
- [2026] **A proof of Riemann's hypothesis via Hadamard-Weierstrass factorization** [[paper](https://arxiv.org/abs/2607.04338)]
- [2026] **Quadratic residue patterns of length 4 and 5** [[paper](https://arxiv.org/abs/2607.17418)]
- [2026] **The Riemann Hypothesis as a Symmetry Requirement of the Physical Vacuum** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.21285829)]
- [2026] **The Read-Budget of an L-Function √(Analytic Conductor) as the Universal Cost of a Read, from Elliptic Curves to the Critical Line — with the Rank, the Coefficient, and the Conductor Sorted into Their Layers** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.21277034)]
- [2026] **Counting the number of 1_{m}-preperiodic \mathcal{O}_{K}-points of a discrete dynamical system with applications from arithmetic statistics, VII** [[paper](https://arxiv.org/abs/2606.14468)]
- [2026] **Products of prime ideals in ray class groups** [[paper](https://arxiv.org/abs/2606.30567)]
- [2026] **A new perspective on the rank of Mazur's Eisenstein Hecke algebra** [[paper](https://arxiv.org/abs/2605.04195)]
- [2026] **Graphs of Hecke operators in mixed ramification** [[paper](https://arxiv.org/abs/2605.13824)]
- [2026] **Classicality for Hilbert modular forms** [[paper](https://arxiv.org/abs/2605.18426)]
- [2026] **On the computation of base-change lifts and lifts of Hida families** [[paper](https://arxiv.org/abs/2604.05618)]
- [2026] **Effective Joint Sato-Tate Distribution and Sign Change of Symmetric Power Coefficients** [[paper](https://arxiv.org/abs/2604.17532)]
- [2026] **Joint Sato-Tate Laws for Transformations of Hecke Eigenvalues: The Vertical Case** [[paper](https://arxiv.org/abs/2604.24753)]
- [2026] **DCCP-Riemann: Computational Verifications** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.21336960)]
- [2026] **Phase Structure of Fisher Information at Riemann Zeros** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.19387248)]
- [2026] **Eigenforms and graphs of Hecke operators with wild ramification** [[paper](https://arxiv.org/abs/2603.15931)]
- [2026] **On the satisfaction frequency of spectral characterization conditions** [[paper](https://arxiv.org/abs/2603.26932)]
- [2026] **Composition of random functions and word reconstruction** [[paper](https://arxiv.org/abs/2603.28936)]
- [2026] **Murmurations: a case study in AI-assisted mathematics** [[paper](https://arxiv.org/abs/2603.09680)]
- [2026] **Sharp threshold for universality of cokernels of classical random matrix models over the p-adic integers** [[paper](https://arxiv.org/abs/2603.12879)]
- [2026] **Holographic Equidistribution** [[paper](https://arxiv.org/abs/2602.12265)]
- [2026] **Mixed fourth moments of automorphic forms and the shifted moments of L-functions** [[paper](https://arxiv.org/abs/2601.00660)]
- [2026] **Hecke operators, Hecke Eigensystems, and Formal Modular Forms over Number Fields** [[paper](https://arxiv.org/abs/2601.17524)]
- [2026] **Matrix Kloosterman Sums, Random Matrix Statistics, and Cryptography** [[paper](https://arxiv.org/abs/2601.01603)]
- [2026] **On the pointwise convergence of the number of abelian varieties over \mathbb{F}_p with fixed trace** [[paper](https://arxiv.org/abs/2601.20824)]
- [2026] **Exact cospectrality probabilities for uniform random matrices** [[paper](https://arxiv.org/abs/2602.00233)]
- [2026] **Categorification of local relative Langlands duality** [[paper](https://arxiv.org/abs/2601.02258)]

##### 2025

- [2025] **First Moment of Quadratic Hecke L-Functions with Lower Order Term** [[paper](https://arxiv.org/abs/2512.22509)]
- [2025] **Second Moment of Central Values of Half-Integral Weight Modular Forms and Subconvexity** [[paper](https://arxiv.org/abs/2512.20483)]
- [2025] **Degeneracy and Sato-Tate groups of y^2=x^{p^2}-1** [[paper](https://arxiv.org/abs/2512.03299)]
- [2025] **A Spectral Characterization of Riemann Zeros via φ-Weighted Toeplitz Matrices** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.18057718)]
- [2025] **A Self-Adjoint Operator for Riemann Zeros via φ-Weighted Toeplitz Positivity** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.18057950)]
- [2025] **Towards Keating-Snaith's conjecture for cubic Hecke L-functions over the Eisenstein field** [[paper](https://arxiv.org/abs/2511.08783)]
- [2025] **Exceptional Congruences for Eta-quotient newforms** [[paper](https://arxiv.org/abs/2511.16039)]
- [2025] **Atkin-Lehner Decompositions for Quaternionic modular forms** [[paper](https://arxiv.org/abs/2511.06584)]
- [2025] **Integrable Contour Kernels in Discrete β=1,4 Ensembles, Universality and Kuznetsov Multipliers** [[paper](https://arxiv.org/abs/2511.08356)]
- [2025] **Universality of rational canonical form for random matrices over a finite field** [[paper](https://arxiv.org/abs/2510.16225)]
- [2025] **A description of the depth-r Bernstein center for rational depths** [[paper](https://arxiv.org/abs/2510.07845)]
- [2025] **Subconvexity for Rankin Selberg L-Functions at Special Points** [[paper](https://arxiv.org/abs/2509.02223)]
- [2025] **A Hilbert 90 Property for S-Class Groups and Applications to the Gross--Kuz'min Conjecture** [[paper](https://arxiv.org/abs/2509.20144)]
- [2025] **Multiplicative Hecke operators and their application II** [[paper](https://arxiv.org/abs/2509.00720)]
- [2025] **Counting the number of m-periodic \mathcal{O}_{K}-points of a discrete dynamical system with applications from arithmetic statistics, V** [[paper](https://arxiv.org/abs/2508.16393)]
- [2025] **The complexity of Ford domains of Γ_0(N)** [[paper](https://arxiv.org/abs/2508.18511)]
- [2025] **Logarithmic Geometry and Geometric Class Field Theory** [[paper](https://arxiv.org/abs/2508.08648)]
- [2025] **Monodromy groups and exceptional Hodge classes, II: Sato-Tate groups** [[paper](https://arxiv.org/abs/2507.02535)]
- [2025] **Counting the number of n-periodic integral points of a discrete dynamical system with applications from arithmetic statistics, IV** [[paper](https://arxiv.org/abs/2507.08601)]
- [2025] **Heuristic Bounded Prime Gaps via a Chaotic Multidimensional Sieve and Random Matrix Theory** [[paper](https://arxiv.org/abs/2507.17986)]
- [2025] **Distinguishing Siegel modular forms** [[paper](https://arxiv.org/abs/2506.22264)]
- [2025] **Towards the p-adic derived Hecke algebra for weight one forms** [[paper](https://arxiv.org/abs/2506.09139)]
- [2025] **Hecke equivariance of the divisor map** [[paper](https://arxiv.org/abs/2505.01702)]
- [2025] **A simple proof of the Atkin-O'Brien partition congruence conjecture for powers of 13** [[paper](https://arxiv.org/abs/2504.10824)]
- [2025] **An algorithm to compute Selmer groups via resolutions by permutations modules** [[paper](https://arxiv.org/abs/2504.13506)]
- [2025] **On an analogue of the doubling method in coding theory** [[paper](https://arxiv.org/abs/2503.10201)]
- [2025] **Greenberg's conjecture for real quadratic number fields** [[paper](https://arxiv.org/abs/2503.00819)]
- [2025] **Murmurations and Sato-Tate Conjectures for High Rank Zetas of Elliptic Curves II: Beyond Riemann Hypothesis** [[paper](https://arxiv.org/abs/2501.10220)]
- [2025] **Hypergeometric Distributions and Joint Families of Elliptic Curves** [[paper](https://arxiv.org/abs/2501.13330)]
- [2025] **Spectral gaps on thick part of moduli spaces** [[paper](https://arxiv.org/abs/2501.09266)]

##### 2024

- [2024] **Certifying nontriviality of Ceresa classes of curves** [[paper](https://arxiv.org/abs/2412.02015)]
- [2024] **Non-Archimedean GUE corners and Hecke modules** [[paper](https://arxiv.org/abs/2412.05999)]
- [2024] **Spectral Reciprocity and Hybrid Subconvexity Bound for triple product L-functions** [[paper](https://arxiv.org/abs/2501.04022)]
- [2024] **Cancellation in sums over special sequences on \rm{GL_{m}} and their applications** [[paper](https://arxiv.org/abs/2411.06978)]
- [2024] **Mean Value for Random Ideal Lattices** [[paper](https://arxiv.org/abs/2411.14973)]
- [2024] **Indices of nilpotency in certain spaces of modular forms** [[paper](https://arxiv.org/abs/2410.24182)]
- [2024] **Certain squarefree levels of reducible modular mod\,\ell Galois representations** [[paper](https://arxiv.org/abs/2410.16854)]
- [2024] **Computations directly on the cuspidal cohomology of congruence subgroups of SL(3, \mathbb{Z})** [[paper](https://arxiv.org/abs/2410.02734)]
- [2024] **Ordinary primes in Hilbert modular varieties** [[paper](https://arxiv.org/abs/2410.01182)]
- [2024] **A weighted vertical Sato-Tate law for Maaß forms on \rm{GSp}_4** [[paper](https://arxiv.org/abs/2409.06027)]
- [2024] **The central limit theorem for entries of random matrices with specific rank over finite fields** [[paper](https://arxiv.org/abs/2409.10412)]
- [2024] **Derived structures in the Langlands Correspondence** [[paper](https://arxiv.org/abs/2409.03035)]
- [2024] **A formula for Fourier coefficients of certain eta-quotients and their expansions as Eisenstein series** [[paper](https://arxiv.org/abs/2408.09480)]
- [2024] **Dimension formulas for modular form spaces of rational weights, the classification of eta-quotient characters and an extension of Martin's theorem** [[paper](https://arxiv.org/abs/2408.00246)]
- [2024] **Traces of Hecke Operators via Hypergeometric Character Sums** [[paper](https://arxiv.org/abs/2408.02918)]
- [2024] **A random walk on the category of finite abelian p-groups** [[paper](https://arxiv.org/abs/2408.06492)]
- [2024] **Traces of Hecke operators on Drinfeld modular forms for GL_2(\mathbb{F}_q[T])** [[paper](https://arxiv.org/abs/2407.04555)]
- [2024] **A Ramanujan bound for Drinfeld modular forms** [[paper](https://arxiv.org/abs/2407.04554)]
- [2024] **Hecke Equivariance of Divisor Lifting with respect to Sesquiharmonic Maass Forms** [[paper](https://arxiv.org/abs/2407.21447)]
- [2024] **Distribution of Primitive Lattice Points in Large Dimensions** [[paper](https://arxiv.org/abs/2407.00986)]
- [2024] **Effective atypical intersections and applications to orbit closures** [[paper](https://arxiv.org/abs/2406.16628)]
- [2024] **Distribution of the Hessian values of Gaussian hypergeometric functions** [[paper](https://arxiv.org/abs/2405.16349)]
- [2024] **Ratios conjecture of quadratic Hecke L-functions of prime-related moduli** [[paper](https://arxiv.org/abs/2404.05081)]
- [2024] **Multiplicative Hecke operators and their applications** [[paper](https://arxiv.org/abs/2404.01042)]
- [2024] **Explainable Ramanujan-type Congruences on Square-Classes of Arithmetic Progressions** [[paper](https://arxiv.org/abs/2404.02672)]
- [2024] **Exceptional zeros of Rankin-Selberg L-functions and joint Sato-Tate distributions** [[paper](https://arxiv.org/abs/2404.06482)]
- [2024] **The distribution of d_4(n) in arithmetic progressions** [[paper](https://arxiv.org/abs/2404.04749)]
- [2024] **Ramanujan type congruences for quotients of Klein forms** [[paper](https://arxiv.org/abs/2403.15967)]
- [2024] **A well-motivated proof that pi is irrational** [[paper](https://arxiv.org/abs/2403.20140)]
- [2024] **p-adic rigidity of eigenforms of infinite slope** [[paper](https://arxiv.org/abs/2403.16918)]
- [2024] **Ellipsephic harmonic series revisited** [[paper](https://arxiv.org/abs/2403.05678)]
- [2024] **Real groups, symmetric varieties and Langlands duality** [[paper](https://arxiv.org/abs/2403.13995)]
- [2024] **Ratios conjecture of quartic L-functions of prime moduli** [[paper](https://arxiv.org/abs/2402.17198)]
- [2024] **On the rationalization of the K(n)-local sphere** [[paper](https://arxiv.org/abs/2402.00960)]
- [2024] **The Prime Geodesic Theorem and Bounds for Character Sums** [[paper](https://arxiv.org/abs/2402.12133)]
- [2024] **Subconvexity Implies Effective Quantum Unique Ergodicity for Hecke-Maaß Cusp Forms on SL_2(\mathbb{Z}) \backslash SL_2(\mathbb{R})** [[paper](https://arxiv.org/abs/2402.14050)]
- [2024] **Nondegeneracy and Sato-Tate Distributions of Two Families of Jacobian Varieties** [[paper](https://arxiv.org/abs/2401.06208)]

##### 2023

- [2023] **Reflecting Poisson walks and dynamical universality in p-adic random matrix theory** [[paper](https://arxiv.org/abs/2312.11702)]
- [2023] **Non-abelian base change for symmetric power liftings of holomorphic modular forms** [[paper](https://arxiv.org/abs/2312.01774)]
- [2023] **Ratios conjecture of cubic L-functions of prime moduli** [[paper](https://arxiv.org/abs/2311.08626)]
- [2023] **A note on the trace formula** [[paper](https://arxiv.org/abs/2311.03523)]
- [2023] **A lower bound for the discrepancy in a Sato-Tate type measure** [[paper](https://arxiv.org/abs/2311.18798)]
- [2023] **A general framework for the analytic Langlands correspondence** [[paper](https://arxiv.org/abs/2311.03743)]
- [2023] **Counting locally supercuspidal newforms** [[paper](https://arxiv.org/abs/2310.17047)]
- [2023] **Comparison of integral structures on the space of modular forms of full level N** [[paper](https://arxiv.org/abs/2310.18869)]
- [2023] **Refinements on vertical Sato-Tate** [[paper](https://arxiv.org/abs/2310.08791)]
- [2023] **Effective Brauer-Siegel on some curves in Y(1)^n** [[paper](https://arxiv.org/abs/2310.04943)]
- [2023] **On Effective Sato-Tate Distributions for Surfaces Arising from Products of Elliptic Curves** [[paper](https://arxiv.org/abs/2309.08848)]
- [2023] **The Ramanujan and Sato-Tate Conjectures for Bianchi modular forms** [[paper](https://arxiv.org/abs/2309.15880)]
- [2023] **The 1-Level Density for Zeros of Hecke L-Functions of Imaginary Quadratic Number Fields of Class Number 1** [[paper](https://arxiv.org/abs/2309.10018)]
- [2023] **Error term in the Cohen-Lenstra heuristic via random matrix approach** [[paper](https://arxiv.org/abs/2308.02232)]
- [2023] **Modular forms with non-vanishing central values and linear independence of Fourier coefficients** [[paper](https://arxiv.org/abs/2307.00900)]
- [2023] **First moment of central values of Hecke L-functions with Fixed Order Characters** [[paper](https://arxiv.org/abs/2306.10726)]
- [2023] **Bianchi period polynomials: Hecke action and congruences** [[paper](https://arxiv.org/abs/2306.10877)]
- [2023] **The Riemann Hypothesis for period polynomials of cusp forms** [[paper](https://arxiv.org/abs/2305.03951)]
- [2023] **The Harris-Venkatesh conjecture for derived Hecke operators II: a unified Stark conjecture** [[paper](https://arxiv.org/abs/2305.08956)]
- [2023] **Relative Trace Formula and Twisted L-functions: the Burgess Bound** [[paper](https://arxiv.org/abs/2305.10719)]
- [2023] **The distribution of the cokernel of a polynomial evaluated at a random integral matrix** [[paper](https://arxiv.org/abs/2303.09125)]
- [2023] **Motivic Serre group and Sato--Tate conjecture** [[paper](https://arxiv.org/abs/2302.13016)]
- [2023] **Counting matrix points on certain varieties over finite fields** [[paper](https://arxiv.org/abs/2302.04830)]
- [2023] **On the Central Limit Theorem for linear eigenvalue statistics on random surfaces of large genus** [[paper](https://arxiv.org/abs/2301.00685)]
- [2023] **Between Coherent and Constructible Local Langlands Correspondences** [[paper](https://arxiv.org/abs/2302.00039)]

##### 2022

- [2022] **Hecke operators on topological modular forms** [[paper](https://arxiv.org/abs/2212.06208)]
- [2022] **Statistics of Cohomological Automorphic Representations on Unitary Groups via the Endoscopic Classification** [[paper](https://arxiv.org/abs/2212.12138)]
- [2022] **Compactifications of Iwahori-level Hilbert modular varieties** [[paper](https://arxiv.org/abs/2211.06922)]
- [2022] **On the Lang-Trotter conjecture for a class of non-generic abelian surfaces** [[paper](https://arxiv.org/abs/2211.10523)]
- [2022] **Bilinear forms with trace functions over arbitrary sets, and applications to Sato-Tate** [[paper](https://arxiv.org/abs/2211.14702)]
- [2022] **Geometrization of the Satake transform for mod p Hecke algebras** [[paper](https://arxiv.org/abs/2211.16226)]
- [2022] **Subconvexity of a double Dirichlet series over the Gaussian field** [[paper](https://arxiv.org/abs/2211.08481)]
- [2022] **Bounds for moments of symmetric square L-functions** [[paper](https://arxiv.org/abs/2209.13882)]
- [2022] **On the value-distribution of the logarithms of symmetric power L-functions in the level aspect** [[paper](https://arxiv.org/abs/2209.11918)]
- [2022] **Geometric Eisenstein Series, Intertwining Operators, and Shin's Averaging Formula** [[paper](https://arxiv.org/abs/2209.08175)]
- [2022] **Hecke equivariance of generalized Borcherds products of type O(2,1)** [[paper](https://arxiv.org/abs/2208.03924)]
- [2022] **Stable Klingen Vectors and Paramodular Newforms** [[paper](https://arxiv.org/abs/2208.08939)]
- [2022] **First moment of central values of quadratic Hecke L-functions in the Gaussian field** [[paper](https://arxiv.org/abs/2207.03746)]
- [2022] **Explicit Sato-Tate type distribution for a family of K3 surfaces** [[paper](https://arxiv.org/abs/2207.01597)]
- [2022] **The cubic moment of Hecke--Maass cusp forms and moments of L-functions** [[paper](https://arxiv.org/abs/2207.09756)]
- [2022] **The Twelfth Moment of Hecke L-Functions in the Weight Aspect** [[paper](https://arxiv.org/abs/2207.00543)]
- [2022] **On triple product L-functions and a conjecture of Harris--Venkatesh** [[paper](https://arxiv.org/abs/2206.05560)]
- [2022] **Short second moment bound and Subconvexity for GL(3) L-functions** [[paper](https://arxiv.org/abs/2206.06517)]
- [2022] **Definite orthogonal modular forms: Computations, Excursions and Discoveries** [[paper](https://arxiv.org/abs/2203.06405)]
- [2022] **The topological Petersson product** [[paper](https://arxiv.org/abs/2202.13171)]
- [2022] **GOE statistics on the moduli space of surfaces of large genus** [[paper](https://arxiv.org/abs/2202.06379)]
- [2022] **Computation of weight 1 modular forms with exotic representations** [[paper](https://arxiv.org/abs/2201.08873)]
- [2022] **Topological Hecke eigenforms** [[paper](https://arxiv.org/abs/2201.00899)]
- [2022] **The Weak Gram Law for Hecke L-functions** [[paper](https://arxiv.org/abs/2201.08898)]

##### 2021

- [2021] **Hybrid subconvexity bounds for twists of \rm GL(3) L-functions** [[paper](https://arxiv.org/abs/2112.15378)]
- [2021] **Lefschetz number formula for Shimura varieties of Hodge type** [[paper](https://arxiv.org/abs/2111.14532)]
- [2021] **Hybrid bounds for the sup-norm of automorphic forms in higher rank** [[paper](https://arxiv.org/abs/2111.09923)]
- [2021] **Bias in cubic Gauss sums: Patterson's conjecture** [[paper](https://arxiv.org/abs/2109.07463)]
- [2021] **Sato-Tate Distributions of Catalan Curves** [[paper](https://arxiv.org/abs/2109.07417)]
- [2021] **Sharp bound for the fourth moment of holomorphic Hecke cusp forms** [[paper](https://arxiv.org/abs/2108.13868)]
- [2021] **An unconditional explicit bound on the error term in the Sato-Tate conjecture** [[paper](https://arxiv.org/abs/2108.03520)]
- [2021] **On Weyl's Subconvex Bound for Cube-Free Hecke characters: Totally Real Case** [[paper](https://arxiv.org/abs/2108.12283)]
- [2021] **Automorphic forms for PGL(3) over elliptic function fields. Part 1: Graphs of Hecke operators** [[paper](https://arxiv.org/abs/2107.08375)]
- [2021] **Sato-Tate groups of abelian threefolds** [[paper](https://arxiv.org/abs/2106.13759)]
- [2021] **Equidistribution theorems for holomorphic Siegel cusp forms of general degree: the level aspect** [[paper](https://arxiv.org/abs/2106.07811)]
- [2021] **Cusp forms as p-adic limits** [[paper](https://arxiv.org/abs/2105.10444)]
- [2021] **Relations among Ramanujan-Type Congruences II** [[paper](https://arxiv.org/abs/2105.13170)]
- [2021] **Hecke operators acting on optimal embeddings in indefinite quaternion algebras** [[paper](https://arxiv.org/abs/2104.13438)]
- [2021] **Frobenius trace distributions for K3 surfaces** [[paper](https://arxiv.org/abs/2102.10620)]
- [2021] **Averages and nonvanishing of central values of triple product L-functions** [[paper](https://arxiv.org/abs/2101.12400)]
- [2021] **A refinement of Sato-Tate conjecture** [[paper](https://arxiv.org/abs/2101.05193)]

##### 2020

- [2020] **Atkin-Lehner theory for Drinfeld modular forms and applications** [[paper](https://arxiv.org/abs/2012.08480)]
- [2020] **Picard modular forms and the cohomology of local systems on a Picard modular surface** [[paper](https://arxiv.org/abs/2012.07673)]
- [2020] **On Sato--Tate distributions, extremal traces, and real multiplication in genus 2** [[paper](https://arxiv.org/abs/2012.10805)]
- [2020] **Equidistribution of αp^θ with a Chebotarev condition and applications to extremal primes** [[paper](https://arxiv.org/abs/2012.12534)]
- [2020] **A modular proof of the properness of the Coleman-Mazur eigencurve** [[paper](https://arxiv.org/abs/2010.10705)]
- [2020] **Machine-Learning the Sato--Tate Conjecture** [[paper](https://arxiv.org/abs/2010.01213)]
- [2020] **Coherent Springer theory and the categorical Deligne-Langlands correspondence** [[paper](https://arxiv.org/abs/2010.02321)]
- [2020] **Subconvexity for GL(3)\times GL(2) L-functions in GL(3) spectral aspect** [[paper](https://arxiv.org/abs/2010.10153)]
- [2020] **Determining monodromy groups of abelian varieties** [[paper](https://arxiv.org/abs/2009.07441)]
- [2020] **Moments and hybrid subconvexity for symmetric-square L-functions** [[paper](https://arxiv.org/abs/2009.08419)]
- [2020] **The fourth moment of central values of quadratic Hecke L-functions in the Gaussian field** [[paper](https://arxiv.org/abs/2004.12528)]
- [2020] **On Langlands program, related representation and G-shtukas** [[paper](https://arxiv.org/abs/2004.11415)]
- [2020] **Almost all primes satisfy the Atkin-Serre conjecture and are not extremal** [[paper](https://arxiv.org/abs/2003.09026)]
- [2020] **Effective Sato-Tate conjecture for abelian varieties and applications** [[paper](https://arxiv.org/abs/2002.08807)]
- [2020] **Applications of analytic newvectors for GL(n)** [[paper](https://arxiv.org/abs/2001.09640)]

##### 2019

- [2019] **A newform theory for Katz modular forms** [[paper](https://arxiv.org/abs/1911.08866)]
- [2019] **Sato-Tate groups of abelian threefolds: a preview of the classification** [[paper](https://arxiv.org/abs/1911.02071)]
- [2019] **The analytic theory of vectorial Drinfeld modular forms** [[paper](https://arxiv.org/abs/1910.12743)]
- [2019] **A geometric approach to the sup-norm problem for automorphic forms: the case of newforms on GL_2(\mathbb F_q(T)) with squarefree level** [[paper](https://arxiv.org/abs/1907.08098)]
- [2019] **Patterns of primes in the Sato-Tate conjecture** [[paper](https://arxiv.org/abs/1907.08285)]
- [2019] **Möbius formulas for densities of sets of prime ideals** [[paper](https://arxiv.org/abs/1907.02914)]
- [2019] **Central limit theorems for elliptic curves and modular forms with smooth weight functions** [[paper](https://arxiv.org/abs/1906.06982)]

##### 2018

- [2018] **Towards the Sato-Tate Groups of Trinomial Hyperelliptic Curves** [[paper](https://arxiv.org/abs/1812.00242)]
- [2018] **Explicit subconvexity for GL_2** [[paper](https://arxiv.org/abs/1812.04391)]
- [2018] **Hyper-Algebras of Vector-Valued Modular Forms** [[paper](https://arxiv.org/abs/1810.02048)]
- [2018] **Bounds on the multiplicity of the Hecke eigenvalues** [[paper](https://arxiv.org/abs/1810.02014)]
- [2018] **Counting and Equidistribution for Quaternion Algebras** [[paper](https://arxiv.org/abs/1810.02787)]
- [2018] **Newforms mod p in squarefree level, with applications to Monsky's Hecke-stable filtration** [[paper](https://arxiv.org/abs/1808.04588)]
- [2018] **Hecke Operators on Vector-Valued Modular Forms** [[paper](https://arxiv.org/abs/1807.07703)]
- [2018] **Extremal primes of elliptic curves without complex multiplication** [[paper](https://arxiv.org/abs/1807.05255)]
- [2018] **Metric number theory of Fourier coefficients of modular forms** [[paper](https://arxiv.org/abs/1807.07518)]
- [2018] **Mod-2 dihedral Galois representations of prime conductor** [[paper](https://arxiv.org/abs/1806.04653)]
- [2018] **Random integral matrices: universality of surjectivity and the cokernel** [[paper](https://arxiv.org/abs/1806.00596)]
- [2018] **Familles de formes modulaires de Drinfeld pour le groupe général linéaire** [[paper](https://arxiv.org/abs/1805.08793)]
- [2018] **Drinfeld modular forms of arbitrary rank, Part III: Examples** [[paper](https://arxiv.org/abs/1805.12339)]
- [2018] **Abelian Chern-Simons theory on the torus and physical views on the Hecke operators** [[paper](https://arxiv.org/abs/1804.02848)]
- [2018] **Hecke Relations in Rational Conformal Field Theory** [[paper](https://arxiv.org/abs/1804.06860)]
- [2018] **Uniform subconvexity and symmetry breaking reciprocity** [[paper](https://arxiv.org/abs/1804.01602)]
- [2018] **Equidistribution theorems for holomorphic Siegel modular forms for GSp_4; Hecke fields and n-level density** [[paper](https://arxiv.org/abs/1802.09970)]
- [2018] **Galois gerbs and Lefschetz number formula for Shimura varieties of Hodge type** [[paper](https://arxiv.org/abs/1801.03057)]

##### 2017

- [2017] **Sato-Tate distributions of twists of the Fermat and the Klein quartics** [[paper](https://arxiv.org/abs/1712.07105)]
- [2017] **A simple proof of the Eichler-Selberg trace formula** [[paper](https://arxiv.org/abs/1711.00327)]
- [2017] **Bounds for traces of Hecke operators and applications to modular and elliptic curves over a finite field** [[paper](https://arxiv.org/abs/1710.09869)]
- [2017] **Indecomposable vector-valued modular forms and periods of modular curves** [[paper](https://arxiv.org/abs/1707.01693)]
- [2017] **On the trace formula for Hecke operators on congruence subgroups, II** [[paper](https://arxiv.org/abs/1706.02691)]
- [2017] **Twisted moments of L-functions and spectral reciprocity** [[paper](https://arxiv.org/abs/1706.01245)]
- [2017] **Moments of the error term in the Sato-Tate law for elliptic curves** [[paper](https://arxiv.org/abs/1705.09229)]
- [2017] **On the rank and the convergence rate towards the Sato-Tate measure** [[paper](https://arxiv.org/abs/1703.03182)]
- [2017] **Subconvex bounds for Hecke-Maass forms on compact arithmetic quotients of semisimple Lie groups** [[paper](https://arxiv.org/abs/1703.06973)]

##### 2016

- [2016] **Simultaneous computation of Hecke operators** [[paper](https://arxiv.org/abs/1612.08659)]
- [2016] **Anticyclotomic p-adic L-functions and Ichino's formula** [[paper](https://arxiv.org/abs/1612.06948)]
- [2016] **Character theory approach to Sato-Tate groups** [[paper](https://arxiv.org/abs/1605.07743)]
- [2016] **Burgess-like subconvexity for GL_1** [[paper](https://arxiv.org/abs/1604.08551)]
- [2016] **Vectorial Drinfeld modular forms over Tate algebras** [[paper](https://arxiv.org/abs/1603.07914)]
- [2016] **The spectral decomposition of |θ|^2** [[paper](https://arxiv.org/abs/1601.02529)]

##### 2015

- [2015] **Hecke eigenvalues of Klingen--Eisenstein series of squarefree level** [[paper](https://arxiv.org/abs/1512.09069)]
- [2015] **Fields of definition of elliptic k-curves and the realizability of all genus 2 Sato--Tate groups over a number field** [[paper](https://arxiv.org/abs/1511.02322)]
- [2015] **Improved subconvexity bounds for GL(2)xGL(3) and GL(3) L-functions by weighted stationary phase** [[paper](https://arxiv.org/abs/1510.01219)]
- [2015] **Natural boundaries for Euler products of Igusa zeta functions of elliptic curves** [[paper](https://arxiv.org/abs/1509.04835)]
- [2015] **The Hecke algebra action on Morava E-theory of height 2** [[paper](https://arxiv.org/abs/1505.06377)]
- [2015] **Effective log-free zero density estimates for automorphic L-functions and the Sato-Tate conjecture** [[paper](https://arxiv.org/abs/1505.03122)]
- [2015] **Analytic continuation on Shimura varieties with μ-ordinary locus** [[paper](https://arxiv.org/abs/1504.07423)]
- [2015] **What is the probability that a random integral quadratic form in n variables has an integral zero?** [[paper](https://arxiv.org/abs/1502.05992)]
- [2015] **Explicit estimates for the zeros of Hecke L-functions** [[paper](https://arxiv.org/abs/1502.05679)]

##### 2014

- [2014] **Products of Vector Valued Eisenstein Series** [[paper](https://arxiv.org/abs/1411.3877)]
- [2014] **Sato-Tate groups of y^2=x^8+c and y^2=x^7-cx** [[paper](https://arxiv.org/abs/1412.0125)]
- [2014] **On the trace formula for Hecke operators on congruence subgroups** [[paper](https://arxiv.org/abs/1408.4998)]
- [2014] **Sato-Tate groups of genus 2 curves** [[paper](https://arxiv.org/abs/1408.6968)]
- [2014] **Hecke stability and weight 1 modular forms** [[paper](https://arxiv.org/abs/1406.0408)]
- [2014] **Equidistribution, L-functions, and Sato-Tate groups** [[paper](https://arxiv.org/abs/1405.5162)]
- [2014] **P-adic L-functions of Bianchi modular forms** [[paper](https://arxiv.org/abs/1404.2100)]
- [2014] **Frobenius distribution for quotients of Fermat curves of prime exponent** [[paper](https://arxiv.org/abs/1403.0807)]

##### 2013

- [2013] **On the modularity of reducible mod l Galois representations** [[paper](https://arxiv.org/abs/1309.3717)]
- [2013] **Weighted Sato-Tate Vertical Distribution of the Satake Parameter of Maass Forms on PGL(N)** [[paper](https://arxiv.org/abs/1303.0889)]
- [2013] **Subconvexity for the Rankin-Selberg L-function in both levels** [[paper](https://arxiv.org/abs/1303.4459)]
- [2013] **An application of the effective Sato-Tate conjecture** [[paper](https://arxiv.org/abs/1301.0139)]
- [2013] **The circle method and bounds for L-functions - III: t-aspect subconvexity for GL(3) L-functions** [[paper](https://arxiv.org/abs/1301.1007)]

##### 2012

- [2012] **Equidistribution of Signs for Modular Eigenforms of Half Integral Weight** [[paper](https://arxiv.org/abs/1210.2319)]
- [2012] **An algebraic property of Hecke operators and two indefinite theta series** [[paper](https://arxiv.org/abs/1207.5766)]
- [2012] **Quaternionic modular forms of any weight** [[paper](https://arxiv.org/abs/1206.5675)]
- [2012] **Sato-Tate distributions of twists of y^2=x^5-x and y^2=x^6+1** [[paper](https://arxiv.org/abs/1203.1476)]
- [2012] **Modular forms and period polynomials** [[paper](https://arxiv.org/abs/1202.5802)]
- [2012] **Kuznetsov's trace formula and the Hecke eigenvalues of Maass forms** [[paper](https://arxiv.org/abs/1202.0189)]

##### 2011

- [2011] **A formula for the action of Hecke operators on half-integral weight Siegel modular forms and applications** [[paper](https://arxiv.org/abs/1110.6351)]
- [2011] **The Sato-Tate law for Drinfeld modules** [[paper](https://arxiv.org/abs/1110.4098)]
- [2011] **On the subconvexity problem for GL(3)\times GL(2) L-functions** [[paper](https://arxiv.org/abs/1107.2042)]
- [2011] **p-adic modular forms of non-integral weight over Shimura curves** [[paper](https://arxiv.org/abs/1106.2712)]

##### 2010

- [2010] **\ell-adic properties of smallest parts functions** [[paper](https://arxiv.org/abs/1011.6079)]
- [2010] **A modularity criterion for Klein forms, with an application to modular forms of level 13** [[paper](https://arxiv.org/abs/1006.1469)]
- [2010] **Effective equidistribution and the Sato-Tate law for families of elliptic curves** [[paper](https://arxiv.org/abs/1004.2753)]

##### 2009

- [2009] **The Sato-Tate conjecture for Hilbert modular forms** [[paper](https://arxiv.org/abs/0912.1054)]
- [2009] **Deformations of Galois Representations and the Theorems of Sato-Tate, Lang-Trotter and others** [[paper](https://arxiv.org/abs/0908.1752)]
- [2009] **Geometric and p-adic modular forms of half-integral weight** [[paper](https://arxiv.org/abs/0906.3238)]

##### 2008

- [2008] **Averages of central L-values of Hilbert modular forms with an application to subconvexity** [[paper](https://arxiv.org/abs/0810.4726)]
- [2008] **Weak subconvexity for central values of L-functions** [[paper](https://arxiv.org/abs/0809.1635)]
- [2008] **Automorphic forms of higher order** [[paper](https://arxiv.org/abs/0802.0361)]
- [2008] **A refined version of the Lang-Trotter Conjecture** [[paper](https://arxiv.org/abs/0801.3946)]

##### 2007

- [2007] **Hecke operators and Hilbert modular forms** [[paper](https://arxiv.org/abs/0711.1277)]

##### 2006

- [2006] **Generating functions for Hecke operators** [[paper](https://arxiv.org/abs/math/0610962)]
- [2006] **L-functions and higher order modular forms** [[paper](https://arxiv.org/abs/math/0601143)]

##### 2005

- [2005] **Average values of modular L-series via the relative trace formula** [[paper](https://arxiv.org/abs/math/0510113)]

##### 2004

- [2004] **Hecke operators on weighted Dedekind symbols** [[paper](https://arxiv.org/abs/math/0412090)]
- [2004] **Random Matrix Theory and the Fourier Coefficients of Half-Integral Weight Forms** [[paper](https://arxiv.org/abs/math/0412083)]
- [2004] **Converse theorems assuming a partial Euler product** [[paper](https://arxiv.org/abs/math/0408221)]
- [2004] **An arithmetic formula for certain coefficients of the Euler product of Hecke polynomials** [[paper](https://arxiv.org/abs/math/0403148)]

##### 2003

- [2003] **On the moments of Hecke series at central points II** [[paper](https://arxiv.org/abs/math/0305178)]

[⬆ Back to top](#paper-list)

#### L-Functions & Zeta

##### 2026

- [2026] **More than two thirds of the zeta zeros are simple and on the critical line** [[paper](https://arxiv.org/abs/2608.13637)]
- [2026] **Special Values of Shifted Dirichlet Series from an Adjoint Map on Almost Holomorphic Modular Forms** [[paper](https://arxiv.org/abs/2608.12542)]
- [2026] **Products of point counts of higher genus curves over finite fields** [[paper](https://arxiv.org/abs/2608.18014)]
- [2026] **The Spiral Convergence of the Polylogarithmic Deformation Family of the Riemann Zeta Function: Proof of the Riemann Hypothesis and the Simple Zeros Conjecture** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.21960475)]
- [2026] **Verified Interval SDP and Domain-Separated Sum-of-Squares Minorants for Critical Line Proportions of the Riemann Zeta Function** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.21915211)]
- [2026] **The Non-Linear Maier Matrix Topology: Geometric Gnomons, Hessian Amplification, and the Spectral-Geometric Resonance of the Riemann Zeros** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.21759418)]
- [2026] **The Non-Linear Maier Matrix Method: Geometric Gnomons, Hessian Amplification, and the Spectral-Geometric Resonance of the Riemann Zeros** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.21758720)]
- [2026] **Spectral Geometry, Generality, and Prime Information in the Riemann Zero Spectrum/First public research preprint** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.21780636)]
- [2026] **Resolution of the Riemann Hypothesis from 1859 using the M • P = R formula and Artur Malecha's Theory "The Paradox of Living Matter" M • P = R Matter • Pressure = Motion three constant variables** *Open MIND* [[paper](https://osf.io/9q4z8)]
- [2026] **The \Omega_G Operator Proof: A Hybrid Hilbert Space Model for Multi-Channel Field Mechanics and Singular Regularization** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.21866825)]
- [2026] **Kloosterman sheaves and Bessel functions for generic principal series of finite groups** [[paper](https://arxiv.org/abs/2608.24836)]
- [2026] **Bounding The Number of Zeros Near the Central Point in Families of Cuspidal Newforms** [[paper](https://arxiv.org/abs/2608.15063)]
- [2026] **Bounds for moments of twisted quadratic characters of prime modulus** [[paper](https://arxiv.org/abs/2608.05961)]
- [2026] **Uniform bounds on prime levels of abelian division fields of elliptic curves over number fields without rationally defined CM** [[paper](https://arxiv.org/abs/2608.12709)]
- [2026] **Average analytic rank for the L-functions of the elliptic curves y^2=x^3-dx** [[paper](https://arxiv.org/abs/2608.06286)]
- [2026] **A Novel Bijective Angle and Volume-preservation Balanced Parameterization for n-dimensional Manifolds** [[paper](https://arxiv.org/abs/2608.01073)]
- [2026] **Hybrid Dealiasing and Implicit Packing for Real Convolutions** [[paper](https://arxiv.org/abs/2608.14497)]
- [2026] **Data generated internal solutions for the plasma wave equation: error bounds and numerical experiments in two dimensions** [[paper](https://arxiv.org/abs/2608.04989)]
- [2026] **A New Lower Bound for Online Vertex Cover under Vertex Arrivals** [[paper](https://arxiv.org/abs/2608.09210)]
- [2026] **Do We Really Need to Read the Input? An Optimality Proof for Stone Game III** [[paper](https://arxiv.org/abs/2608.06162)]
- [2026] **Support Contraction for Well-Supported Nash Equilibria** [[paper](https://arxiv.org/abs/2608.00453)]
- [2026] **On the dependence of the zero-free region of a partition function on the external field** [[paper](https://arxiv.org/abs/2608.03687)]
- [2026] **Polynomial-Time Singular Witnesses for Non-SNS Sign Patterns** [[paper](https://arxiv.org/abs/2608.12075)]
- [2026] **A Boolean polynomial operator for the Collatz 3n+1 problem** [[paper](https://arxiv.org/abs/2608.25791)]
- [2026] **Hasse-Witt invariants for trace forms of Jacobi polynomials** [[paper](https://arxiv.org/abs/2608.12019)]
- [2026] **Fourier Spectral Reciprocity and Canonical Hecke L-Functions** [[paper](https://arxiv.org/abs/2608.23886)]
- [2026] **Weyl Subconvexity for GL_2 with Simple Supercuspidal Ramification** [[paper](https://arxiv.org/abs/2608.04982)]
- [2026] **Strichartz estimates for quasi-periodic functions on long time intervals: An arithmetic approach** [[paper](https://arxiv.org/abs/2608.03194)]
- [2026] **Simultaneous non-vanishing of Dirichlet L--functions, II: Weighted central limit theorem** [[paper](https://arxiv.org/abs/2607.21532)]
- [2026] **Beyond the Riemann Hypothesis bounds: A pair-correlation approach to the least prime in arithmetic progression and the smallest quadratic non-residue** [[paper](https://arxiv.org/abs/2607.14515)]
- [2026] **Euler systems and the symmetric square of a Hida family** [[paper](https://arxiv.org/abs/2607.12679)]
- [2026] **Divisor moments of polynomials in Fourier coefficients of modular forms** [[paper](https://arxiv.org/abs/2607.18832)]
- [2026] **A decades-long breakthrough in zero-density estimates and primes in short intervals** [[paper](https://arxiv.org/abs/2607.04632)]
- [2026] **Symmetric Spectral Reciprocity for GL(2) and Uniform Subconvexity** [[paper](https://arxiv.org/abs/2607.04476)]
- [2026] **Arithmetic Spectral Theory: A Unified Framework for Number Theory, Quantum Mechanics, Artificial Intelligence, and Post-Quantum Cryptography** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.21610119)]
- [2026] **A Complex-Analytic Law for Riemann Zeta Zeros at Prime Frequencies** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.21408416)]
- [2026] **Operator-Theoretic and Computational Realizations of the Riemann Hypothesis** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.21143338)]
- [2026] **The Mirror: verified classical structure of the Riemann zeta function - checks, figures, and verification reports** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.21495044)]
- [2026] **Operator-Theoretic and Computational Realizations of the Riemann Hypothesis Expanded** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.21144644)]
- [2026] **"An Empirical Amplitude Law for the Spectral Form Factor of Riemann Zeta Zeros at Prime Frequencies"** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.21408248)]
- [2026] **Riemann Hypothesis- Energy Zero-Tracking (WITH TEST CODE ) and Prime Synchronization (Part 2)** *Figshare* [[paper](https://doi.org/10.6084/m9.figshare.33086495.v1)]
- [2026] **Riemann Hypothesis- Energy Zero-Tracking (WITH TEST CODE) and Prime Synchronization (Part 2)** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.21554790)]
- [2026] **The NEXUS-RH Framework: Arithmetic-Moment Stieltjes Pipeline and the Spectral Resolution of Riemann Zeros** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.21154898)]
- [2026] **Arithmetic Energy Methods, Exact Identities, and a Conditional Framework for the Riemann Hypothesis** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.20370175)]
- [2026] **Operator-Theoretic Factorizations and the Positivity Constraints of Spectral Measures** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.21251899)]
- [2026] **Distribution of Selmer ranks in prime cyclic extensions** [[paper](https://arxiv.org/abs/2607.01126)]
- [2026] **Local statistics and average rank of genus g hyperelliptic curves with a Weierstrass point** [[paper](https://arxiv.org/abs/2607.12381)]
- [2026] **A Gaussian-Perron Prime-Side Defect and Local Profiles Near Critical-Line Zeros of the Riemann Zeta Function** [[paper](https://arxiv.org/abs/2607.04316)]
- [2026] **On the Fractional Parts of Polynomials Modulo p** [[paper](https://arxiv.org/abs/2607.21259)]
- [2026] **The Fine-Structure Hierarchy of Prime Biases and the Universal Dominance of -1 \pmod N** [[paper](https://arxiv.org/abs/2607.28931)]
- [2026] **On the role of higher roots in prime ideal races** [[paper](https://arxiv.org/abs/2607.23150)]
- [2026] **SinCoTrap: A High-Order Locally Corrected Trapezoidal Rule for Periodic Singular Integrals in Arbitrary Dimensions** [[paper](https://arxiv.org/abs/2607.12390)]
- [2026] **A MATLAB Tool for the Stable Generation of Matrix Polynomial Evaluation Schemes with Two-Product Savings** [[paper](https://arxiv.org/abs/2607.28286)]
- [2026] **Nested Volume-Surface Integral Equations for Acoustics** [[paper](https://arxiv.org/abs/2607.06429)]
- [2026] **Lagrange interpolation processes based on the zeros of anti-Gauss Jacobi polynomials** [[paper](https://arxiv.org/abs/2607.21714)]
- [2026] **Fast Rational Univariate Representation via Gaussian Elimination** [[paper](https://arxiv.org/abs/2607.06397)]
- [2026] **Incremental Optimal Assignment for Real-Time Crowd Tracking** [[paper](https://arxiv.org/abs/2607.21368)]
- [2026] **Packing Linear Programs and Fractional Knapsack using Comparison Oracles** [[paper](https://arxiv.org/abs/2607.19557)]
- [2026] **Query Complexity of Hypergraph Connectivity and Learnability using CUT Oracles** [[paper](https://arxiv.org/abs/2607.01216)]
- [2026] **The mean value of the digits of 1/p** [[paper](https://arxiv.org/abs/2607.13663)]
- [2026] **Vertex volumes, lattice-minima tails, and height zeta functions for the standard arithmetic quotient of \operatorname{PGL}_d** [[paper](https://arxiv.org/abs/2607.28433)]
- [2026] **On a Smoothed Walfisz Divisor Problem** [[paper](https://arxiv.org/abs/2607.01956)]
- [2026] **Ramanujan-type identities for alternating Hurwitz zeta functions** [[paper](https://arxiv.org/abs/2607.03490)]
- [2026] **Large values of quadratic Dirichlet L-functions of prime-related moduli** [[paper](https://arxiv.org/abs/2606.15635)]
- [2026] **Duke for Drinfeld** [[paper](https://arxiv.org/abs/2606.21163)]
- [2026] **A note on large values of Dirichlet L-functions for characters of fixed order at 1/2&lt;σ\leq 1** [[paper](https://arxiv.org/abs/2606.09818)]
- [2026] **Symmetric square L-functions on GL_3** [[paper](https://arxiv.org/abs/2606.19959)]
- [2026] **Amplified moments of the Riemann zeta function** [[paper](https://arxiv.org/abs/2606.27323)]
- [2026] **Connection between the Riemann zeta-function and random matrices via hyperfunctions** [[paper](https://arxiv.org/abs/2606.07312)]
- [2026] **Source Code and Numerical Results for a Parameter-Free Spectral Test of the Riemann Hypothesis via Explicit-Formula Confinement** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.20822815)]
- [2026] **Discrete Fourier Transform Approach to Cyclically Covering Subspaces of \mathbb{F}^n_q** [[paper](https://arxiv.org/abs/2606.13307)]
- [2026] **Thakur's hypotheses on power sums of \mathbb{F}_q[t]** [[paper](https://arxiv.org/abs/2606.16239)]
- [2026] **Ten Digits on a Train: AI-Assisted Verification of Two Eigenvalue Problems** [[paper](https://arxiv.org/abs/2606.23821)]
- [2026] **Computing resonances of perturbed Schrödinger equations: Application to Reissner-Norsdtröm-de Sitter black holes** [[paper](https://arxiv.org/abs/2606.18770)]
- [2026] **Algorithmic Foundations of Deep Learning: Complexity-Theoretic Rates and a Characterization of Universal Approximation** [[paper](https://arxiv.org/abs/2606.26705)]
- [2026] **Nonlinear Geotechnical Analysis Using a Polygonal Cell-Based Smoothed Finite Element Framework** [[paper](https://arxiv.org/abs/2606.20384)]
- [2026] **Generating 2-Gray codes for grand Motzkin paths and grand Dyck paths with air pockets in constant amortized time** [[paper](https://arxiv.org/abs/2606.05470)]
- [2026] **Online Connectivity Augmentation** [[paper](https://arxiv.org/abs/2606.18160)]
- [2026] **On the rank of hypergeometric sheaves on higher dimensional tori** [[paper](https://arxiv.org/abs/2606.11054)]
- [2026] **Analogues of the Lindelöf Hypothesis for the Barnes multiple zeta function and related problems** [[paper](https://arxiv.org/abs/2606.02407)]
- [2026] **Spectral interpretation of Riemann zeta zeros** [[paper](https://arxiv.org/abs/2606.17494)]
- [2026] **The Littlewood-Paley formula and mean counting function for vertical limits of Dirichlet series** [[paper](https://arxiv.org/abs/2606.20293)]
- [2026] **The θ= \infty Conjecture and the Riemann Hypothesis for Automorphic L-functions** [[paper](https://arxiv.org/abs/2605.24363)]
- [2026] **Joint extreme values of L-functions on and off the critical line** [[paper](https://arxiv.org/abs/2605.03665)]
- [2026] **Closed geodesics in short intervals for random hyperbolic surfaces** [[paper](https://arxiv.org/abs/2605.22059)]
- [2026] **Rethinking the work of Langlands on Eisenstein series** [[paper](https://arxiv.org/abs/2605.22475)]
- [2026] **Structural Observational Inversion and the Riemann Hypothesis** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.20012519)]
- [2026] **Part 1: The Resolution to the Riemann Hypothesis Riemann Zeros as Fano-Cycle Closures of a σ-Equivariant Operator System - A Parameter-Free Architectural Derivation Confirmed Pointwise Across 2000 Cached Zeros** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.20205599)]
- [2026] **Spectrum-Zero Functor and Constructive Proof of the Riemann Hypothesis: Based on the YD-T64 Framework and TCSC Axiom System of YuanXian Theory** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.20062686)]
- [2026] **The Prime Wave Operator: A Self-Adjoint Candidate for the Hilbert-Pólya Conjecture** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.20102262)]
- [2026] **Stochastic Convergence Analysis for Large-Scale Linear Discrete Ill-posed Problems** [[paper](https://arxiv.org/abs/2605.18259)]
- [2026] **Elfs, transducers and quantum walks** [[paper](https://arxiv.org/abs/2605.30013)]
- [2026] **Convex Optimization with Nested Evolving Feasible Sets** [[paper](https://arxiv.org/abs/2605.07386)]
- [2026] **An Entropy-Governed Speedup for Quantum Algorithms on Local Hamiltonians** [[paper](https://arxiv.org/abs/2605.18241)]
- [2026] **Node-Weighted Triangles: Faster and Simpler** [[paper](https://arxiv.org/abs/2605.08588)]
- [2026] **Label Correcting Algorithms for the Multiobjective Temporal Shortest Path Problem** [[paper](https://arxiv.org/abs/2605.05954)]
- [2026] **An explicit Galois descent for multiple t-values of maximal height** [[paper](https://arxiv.org/abs/2605.10262)]
- [2026] **On the density of rational lines on diagonal cubic hypersurfaces, II** [[paper](https://arxiv.org/abs/2605.30549)]
- [2026] **A novel asymptotic technique for integrals involving the Hankel contour and the Bleistein asymptotic formula** [[paper](https://arxiv.org/abs/2605.03466)]
- [2026] **Frames of orbits of multiplication operators on Hardy spaces** [[paper](https://arxiv.org/abs/2606.00912)]
- [2026] **Large values of L(σ,χ) for subgroups of characters** [[paper](https://arxiv.org/abs/2604.02960)]
- [2026] **Higher order derivative moments of CUE characteristic polynomials and the Riemann zeta function** [[paper](https://arxiv.org/abs/2604.03051)]
- [2026] **Approximating the Permanent of a Random Matrix with Polynomially Small Mean: Zeros and Universality** [[paper](https://arxiv.org/abs/2604.01367)]
- [2026] **The Primorial Compile Algebra and Meta-Computational Ontology: Structural Completeness in Prime Gap Distributions** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.19886655)]
- [2026] **From Zero to One A Harmonic Framework for Arithmetic Structure** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.19798755)]
- [2026] **Large sieve inequality for sums of Legendre symbols over short intervals** [[paper](https://arxiv.org/abs/2604.23661)]
- [2026] **On Lower Bounds for sums of Fourier Coefficients of Twist-Inequivalent Newforms** [[paper](https://arxiv.org/abs/2604.07474)]
- [2026] **Mathematical Analysis of Image Matching Techniques** [[paper](https://arxiv.org/abs/2604.07574)]
- [2026] **Online Trading as a Secretary Problem Variant** [[paper](https://arxiv.org/abs/2604.15933)]
- [2026] **Zero-Freeness of the Hard-Core Model with Bounded Connective Constant** [[paper](https://arxiv.org/abs/2604.02746)]
- [2026] **Near-Optimal Constructive Bounds for \ell_2 Prefix Discrepancy and Steinitz Problems via Affine Spectral Independence** [[paper](https://arxiv.org/abs/2604.13355)]
- [2026] **On the Learning Curves of Revenue Maximization** [[paper](https://arxiv.org/abs/2604.26922)]
- [2026] **A note on The asymptotic uniform distribution of subset sums** [[paper](https://arxiv.org/abs/2604.23787)]
- [2026] **A statistical investigation of a divisor-sum function** [[paper](https://arxiv.org/abs/2604.05284)]
- [2026] **On special values of Koshliakov zeta functions** [[paper](https://arxiv.org/abs/2604.04675)]
- [2026] **A divisor function of Wigert and higher degree forms** [[paper](https://arxiv.org/abs/2604.27698)]
- [2026] **A conditional bound for the least prime in an arithmetic progression** [[paper](https://arxiv.org/abs/2603.25612)]
- [2026] **Twisted dynamical zeta functions and the Fried's conjecture** [[paper](https://arxiv.org/abs/2603.03156)]
- [2026] **PhaseJumps: fast computation of zeros from planar grid samples** [[paper](https://arxiv.org/abs/2603.13158)]
- [2026] **Zero-free regions inspired by work of Heath-Brown** [[paper](https://arxiv.org/abs/2603.21490)]
- [2026] **Empirical Collapse of Riemann Zeta Zeros via Fractal Correction: A Constructive Resolution of the Riemann Hypothesis** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.18953513)]
- [2026] **On the Convexity of Smoothed Zeta Zero Sums and Its Relation to the Riemann Hypothesis** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.19062165)]
- [2026] **A Wasserstein metric approach to generalized Skewes' numbers. I. Prime number races** [[paper](https://arxiv.org/abs/2603.20093)]
- [2026] **Stability and Bifurcation Analysis of Nonlinear PDEs via Random Projection-based PINNs: A Krylov-Arnoldi Approach** [[paper](https://arxiv.org/abs/2603.21568)]
- [2026] **Relative integral spinor norm groups over dyadic local fields** [[paper](https://arxiv.org/abs/2603.01671)]
- [2026] **Beyond Endoscopy for GL(3, \mathbb{Q}): Isolation of the residual spectrum via Poisson Summation** [[paper](https://arxiv.org/abs/2603.21506)]
- [2026] **Explicit formula for multi-indexed poly-Bernoulli numbers** [[paper](https://arxiv.org/abs/2603.15380)]
- [2026] **Iwasawa invariants and class number parity of multi-quadratic number fields** [[paper](https://arxiv.org/abs/2603.05142)]
- [2026] **Frequency of a Digit in the Representation of a Number and the Asymptotic Mean Value of the Digits** [[paper](https://arxiv.org/abs/2603.04877)]
- [2026] **Shifted moments of modular L-functions to a fixed level** [[paper](https://arxiv.org/abs/2602.01409)]
- [2026] **Goldfeld conjecture for non-hyperelliptic direction** [[paper](https://arxiv.org/abs/2602.21985)]
- [2026] **Distribution of sums involving Dirichlet characters over the k-free integers** [[paper](https://arxiv.org/abs/2602.23100)]
- [2026] **Explicit conditional bounds for ζ(s) at the edge of the critical strip** [[paper](https://arxiv.org/abs/2602.06199)]
- [2026] **The Riemann Hypothesis: Past, Present and a Letter Through Time** [[paper](https://arxiv.org/abs/2602.04022)]
- [2026] **TorchLean: Formalizing Neural Networks in Lean** [[paper](https://arxiv.org/abs/2602.22631)]
- [2026] **The condition number of a random banded Toeplitz matrix is typically large** [[paper](https://arxiv.org/abs/2602.12581)]
- [2026] **V-ABFT: Variance-Based Adaptive Threshold for Fault-Tolerant Matrix Multiplication in Mixed-Precision Deep Learning** [[paper](https://arxiv.org/abs/2602.08043)]
- [2026] **The AI Research Assistant: Promise, Peril, and a Proof of Concept** [[paper](https://arxiv.org/abs/2602.22842)]
- [2026] **Revisiting the Sparse Matrix Compression Problem** [[paper](https://arxiv.org/abs/2602.15314)]
- [2026] **Space Complexity Dichotomies for Subgraph Finding Problems in the Streaming Model** [[paper](https://arxiv.org/abs/2602.08002)]
- [2026] **Whittaker functions on {\rm GL}_n via theta lifting** [[paper](https://arxiv.org/abs/2602.06315)]
- [2026] **Minimal zero-free regions for results on primes between consecutive perfect kth powers** [[paper](https://arxiv.org/abs/2602.14340)]
- [2026] **A new improved explicit estimate for ζ\left( 1/2+it\right)** [[paper](https://arxiv.org/abs/2602.05614)]
- [2026] **Counting number fields using multiple Dirichlet series** [[paper](https://arxiv.org/abs/2602.23619)]
- [2026] **Primes in arithmetic progressions to large moduli and refinements of Harman's sieve** [[paper](https://arxiv.org/abs/2602.20917)]
- [2026] **On the Mean Value of a Weighted Composite Arithmetic Function** [[paper](https://arxiv.org/abs/2602.16027)]
- [2026] **On integral boxes of minimal surface** [[paper](https://arxiv.org/abs/2602.02349)]
- [2026] **The Parabolic Mellin Transform: Gamma and Zeta Integral Representations** [[paper](https://arxiv.org/abs/2602.17007)]
- [2026] **Efficient third-order iterative algorithms for computing zeros of special functions** [[paper](https://arxiv.org/abs/2601.04148)]
- [2026] **The Zero-Density Convergence Theorem - A Spectral-Probabilistic Hybrid Approach** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.18121391)]
- [2026] **Riemann Hypothesis Proof via H4 Weierstrass Geometric Fields** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.18136282)]
- [2026] **🔢 Riemann Hypothesis: Mathematical Proof via Weil Positivity Criterion** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.18137446)]
- [2026] **A generalisation of the Euclid-Mullin sequences** [[paper](https://arxiv.org/abs/2601.21901)]
- [2026] **Neumann series of Bessel functions for the solutions of the Sturm-Liouville equation in impedance form and related boundary value problems** [[paper](https://arxiv.org/abs/2601.04513)]
- [2026] **A Primal-Dual Level Set Method for Computing Geodesic Distances** [[paper](https://arxiv.org/abs/2601.23244)]
- [2026] **Learn and Verify: A Framework for Rigorous Verification of Physics-Informed Neural Networks** [[paper](https://arxiv.org/abs/2601.19818)]
- [2026] **Precision autotuning for linear solvers via contextual bandit-based RL** [[paper](https://arxiv.org/abs/2601.00728)]
- [2026] **Online Linear Programming with Replenishment** [[paper](https://arxiv.org/abs/2601.14629)]
- [2026] **Generalisations of the Landau--Gonek Theorem and applications to mean values of zeta** [[paper](https://arxiv.org/abs/2601.18025)]
- [2026] **On the Zeros of the Riemann Zeta Function with Two Ordinate Shifts** [[paper](https://arxiv.org/abs/2601.15610)]
- [2026] **Frobenius numbers and the first Hilbert coefficients of certain numerical semigroup rings** [[paper](https://arxiv.org/abs/2601.21819)]
- [2026] **Improved Averaged Distribution of d_3(n) in Prime Arithmetic Progressions** [[paper](https://arxiv.org/abs/2601.12601)]
- [2026] **On the largest prime factor of integers in short intervals III** [[paper](https://arxiv.org/abs/2601.00910)]

##### 2025

- [2025] **Bounding the integral of the argument of the Riemann Zeta function** [[paper](https://arxiv.org/abs/2512.23064)]
- [2025] **A discrete approach to Dirichlet L-functions, their special values and zeros** [[paper](https://arxiv.org/abs/2512.01779)]
- [2025] **On the Riemann Hypothesis for Drinfeld Modules** [[paper](https://arxiv.org/abs/2512.12374)]
- [2025] **Chebyshev's bias without linear independence** [[paper](https://arxiv.org/abs/2512.23302)]
- [2025] **Optimal bounds for sums of non-negative arithmetic functions** [[paper](https://arxiv.org/abs/2512.15709)]
- [2025] **Deepening and Extensions of the Theory of Complex-Order Riemann Zeta Functions** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.18450268)]
- [2025] **On the Nature of Nature: Celestial Holography to the Zeta Zeros** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.19429127)]
- [2025] **A Complete Framework and Implementation Path for Research on the Riemann Hypothesis** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.18508656)]
- [2025] **The Horizon Project A Spectral Architecture for the Riemann Hypothesis** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.17883239)]
- [2025] **On Goldbach numbers in short intervals** [[paper](https://arxiv.org/abs/2512.23534)]
- [2025] **Regularity analysis and verification of Coons volume mappings** [[paper](https://arxiv.org/abs/2512.21656)]
- [2025] **Mixed finite element approximation for non-divergence form elliptic equations with random input data** [[paper](https://arxiv.org/abs/2512.04003)]
- [2025] **An arbitrary Lagrangian-Eulerian semi-implicit hybrid method for continuum mechanics with GLM cleaning** [[paper](https://arxiv.org/abs/2512.03741)]
- [2025] **Quadratic Gauss sums over \mathbb{Z}^n/c\mathbb{Z}^n: explicit formulas, a duality theorem, and applications to Weil representations and cubic hypersurfaces over \mathbb{F}_p** [[paper](https://arxiv.org/abs/2512.15334)]
- [2025] **Twisted character formula for toral supercuspidal representations** [[paper](https://arxiv.org/abs/2512.20525)]
- [2025] **Some explicit values of a q-multiple zeta function whose denominator power is not uniform** [[paper](https://arxiv.org/abs/2512.06672)]
- [2025] **Explicit bounds for the graphicality of the prime gap sequence** [[paper](https://arxiv.org/abs/2512.24230)]
- [2025] **Spectral Reciprocity: A Fourier--Analytic Approach** [[paper](https://arxiv.org/abs/2512.03305)]
- [2025] **Secondary Term for the Mean Value of Maass Special L-values** [[paper](https://arxiv.org/abs/2512.24028)]
- [2025] **Primes in simultaneous arithmetic progressions** [[paper](https://arxiv.org/abs/2512.22798)]
- [2025] **Limits of Equi-Affine Equi-Distant Loci of Planar Convex Domains with Two Non-Parallel Asymptotes** [[paper](https://arxiv.org/abs/2512.21154)]
- [2025] **On a problem of Erdős and Ingham** [[paper](https://arxiv.org/abs/2512.16528)]
- [2025] **Zeta Zeros on the Critical Line** [[paper](https://arxiv.org/abs/2511.20059)]
- [2025] **Riemann Hypothesis for Non-Abelian Zeta Functions of Genus 2 Curves** [[paper](https://arxiv.org/abs/2511.06729)]
- [2025] **Variations of the Hardy Z-Function and the Montgomery Pair Correlation Conjecture** [[paper](https://arxiv.org/abs/2511.18275)]
- [2025] **Asymptotic analysis of a Family of Painlevé Functions with Applications to CUE Derivative Moments** [[paper](https://arxiv.org/abs/2511.18118)]
- [2025] **The Riemann Hypothesis Emerges in Dynamical Quantum Phase Transitions** [[paper](https://arxiv.org/abs/2511.11199)]
- [2025] **From Bound States to Resonances: A Computational Roadmap for Testing the Riemann Hypothesis via Quantum Scattering** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.17682583)]
- [2025] **Prime Fluctuations as an Arithmetic Schrödinger Flow: High-Precision Numerical Verification up to 10^{18} and Stability Analysis** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.17641610)]
- [2025] **The Prime Cosmic Web Law** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.17766265)]
- [2025] **Prime Deterministic Flow Law** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.17766307)]
- [2025] **The Arithmetic Clock: A Physical Hamiltonian for Prime Numbers and its Additive Corollaries** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.17716295)]
- [2025] **Causal Unification of Goldbach via the Arithmetic Hamiltonian Hzeta** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.17718231)]
- [2025] **Uniform bounds on the level of cyclotomic division fields of elliptic curves** [[paper](https://arxiv.org/abs/2511.23381)]
- [2025] **Lower Bounds on High Moments of Twisted Fourier coefficients of Modular Forms** [[paper](https://arxiv.org/abs/2511.02344)]
- [2025] **Zeta Spectral Triples** [[paper](https://arxiv.org/abs/2511.22755)]
- [2025] **Average hardness of SIVP for module lattices of fixed rank** [[paper](https://arxiv.org/abs/2511.13659)]
- [2025] **Variational Principles for the Helmholtz equation: application to Finite Element and Neural Network approximations** [[paper](https://arxiv.org/abs/2511.13217)]
- [2025] **Asymptotic models for time-domain scattering by small particles of arbitrary shapes** [[paper](https://arxiv.org/abs/2511.11103)]
- [2025] **Some error estimates for semidiscrete finite element approximations of stable solutions to mean field game systems** [[paper](https://arxiv.org/abs/2511.13352)]
- [2025] **Polynomial Algorithms for Simultaneous Unitary Similarity and Equivalence** [[paper](https://arxiv.org/abs/2511.19439)]
- [2025] **p-adic multiple zeta values and binomial multiple harmonic sums** [[paper](https://arxiv.org/abs/2511.23255)]
- [2025] **A round of Pintz to celebrate oscillations in sums** [[paper](https://arxiv.org/abs/2511.09978)]
- [2025] **Stationary phase analysis for analytic newvectors and application to subconvexity problems** [[paper](https://arxiv.org/abs/2511.22644)]
- [2025] **Average shifted convolution sum for GL(d_1)\times GL(d_2)** [[paper](https://arxiv.org/abs/2511.23096)]
- [2025] **Effective Brauer-Siegel theorems for Artin L-functions** [[paper](https://arxiv.org/abs/2510.02309)]
- [2025] **Average rank of elliptic curves over function fields** [[paper](https://arxiv.org/abs/2510.25630)]
- [2025] **A Multi-Domain Resolution of the Generalized Riemann Hypothesis: Spectral Construction, Motivic Descent, and Topological Sealing via the (ARK) Agnostic Replication Kit** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.19277353)]
- [2025] **A Unitary Resolution of the Generalized Riemann Hypothesis: Spectral Operator Realization, Motivic Descent, and the Topological Atiyah-Singer Seal via the (ARK) Agnostic Replication Kit** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.19703407)]
- [2025] **A Note on Algorithms for Computing p_n** [[paper](https://arxiv.org/abs/2510.16285)]
- [2025] **On the Rasmussen-Tamagawa conjecture for abelian fivefolds** [[paper](https://arxiv.org/abs/2510.14306)]
- [2025] **A Novel Algorithm for Representing Positive Semi-Definite Polynomials as Sums of Squares with Rational Coefficients** [[paper](https://arxiv.org/abs/2510.01568)]
- [2025] **Exact deflation for accurate SVD computation of nonnegative bidiagonal products of arbitrary rank** [[paper](https://arxiv.org/abs/2510.10502)]
- [2025] **Multistep Methods for Floquet Multipliers and Subspaces** [[paper](https://arxiv.org/abs/2510.23082)]
- [2025] **An extensive search for stable periodic orbits of the equal-mass zero angular momentum three-body problem** [[paper](https://arxiv.org/abs/2510.22802)]
- [2025] **Revoke vs. Restart in Unweighted Throughput Scheduling** [[paper](https://arxiv.org/abs/2510.15318)]
- [2025] **On Integer Programs That Look Like Paths** [[paper](https://arxiv.org/abs/2510.22430)]
- [2025] **Exact zCDP Characterizations for Fundamental Differentially Private Mechanisms** [[paper](https://arxiv.org/abs/2510.25746)]
- [2025] **Carlson's theorem and vertical limit functions** [[paper](https://arxiv.org/abs/2510.05793)]
- [2025] **Note on the positivity of the real part of the log-derivative of the Riemann ξ-function near the critical line** [[paper](https://arxiv.org/abs/2509.18963)]
- [2025] **Some series equivalent to the extended Riemann hypothesis for Dedekind zeta functions** [[paper](https://arxiv.org/abs/2509.21518)]
- [2025] **Linear relations between L-values of newforms and moments of elliptic K integral** [[paper](https://arxiv.org/abs/2509.19960)]
- [2025] **Rationality fields of CM modular forms** [[paper](https://arxiv.org/abs/2509.24119)]
- [2025] **An L-function Approach to Two-Dimensional Conformal Field Theory** [[paper](https://arxiv.org/abs/2509.21672)]
- [2025] **Complex moments of the derivative of the Riemann zeta function** [[paper](https://arxiv.org/abs/2509.07788)]
- [2025] **Integer moments of the derivatives of the Riemann zeta function** [[paper](https://arxiv.org/abs/2509.07792)]
- [2025] **Computing the Zeros of a Holomorphic Function Using Quadrature-Based Subdivision and Rational Approximation of the Logarithmic Derivative** [[paper](https://arxiv.org/abs/2509.15936)]
- [2025] **Efficient Algorithms for Disjoint Shortest Paths Problem and its Extensions** [[paper](https://arxiv.org/abs/2509.14588)]
- [2025] **Solving Zero-Sum Games with Fewer Matrix-Vector Products** [[paper](https://arxiv.org/abs/2509.04426)]
- [2025] **A Predictive Framework for Base-n Radix Sort Optimization** [[paper](https://arxiv.org/abs/2509.19021)]
- [2025] **Explicit zero-free regions for automorphic L-functions** [[paper](https://arxiv.org/abs/2509.20873)]
- [2025] **Moments of Higher Logarithmic Derivatives and Exceptional Zeros in Cyclotomic Fields** [[paper](https://arxiv.org/abs/2509.06390)]
- [2025] **Quantum arithmetic of Drinfeld modules** [[paper](https://arxiv.org/abs/2509.01818)]
- [2025] **The Parity of Two Types of Cyclotomic Euler Sums via Contour Integrals** [[paper](https://arxiv.org/abs/2509.17468)]
- [2025] **A Baseline T\log^2 T Upper Bound for KL-Regularized Prime--Zero Optimal Transport** [[paper](https://arxiv.org/abs/2509.07329)]
- [2025] **Shifted moments of cubic and quartic Dirichlet L-functions** [[paper](https://arxiv.org/abs/2508.14534)]
- [2025] **Conditional estimates on the argument of Dirichlet L-functions with applications to low-lying zeros** [[paper](https://arxiv.org/abs/2508.13301)]
- [2025] **An application of Titchmarsh's theorem and the Salem equivalence** [[paper](https://arxiv.org/abs/2508.21789)]
- [2025] **Large sieves for GL_n and applications** [[paper](https://arxiv.org/abs/2508.14888)]
- [2025] **Bulk asymptotics of the Gaussian β-ensemble characteristic polynomial** [[paper](https://arxiv.org/abs/2508.01458)]
- [2025] **Unconditional results for Artin-type problems over number fields** [[paper](https://arxiv.org/abs/2508.08996)]
- [2025] **Selberg orthogonality for half-integral weight modular forms** [[paper](https://arxiv.org/abs/2508.07734)]
- [2025] **On the Parameterized Complexity of Grundy Domination and Zero Forcing Problems** [[paper](https://arxiv.org/abs/2508.18104)]
- [2025] **Output-Sparse Matrix Multiplication Using Compressed Sensing** [[paper](https://arxiv.org/abs/2508.10250)]
- [2025] **An effective version of Chebotarev's density theorem** [[paper](https://arxiv.org/abs/2508.09480)]
- [2025] **An explicit parity theorem for multiple polylogarithms** [[paper](https://arxiv.org/abs/2508.02040)]
- [2025] **On a proof of Xu's Conjecture and depths of Galois descents** [[paper](https://arxiv.org/abs/2508.02648)]
- [2025] **Exceptional zeros of GL_3\timesGL_3 Rankin-Selberg L-functions** [[paper](https://arxiv.org/abs/2508.09984)]
- [2025] **Landau-Siegel Zeros of Triple Product L-functions** [[paper](https://arxiv.org/abs/2508.06423)]
- [2025] **A new zero-density estimate for ζ(s) and the error term in the Prime Number Theorem** [[paper](https://arxiv.org/abs/2508.02041)]
- [2025] **Gaussian test functions and Jacquet-Rallis transfer** [[paper](https://arxiv.org/abs/2508.12598)]
- [2025] **Subconvex L^p-sets, Weyl's inequality, and equidistribution** [[paper](https://arxiv.org/abs/2508.13384)]
- [2025] **The Weyl bound for triple product L-functions in the cubic level** [[paper](https://arxiv.org/abs/2508.13746)]
- [2025] **Simultaneous nonvanishing of Dirichlet L-functions in Galois orbits** [[paper](https://arxiv.org/abs/2507.06609)]
- [2025] **On Hypothesis H of Rudnick and Sarnak** [[paper](https://arxiv.org/abs/2507.20653)]
- [2025] **Distributions of consecutive level spacings of circular unitary ensemble and their ratio: finite-size corrections and Riemann ζ zeros** [[paper](https://arxiv.org/abs/2507.10193)]
- [2025] **Correlations of error terms for weighted prime counting functions** [[paper](https://arxiv.org/abs/2507.13504)]
- [2025] **Effective open image theorem and a Linnik type problem for elliptic curves** [[paper](https://arxiv.org/abs/2507.06913)]
- [2025] **Approximate direct and inverse scattering for the AKNS system** [[paper](https://arxiv.org/abs/2507.05525)]
- [2025] **Linearization-Based Feedback Stabilization of McKean-Vlasov PDEs** [[paper](https://arxiv.org/abs/2507.12411)]
- [2025] **Superconvergence points of Hermite spectral interpolation** [[paper](https://arxiv.org/abs/2507.15350)]
- [2025] **Approaching Optimality for Solving Dense Linear Systems with Low-Rank Structure** [[paper](https://arxiv.org/abs/2507.11724)]
- [2025] **To buy or not to buy: deterministic rent-or-buy problems on node-weighted graphs** [[paper](https://arxiv.org/abs/2507.08698)]
- [2025] **On zeros and algorithms for disordered systems: mean-field spin glasses** [[paper](https://arxiv.org/abs/2507.15616)]
- [2025] **Solving Linear Programs with Differential Privacy** [[paper](https://arxiv.org/abs/2507.10946)]
- [2025] **On the connection between zero-free regions and the error term in the Prime Number Theorem** [[paper](https://arxiv.org/abs/2507.13780)]
- [2025] **Refinements for primes in short arithmetic progressions** [[paper](https://arxiv.org/abs/2507.15334)]
- [2025] **On effective mean-values of arithmetic functions** [[paper](https://arxiv.org/abs/2507.10483)]
- [2025] **Explicit Formulas For Generalized Polylogarithmic Integrals, Euler Sums, And BBP-Type Series** [[paper](https://arxiv.org/abs/2507.04205)]
- [2025] **A Rigorous Error Bound for the TG Kernel in Prime Counting** [[paper](https://arxiv.org/abs/2506.22634)]
- [2025] **Lower bounds for high moments of zeta sums** [[paper](https://arxiv.org/abs/2506.09334)]
- [2025] **Stable Computation of Laplacian Eigenfunctions Corresponding to Clustered Eigenvalues** [[paper](https://arxiv.org/abs/2506.07340)]
- [2025] **Two dimensional integral representations via branches of the Bruhat-Tits tree** [[paper](https://arxiv.org/abs/2506.05661)]
- [2025] **The cubic moment of L-functions for specified local component families** [[paper](https://arxiv.org/abs/2506.14741)]
- [2025] **Mean value theorems with smooth numbers** [[paper](https://arxiv.org/abs/2506.22192)]
- [2025] **An extended Vinogradov's mean value theorem** [[paper](https://arxiv.org/abs/2506.01751)]
- [2025] **Twisted second moment of primitive cubic L-functions** [[paper](https://arxiv.org/abs/2506.14656)]
- [2025] **The hyperbolic lattice counting problem in large dimensions** [[paper](https://arxiv.org/abs/2506.17753)]
- [2025] **Iwasawa theory for vertex-weighted graphs** [[paper](https://arxiv.org/abs/2505.12351)]
- [2025] **Hamiltonian with Energy Levels Corresponding to Riemann Zeros** [[paper](https://arxiv.org/abs/2505.21192)]
- [2025] **FTNILO: Explicit Multivariate Function Inversion, Optimization and Counting, Cryptography Weakness and Riemann Hypothesis Solution Equation with Tensor Networks** [[paper](https://arxiv.org/abs/2505.05493)]
- [2025] **The second moment of cubic Dirichlet L-functions over function fields** [[paper](https://arxiv.org/abs/2505.12015)]
- [2025] **Some explicit values of a q-multiple zeta-star function at roots of unity** [[paper](https://arxiv.org/abs/2505.11207)]
- [2025] **Automatic Verification of Floating-Point Accumulation Networks** [[paper](https://arxiv.org/abs/2505.18791)]
- [2025] **Computational Math with Neural Networks is Hard** [[paper](https://arxiv.org/abs/2505.17751)]
- [2025] **On the regularization property of Levenberg-Marquardt method with Singular Scaling for nonlinear inverse problems** [[paper](https://arxiv.org/abs/2506.00190)]
- [2025] **Success probability in Shor's Algorithm** [[paper](https://arxiv.org/abs/2505.00433)]
- [2025] **A Private Approximation of the 2nd-Moment Matrix of Any Subsamplable Input** [[paper](https://arxiv.org/abs/2505.14251)]
- [2025] **Beyond endoscopy for \mathsf{GL}_2 over \mathbb{Q} with ramification 1: Poisson summation** [[paper](https://arxiv.org/abs/2505.18967)]
- [2025] **On the p-adic valuations of values of Legendre polynomials** [[paper](https://arxiv.org/abs/2505.08935)]
- [2025] **Riemann zeros and the KKR determinant** [[paper](https://arxiv.org/abs/2504.07928)]
- [2025] **Variance of square-full integers in short intervals and arithmetic progressions** [[paper](https://arxiv.org/abs/2504.14511)]
- [2025] **On the distribution of the sequence of integers d(n^2)** [[paper](https://arxiv.org/abs/2504.13968)]
- [2025] **An Efficient Second-Order Adaptive Procedure for Inserting CAD Geometries into Hexahedral Meshes using Volume Fractions** [[paper](https://arxiv.org/abs/2504.03525)]
- [2025] **On Mixed-Precision Iterative Methods and Analysis for Nearly Completely Decomposable Markov Processes** [[paper](https://arxiv.org/abs/2504.06378)]
- [2025] **Minimum Cost Nowhere-zero Flows and Cut-balanced Orientations** [[paper](https://arxiv.org/abs/2504.18767)]
- [2025] **Approximate Lifted Model Construction** [[paper](https://arxiv.org/abs/2504.20784)]
- [2025] **The Long Arm of Nashian Allocation in Online p-Mean Welfare Maximization** [[paper](https://arxiv.org/abs/2504.13430)]
- [2025] **Deterministic factorization of constant-depth algebraic circuits in subexponential time** [[paper](https://arxiv.org/abs/2504.08063)]
- [2025] **Invertible Calabi-Yau Orbifolds over Finite Fields** [[paper](https://arxiv.org/abs/2504.16716)]
- [2025] **Arborescent links and modular tails** [[paper](https://arxiv.org/abs/2504.18060)]
- [2025] **On the mean value of GL_1 and GL_2 L-functions, with applications to murmurations** [[paper](https://arxiv.org/abs/2504.09944)]
- [2025] **Murmurations for elliptic curves ordered by height** [[paper](https://arxiv.org/abs/2504.12295)]
- [2025] **The first moment of central value of primitive quartic L-functions with fixed genus** [[paper](https://arxiv.org/abs/2504.14291)]
- [2025] **Application of methods of quasicrystals theory to entire functions of exponential growth** [[paper](https://arxiv.org/abs/2504.03365)]
- [2025] **Uniform treatments of Bernoulli numbers, Stirling numbers, and their generating functions** [[paper](https://arxiv.org/abs/2504.16965)]
- [2025] **Formalizing zeta and L-functions in Lean** [[paper](https://arxiv.org/abs/2503.00959)]
- [2025] **The positivity technique and low-lying zeros of Dirichlet L-functions** [[paper](https://arxiv.org/abs/2503.15832)]
- [2025] **Twisted moments of characteristic polynomials of random matrices in the unitary group** [[paper](https://arxiv.org/abs/2503.21682)]
- [2025] **Simple and accurate approximations to the Riemann zeta function** [[paper](https://arxiv.org/abs/2503.09519)]
- [2025] **The subconvexity bound for standard L-function in level aspect** [[paper](https://arxiv.org/abs/2503.12310)]
- [2025] **Level curves for Zhang's Eta Function** [[paper](https://arxiv.org/abs/2503.07696)]
- [2025] **On the Second Hardy-Littlewood Conjecture** [[paper](https://arxiv.org/abs/2503.02766)]
- [2025] **On computing the zeros of a class of Sobolev orthogonal polynomials** [[paper](https://arxiv.org/abs/2503.20567)]
- [2025] **Shock with Confidence: Formal Proofs of Correctness for Hyperbolic Partial Differential Equation Solvers** [[paper](https://arxiv.org/abs/2503.13877)]
- [2025] **Coreset Spectral Clustering** [[paper](https://arxiv.org/abs/2503.07227)]
- [2025] **Root numbers for twisted Fermat quotient curves** [[paper](https://arxiv.org/abs/2503.22991)]
- [2025] **Mean value theorems for rational exponential sums** [[paper](https://arxiv.org/abs/2503.10933)]
- [2025] **Mean value of cubic L-funcitons with fixed genus** [[paper](https://arxiv.org/abs/2503.17228)]
- [2025] **Pair correlation for sums of two ordinates of zeros of the Riemann zeta function** [[paper](https://arxiv.org/abs/2502.20569)]
- [2025] **On the largest singular vector of the Redheffer matrix** [[paper](https://arxiv.org/abs/2502.09489)]
- [2025] **Certified algebraic curve projections by path tracking** [[paper](https://arxiv.org/abs/2502.05357)]
- [2025] **A fast and slightly robust covariance estimator** [[paper](https://arxiv.org/abs/2502.20708)]
- [2025] **Understanding the Kronecker Matrix-Vector Complexity of Linear Algebra** [[paper](https://arxiv.org/abs/2502.08029)]
- [2025] **Subconvexity for \rm GL_2 \times GL_2 L-functions in the depth aspect** [[paper](https://arxiv.org/abs/2502.18727)]
- [2025] **A Subconvex Metaplectic Prime Geodesic Theorem and the Shimura Correspondence** [[paper](https://arxiv.org/abs/2502.18366)]
- [2025] **On the mean values of the Barnes multiple zeta function** [[paper](https://arxiv.org/abs/2502.09852)]
- [2025] **Fourier optimization and pair correlation problems** [[paper](https://arxiv.org/abs/2502.05106)]
- [2025] **On some properties of special functions involving k-gamma and k-digamma functions** [[paper](https://arxiv.org/abs/2502.15852)]
- [2025] **On the distribution of the strongly multiplicative function 2^{ω(n)} on the set of natural numbers** [[paper](https://arxiv.org/abs/2502.02598)]
- [2025] **The Mean Value Theorem: Analytical Proof and Computational Approaches** [[paper](https://arxiv.org/abs/2501.02449)]
- [2025] **A SIMPLE-Based Preconditioned Solver for the Direct-Forcing Immersed Boundary Method** [[paper](https://arxiv.org/abs/2501.15314)]
- [2025] **The Numerical Approximation of Caputo Fractional Derivative of Higher Orders Using A Shifted Gegenbauer Pseudospectral Method: Two-Point Boundary Value Problems of the Bagley Torvik Type Case Study** [[paper](https://arxiv.org/abs/2501.17956)]
- [2025] **Local Sherman's Algorithm for Multi-commodity Flow** [[paper](https://arxiv.org/abs/2501.10632)]
- [2025] **On the non-submodularity of the problem of adding links to minimize the effective graph resistance** [[paper](https://arxiv.org/abs/2501.03363)]
- [2025] **New Proofs of the Explicit Formulas of Arakawa--Kaneko Zeta Values and Kaneko--Tsumura η- and ψ- Values** [[paper](https://arxiv.org/abs/2501.11303)]
- [2025] **Hybrid bounds for {\rm{GL}}(4)\times {\rm{GL}}(1) twisted L-functions** [[paper](https://arxiv.org/abs/2501.15801)]
- [2025] **Étude statistique du facteur premier médian, 1 : valeur moyenne** [[paper](https://arxiv.org/abs/2501.15947)]
- [2025] **First moments of {\rm{GL}} (3) \times {\rm{GL}} (2) and {\rm{GL}} (2) L-functions and their applications** [[paper](https://arxiv.org/abs/2501.15886)]

##### 2024

- [2024] **Bounds for Moments of Twisted Fourier coefficients of Modular Forms** [[paper](https://arxiv.org/abs/2412.12515)]
- [2024] **Low-Lying Zeros of L-functions of Adélic Hilbert Modular Forms and their Convolutions** [[paper](https://arxiv.org/abs/2412.03034)]
- [2024] **Bounds for moments of quadratic Dirichlet character sums of prime moduli** [[paper](https://arxiv.org/abs/2412.19151)]
- [2024] **On Shusterman's Goldbach-type problem for sign patterns of the Liouville function** [[paper](https://arxiv.org/abs/2412.17199)]
- [2024] **A numerical algorithm for computing the zeros of parabolic cylinder functions in the complex plane** [[paper](https://arxiv.org/abs/2412.13085)]
- [2024] **Computation and properties of the Epstein zeta function with applications to quantum systems** [[paper](https://arxiv.org/abs/2412.16317)]
- [2024] **On curious properties of the general size-biased distribution** [[paper](https://arxiv.org/abs/2412.19347)]
- [2024] **The third moment of the logarithm of zeta and a twisted pair correlation conjecture** [[paper](https://arxiv.org/abs/2412.20099)]
- [2024] **Spherical Area-Preserving Parameterization via Energy Minimization** [[paper](https://arxiv.org/abs/2412.19011)]
- [2024] **Verifying Shortest Paths in Linear Time** [[paper](https://arxiv.org/abs/2412.06121)]
- [2024] **Computational Explorations of Total Variation Distance** [[paper](https://arxiv.org/abs/2412.10370)]
- [2024] **NP-hardness and a PTAS for the Euclidean Steiner Line Problem** [[paper](https://arxiv.org/abs/2412.07046)]
- [2024] **The Igusa local zeta function of certain Thom-Sebastiani type functions** [[paper](https://arxiv.org/abs/2412.08354)]
- [2024] **Improved estimates for the argument and zero-counting function of the Riemann zeta-function** [[paper](https://arxiv.org/abs/2412.15470)]
- [2024] **Spectral Reciprocity for the first moment of triple product L-functions and applications** [[paper](https://arxiv.org/abs/2501.10418)]
- [2024] **Subconvex bound for Rankin-Selberg L-functions in prime power level** [[paper](https://arxiv.org/abs/2412.01739)]
- [2024] **Level aspect subconvexity for \textrm{GL(2)}\times \textrm{GL(2)} \textrm{L}-functions** [[paper](https://arxiv.org/abs/2412.12410)]
- [2024] **The asymptotic in Waring's problem over function fields via a singular locus in the circle method** [[paper](https://arxiv.org/abs/2412.14053)]
- [2024] **Pointwise ergodic theorems along fractional powers of primes** [[paper](https://arxiv.org/abs/2412.07055)]
- [2024] **Integral representation and functional inequalities involving generalized polylogarithm** [[paper](https://arxiv.org/abs/2412.08552)]
- [2024] **L^{p}-integrability of functions with Fourier supports on fractal sets on the moment curve** [[paper](https://arxiv.org/abs/2412.19956)]
- [2024] **Lower bounds for shifted moments of Dirichlet L-functions of fixed modulus** [[paper](https://arxiv.org/abs/2411.03692)]
- [2024] **Nearly higher Coleman theory and p-adic L-functions for GSp(4) \times GL(2) and GSp(4) \times GL(2) \times GL(2)** [[paper](https://arxiv.org/abs/2411.04559)]
- [2024] **Optimal Cosine Polynomials for Riemann Zeta Zero-Free Region** [[paper](https://arxiv.org/abs/2411.01385)]
- [2024] **On the mean values of the error terms in Mertens' theorems** [[paper](https://arxiv.org/abs/2411.18903)]
- [2024] **Fourier optimization and consequences of the generalized Riemann hypothesis** [[paper](https://arxiv.org/abs/2411.05095)]
- [2024] **A Sylvester equation approach for the computation of zero-group-velocity points in waveguides** [[paper](https://arxiv.org/abs/2411.09584)]
- [2024] **A Simple Sparse Matrix Vector Multiplication Approach to Padded Convolution** [[paper](https://arxiv.org/abs/2411.19419)]
- [2024] **Totally Δ-modular IPs with two non-zeros in most rows** [[paper](https://arxiv.org/abs/2411.15282)]
- [2024] **Fair Secretaries with Unfair Predictions** [[paper](https://arxiv.org/abs/2411.09854)]
- [2024] **Optimal Capacity Modification for Stable Matchings with Ties** [[paper](https://arxiv.org/abs/2411.10284)]
- [2024] **Sampling permutations satisfying constraints within the lopsided local lemma regime** [[paper](https://arxiv.org/abs/2411.02750)]
- [2024] **Dimension Reduction via Sum-of-Squares and Improved Clustering Algorithms for Non-Spherical Mixtures** [[paper](https://arxiv.org/abs/2411.12438)]
- [2024] **Non-zero values of a family of approximations of a class of L-functions** [[paper](https://arxiv.org/abs/2411.08364)]
- [2024] **A note on zero-density approaches for the difference between consecutive primes** [[paper](https://arxiv.org/abs/2411.01845)]
- [2024] **A general quantified Ingham-Karamata Tauberian theorem** [[paper](https://arxiv.org/abs/2411.03809)]
- [2024] **Conductors and local newforms for the metaplectic group of rank 1** [[paper](https://arxiv.org/abs/2410.16564)]
- [2024] **Hypergeometric Functions of Random Matrices and Quasimodular Forms** [[paper](https://arxiv.org/abs/2410.04243)]
- [2024] **Matsuda monoids and Artin's primitive root conjecture** [[paper](https://arxiv.org/abs/2410.09694)]
- [2024] **On the analytic extension of Random Riemann Zeta Functions for some probabilistic models of the primes** [[paper](https://arxiv.org/abs/2410.03044)]
- [2024] **Conditional estimates for L-functions in the Selberg class II** [[paper](https://arxiv.org/abs/2410.22711)]
- [2024] **Multi-Window Approaches for Direct and Stable STFT Phase Retrieval** [[paper](https://arxiv.org/abs/2410.05486)]
- [2024] **Anytime-Constrained Equilibria in Polynomial Time** [[paper](https://arxiv.org/abs/2410.23637)]
- [2024] **Putting Off the Catching Up: Online Joint Replenishment Problem with Holding and Backlog Costs** [[paper](https://arxiv.org/abs/2410.18535)]
- [2024] **Towards a Parameterized Approximation Dichotomy of MinCSP for Linear Equations over Finite Commutative Rings** [[paper](https://arxiv.org/abs/2410.09932)]
- [2024] **Regularized Robustly Reliable Learners and Instance Targeted Attacks** [[paper](https://arxiv.org/abs/2410.10572)]
- [2024] **An Algebraic Generalization of the Ramanujan Sum** [[paper](https://arxiv.org/abs/2411.00018)]
- [2024] **On the Endomorphism Algebra of Abelian Varieties Associated with Hilbert Modular Forms** [[paper](https://arxiv.org/abs/2410.20223)]
- [2024] **Traces of partition Eisenstein series and almost holomorphic modular forms** [[paper](https://arxiv.org/abs/2410.04892)]
- [2024] **On the Second Moment of Twisted Higher Degree L-functions** [[paper](https://arxiv.org/abs/2410.20144)]
- [2024] **Voronoi summation formulas, oscillations of Riesz sums, and Ramanujan-Guinand and Cohen type identities** [[paper](https://arxiv.org/abs/2410.04506)]
- [2024] **Equivalent criteria for the Riemann hypothesis for a general class of L-functions** [[paper](https://arxiv.org/abs/2409.17708)]
- [2024] **Sharp conditional moment bounds for products of L-functions** [[paper](https://arxiv.org/abs/2409.19780)]
- [2024] **On moments of the derivative of CUE characteristic polynomials and the Riemann zeta function** [[paper](https://arxiv.org/abs/2409.03687)]
- [2024] **A refined random matrix model for function field L-functions** [[paper](https://arxiv.org/abs/2409.02876)]
- [2024] **A lower bound on high moments of character sums** [[paper](https://arxiv.org/abs/2409.13436)]
- [2024] **Asymptotics for smooth numbers in short intervals** [[paper](https://arxiv.org/abs/2409.05761)]
- [2024] **Nonabelian Fourier Kernels on SL_2 and GL_2** [[paper](https://arxiv.org/abs/2409.14696)]
- [2024] **Note on an explicit formula of Rademacher symbols for triangle groups** [[paper](https://arxiv.org/abs/2409.12779)]
- [2024] **Wild conductor exponents of curves** [[paper](https://arxiv.org/abs/2409.12688)]
- [2024] **A Mean Value Theorem for general Dirichlet Series** [[paper](https://arxiv.org/abs/2409.06301)]
- [2024] **Murmurations and ratios conjectures** [[paper](https://arxiv.org/abs/2408.12723)]
- [2024] **Linear constellations in primes with arithmetic restrictions** [[paper](https://arxiv.org/abs/2408.17441)]
- [2024] **Functional Equations and Pole Structure of the Bartholdi Zeta Function** [[paper](https://arxiv.org/abs/2408.04952)]
- [2024] **Nontrivial Riemann Zeros as Spectrum** [[paper](https://arxiv.org/abs/2408.15135)]
- [2024] **Shifted second moment of the Riemann zeta function and a Fourier type kernel** [[paper](https://arxiv.org/abs/2408.04247)]
- [2024] **Paramodular forms from Calabi-Yau Operators** [[paper](https://arxiv.org/abs/2408.10183)]
- [2024] **Asymptotics of a Gauss hypergeometric function related to moments of symmetric square L-functions I** [[paper](https://arxiv.org/abs/2408.05615)]
- [2024] **Square-free orders for CM elliptic curves modulo p in short intervals** [[paper](https://arxiv.org/abs/2408.05904)]
- [2024] **Faster Private Minimum Spanning Trees** [[paper](https://arxiv.org/abs/2408.06997)]
- [2024] **Asymptotics of a Gauss hypergeometric function related to moments of symmetric-square L-functions II** [[paper](https://arxiv.org/abs/2408.05619)]
- [2024] **Whittaker functions on GL(4,R) and archimedean Bump--Friedberg integrals** [[paper](https://arxiv.org/abs/2409.00401)]
- [2024] **A method for verifying the generalized Riemann hypothesis** [[paper](https://arxiv.org/abs/2408.00187)]
- [2024] **A Tauberian characterization of the Riemann hypothesis through the floor function** [[paper](https://arxiv.org/abs/2407.18859)]
- [2024] **Analytic Number Theory and Algebraic Asymptotic Analysis** [[paper](https://arxiv.org/abs/2407.17820)]
- [2024] **Series over Bessel functions as series in terms of Riemann's zeta function** [[paper](https://arxiv.org/abs/2407.13004)]
- [2024] **Straggler-tolerant stationary methods for linear systems** [[paper](https://arxiv.org/abs/2407.01098)]
- [2024] **Total Lagrangian Smoothed Particle Hydrodynamics with An Improved Bond-Based Deformation Gradient for Large Strain Solid Dynamics** [[paper](https://arxiv.org/abs/2407.04021)]
- [2024] **A Decomposition Theorem for Dynamic Flows** [[paper](https://arxiv.org/abs/2407.04761)]
- [2024] **Hybrid k-Clustering: Blending k-Median and k-Center** [[paper](https://arxiv.org/abs/2407.08295)]
- [2024] **The second moment of the GL_3 standard L-function on the critical line** [[paper](https://arxiv.org/abs/2407.06962)]
- [2024] **Primes in almost all short intervals** [[paper](https://arxiv.org/abs/2407.05651)]
- [2024] **New zero-density estimates for the Beurling ζ function** [[paper](https://arxiv.org/abs/2407.12746)]
- [2024] **On a space of functions with entire Laplace transforms and its connection with the optimality of the Ingham-Karamata theorem** [[paper](https://arxiv.org/abs/2407.15547)]
- [2024] **Some new properties of the beta function and Ramanujan R-function** [[paper](https://arxiv.org/abs/2407.15664)]
- [2024] **Shifted moments of quadratic Dirichlet L-functions** [[paper](https://arxiv.org/abs/2406.18024)]
- [2024] **Large values of quadratic Dirichlet L-functions** [[paper](https://arxiv.org/abs/2406.01519)]
- [2024] **Euler Product Sieve** [[paper](https://arxiv.org/abs/2406.00786)]
- [2024] **Method for Verifying Solutions of Sparse Linear Systems with General Coefficients** [[paper](https://arxiv.org/abs/2406.02033)]
- [2024] **Zeroing neural dynamics solving time-variant complex conjugate matrix equation X(τ)F(τ)-A(τ)\overline{X}(τ)=C(τ)** [[paper](https://arxiv.org/abs/2406.12783)]
- [2024] **Roping in Uncertainty: Robustness and Regularization in Markov Games** [[paper](https://arxiv.org/abs/2406.08847)]
- [2024] **Approximation Algorithms for Smallest Intersecting Balls** [[paper](https://arxiv.org/abs/2406.11369)]
- [2024] **Engineering Semi-streaming DFS algorithms** [[paper](https://arxiv.org/abs/2406.03922)]
- [2024] **Dedekind sums and mean square value of L(1,χ) over subgroups** [[paper](https://arxiv.org/abs/2406.02802)]
- [2024] **Coproduct Formula for Motivic Version of Yamamoto's Integral** [[paper](https://arxiv.org/abs/2406.08127)]
- [2024] **Integral solutions to systems of diagonal equations** [[paper](https://arxiv.org/abs/2406.09256)]
- [2024] **Mean Values of the auxiliary function** [[paper](https://arxiv.org/abs/2406.13278)]
- [2024] **Recovering short generators via negative moments of Dirichlet L-functions** [[paper](https://arxiv.org/abs/2405.13420)]
- [2024] **Euler Products at the Centre and Applications to Chebyshev's Bias** [[paper](https://arxiv.org/abs/2405.01512)]
- [2024] **Upper Bounds for the Lowest First Zero in Families of Cuspidal Newforms** [[paper](https://arxiv.org/abs/2405.11172)]
- [2024] **The Riemann hypothesis and dynamics of Backtracking New Q-Newton's method** [[paper](https://arxiv.org/abs/2405.05834)]
- [2024] **Upper bounds for moments of zeta sums** [[paper](https://arxiv.org/abs/2405.12506)]
- [2024] **The average number of Goldbach representations over multiples of q** [[paper](https://arxiv.org/abs/2405.04315)]
- [2024] **Moments of symmetric square L-functions on GL(3)** [[paper](https://arxiv.org/abs/2405.10827)]
- [2024] **Rogers-Ramanujan identities in Statistical Mechanics** [[paper](https://arxiv.org/abs/2405.08425)]
- [2024] **Explicit estimates for the logarithmic derivative and the reciprocal of the Riemann zeta function** [[paper](https://arxiv.org/abs/2405.04869)]
- [2024] **Almost periodicity and boundary values of Dirichlet series** [[paper](https://arxiv.org/abs/2405.03522)]
- [2024] **An 808 Line Phasor-Based Dehomogenisation Matlab Code For Multi-Scale Topology Optimisation** [[paper](https://arxiv.org/abs/2405.14321)] [[code](https://github.com/peterdorffler/deHomTop808.git)]
- [2024] **Fair Set Cover** *KDD 2025* [[paper](https://arxiv.org/abs/2405.11639)]
- [2024] **Effective correlation and decorrelation for newforms, and weak subconvexity for L-functions** [[paper](https://arxiv.org/abs/2405.05249)]
- [2024] **Estimates for smooth Weyl sums on major arcs** [[paper](https://arxiv.org/abs/2405.18608)]
- [2024] **Explicit formulae for the mean value of products of values of Dirichlet L-functions at positive integers** [[paper](https://arxiv.org/abs/2405.17981)]
- [2024] **On a Generalized Moment Integral containing Riemann's Zeta Function: Analysis and Experiment** [[paper](https://arxiv.org/abs/2405.16429)]
- [2024] **Brenke polynomials with real zeros and the Riemann Hypothesis** [[paper](https://arxiv.org/abs/2405.18940)]
- [2024] **Summing divergent matrix series** [[paper](https://arxiv.org/abs/2405.19713)]
- [2024] **Character Sums and the Riemann Hypothesis** [[paper](https://arxiv.org/abs/2404.19647)]
- [2024] **On the spectrum of a differential operator on a Hilbert-Pólya space** [[paper](https://arxiv.org/abs/2404.11902)]
- [2024] **Newton's method for nonlinear mappings into vector bundles** [[paper](https://arxiv.org/abs/2404.04073)]
- [2024] **Computation of the solution for the 2D acoustic pulse propagation** [[paper](https://arxiv.org/abs/2404.10489)]
- [2024] **The PRODSAT phase of random quantum satisfiability** [[paper](https://arxiv.org/abs/2404.18447)]
- [2024] **The ESPRIT algorithm under high noise: Optimal error scaling and noisy super-resolution** [[paper](https://arxiv.org/abs/2404.03885)]
- [2024] **A note on trigonometric polynomials for lower bounds of ζ(s)** [[paper](https://arxiv.org/abs/2404.05928)]
- [2024] **An explicit formula for the orbital integrals on the spherical Hecke algebra of GL_3** [[paper](https://arxiv.org/abs/2404.04666)]
- [2024] **Petersson norms of Borcherds theta lifts to O(1, 8n+1) with applications to injectivity and sup-norm bounds** [[paper](https://arxiv.org/abs/2404.04426)]
- [2024] **Non-Abelian observable-geometric phases and the Riemann zeros** [[paper](https://arxiv.org/abs/2403.19118)]
- [2024] **The Density of Borromean Primes** [[paper](https://arxiv.org/abs/2403.17957)]
- [2024] **On the error in the prime number theorem in short intervals** [[paper](https://arxiv.org/abs/2403.11814)]
- [2024] **On Littlewood's estimate for the modulus of the zeta function on the critical line** [[paper](https://arxiv.org/abs/2403.17803)]
- [2024] **On the computation of lattice sums without translational invariance** [[paper](https://arxiv.org/abs/2403.03213)]
- [2024] **A high-order explicit Runge-Kutta approximation technique for the Shallow Water Equations** [[paper](https://arxiv.org/abs/2403.17123)]
- [2024] **Another look at Residual Dynamic Mode Decomposition in the regime of fewer Snapshots than Dictionary Size** [[paper](https://arxiv.org/abs/2403.05891)]
- [2024] **Minimum-cost paths for electric cars** [[paper](https://arxiv.org/abs/2403.16936)]
- [2024] **Towards Deterministic Algorithms for Constant-Depth Factors of Constant-Depth Circuits** [[paper](https://arxiv.org/abs/2403.01965)]
- [2024] **An explicit parity theorem for multiple zeta values via multitangent functions** [[paper](https://arxiv.org/abs/2403.14604)]
- [2024] **Frobenius numbers associated with Diophantine triples of x^2+y^2=z^r (extended version)** [[paper](https://arxiv.org/abs/2403.07534)]
- [2024] **Sharp bounds for joint moments of the Riemann zeta function** [[paper](https://arxiv.org/abs/2403.00902)]
- [2024] **The Prime Geodesic Theorem for the Picard Orbifold** [[paper](https://arxiv.org/abs/2403.06626)]
- [2024] **Mean values of arithmetic functions and application to sums of powers** [[paper](https://arxiv.org/abs/2403.19320)]
- [2024] **Bounds for moments of quadratic Dirichlet character sums** [[paper](https://arxiv.org/abs/2403.14634)]
- [2024] **The Multiplicative Formula of Langlands for Orbital Integrals in GL(2)** [[paper](https://arxiv.org/abs/2402.08013)]
- [2024] **The Kummer ratio of the relative class number for prime cyclotomic fields** [[paper](https://arxiv.org/abs/2402.13829)]
- [2024] **Explicit formula and quasicrystal definition** [[paper](https://arxiv.org/abs/2402.10604)]
- [2024] **Uniform enclosures for the phase and zeros of Bessel functions and their derivatives** [[paper](https://arxiv.org/abs/2402.06956)]
- [2024] **De la Vallée Poussin filtered polynomial approximation on the half line** [[paper](https://arxiv.org/abs/2402.08358)]
- [2024] **Finite and infinite order differential properties of the reduced Mittag--Leffler polynomials** [[paper](https://arxiv.org/abs/2402.07795)]
- [2024] **Integrating High-Dimensional Functions Deterministically** [[paper](https://arxiv.org/abs/2402.08232)]
- [2024] **Decremental (1+ε)-Approximate Maximum Eigenvector: Dynamic Power Method** [[paper](https://arxiv.org/abs/2402.17929)]
- [2024] **Problems on Group-labeled Matroid Bases** [[paper](https://arxiv.org/abs/2402.16259)]
- [2024] **On the error term in the explicit formula of Riemann-von Mangoldt II** [[paper](https://arxiv.org/abs/2402.04272)]
- [2024] **Equations of genus 4 curves from their theta constants** [[paper](https://arxiv.org/abs/2402.03160)]
- [2024] **Explicit formulae for linear characters of Γ_0(N)** [[paper](https://arxiv.org/abs/2402.14796)]
- [2024] **Efficient (3,3)-isogenies on fast Kummer surfaces** [[paper](https://arxiv.org/abs/2402.01223)]
- [2024] **Partitio Numerorum: sums of squares and higher powers** [[paper](https://arxiv.org/abs/2402.09537)]
- [2024] **An Extension of Glasser's Master Theorem and a Collection of Improper Integrals Many of Which Involve Riemann's Zeta Function** [[paper](https://arxiv.org/abs/2402.17586)]
- [2024] **Repulsion of zeros close to s=1/2 for L-functions** [[paper](https://arxiv.org/abs/2401.07959)]
- [2024] **Joint distribution of primes in multiple short intervals** [[paper](https://arxiv.org/abs/2401.04000)]
- [2024] **On the regularized products of some Dirichlet series** [[paper](https://arxiv.org/abs/2401.03645)]
- [2024] **Ordinality and Riemann Hypothesis II** [[paper](https://arxiv.org/abs/2401.07214)]
- [2024] **Class numbers, Ono invariants and some interesting primes** [[paper](https://arxiv.org/abs/2401.10930)]
- [2024] **Uniform bounds for the density in Artin's conjecture on primitive roots** [[paper](https://arxiv.org/abs/2401.11589)]
- [2024] **A note on Laguerre truncated polynomials and quadrature formula** [[paper](https://arxiv.org/abs/2401.00752)]
- [2024] **On the Algorithmic Verification of Nonlinear Superposition for Systems of First Order Ordinary Differential Equations** [[paper](https://arxiv.org/abs/2401.17012)]
- [2024] **Chebyshev Subdivision and Reduction Methods for Solving Multivariable Systems of Equations** [[paper](https://arxiv.org/abs/2401.02114)]
- [2024] **Validated numerics for algebraic path tracking** [[paper](https://arxiv.org/abs/2401.17973)]
- [2024] **The semi-analytic theory and computation of finite-depth standing water waves** [[paper](https://arxiv.org/abs/2401.00844)]
- [2024] **Multi-Function Multi-Way Analog Technology for Sustainable Machine Intelligence Computation** [[paper](https://arxiv.org/abs/2401.13754)]
- [2024] **An Instance-Based Approach to the Trace Reconstruction Problem** [[paper](https://arxiv.org/abs/2401.14277)]
- [2024] **Are We Still Missing an Item?** [[paper](https://arxiv.org/abs/2401.06547)]
- [2024] **An Optimal Randomized Algorithm for Finding the Saddlepoint** [[paper](https://arxiv.org/abs/2401.06512)]
- [2024] **Scalable network reconstruction in subquadratic time** [[paper](https://arxiv.org/abs/2401.01404)]
- [2024] **SARRIGUREN: a polynomial-time complete algorithm for random k-SAT with relatively dense clauses** [[paper](https://arxiv.org/abs/2401.09234)]
- [2024] **Generation of weighted trees, block trees and block graphs** [[paper](https://arxiv.org/abs/2401.09764)]
- [2024] **An Elementary Approach to the Group Law on Elliptic Curves** [[paper](https://arxiv.org/abs/2401.02346)]
- [2024] **The probability of non-isomorphic group structures of isogenous elliptic curves in finite field extensions, II** [[paper](https://arxiv.org/abs/2401.06250)]
- [2024] **Adelic Rogers' formula and an application** [[paper](https://arxiv.org/abs/2401.13476)]
- [2024] **Moments of Averages of Ramanujan Sums over Number Fields** [[paper](https://arxiv.org/abs/2401.05052)]

##### 2023

- [2023] **The average analytic rank of elliptic curves with prescribed level structure** [[paper](https://arxiv.org/abs/2312.05817)]
- [2023] **Euler Product Asymptotics for L-functions of Elliptic Curves** [[paper](https://arxiv.org/abs/2312.05236)]
- [2023] **Sharper bounds for the error in the prime number theorem assuming the Riemann Hypothesis** [[paper](https://arxiv.org/abs/2312.05628)]
- [2023] **A fast and efficient numerical method for computing the stress concentration between closely located stiff inclusions of general shapes** [[paper](https://arxiv.org/abs/2312.00630)]
- [2023] **Improved Approximation Coflows Scheduling Algorithms for Minimizing the Total Weighted Completion Time and Makespan in Heterogeneous Parallel Networks** [[paper](https://arxiv.org/abs/2312.16413)]
- [2023] **Values and derivative values at nonpositive integers of generalized multiple Hurwitz zeta functions** [[paper](https://arxiv.org/abs/2312.04725)]
- [2023] **Mean-square values of the Riemann zeta function on arithmetic progressions** [[paper](https://arxiv.org/abs/2401.01892)]
- [2023] **An approach to determining the existence of a limit distribution of additive arithmetic functions** [[paper](https://arxiv.org/abs/2401.08657)]
- [2023] **The simple normality of the fractional powers of two and the Riemann zeta function** [[paper](https://arxiv.org/abs/2312.13943)]
- [2023] **On the Riemann Hypothesis and Hilbert's Tenth Problem** [[paper](https://arxiv.org/abs/2311.09464)]
- [2023] **Interpolation and Extrapolation Statements equivalent to the Riemann Hypothesis** [[paper](https://arxiv.org/abs/2312.00211)]
- [2023] **On convergence of points to limiting processes, with an application to zeta zeros** [[paper](https://arxiv.org/abs/2311.13441)]
- [2023] **An explicit formula for the zeros of the Riemann zeta function** [[paper](https://arxiv.org/abs/2312.00108)]
- [2023] **A smooth version of Landaus explicit formula** [[paper](https://arxiv.org/abs/2311.04347)]
- [2023] **The Arithmetic of Elliptic Pairs and An ν+1-variable Artin Conjecture** [[paper](https://arxiv.org/abs/2311.16281)]
- [2023] **Optimal Embedding Dimension for Sparse Subspace Embeddings** [[paper](https://arxiv.org/abs/2311.10680)]
- [2023] **Perfect Simulation of Las Vegas Algorithms via Local Computation** [[paper](https://arxiv.org/abs/2311.11679)]
- [2023] **Improved Approximation Algorithms for Minimizing the Total Weighted Completion Time of Coflows** [[paper](https://arxiv.org/abs/2311.11296)]
- [2023] **A quantum central path algorithm for linear optimization** [[paper](https://arxiv.org/abs/2311.03977)]
- [2023] **Recursive lattice reduction -- A framework for finding short lattice vectors** [[paper](https://arxiv.org/abs/2311.15064)]
- [2023] **Generalizations of Koga's version of the Wiener-Ikehara theorem** [[paper](https://arxiv.org/abs/2311.03013)]
- [2023] **Frobenius sign separation for abelian varieties** [[paper](https://arxiv.org/abs/2310.10568)]
- [2023] **Fourier optimization and Montgomery's pair correlation conjecture** [[paper](https://arxiv.org/abs/2310.01913)]
- [2023] **Negative discrete moments of the derivative of the Riemann zeta-function** [[paper](https://arxiv.org/abs/2310.03949)]
- [2023] **A note on prime index of a certain subgroup in \mathbb{F}_p^*** [[paper](https://arxiv.org/abs/2310.04527)]
- [2023] **When D-companion matrix meets incomplete polynomials** [[paper](https://arxiv.org/abs/2310.08930)]
- [2023] **Backward Reachability Analysis of Perturbed Continuous-Time Linear Systems Using Set Propagation** [[paper](https://arxiv.org/abs/2310.19083)]
- [2023] **The Bivariate Normal Integral via Owen's T Function as a Modified Euler's Arctangent Series** [[paper](https://arxiv.org/abs/2312.00011)]
- [2023] **Finite difference method in prolate spheroidal coordinates for freely suspended spheroidal particles in linear flows of viscous and viscoelastic fluids** [[paper](https://arxiv.org/abs/2310.06665)]
- [2023] **Simple, Scalable and Effective Clustering via One-Dimensional Projections** *NeurIPS 2023* [[paper](https://arxiv.org/abs/2310.16752)]
- [2023] **Explicit Hecke descent for special cycles** [[paper](https://arxiv.org/abs/2310.01677)]
- [2023] **On the mean values of products of Dirichlet L-functions at positive integers** [[paper](https://arxiv.org/abs/2310.18048)]
- [2023] **On the joint second moment of zeta and its logarithmic derivative** [[paper](https://arxiv.org/abs/2310.15918)]
- [2023] **Mean value theorems for the S-arithmetic primitive Siegel transforms** [[paper](https://arxiv.org/abs/2310.03459)]
- [2023] **A Quadratic Vinogradov Mean Value Theorem in Finite Fields** [[paper](https://arxiv.org/abs/2310.02950)]
- [2023] **Hamiltonian for the Hilbert-Pólya Conjecture** [[paper](https://arxiv.org/abs/2309.00405)]
- [2023] **The supersingular endomorphism ring problem given one endomorphism** [[paper](https://arxiv.org/abs/2309.11912)]
- [2023] **The supersingular Endomorphism Ring and One Endomorphism problems are equivalent** [[paper](https://arxiv.org/abs/2309.10432)]
- [2023] **A Golub-Welsch version for simultaneous Gaussian quadrature** [[paper](https://arxiv.org/abs/2309.11864)]
- [2023] **Matrix-based implementation and GPU acceleration of linearized ordinary state-based peridynamic models in MATLAB** [[paper](https://arxiv.org/abs/2309.11273)]
- [2023] **Matrix Multiplication Verification Using Coding Theory** [[paper](https://arxiv.org/abs/2309.16176)]
- [2023] **Black-Box Identity Testing of Noncommutative Rational Formulas in Deterministic Quasipolynomial Time** [[paper](https://arxiv.org/abs/2309.15647)]
- [2023] **The residue-counts of x^2+a/x modulo a prime** [[paper](https://arxiv.org/abs/2309.07685)]
- [2023] **Multiple zeta-star values for indices of infinite length** [[paper](https://arxiv.org/abs/2309.09201)]
- [2023] **Subconvex bounds for U_{n+1}\times U_n in horizontal aspects** [[paper](https://arxiv.org/abs/2309.06314)]
- [2023] **Relative Trace Formula, Subconvexity and Quantitative Nonvanishing of Rankin-Selberg L-functions for GL(n+1)\timesGL(n)** [[paper](https://arxiv.org/abs/2309.07534)]
- [2023] **A remark on the mean value inequalities related to Waring's problem** [[paper](https://arxiv.org/abs/2309.11590)]
- [2023] **Subconvexity for L-functions on {\rm U}(n) \times {\rm U}(n+1) in the depth aspect** [[paper](https://arxiv.org/abs/2309.16667)]
- [2023] **Mean values of long Dirichlet polynomials with divisor coefficients** [[paper](https://arxiv.org/abs/2309.08057)]
- [2023] **Generalized divisor functions in arithmetic progressions: I** [[paper](https://arxiv.org/abs/2308.06839)]
- [2023] **Chebyshev's bias for Fermat curves of prime degree** [[paper](https://arxiv.org/abs/2307.05958)]
- [2023] **On off-critical zeros of lattice energies in the neighborhood of the Riemann zeta function** [[paper](https://arxiv.org/abs/2307.06002)]
- [2023] **On the constants in Mertens' theorems for primes in arithmetic progressions** [[paper](https://arxiv.org/abs/2306.09981)]
- [2023] **Jacob's ladders, almost linear increments of the Hardy-Littlewood integral (1918) and their relations to the Selberg's formula (1946) and the Fermat-Wiles theorem** [[paper](https://arxiv.org/abs/2306.07648)]
- [2023] **Schatten class composition operators on the Hardy space of Dirichlet series and a comparison-type principle** [[paper](https://arxiv.org/abs/2306.05733)]
- [2023] **Two Matrix Model, the Riemann Hypothesis and Master Matrix Obstruction** [[paper](https://arxiv.org/abs/2305.14664)]
- [2023] **A heuristic for discrete mean values of the derivative of the Riemann zeta function** [[paper](https://arxiv.org/abs/2305.14253)]
- [2023] **First moment of central values of quadratic Dirichlet L-functions** [[paper](https://arxiv.org/abs/2303.11588)]
- [2023] **High moments of theta functions and character sums** [[paper](https://arxiv.org/abs/2303.14561)]
- [2023] **The first coefficient of Langlands Eisenstein series for \hbox{SL}(n,\mathbb Z)** [[paper](https://arxiv.org/abs/2303.05442)]
- [2023] **Quantum Computing and the Riemann Hypothesis** [[paper](https://arxiv.org/abs/2303.04602)]
- [2023] **Formalization of p-adic L-functions in Lean 3** [[paper](https://arxiv.org/abs/2302.14491)]
- [2023] **The prime number theorem for primes in arithmetic progressions at large values** [[paper](https://arxiv.org/abs/2301.13457)]
- [2023] **Mollified Moments of Cubic Dirichlet L-Functions over the Eisenstein Field** [[paper](https://arxiv.org/abs/2301.10979)]
- [2023] **Large values of the error term in the prime number theorem** [[paper](https://arxiv.org/abs/2301.09053)]

##### 2022

- [2022] **The mixing conjecture under GRH** [[paper](https://arxiv.org/abs/2212.06280)]
- [2022] **Explicit zero-free regions for the Riemann zeta-function** [[paper](https://arxiv.org/abs/2212.06867)]
- [2022] **Implications of subconvexity bounds for the moments of zeta** [[paper](https://arxiv.org/abs/2212.04421)]
- [2022] **Currently there are no reasons to doubt the Riemann Hypothesis: The zeta function beyond the realm of computation** [[paper](https://arxiv.org/abs/2211.11671)]
- [2022] **An explicit version of Chen's theorem assuming the Generalized Riemann Hypothesis** [[paper](https://arxiv.org/abs/2211.08844)]
- [2022] **On the prime Selmer ranks of cyclic prime twist families of elliptic curves over global function fields** [[paper](https://arxiv.org/abs/2211.11486)]
- [2022] **Formally Self-Adjoint Hamiltonian for the Hilbert-Pólya Conjecture** [[paper](https://arxiv.org/abs/2211.01899)]
- [2022] **More Zero-Free Regions for Fractional Hypergeometric Zeta Functions** [[paper](https://arxiv.org/abs/2211.10074)]
- [2022] **An explicit Vinogradov-Korobov zero-free region for Dirichlet L-functions** [[paper](https://arxiv.org/abs/2210.06457)]
- [2022] **Trigonometric inequalities and the Riemann zeta-function** [[paper](https://arxiv.org/abs/2210.14130)]
- [2022] **The screw line of the Riemann zeta-function and its applications** [[paper](https://arxiv.org/abs/2209.04658)]
- [2022] **Some explicit results on the sum of a prime and an almost prime** [[paper](https://arxiv.org/abs/2208.01229)]
- [2022] **The subconvexity problem for Rankin-Selberg and triple product L-functions** [[paper](https://arxiv.org/abs/2207.14449)]
- [2022] **Conditional estimates for the logarithmic derivative of Dirichlet L-functions** [[paper](https://arxiv.org/abs/2206.00819)]
- [2022] **Subconvexity of twisted Shintani zeta functions** [[paper](https://arxiv.org/abs/2206.00880)]
- [2022] **Towards the Deep Riemann Hypothesis for GL_{n}** [[paper](https://arxiv.org/abs/2206.02612)]
- [2022] **From asymptotic to closed forms for the Keiper/Li approach to the Riemann Hypothesis** [[paper](https://arxiv.org/abs/2204.01036)]
- [2022] **An analogue of the Riemann Hypothesis via quantum walks** [[paper](https://arxiv.org/abs/2204.00765)]
- [2022] **Composition operators on weighted Hilbert spaces of Dirichlet series** [[paper](https://arxiv.org/abs/2204.11566)]
- [2022] **String theory, \mathcal{N}=4 SYM and Riemann hypothesis** [[paper](https://arxiv.org/abs/2203.17091)]
- [2022] **New estimates for some integrals of functions defined over primes** [[paper](https://arxiv.org/abs/2203.09290)]
- [2022] **An asymptotic approximation for the Riemann zeta function revisited** [[paper](https://arxiv.org/abs/2203.07863)]
- [2022] **High Precision Computation of Riemann's Zeta Function by the Riemann-Siegel Formula, II** [[paper](https://arxiv.org/abs/2201.00342)]

##### 2021

- [2021] **Zeta zero dependence and the critical line** [[paper](https://arxiv.org/abs/2112.08234)]
- [2021] **Odd moments for the trace of Frobenius and the Sato--Tate conjecture in arithmetic progressions** [[paper](https://arxiv.org/abs/2112.08205)]
- [2021] **Strong subconvexity for self-dual GL (3) L-functions** [[paper](https://arxiv.org/abs/2112.14396)]
- [2021] **Prolate spheroidal operator and Zeta** [[paper](https://arxiv.org/abs/2112.05500)]
- [2021] **Rapid computation of special values of Dirichlet L-functions** [[paper](https://arxiv.org/abs/2110.10583)]
- [2021] **On the q-analogue of the pair correlation conjecture via Fourier optimization** [[paper](https://arxiv.org/abs/2108.10238)]
- [2021] **Certain Fourier Operators on GL_1 and Local Langlands Gamma functions** [[paper](https://arxiv.org/abs/2108.03565)]
- [2021] **Towards an Elementary Formulation of the Riemann Hypothesis in Terms of Permutation Groups** [[paper](https://arxiv.org/abs/2108.09570)]
- [2021] **Majorana quanta, string scattering, curved spacetimes and the Riemann Hypothesis** [[paper](https://arxiv.org/abs/2108.07852)]
- [2021] **Amplitudes and the Riemann Zeta Function** [[paper](https://arxiv.org/abs/2108.07820)]
- [2021] **Efficient computation of the zeros of the Bargmann transform under additive white noise** [[paper](https://arxiv.org/abs/2108.12921)]
- [2021] **Upper bounds for fractional joint moments of the Riemann zeta function** [[paper](https://arxiv.org/abs/2106.00165)]
- [2021] **On the Stieltjes constants and gamma functions with respect to alternating Hurwitz zeta functions** [[paper](https://arxiv.org/abs/2106.14674)]
- [2021] **Bounds for moments of quadratic Dirichlet L-functions of prime-related moduli** [[paper](https://arxiv.org/abs/2105.03601)]
- [2021] **Bounds for moments of cubic and quartic Dirichlet L-functions** [[paper](https://arxiv.org/abs/2104.09909)]
- [2021] **Subconvexity of Shintani's zeta function** [[paper](https://arxiv.org/abs/2104.13558)]
- [2021] **Subconvexity for twisted GL(3) L-functions** [[paper](https://arxiv.org/abs/2104.04719)]
- [2021] **Subconvexity bounds for twisted L-functions, II** [[paper](https://arxiv.org/abs/2103.12330)]
- [2021] **Bounding the log-derivative of the zeta-function** [[paper](https://arxiv.org/abs/2103.06237)]
- [2021] **On upper bounds for the count of elite primes** [[paper](https://arxiv.org/abs/2102.00906)]
- [2021] **Square-root cancellation for sums of factorization functions over squarefree progressions in \mathbb F_q[t]** [[paper](https://arxiv.org/abs/2102.09730)]
- [2021] **Phase operator on L^2(\mathbb{Q}_p) and the zeroes of Fisher and Riemann** [[paper](https://arxiv.org/abs/2102.13445)]
- [2021] **Brownian bridge expansions for Lévy area approximations and particular values of the Riemann zeta function** [[paper](https://arxiv.org/abs/2102.10095)]
- [2021] **Weighted value distributions of the Riemann zeta function on the critical line** [[paper](https://arxiv.org/abs/2101.08036)]
- [2021] **The Weyl bound for triple product L-functions** [[paper](https://arxiv.org/abs/2101.12106)]

##### 2020

- [2020] **Jacob's ladder as generator of new class of iterated L_2-orthogonal systems and their dependence on the Riemann's function** [[paper](https://arxiv.org/abs/2012.09694)]
- [2020] **Nonvanishing of Central Derivatives of Modular L-series in Level p^2** [[paper](https://arxiv.org/abs/2010.12999)]
- [2020] **Laws Of Form and the Riemann Hypothesis** [[paper](https://arxiv.org/abs/2010.13781)]
- [2020] **Analogues of the Robin-Lagarias Criteria for the Riemann Hypothesis** [[paper](https://arxiv.org/abs/2008.04787)]
- [2020] **On the growth of Rankin-Selberg L-functions for SL(2)** [[paper](https://arxiv.org/abs/2008.11771)]
- [2020] **Schoenberg's Theory of Totally Positive Functions and the Riemann Zeta Function** [[paper](https://arxiv.org/abs/2007.12889)]
- [2020] **p-adic model theory, p-adic integrals, Euler products, and zeta functions of groups** [[paper](https://arxiv.org/abs/2007.09242)]
- [2020] **Zeta Correction: A New Approach to Constructing Corrected Trapezoidal Quadrature Rules for Singular Integral Operators** [[paper](https://arxiv.org/abs/2007.13898)]
- [2020] **On q-analogs of zeta functions associated with a pair of q-analogs of Bernoulli numbers and polynomials** [[paper](https://arxiv.org/abs/2007.10447)]
- [2020] **An approximation to zeros of the Riemann zeta function using fractional calculus** [[paper](https://arxiv.org/abs/2006.14963)]
- [2020] **Computing Igusa's local zeta function of univariates in deterministic polynomial-time** [[paper](https://arxiv.org/abs/2006.08926)]
- [2020] **Some singular values of the elliptic lambda function and incredible cubic identities** [[paper](https://arxiv.org/abs/2006.12034)]
- [2020] **On subconvexity bounds for twisted L-functions** [[paper](https://arxiv.org/abs/2006.05984)]
- [2020] **The Riemann Hypothesis for period polynomials of Hilbert modular forms** [[paper](https://arxiv.org/abs/2005.10763)]
- [2020] **The Petersson/Kuznetsov trace formula with prescribed local ramifications** [[paper](https://arxiv.org/abs/2005.09949)]
- [2020] **Fourier interpolation with zeros of zeta and L-functions** [[paper](https://arxiv.org/abs/2005.02996)]
- [2020] **A mean counting function for Dirichlet series and compact composition operators** [[paper](https://arxiv.org/abs/2005.05094)]
- [2020] **The gap g_n between two consecutive primes satisfies g_n=O({p_n}^{2/3})** [[paper](https://arxiv.org/abs/2004.10528)]
- [2020] **Unconditional Prime-representing Functions, Following Mills** [[paper](https://arxiv.org/abs/2004.01285)]
- [2020] **Black holes, quantum chaos, and the Riemann hypothesis** [[paper](https://arxiv.org/abs/2004.09523)]
- [2020] **Explicit bound for the number of primes in arithmetic progressions assuming the Generalized Riemann Hypothesis** [[paper](https://arxiv.org/abs/2003.01925)]
- [2020] **Properties of Prime Products and Robin's Inequality** [[paper](https://arxiv.org/abs/2002.08022)]
- [2020] **Harmonic numbers and the prime counting function** [[paper](https://arxiv.org/abs/2002.02188)]
- [2020] **On an explicit zero-free region for the Dedekind zeta-function** [[paper](https://arxiv.org/abs/2002.05456)]
- [2020] **The Langlands spectral decomposition** [[paper](https://arxiv.org/abs/2001.00790)]

##### 2019

- [2019] **Derivatives of L-functions** [[paper](https://arxiv.org/abs/1910.05010)]
- [2019] **An approximate functional equation for the Riemann zeta function with exponentially decaying error** [[paper](https://arxiv.org/abs/1910.05754)]
- [2019] **Explicit zero density estimate for the Riemann zeta-function near the critical line** [[paper](https://arxiv.org/abs/1910.08274)]
- [2019] **Limiting properties of the distribution of primes in an arbitrarily large number of residue classes** [[paper](https://arxiv.org/abs/1909.03975)]
- [2019] **Contraction: a Unified Perspective of Correlation Decay and Zero-Freeness of 2-Spin Systems** [[paper](https://arxiv.org/abs/1909.04244)]
- [2019] **On Arthur's unitarity conjecture for split real groups** [[paper](https://arxiv.org/abs/1908.04363)]
- [2019] **Pair correlation for Dedekind zeta functions of abelian extensions** [[paper](https://arxiv.org/abs/1908.04876)]
- [2019] **The fourth moment of quadratic Dirichlet L-functions** [[paper](https://arxiv.org/abs/1907.01107)]
- [2019] **Zeros of ferromagnetic 2-spin systems** [[paper](https://arxiv.org/abs/1907.06156)]
- [2019] **Analysis and combinatorics of partition zeta functions** [[paper](https://arxiv.org/abs/1907.12465)]
- [2019] **Conditional upper bound for the k-th prime ideal with given Artin symbol** [[paper](https://arxiv.org/abs/1906.01994)]
- [2019] **Geometric Polynomials: Properties and Applications to Series with Zeta Values** [[paper](https://arxiv.org/abs/1905.06171)]
- [2019] **The Riemann zeta function in short intervals [after Najnudel, and Arguin, Belius, Bourgade, Radziwiłł, and Soundararajan]** [[paper](https://arxiv.org/abs/1904.08204)]
- [2019] **The Bloch groups and special values of Dedekind zeta functions** [[paper](https://arxiv.org/abs/1903.09508)]
- [2019] **Identifying the Riemann zeros by periodically driving a single qubit** [[paper](https://arxiv.org/abs/1903.07819)]
- [2019] **A Conditional Explicit Result for the Prime Number Theorem in Short Intervals** [[paper](https://arxiv.org/abs/1902.05065)]
- [2019] **Constants of de Bruijn-Newman type in analytic number theory and statistical physics** [[paper](https://arxiv.org/abs/1901.06596)]
- [2019] **(p-adic) L-functions and (p-adic) (multiple) zeta values** [[paper](https://arxiv.org/abs/1901.01957)]
- [2019] **A note on an average additive problem with prime numbers** [[paper](https://arxiv.org/abs/1901.04481)]
- [2019] **The mean values of cubic L-functions over function fields** [[paper](https://arxiv.org/abs/1901.00817)]
- [2019] **Some relations between the Riemann zeta function and the generalized Bernoulli polynomials of level m** [[paper](https://arxiv.org/abs/1901.03700)]

##### 2018

- [2018] **Product of an integer free of small prime factors and prime in arithmetic progression** [[paper](https://arxiv.org/abs/1812.10214)]
- [2018] **Arguments Related to the Riemann Hypothesis: New Methods and Results** [[paper](https://arxiv.org/abs/1811.04867)]
- [2018] **A generalization of the Riemann-Siegel formula** [[paper](https://arxiv.org/abs/1811.01130)]
- [2018] **Zeros of a polynomial of ζ^{(j)}(s)** [[paper](https://arxiv.org/abs/1811.05277)]
- [2018] **A computational history of prime numbers and Riemann zeros** [[paper](https://arxiv.org/abs/1810.05244)]
- [2018] **Pair Correlation Estimates for the Zeros of the Zeta Function via Semidefinite Programming** [[paper](https://arxiv.org/abs/1810.08843)]
- [2018] **Approximate functional equation and upper bounds for the Barnes double zeta-function** [[paper](https://arxiv.org/abs/1810.08295)]
- [2018] **Rational approximations to the zeta function II** [[paper](https://arxiv.org/abs/1810.01613)]
- [2018] **On mixed joint discrete universality for a class of zeta-functions II** [[paper](https://arxiv.org/abs/1809.10920)]
- [2018] **Operator-valued zeta functions and Fourier analysis** [[paper](https://arxiv.org/abs/1810.01821)]
- [2018] **Jacob's ladders and grafting of the complete hybrid formulas into ζ-synergetic meta-functional equation for Riemann's zeta-function** [[paper](https://arxiv.org/abs/1809.05327)]
- [2018] **On the value-distribution of symmetric power L-functions** [[paper](https://arxiv.org/abs/1808.05749)]
- [2018] **A Note on Harmonic number identities, Stirling series and multiple zeta values** [[paper](https://arxiv.org/abs/1807.00711)]
- [2018] **Fisher zeros and correlation decay in the Ising model** [[paper](https://arxiv.org/abs/1807.06577)]
- [2018] **A note on entire L-functions** [[paper](https://arxiv.org/abs/1805.01119)]
- [2018] **Adelic Voronoi Summation and Subconvexity for GL(2) L-Functions in the depth Aspect** [[paper](https://arxiv.org/abs/1805.00974)]
- [2018] **Variants on Andrica's conjecture with and without the Riemann hypothesis** [[paper](https://arxiv.org/abs/1804.02500)]
- [2018] **Prime lattice points in ovals** [[paper](https://arxiv.org/abs/1803.03013)]
- [2018] **Small zeros of Dirichlet L-functions of quadratic characters of prime modulus** [[paper](https://arxiv.org/abs/1802.03413)]
- [2018] **Relative functoriality and functional equations via trace formulas** [[paper](https://arxiv.org/abs/1801.03881)]
- [2018] **Subconvexity for L-functions of non-spherical cusp forms on GL(3)** [[paper](https://arxiv.org/abs/1801.07611)]

##### 2017

- [2017] **A New Strategy for Riemann Hypothesis** [[paper](https://arxiv.org/abs/1712.01519)]
- [2017] **Explicit formulae for averages of Goldbach representations** [[paper](https://arxiv.org/abs/1712.00737)]
- [2017] **Asymptotics to all orders of the Hurwitz zeta function** [[paper](https://arxiv.org/abs/1712.01681)]
- [2017] **The distribution of primes and Euler characreristic** [[paper](https://arxiv.org/abs/1711.03001)]
- [2017] **Local Factors, Reciprocity and Vinberg Monoids** [[paper](https://arxiv.org/abs/1710.04285)]
- [2017] **From the arrow of time in Badiali's quantum approach to the dynamic meaning of Riemann's hypothesis** [[paper](https://arxiv.org/abs/1710.01558)]
- [2017] **Inclusive prime number races** [[paper](https://arxiv.org/abs/1710.00088)]
- [2017] **Fourier optimization and prime gaps** [[paper](https://arxiv.org/abs/1708.04122)]
- [2017] **Notes on the Riemann Hypothesis** [[paper](https://arxiv.org/abs/1707.01770)]
- [2017] **On Müntz-type formulas related to the Riemann zeta function** [[paper](https://arxiv.org/abs/1705.09386)]
- [2017] **Sharp norm estimates for composition operators and Hilbert-type inequalities** [[paper](https://arxiv.org/abs/1705.01316)]
- [2017] **On some mellin transforms for the Riemann zeta function in the critical strip** [[paper](https://arxiv.org/abs/1705.02256)]
- [2017] **On large gaps between zeros of L-functions from branches** [[paper](https://arxiv.org/abs/1704.05834)]
- [2017] **Comment on "Hamiltonian for the Zeros of the Riemann Zeta Function"** [[paper](https://arxiv.org/abs/1704.02644)]
- [2017] **The Ising Partition Function: Zeros and Deterministic Approximation** [[paper](https://arxiv.org/abs/1704.06493)]
- [2017] **Approximate functional equations for the Hurwitz and Lerch zeta-functions** [[paper](https://arxiv.org/abs/1704.01850)]
- [2017] **The Zetafast algorithm for computing zeta functions** [[paper](https://arxiv.org/abs/1703.01414)]
- [2017] **Approximate functional equation for the derivatives of functions in Selberg class** [[paper](https://arxiv.org/abs/1703.06622)]
- [2017] **Standard Zero-Free Regions for Rankin--Selberg L-Functions via Sieve Theory** [[paper](https://arxiv.org/abs/1703.05450)]
- [2017] **Subconvexity for \rm{GL}(3) L-functions** [[paper](https://arxiv.org/abs/1703.04424)]
- [2017] **Some new inequalities for Generalized Mathieu type series and Riemann zeta functions** [[paper](https://arxiv.org/abs/1701.03971)]

##### 2016

- [2016] **Super-positivity of a family of L-functions** [[paper](https://arxiv.org/abs/1612.09359)]
- [2016] **An analogue of Wilton's formula and values of Dedekind zeta functions** [[paper](https://arxiv.org/abs/1611.08693)]
- [2016] **Zeros of Lattice Sums: 3. Reduction of the Generalised Riemann Hypothesis to Specific Geometries** [[paper](https://arxiv.org/abs/1610.07932)]
- [2016] **Polymeric quantum mechanics and the zeros of the Riemann zeta function** [[paper](https://arxiv.org/abs/1610.01957)]
- [2016] **Coalescence Phenomenon of Quantum Cohomology of Grassmannians and the Distribution of Prime Numbers** [[paper](https://arxiv.org/abs/1608.06868)]
- [2016] **Hamiltonian for the zeros of the Riemann zeta function** [[paper](https://arxiv.org/abs/1608.03679)]
- [2016] **On smoothing singularities of elliptic orbital integrals on GL(n) and Beyond Endoscopy** [[paper](https://arxiv.org/abs/1608.05938)]
- [2016] **New computations of the Riemann zeta function on the critical line** [[paper](https://arxiv.org/abs/1607.00709)]
- [2016] **The ternary Goldbach problem with a prime and two isolated primes** [[paper](https://arxiv.org/abs/1606.03845)]
- [2016] **Explicit Short Intervals for Primes in Arithmetic Progressions on GRH** [[paper](https://arxiv.org/abs/1606.08616)]
- [2016] **A standard zero free region for Rankin-Selberg L-functions** [[paper](https://arxiv.org/abs/1606.00330)]
- [2016] **An estimate of the second moment of a sampling of the Riemann zeta function on the critical line** [[paper](https://arxiv.org/abs/1606.01179)]
- [2016] **Explorations in the theory of partition zeta functions** [[paper](https://arxiv.org/abs/1605.05536)]
- [2016] **On the regularity of fractional integrals of modular forms** [[paper](https://arxiv.org/abs/1603.06491)]
- [2016] **Primes and prime ideals in short intervals** [[paper](https://arxiv.org/abs/1602.02906)]
- [2016] **Zeros of Lattice Sums: 2. A Geometry for the Generalised Riemann Hypothesis** [[paper](https://arxiv.org/abs/1602.06330)]
- [2016] **New error term for the fourth moment of automorphic L functions** [[paper](https://arxiv.org/abs/1602.08203)]
- [2016] **Epstein zeta-functions, subconvexity, and the purity conjecture** [[paper](https://arxiv.org/abs/1602.02326)]
- [2016] **The Riemann zeros as spectrum and the Riemann hypothesis** [[paper](https://arxiv.org/abs/1601.01797)]
- [2016] **Riemann Hypothesis and Random Walks: the Zeta case** [[paper](https://arxiv.org/abs/1601.00914)]
- [2016] **The multiple Dirichlet product and the multiple Dirichlet series** [[paper](https://arxiv.org/abs/1601.05924)]

##### 2015

- [2015] **Limiting eigenvalue distribution of random matrices of Ihara zeta function of long-range percolation graphs** [[paper](https://arxiv.org/abs/1512.09065)]
- [2015] **Construction of models of universe on the Riemann hypothesis** [[paper](https://arxiv.org/abs/1512.03009)]
- [2015] **A Half-Discrete Hardy-Hilbert-Type Inequality with a Best Possible Constant Factor Related to the Hurwitz Zeta Function** [[paper](https://arxiv.org/abs/1512.04718)]
- [2015] **A More Accurate Half-Discrete Hardy-Hilbert-Type Inequality with the Best Possible Constant Factor Related to the Extended Riemann-Zeta Function** [[paper](https://arxiv.org/abs/1512.04063)]
- [2015] **The L-functions and modular forms database project** [[paper](https://arxiv.org/abs/1511.04289)]
- [2015] **Subconvexity for a double Dirichlet series and non-vanishing of L-functions** [[paper](https://arxiv.org/abs/1511.00071)]
- [2015] **Hankel Determinants of Zeta Values** [[paper](https://arxiv.org/abs/1510.01901)]
- [2015] **An essay on the Riemann Hypothesis** [[paper](https://arxiv.org/abs/1509.05576)]
- [2015] **The distribution of prime numbers and tuples in the natural numbers** [[paper](https://arxiv.org/abs/1509.08703)]
- [2015] **Convergence of families of Dirichlet series** [[paper](https://arxiv.org/abs/1509.03863)]
- [2015] **On eigenvalue distribution of random matrices of Ihara zeta function of large random graphs** [[paper](https://arxiv.org/abs/1508.07839)]
- [2015] **The Langlands-Shahidi method over function fields: Ramanujan Conjecture and Riemann Hypothesis for the unitary groups** [[paper](https://arxiv.org/abs/1507.03625)]
- [2015] **Nonabelian Fourier transforms for spherical representations** [[paper](https://arxiv.org/abs/1506.09128)]
- [2015] **On the Distribution of Products of Primes and Powers** [[paper](https://arxiv.org/abs/1506.02854)]
- [2015] **Beyond Endoscopy via the Trace Formula-I: Poisson Summation and Contributions of Special Representations** [[paper](https://arxiv.org/abs/1506.02218)]
- [2015] **Some relations involving the higher derivatives of the Riemann zeta function** [[paper](https://arxiv.org/abs/1506.07386)]
- [2015] **From Quantum Systems to L-Functions: Pair Correlation Statistics and Beyond** [[paper](https://arxiv.org/abs/1505.07481)]
- [2015] **The Sound of Fractal Strings and the Riemann Hypothesis** [[paper](https://arxiv.org/abs/1505.01548)]
- [2015] **Short intervals asymptotic formulae for binary problems with primes and powers, II: density 1** [[paper](https://arxiv.org/abs/1504.04709)]
- [2015] **Short intervals asymptotic formulae for binary problems with primes and powers, I: density 3/2** [[paper](https://arxiv.org/abs/1504.02271)]
- [2015] **On the subconvexity problem for L-functions on GL(3)** [[paper](https://arxiv.org/abs/1504.02667)]
- [2015] **A note on the zeros of zeta and L-functions** [[paper](https://arxiv.org/abs/1503.00955)]
- [2015] **Primes in explicit short intervals on RH** [[paper](https://arxiv.org/abs/1503.05403)]
- [2015] **Seiberg Duality, Quiver Gauge Theories, and Ihara Zeta Function** [[paper](https://arxiv.org/abs/1502.05771)]
- [2015] **The Arithmetic Cosine Transform: Exact and Approximate Algorithms** [[paper](https://arxiv.org/abs/1502.01377)]
- [2015] **From Veneziano to Riemann: A String Theory Statement of the Riemann Hypothesis** [[paper](https://arxiv.org/abs/1501.01975)]
- [2015] **Towards Quantized Number Theory: Spectral Operators and an Asymmetric Criterion for the Riemann Hypothesis** [[paper](https://arxiv.org/abs/1501.05362)]
- [2015] **Quadratic Weyl Sums, Automorphic Functions, and Invariance Principles** [[paper](https://arxiv.org/abs/1501.07661)]

##### 2014

- [2014] **Newman's conjecture, zeros of the L-functions, function fields** [[paper](https://arxiv.org/abs/1411.2071)]
- [2014] **Finding zeros of the Riemann zeta function by periodic driving of cold atoms** [[paper](https://arxiv.org/abs/1411.0459)]
- [2014] **Will a physicist prove the Riemann Hypothesis?** [[paper](https://arxiv.org/abs/1410.1214)]
- [2014] **Nonnegative trigonometric polynomials and a zero-free region for the Riemann zeta-function** [[paper](https://arxiv.org/abs/1410.3926)]
- [2014] **Exponential Sums Related to Maass Forms** [[paper](https://arxiv.org/abs/1409.7235)]
- [2014] **Riemann Hypothesis for Goss t-adic Zeta Function** [[paper](https://arxiv.org/abs/1408.1111)]
- [2014] **A theory for the zeros of Riemann ζ and other L-functions (updated)** [[paper](https://arxiv.org/abs/1407.4358)]
- [2014] **A survey on the theory of universality for zeta and L-functions** [[paper](https://arxiv.org/abs/1407.4216)]
- [2014] **Sum of one prime and two squares of primes in short intervals** [[paper](https://arxiv.org/abs/1406.3441)]
- [2014] **Close to Uniform Prime Number Generation With Fewer Random Bits** [[paper](https://arxiv.org/abs/1406.7078)]
- [2014] **Certain identities, connection and explicit formulas for the Bernoulli, Euler numbers and Riemann zeta -values** [[paper](https://arxiv.org/abs/1406.5345)]
- [2014] **On the distribution of Atkin and Elkies primes for reductions of elliptic curves on average** [[paper](https://arxiv.org/abs/1404.0399)]
- [2014] **The Riemann zeros as energy levels of a Dirac fermion in a potential built from the prime numbers in Rindler spacetime** [[paper](https://arxiv.org/abs/1404.4252)]
- [2014] **The Second Moment of Rankin-Selberg L-function and Hybrid Subconvexity Bound** [[paper](https://arxiv.org/abs/1404.2336)]
- [2014] **The subconvexity bound for triple product L-function in level aspect** [[paper](https://arxiv.org/abs/1404.1636)]
- [2014] **Zeta functions over zeros of Zeta functions and an exponential-asymptotic view of the Riemann Hypothesis** [[paper](https://arxiv.org/abs/1403.4558)]
- [2014] **On the Riemann Hypothesis and the Difference Between Primes** [[paper](https://arxiv.org/abs/1402.6417)]
- [2014] **Jacob's ladders, reverse iterations and new infinite set of L_2-orthogonal systems generated by the Riemann \zf-function** [[paper](https://arxiv.org/abs/1402.2098)]
- [2014] **Mean Value Theorems for L-functions over Prime Polynomials for the Rational Function Field** [[paper](https://arxiv.org/abs/1401.0418)]

##### 2013

- [2013] **Apéry's theorem and problems for the values of Riemann's zeta function and their q-analogues** [[paper](https://arxiv.org/abs/1312.6919)]
- [2013] **Notes on \log(ζ(s))^{\prime\prime}** [[paper](https://arxiv.org/abs/1311.5465)]
- [2013] **A sum rule for the critical zeros of ζ(s)** [[paper](https://arxiv.org/abs/1309.7040)]
- [2013] **The Riemann Hypothesis for Dirichlet L Functions** [[paper](https://arxiv.org/abs/1308.6431)]
- [2013] **Constructing a Proof of the Riemann Hypothesis** [[paper](https://arxiv.org/abs/1309.5845)]
- [2013] **The Riemann Hypothesis for Symmetrised Combinations of Zeta Functions** [[paper](https://arxiv.org/abs/1308.5756)]
- [2013] **Questions and Remarks to the Langlands Program** [[paper](https://arxiv.org/abs/1307.1878)]
- [2013] **A method for calculating spectral statistics based on random-matrix universality with an application to the three-point correlations of the Riemann zeros** [[paper](https://arxiv.org/abs/1307.6012)]
- [2013] **Quantum graphs whose spectra mimic the zeros of the Riemann zeta function** [[paper](https://arxiv.org/abs/1307.6055)]
- [2013] **Two-point correlation function for Dirichlet L-functions** [[paper](https://arxiv.org/abs/1307.6010)]
- [2013] **Riemann Hypothesis: Architecture of a conjecture "along" the lines of Pólya. From trivial zeros and Harmonic Oscillator to information about non-trivial zeros of the Riemann zeta-function** [[paper](https://arxiv.org/abs/1306.3711)]
- [2013] **Explicit formulae for primes in arithmetic progressions, I** [[paper](https://arxiv.org/abs/1306.5322)]
- [2013] **Subconvexity for Half Integral Weight L-functions** [[paper](https://arxiv.org/abs/1307.0112)]
- [2013] **Numerical Computations Concerning the GRH** [[paper](https://arxiv.org/abs/1305.3087)]
- [2013] **Truncated Infinitesimal Shifts, Spectral Operators and Quantized Universality of the Riemann Zeta Function** [[paper](https://arxiv.org/abs/1305.3933)]
- [2013] **Major arcs for Goldbach's problem** [[paper](https://arxiv.org/abs/1305.2897)]
- [2013] **Elliptic curves of unbounded rank and Chebyshev's bias** [[paper](https://arxiv.org/abs/1304.8011)]
- [2013] **Riemann Hypothesis as an Uncertainty Relation** [[paper](https://arxiv.org/abs/1304.2435)]
- [2013] **Riemann zeta zeros and prime number spectra in quantum field theory** [[paper](https://arxiv.org/abs/1303.7028)]
- [2013] **Quantum Computation of Prime Number Functions** [[paper](https://arxiv.org/abs/1302.6245)]
- [2013] **A Weyl Creation Algebra Approach to the Riemann Hypothesis** [[paper](https://arxiv.org/abs/1302.5033)]
- [2013] **A general inversion formula for summatory arithmetic functions and its application to the summatory function of the Moebius function** [[paper](https://arxiv.org/abs/1301.4202)]
- [2013] **Limit Representations of Riemann's Zeta Function** [[paper](https://arxiv.org/abs/1301.3659)]

##### 2012

- [2012] **Paquets stables des séries discrètes accessibles par endoscopie tordue; leur paramètre de Langlands** [[paper](https://arxiv.org/abs/1212.5433)]
- [2012] **Explicit relations between primes in short intervals and exponential sums over primes** [[paper](https://arxiv.org/abs/1212.5704)]
- [2012] **Maass forms on GL(3) and GL(4)** [[paper](https://arxiv.org/abs/1212.4545)]
- [2012] **A lattice gas of prime numbers and the Riemann Hypothesis** [[paper](https://arxiv.org/abs/1211.6621)]
- [2012] **Quantum Field Theories and Prime Numbers Spectrum** [[paper](https://arxiv.org/abs/1211.5198)]
- [2012] **Euler Products beyond the Boundary** [[paper](https://arxiv.org/abs/1210.1216)]
- [2012] **Standard models of abstract intersection theory for operators in Hilbert space** [[paper](https://arxiv.org/abs/1210.3526)]
- [2012] **Elegant expressions and generic formulas for the Riemann zeta function for integer arguments** [[paper](https://arxiv.org/abs/1210.5157)]
- [2012] **Double Dirichlet series and quantum unique ergodicity of weight 1/2 Eisenstein series** [[paper](https://arxiv.org/abs/1209.1894)]
- [2012] **The Mean Value of L(\tfrac{1}{2},χ) in the Hyperelliptic Ensemble** [[paper](https://arxiv.org/abs/1208.1131)]
- [2012] **On generalized Hardy classes of Dirichlet series** [[paper](https://arxiv.org/abs/1207.5337)]
- [2012] **On an inequality for the Riemann zeta-function in the critical strip** [[paper](https://arxiv.org/abs/1206.1801)]
- [2012] **A central limit theorem for the zeroes of the zeta function** [[paper](https://arxiv.org/abs/1205.0303)]
- [2012] **A Dirac type xp-Model and the Riemann Zeros** [[paper](https://arxiv.org/abs/1205.6755)]
- [2012] **Bounds for Rankin--Selberg integrals and quantum unique ergodicity for powerful levels** [[paper](https://arxiv.org/abs/1205.5534)]
- [2012] **Riemann Zeroes and Phase Transitions via the Spectral Operator on Fractal Strings** [[paper](https://arxiv.org/abs/1203.4828)]
- [2012] **Explicit evaluation of certain sums of multiple zeta-star values** [[paper](https://arxiv.org/abs/1203.1111)]
- [2012] **Small gaps between zeros of twisted L-functions** [[paper](https://arxiv.org/abs/1202.2671)]
- [2012] **Small values of the Euler function and the Riemann hypothesis** [[paper](https://arxiv.org/abs/1202.0729)]
- [2012] **Freezing Transition, Characteristic Polynomials of Random Matrices, and the Riemann Zeta-Function** [[paper](https://arxiv.org/abs/1202.4713)]
- [2012] **On A Rapidly Converging Series For The Riemann Zeta Function** [[paper](https://arxiv.org/abs/1201.6538)]

##### 2011

- [2011] **Zero-free regions for Dirichlet series (II)** [[paper](https://arxiv.org/abs/1112.0166)]
- [2011] **Determinantal approach to a proof of the Riemann hypothesis** [[paper](https://arxiv.org/abs/1111.1128)]
- [2011] **Evaluation of Riemann Zeta function on the Line \Re(s) = 1 and Odd Arguments** [[paper](https://arxiv.org/abs/1109.6335)]
- [2011] **An exact trace formula and zeta functions for an infinite quantum graph with a non-standard Weyl asymptotics** [[paper](https://arxiv.org/abs/1104.1364)]
- [2011] **Plasmon Resonances in Nanoparticles, Their Applications to Magnetics and Relation to the Riemann Hypothesis** [[paper](https://arxiv.org/abs/1104.5202)]
- [2011] **A consequence of Littlewood's conditional estimates for the Riemann zeta-function** [[paper](https://arxiv.org/abs/1104.1358)]
- [2011] **Pauli graphs, Riemann hypothesis, Goldbach pairs** [[paper](https://arxiv.org/abs/1103.2608)]
- [2011] **Graph Zeta Function and Gauge Theories** [[paper](https://arxiv.org/abs/1102.1304)]
- [2011] **Yet Another Riemann Hypothesis** [[paper](https://arxiv.org/abs/1101.0311)]
- [2011] **Sums of many primes** [[paper](https://arxiv.org/abs/1101.3489)]
- [2011] **Physics of the Riemann Hypothesis** [[paper](https://arxiv.org/abs/1101.3116)]
- [2011] **Optimal quasi-free approximation:reconstructing the spectrum from ground state energies** [[paper](https://arxiv.org/abs/1101.2163)]

##### 2010

- [2010] **A physics pathway to the Riemann hypothesis** [[paper](https://arxiv.org/abs/1012.4264)]
- [2010] **Riemann hypothesis and Quantum Mechanics** [[paper](https://arxiv.org/abs/1012.4665)]
- [2010] **Constructing elliptic curve isogenies in quantum subexponential time** [[paper](https://arxiv.org/abs/1012.4019)]
- [2010] **The field-of-norms functor and the Hilbert symbol for higher local fields** [[paper](https://arxiv.org/abs/1010.0555)]
- [2010] **Uniform approximation of some Dirichlet series by partial products of Euler type** [[paper](https://arxiv.org/abs/1008.0852)]
- [2010] **Note On Prime Gaps And Very Short Intervals** [[paper](https://arxiv.org/abs/1008.2381)]
- [2010] **The Riemann Hypothesis for Angular Lattice Sums** [[paper](https://arxiv.org/abs/1007.4111)]
- [2010] **On the Rankin-Selberg zeta-function** [[paper](https://arxiv.org/abs/1007.4310)]
- [2010] **On some expansions for the Euler Gamma function and the Riemann Zeta function** [[paper](https://arxiv.org/abs/1007.1955)]
- [2010] **Generalized Riemann hypotheses: sufficient and equivalent criteria** [[paper](https://arxiv.org/abs/1005.1609)]
- [2010] **Some infinite series involving the Riemann zeta function** [[paper](https://arxiv.org/abs/1005.2730)]
- [2010] **New rapidly converging series representations for values of the Riemann zeta function and the Dirichlet beta function** [[paper](https://arxiv.org/abs/1003.4592)]
- [2010] **Estimates of Some Functions Over Primes without R.H.** [[paper](https://arxiv.org/abs/1002.0442)]
- [2010] **Meromorphic Continuation of the Goldbach generating function** [[paper](https://arxiv.org/abs/1002.4806)]
- [2010] **Roots of the derivative of the Riemann zeta function and of characteristic polynomials** [[paper](https://arxiv.org/abs/1002.0372)]
- [2010] **A method for locating where the real part of the Riemann zeta function becomes negative for its real argument greater than one** [[paper](https://arxiv.org/abs/1001.2962)]

##### 2009

- [2009] **On certain sums over the nontrivial zeta zeros** [[paper](https://arxiv.org/abs/0912.2390)]
- [2009] **Chebyshev's bias for products of two primes** [[paper](https://arxiv.org/abs/0908.0093)]
- [2009] **Subconvexity for a double Dirichlet series** [[paper](https://arxiv.org/abs/0907.4867)]
- [2009] **Explicit Upper Bounds for L-functions on the critical line** [[paper](https://arxiv.org/abs/0906.4177)]
- [2009] **Large Spaces Between the Zeros of the Riemann Zeta-Function** [[paper](https://arxiv.org/abs/0906.5458)]
- [2009] **Asymptotic Estimates for Some Number Theoretic Power Series** [[paper](https://arxiv.org/abs/0905.2070)]
- [2009] **Twisted L-functions over number fields and Hilbert's eleventh problem** [[paper](https://arxiv.org/abs/0904.2429)]
- [2009] **Scale invariant correlations and the distribution of prime numbers** [[paper](https://arxiv.org/abs/0903.2592)]

##### 2008

- [2008] **Lectures on height zeta functions: At the confluence of algebraic geometry, algebraic number theory, and analysis** [[paper](https://arxiv.org/abs/0812.0947)]
- [2008] **On the Taylor Coefficients of the Hurwitz Zeta Function** [[paper](https://arxiv.org/abs/0812.1303)]
- [2008] **Densities, Laplace Transforms and Analytic Number Theory** [[paper](https://arxiv.org/abs/0810.4820)]
- [2008] **Criteria equivalent to the Riemann Hypothesis** [[paper](https://arxiv.org/abs/0808.0640)]
- [2008] **On primitive Dirichlet characters and the Riemann hypothesis** [[paper](https://arxiv.org/abs/0806.3944)]
- [2008] **Mean representation number of integers as the sum of primes** [[paper](https://arxiv.org/abs/0806.3295)]
- [2008] **A few equalities involving integrals of the logarithm of the Riemann Zeta-function and equivalent to the Riemann hypothesis** [[paper](https://arxiv.org/abs/0806.1596)]
- [2008] **On the minima and convexity of Epstein Zeta function** [[paper](https://arxiv.org/abs/0806.1999)]
- [2008] **Further Comments on Realization of Riemann Hypothesis via Coupling Constant Spectrum** [[paper](https://arxiv.org/abs/0804.3099)]
- [2008] **Pair correlation of the zeros of the derivative of the Riemann ξ-function** [[paper](https://arxiv.org/abs/0803.0425)]
- [2008] **A Hidden Symmetry Related to the Riemann Hypothesis with the Primes into the Critical Strip** [[paper](https://arxiv.org/abs/0803.1508)]
- [2008] **Correlations of eigenvalues and Riemann zeros** [[paper](https://arxiv.org/abs/0803.2795)]

##### 2007

- [2007] **A quantum mechanical model of the Riemann zeros** [[paper](https://arxiv.org/abs/0712.0705)]
- [2007] **On some properties of Riemann zeta function on critical line** [[paper](https://arxiv.org/abs/0710.0943)]
- [2007] **Other representations of the Riemann Zeta function and an additional reformulation of the Riemann Hypothesis** [[paper](https://arxiv.org/abs/0707.2406)]
- [2007] **A signed analog of Euler's reduction formula for the double zeta function** [[paper](https://arxiv.org/abs/0707.4486)]
- [2007] **Lower bounds for moments of zeta prime rho** [[paper](https://arxiv.org/abs/0706.2321)]
- [2007] **Series of zeta values, the Stieltjes constants, and a sum S_γ(n)** [[paper](https://arxiv.org/abs/0706.0345)]
- [2007] **The Stieltjes constants, their relation to the eta_j coefficients, and representation of the Hurwitz zeta function** [[paper](https://arxiv.org/abs/0706.0343)]
- [2007] **Finite Euler products and the Riemann Hypothesis** [[paper](https://arxiv.org/abs/0704.3448)]
- [2007] **A new integral representation for the Riemann Zeta function** [[paper](https://arxiv.org/abs/math-ph/0703073)]
- [2007] **H = x p with interaction and the Riemann zeros** [[paper](https://arxiv.org/abs/math-ph/0702034)]
- [2007] **An efficient algorithm for accelerating the convergence of oscillatory series, useful for computing the polylogarithm and Hurwitz zeta functions** [[paper](https://arxiv.org/abs/math/0702243)]
- [2007] **Regularization for zeta functions with physical applications II** [[paper](https://arxiv.org/abs/math-ph/0702011)]

##### 2006

- [2006] **Moments of the Riemann zeta-function** [[paper](https://arxiv.org/abs/math/0612106)]
- [2006] **Interacting Bose and Fermi gases in low dimensions and the Riemann hypothesis** [[paper](https://arxiv.org/abs/math-ph/0611043)]
- [2006] **Subconvexity for the Riemann zeta-function and the divisor problem** [[paper](https://arxiv.org/abs/math/0611809)]
- [2006] **Riemann Hypothesis: a special case of the Riesz and Hardy-Littlewood wave and a numerical treatment of the Baez-Duarte coefficients up to some billions in the k-variable** [[paper](https://arxiv.org/abs/math/0609480)]
- [2006] **On the coefficients of the Baez-Duarte criterion for the Riemann hypothesis and their extensions** [[paper](https://arxiv.org/abs/math-ph/0608050)]
- [2006] **Computing central values of twisted L-series: the case of composite levels** [[paper](https://arxiv.org/abs/math/0607008)]
- [2006] **On Nyman, Beurling and Baez-Duarte's Hilbert space reformulation of the Riemann hypothesis** [[paper](https://arxiv.org/abs/math/0607733)]
- [2006] **The Laplace and Mellin transforms of powers of the Riemann zeta-function** [[paper](https://arxiv.org/abs/math/0605721)]
- [2006] **Riemann Hypothesis: The Riesz-Hardy-Littlewood wave in the long wavelength region** [[paper](https://arxiv.org/abs/math/0605565)]
- [2006] **A Number Theoretic Interpolation Between Quantum and Classical Complexity Classes** [[paper](https://arxiv.org/abs/quant-ph/0604089)]
- [2006] **The criteria of Riesz, Hardy-Littlewood et al. for the Riemann Hypothesis revisited using similar functions** [[paper](https://arxiv.org/abs/math/0601138)]

##### 2005

- [2005] **The Riemann zeros and the cyclic Renormalization Group** [[paper](https://arxiv.org/abs/math/0510572)]
- [2005] **An explicit zero-free region for the Dirichlet L-functions** [[paper](https://arxiv.org/abs/math/0510570)]
- [2005] **Investigations of Zeros Near the Central Point of Elliptic Curve L-Functions** [[paper](https://arxiv.org/abs/math/0508150)]
- [2005] **Artin's conjecture, Turing's method and the Riemann hypothesis** [[paper](https://arxiv.org/abs/math/0507502)]
- [2005] **Polygamma theory, the Li/Keiper constants, and validity of the Riemann Hypothesis** [[paper](https://arxiv.org/abs/math-ph/0507042)]
- [2005] **Toward verification of the Riemann hypothesis: Application of the Li criterion** [[paper](https://arxiv.org/abs/math-ph/0505052)]
- [2005] **Experimental determination of Apery-like identities for zeta(2n+2)** [[paper](https://arxiv.org/abs/math/0505270)]
- [2005] **Searching symbolically for Apery-like formulae for values of the Riemann zeta function** [[paper](https://arxiv.org/abs/math/0505093)]
- [2005] **Riemann Hypothesis and Short Distance Fermionic Green's Functions** [[paper](https://arxiv.org/abs/math-ph/0504035)]
- [2005] **Periods, subconvexity of L-functions and representation theory** [[paper](https://arxiv.org/abs/math/0504411)]

##### 2004

- [2004] **Higher moments of primes in short intervals I** [[paper](https://arxiv.org/abs/math/0409530)]
- [2004] **Open circular billiards and the Riemann hypothesis** [[paper](https://arxiv.org/abs/nlin/0408009)]
- [2004] **Explicit lower bounds on the modular degree of an elliptic curve** [[paper](https://arxiv.org/abs/math/0408126)]
- [2004] **A pseudo-unitary ensemble of random matrices, PT-symmetry and the Riemann Hypothesis** [[paper](https://arxiv.org/abs/quant-ph/0407167)]
- [2004] **A sharpening of Li's criterion for the Riemann Hypothesis** [[paper](https://arxiv.org/abs/math/0404213)]
- [2004] **The Riemann Magneton of the Primes** [[paper](https://arxiv.org/abs/math-ph/0404031)]
- [2004] **Computing zeta functions via p-adic cohomology** [[paper](https://arxiv.org/abs/math/0403233)]
- [2004] **Three Lectures on the Riemann Zeta-Function** [[paper](https://arxiv.org/abs/math/0401126)]

##### 2003

- [2003] **Sum relations for multiple zeta values and connection formulas for the Gauss hypergeometric functions** [[paper](https://arxiv.org/abs/math/0307264)]
- [2003] **On the second moment of S(T) in the theory of the Riemann zeta function** [[paper](https://arxiv.org/abs/math/0305339)]
- [2003] **Distribution of the zeros of the Riemann zeta function in longer intervals** [[paper](https://arxiv.org/abs/math/0305341)]
- [2003] **Automorphic L-functions and functoriality** [[paper](https://arxiv.org/abs/math/0304329)]

##### 2002

- [2002] **Random matrix theory and the zeros of zeta'(s)** [[paper](https://arxiv.org/abs/math-ph/0207044)]
- [2002] **Diophantine problems for q-zeta values** [[paper](https://arxiv.org/abs/math/0206179)]
- [2002] **Transfer operators and dynamical zeta functions for a class of lattice spin models** [[paper](https://arxiv.org/abs/math/0203191)]
- [2002] **The moment zeta function and applications** [[paper](https://arxiv.org/abs/math/0201109)]

##### 1859

- [1859] **Über die Anzahl der Primzahlen unter einer gegebenen Grösse** *Monatsberichte der Berliner Akademie* [[paper](https://arxiv.org/abs/0809.2087)]

[⬆ Back to top](#paper-list)

#### Modular Forms

##### 2026

- [2026] **A simple construction of the automorphic residual spectrum** [[paper](https://arxiv.org/abs/2608.19129)]
- [2026] **Kohnen--Ueda local newforms** [[paper](https://arxiv.org/abs/2608.22442)]
- [2026] **Pseudonullity for fine Selmer groups over multiple \mathbb{Z}_p^{d}-extensions** [[paper](https://arxiv.org/abs/2608.25309)]
- [2026] **Depth Two Mock Modularity by Eisenstein Series Coupling** [[paper](https://arxiv.org/abs/2607.00643)]
- [2026] **Determining newforms via arithmetic relations among Fourier coefficients** [[paper](https://arxiv.org/abs/2606.27190)]
- [2026] **A generic categorical local Langlands correspondence for quasi-split reductive groups** [[paper](https://arxiv.org/abs/2606.10149)]
- [2026] **The Abel--Jacobi map over the twistor-\mathbb{P}^1 and real local class field theory** [[paper](https://arxiv.org/abs/2606.03902)]
- [2026] **Towards a generalized Maeda conjecture for modular forms with quadratic nebentypus** [[paper](https://arxiv.org/abs/2605.26771)]
- [2026] **Distributions of Iwasawa λ-invariants of Z_p-towers over supersingular isogeny graphs** [[paper](https://arxiv.org/abs/2605.23184)]
- [2026] **Tautological modular forms of level two and degree two** [[paper](https://arxiv.org/abs/2605.13300)]
- [2026] **The Serre Derivatives and Zeros of Modular Forms** [[paper](https://arxiv.org/abs/2605.10227)]
- [2026] **Non-vanishing of the p-adic constant for mock modular forms associated to a newform with real Fourier coefficients** [[paper](https://arxiv.org/abs/2604.20520)]
- [2026] **The local Langlands correspondence of essentially unipotent supercuspidal representations for disconnected reductive groups** [[paper](https://arxiv.org/abs/2604.25198)]
- [2026] **Anticyclotomic Iwasawa main conjectures for modular forms** [[paper](https://arxiv.org/abs/2603.22483)]
- [2026] **Igusa Stacks and the Cohomology of Shimura Varieties II** [[paper](https://arxiv.org/abs/2603.24921)]
- [2026] **Modular abelian surfaces of small conductor with nontrivial Tate--Shafarevich groups** [[paper](https://arxiv.org/abs/2602.19813)]
- [2026] **L^4-norms of automorphic forms in the depth aspect** [[paper](https://arxiv.org/abs/2602.19646)]
- [2026] **On the Vanishing and Cuspidality of D_4 Modular Forms** [[paper](https://arxiv.org/abs/2601.21071)]
- [2026] **A relative Langlands dual realization of T^*(G/K) and derived Satake** [[paper](https://arxiv.org/abs/2601.18022)]
- [2026] **A note on extensions of p-adic representations of GL_2(\mathbb{Q}_p)** [[paper](https://arxiv.org/abs/2601.07707)]

##### 2025

- [2025] **Signatures in TQFT : Asymptotics and Modularity** [[paper](https://arxiv.org/abs/2512.13450)]
- [2025] **Parameters and Theta lifts** [[paper](https://arxiv.org/abs/2512.19344)]
- [2025] **A relative trace formula identity for non-tempered spherical varieties** [[paper](https://arxiv.org/abs/2512.03320)]
- [2025] **Prime detecting quasi-modular forms in higher level** [[paper](https://arxiv.org/abs/2511.04030)]
- [2025] **Local newforms for generic representations of p-adic {\rm SO}_{2n+1}: Uniqueness** [[paper](https://arxiv.org/abs/2510.03068)]
- [2025] **Gross's conjecture: the dihedral case** [[paper](https://arxiv.org/abs/2510.03476)]
- [2025] **On a tamely ramified local relative Langlands conjecture via categorical representations** [[paper](https://arxiv.org/abs/2510.25231)]
- [2025] **Solid locally analytic representations in mixed characteristic** [[paper](https://arxiv.org/abs/2510.13673)]
- [2025] **Prime Geodesic Theorem for Arithmetic Compact Surfaces: Principal Congruence Case** [[paper](https://arxiv.org/abs/2510.05659)]
- [2025] **Uniform subconvexity bounds for GL(2)\times GL(2) L-functions in the spectral aspect** [[paper](https://arxiv.org/abs/2509.05968)]
- [2025] **Introduction to the relative Langlands program** [[paper](https://arxiv.org/abs/2509.18062)]
- [2025] **Survey on bounding Selmer groups for Rankin--Selberg motives** [[paper](https://arxiv.org/abs/2509.16881)]
- [2025] **An algorithm for Aubert-Zelevinsky duality à la Mœglin-Waldspurger** [[paper](https://arxiv.org/abs/2509.13231)]
- [2025] **Normalized Indexing for Ramification Subgroups** [[paper](https://arxiv.org/abs/2509.14881)]
- [2025] **Low-lying zeros of Hilbert modular L-functions weighted by powers of central L-values** [[paper](https://arxiv.org/abs/2508.18469)]
- [2025] **Motives and Automorphic Representations** [[paper](https://arxiv.org/abs/2507.10268)]
- [2025] **Computing Hilbert modular forms as orthogonal modular forms** [[paper](https://arxiv.org/abs/2506.21981)]
- [2025] **L-packets and the generic Arthur packet conjectures for even unitary similitude groups** [[paper](https://arxiv.org/abs/2506.00892)]
- [2025] **The Hiraga-Ichino-Ikeda Conjecture for Principal Series of Split p-adic Groups** [[paper](https://arxiv.org/abs/2506.19619)]
- [2025] **The refined Tamagawa number conjectures for GL_2** [[paper](https://arxiv.org/abs/2505.09121)]
- [2025] **On the generic part of the cohomology of Shimura varieties of abelian type** [[paper](https://arxiv.org/abs/2505.04329)]
- [2025] **About quasi-modular forms, differential operators and Rankin--Cohen algebras** [[paper](https://arxiv.org/abs/2503.04080)]
- [2025] **Fargues-Scholze correspondence and endoscopic classification for special orthogonal and unitary groups** [[paper](https://arxiv.org/abs/2503.04623)]
- [2025] **Algorithms for parabolic inductions and Jacquet modules in GL_n** [[paper](https://arxiv.org/abs/2503.00886)]
- [2025] **Non-reductive cycles and twisted arithmetic transfers for Shimura curves** [[paper](https://arxiv.org/abs/2502.16754)]

##### 2024

- [2024] **Defining newforms in characteristic p** [[paper](https://arxiv.org/abs/2412.20606)]
- [2024] **Kolyvagin's conjecture for modular forms** [[paper](https://arxiv.org/abs/2412.02303)]
- [2024] **A 6-functor formalism for solid quasi-coherent sheaves on the Fargues-Fontaine curve** [[paper](https://arxiv.org/abs/2412.20968)]
- [2024] **Introduction to Shtukas and their moduli** [[paper](https://arxiv.org/abs/2411.10248)]
- [2024] **Classicality of derived Emerton--Gee stack II: generalised reductive groups** [[paper](https://arxiv.org/abs/2411.12661)]
- [2024] **Euler systems and relative Satake isomorphism** [[paper](https://arxiv.org/abs/2410.18392)]
- [2024] **Relative Langlands Duality** [[paper](https://arxiv.org/abs/2409.04677)]
- [2024] **Automatic convergence for Siegel modular forms** [[paper](https://arxiv.org/abs/2408.16392)]
- [2024] **Automatic convergence and arithmeticity of modular forms on exceptional groups** [[paper](https://arxiv.org/abs/2408.09519)]
- [2024] **On the geometrization of the local Langlands correspondence** [[paper](https://arxiv.org/abs/2408.16571)]
- [2024] **On the geometrization of the p-adic local Langlands correspondence** [[paper](https://arxiv.org/abs/2408.02358)]
- [2024] **Non-basic rigid packets for discrete L-parameters** [[paper](https://arxiv.org/abs/2408.13908)]
- [2024] **Second adjointness and cuspidal supports at the categorical level** [[paper](https://arxiv.org/abs/2408.04582)]
- [2024] **Strong Hybrid Subconvexity for Twisted Selfdual GL_3 L-Functions** [[paper](https://arxiv.org/abs/2408.00596)]
- [2024] **Euler characteristics of the generalized Kloosterman sheaves for symplectic and orthogonal groups** [[paper](https://arxiv.org/abs/2407.19700)]
- [2024] **Reducibility points and characteristic p local fields I- Simple supercuspidal representations of symplectic groups** [[paper](https://arxiv.org/abs/2406.15767)]
- [2024] **\infty-Categorical Generalized Langlands Correspondence II: Langlands Program Formalism** [[paper](https://arxiv.org/abs/2405.17909)]
- [2024] **The generic dual of p-adic groups and applications** [[paper](https://arxiv.org/abs/2404.07111)]
- [2024] **Ramification of weak Arthur packets for p-adic groups** [[paper](https://arxiv.org/abs/2404.03485)]
- [2024] **p-Adic hypergeometric functions and certain weight three newforms** [[paper](https://arxiv.org/abs/2403.16939)]
- [2024] **Shalika newforms for GL(n)** [[paper](https://arxiv.org/abs/2403.04119)]
- [2024] **On the anticyclotomic Iwasawa theory of newforms at Eisenstein primes of semistable reduction** [[paper](https://arxiv.org/abs/2402.12781)]
- [2024] **Geometric and arithmetic theta correspondences** [[paper](https://arxiv.org/abs/2402.12159)]
- [2024] **A Survey of a Random Matrix Model for a Family of Cusp Forms** [[paper](https://arxiv.org/abs/2402.06641)]
- [2024] **A GL(3) converse theorem via a "beyond endoscopy" approach** [[paper](https://arxiv.org/abs/2401.04037)]
- [2024] **Geometric Langlands duality for periods** [[paper](https://arxiv.org/abs/2402.00180)]
- [2024] **Generalised Whittaker models as instances of relative Langlands duality II: Plancherel density and global periods** [[paper](https://arxiv.org/abs/2401.06624)]

##### 2023

- [2023] **The Arithmetic of the Fourier Coefficients of Automorphic Forms** [[paper](https://arxiv.org/abs/2312.09003)]
- [2023] **Isocrystals and limits of rigid local Langlands correspondences** [[paper](https://arxiv.org/abs/2312.09195)]
- [2023] **Modular functoriality in the Local Langlands Correspondence** [[paper](https://arxiv.org/abs/2312.12542)]
- [2023] **\infty-Categorical Generalized Langlands Program I: Mixed-Parity Modules and Sheaves** [[paper](https://arxiv.org/abs/2311.10019)]
- [2023] **Recent progress on Langlands reciprocity for GL_n: Shimura varieties and beyond** [[paper](https://arxiv.org/abs/2311.13382)]
- [2023] **The Geometry of Drinfeld Modular Forms** [[paper](https://arxiv.org/abs/2310.19623)]
- [2023] **Cuspidality criterion for symmetric powers of automorphic representations of GL(2) over function fields** [[paper](https://arxiv.org/abs/2310.02458)]
- [2023] **Patterns of primes in joint Sato--Tate distributions** [[paper](https://arxiv.org/abs/2308.06632)]
- [2023] **Extending the support of 1- and 2-level densities for cusp form L-functions under square-root cancellation hypotheses** [[paper](https://arxiv.org/abs/2305.15293)]
- [2023] **Character Sheaves on Tori over Local Fields** [[paper](https://arxiv.org/abs/2304.06622)]
- [2023] **The explicit Local Langlands Correspondence for GSp_4, Sp_4 and stability (with an application to Modularity Lifting)** [[paper](https://arxiv.org/abs/2304.02622)]
- [2023] **Defining differential equations for modular forms and Jacobi forms** [[paper](https://arxiv.org/abs/2303.17936)]
- [2023] **Local Jacquet-Langlands correspondence for regular supercuspidal representations** [[paper](https://arxiv.org/abs/2303.02354)]
- [2023] **Explicit Constructions of Automorphic Forms: Theta Correspondence and Automorphic Descent** [[paper](https://arxiv.org/abs/2303.14919)]
- [2023] **Iwasawa invariants of modular forms with a_p=0** [[paper](https://arxiv.org/abs/2302.05748)]
- [2023] **Local-global compatibility over function fields** [[paper](https://arxiv.org/abs/2301.09711)]

##### 2022

- [2022] **The Tamagawa number conjecture and Kolyvagin's conjecture for motives of modular forms** [[paper](https://arxiv.org/abs/2211.04907)]
- [2022] **An introduction to the categorical p-adic Langlands program** [[paper](https://arxiv.org/abs/2210.01404)]
- [2022] **Quaternionic Satake equivalence** [[paper](https://arxiv.org/abs/2207.04078)]
- [2022] **Towards a mod-p Lubin-Tate theory for \GL_2 over totally real fields** [[paper](https://arxiv.org/abs/2206.09706)]
- [2022] **Orbital integrals and normalizations of measures** [[paper](https://arxiv.org/abs/2205.02391)]
- [2022] **Correspondance de Langlands locale p-adique et anneaux de Kisin** [[paper](https://arxiv.org/abs/2204.11217)]
- [2022] **Counting Points on Igusa Varieties of Hodge Type** [[paper](https://arxiv.org/abs/2203.01448)]
- [2022] **Notes on the Twistor \mathbf P^1** [[paper](https://arxiv.org/abs/2202.02657)]

##### 2021

- [2021] **Test Vectors for Archimedean Period Integrals** [[paper](https://arxiv.org/abs/2112.06860)]
- [2021] **Spherical varieties, functoriality, and quantization** [[paper](https://arxiv.org/abs/2111.03004)]
- [2021] **On certain supercuspidal representations of SL_n(F) associated with tamely ramified extensions: the formal degree conjecture and the root number conjecture** [[paper](https://arxiv.org/abs/2109.04642)]
- [2021] **On certain supercuspidal representations of symplectic groups associated with tamely ramified extensions : the formal degree conjecture and the root number conjecture** [[paper](https://arxiv.org/abs/2109.07124)]
- [2021] **On the étale cohomology of Hilbert modular varieties with torsion coefficients** [[paper](https://arxiv.org/abs/2107.10081)]
- [2021] **The local Langlands correspondence for \DeclareMathOperator{\GL}{GL}\GL_n over function fields** [[paper](https://arxiv.org/abs/2106.05381)]
- [2021] **Weight 2 CM newforms as p-adic limits** [[paper](https://arxiv.org/abs/2104.02335)]
- [2021] **Divisors of Fourier coefficients of two newforms** [[paper](https://arxiv.org/abs/2104.10055)]
- [2021] **Typical representations, parabolic induction and the inertial local Langlands correspondence** [[paper](https://arxiv.org/abs/2101.04900)]
- [2021] **Toward the endoscopic classification of unipotent representations of p-adic G_2** [[paper](https://arxiv.org/abs/2101.04578)]

##### 2020

- [2020] **Serre-Hazewinkel Local Class Field Theory and a Geometric Proof of the Local Langlands Correspondence for \operatorname{GL}(1)** [[paper](https://arxiv.org/abs/2011.00025)]
- [2020] **Coherent sheaves on the stack of Langlands parameters** [[paper](https://arxiv.org/abs/2008.02998)]
- [2020] **On Langlands program, global fields and shtukas** [[paper](https://arxiv.org/abs/2007.03411)]
- [2020] **An Approach to the Characterization of the Local Langlands Correspondence** [[paper](https://arxiv.org/abs/2003.11484)]

##### 2019

- [2019] **Stability of symmetric cube gamma factors for GL(2)** [[paper](https://arxiv.org/abs/1911.03428)]
- [2019] **A geometric Jacquet-Langlands correspondence for paramodular Siegel threefolds** [[paper](https://arxiv.org/abs/1906.04008)]
- [2019] **The Trace Formula and the Proof of the Global Jacquet-Langlands Correspondence** [[paper](https://arxiv.org/abs/1904.09517)]

##### 2018

- [2018] **Potential automorphy over CM fields** [[paper](https://arxiv.org/abs/1812.09999)]
- [2018] **Langlands Program and Ramanujan Conjecture: a survey** [[paper](https://arxiv.org/abs/1812.05203)]
- [2018] **Incorrigible Representations** [[paper](https://arxiv.org/abs/1811.05050)]
- [2018] **Fourier expansions at cusps** [[paper](https://arxiv.org/abs/1807.00391)]
- [2018] **Local Langlands correspondence, local factors, and zeta integrals in analytic families** [[paper](https://arxiv.org/abs/1807.10488)]
- [2018] **A converse theorem for Borcherds products on X_0(N)** [[paper](https://arxiv.org/abs/1806.09577)]
- [2018] **Counting cusp forms by analytic conductor** [[paper](https://arxiv.org/abs/1805.00633)]
- [2018] **The basis problem revisited** [[paper](https://arxiv.org/abs/1804.04234)]

##### 2017

- [2017] **On the Kottwitz conjecture for local shtuka spaces** [[paper](https://arxiv.org/abs/1709.06651)]
- [2017] **Local Langlands correspondence in rigid families** [[paper](https://arxiv.org/abs/1708.01213)]
- [2017] **Central values of twisted base change L-functions associated to Hilbert modular forms** [[paper](https://arxiv.org/abs/1707.07307)]
- [2017] **Exceptional splitting of reductions of abelian surfaces** [[paper](https://arxiv.org/abs/1706.08154)]
- [2017] **Representations by sextenary quadratic forms with coefficients 1,2,3 and 6 and on newforms in S_{3} (Γ_0 (24), χ)** [[paper](https://arxiv.org/abs/1705.01244)]
- [2017] **Semisimple characters for inner froms I: GL_n(D)** [[paper](https://arxiv.org/abs/1703.04904)]
- [2017] **On the number of representations of certain quadratic forms and a formula for the Ramanujan Tau function** [[paper](https://arxiv.org/abs/1702.01249)]
- [2017] **Congruences for modular forms mod 2 and quaternionic S-ideal classes** [[paper](https://arxiv.org/abs/1701.07864)]
- [2017] **Monodromy and Vinberg fusion for the principal degeneration of the space of G-bundles** [[paper](https://arxiv.org/abs/1701.01898)]

##### 2016

- [2016] **Affinoids in the Lubin-Tate perfectoid space and special cases of the local Langlands correspondence** [[paper](https://arxiv.org/abs/1609.02524)]
- [2016] **A plectic Taniyama group** [[paper](https://arxiv.org/abs/1606.03320)]
- [2016] **Proof of the Aubert-Baum-Plymen-Solleveld conjecture for split classical groups** [[paper](https://arxiv.org/abs/1604.04238)]
- [2016] **Geometrization of the local Langlands correspondence: an overview** [[paper](https://arxiv.org/abs/1602.00999)]

##### 2015

- [2015] **The Sato--Tate Distribution in Families of Elliptic Curves with a Rational Parameter of Bounded Height** [[paper](https://arxiv.org/abs/1512.07301)]
- [2015] **Some endoscopic properties of the essentially tame Jacquet-Langlands correspondence** [[paper](https://arxiv.org/abs/1510.04091)]
- [2015] **Globalization of supercuspidal representations over function fields and applications** [[paper](https://arxiv.org/abs/1510.00131)]
- [2015] **On tensor third L-functions of automorphic representations of GL_n(\mathbb{A}_F)** [[paper](https://arxiv.org/abs/1509.01863)]
- [2015] **Local Langlands Duality and a Duality of Conformal Field Theories** [[paper](https://arxiv.org/abs/1506.00663)]
- [2015] **The Jacquet Langlands correspondence via twisted descent** [[paper](https://arxiv.org/abs/1501.00506)]

##### 2014

- [2014] **A p-adic Labesse-Langlands transfer** [[paper](https://arxiv.org/abs/1412.4140)]
- [2014] **Local Jacquet-Langlands correspondences for simple supercuspidal representations** [[paper](https://arxiv.org/abs/1412.3523)]
- [2014] **Differential modular forms attached to newforms mod p** [[paper](https://arxiv.org/abs/1409.5367)]
- [2014] **Existence of non-abelian local constants, and their properties** [[paper](https://arxiv.org/abs/1401.5591)]

##### 2013

- [2013] **On the Typical Size and Cancelations Among the Coefficients of Some Modular Forms** [[paper](https://arxiv.org/abs/1308.6606)]
- [2013] **Affinoids in the Lubin-Tate perfectoid space and simple supercuspidal representations I: tame case** [[paper](https://arxiv.org/abs/1308.1276)]

##### 2012

- [2012] **Dimensions of spaces of Siegel cusp forms of degree 2** [[paper](https://arxiv.org/abs/1209.3088)]
- [2012] **Epipelagic L-packets and rectifying characters** [[paper](https://arxiv.org/abs/1209.1720)]
- [2012] **p-adic Langlands functoriality for the definite unitary group** [[paper](https://arxiv.org/abs/1206.2193)]
- [2012] **Genericity and contragredience in the local Langlands correspondence** [[paper](https://arxiv.org/abs/1204.0132)]
- [2012] **Level Aspect Subconvexity For Rankin-Selberg L-functions** [[paper](https://arxiv.org/abs/1203.1300)]
- [2012] **Langlands Program, Trace Formulas, and their Geometrization** [[paper](https://arxiv.org/abs/1202.2110)]

##### 2010

- [2010] **Théorie de Lubin-Tate non abélienne l-entière** [[paper](https://arxiv.org/abs/1011.1887)]
- [2010] **The Local Langlands correspondence for \GL_n over p-adic fields** [[paper](https://arxiv.org/abs/1010.1540)]
- [2010] **Geometrization of Trace Formulas** [[paper](https://arxiv.org/abs/1004.5323)]

##### 2009

- [2009] **Explicit non-abelian Lubin-Tate theory for GL(2)** [[paper](https://arxiv.org/abs/0910.1132)]

##### 2008

- [2008] **On a p-adic extension of the Jacquet-Langlands correspondence to weight 1** [[paper](https://arxiv.org/abs/0809.1048)]
- [2008] **Langlands Functoriality Conjecture** [[paper](https://arxiv.org/abs/0808.0917)]

##### 2006

- [2006] **Deformation spaces of one-dimensional formal modules and their cohomology** [[paper](https://arxiv.org/abs/math/0611109)]

##### 2002

- [2002] **Chtoucas de Drinfeld, formule des traces d'Arthur-Selberg et correspondance de Langlands** [[paper](https://arxiv.org/abs/math/0212399)]
- [2002] **The work of Laurent Lafforgue** [[paper](https://arxiv.org/abs/math/0212417)]

[⬆ Back to top](#paper-list)

### Dynamical Systems

#### Transfer Operators

##### 2026

- [2026] **Equidistribution and thermodynamics at infinity** [[paper](https://arxiv.org/abs/2608.19457)]
- [2026] **Analyticity of Lyapunov Exponents for Mixed Markov Quasi-Periodic Cocycles** [[paper](https://arxiv.org/abs/2608.01569)]
- [2026] **Decay of Correlations for Partially Hyperbolic Skew-Products** [[paper](https://arxiv.org/abs/2607.21516)]
- [2026] **Quantum Markov Chains for an Asymmetric Mixed Ising-XY Model on a Cayley Tree** [[paper](https://arxiv.org/abs/2607.14343)]
- [2026] **Arithmetic Landscape Functions of a Discrete Cat Map** [[paper](https://arxiv.org/abs/2607.24857)]
- [2026] **The Natural Extension for the Triangle Map (a Multi-dimensional Continued Fraction) with An Internal Symmetry from Young Conjugation** [[paper](https://arxiv.org/abs/2606.28014)]
- [2026] **Pair correlation statistics for dynamical systems** [[paper](https://arxiv.org/abs/2606.17880)]
- [2026] **Recent Progress in the Application of Transfer Operators to Dispersing Billiards** [[paper](https://arxiv.org/abs/2606.10155)]
- [2026] **Spectral clustering of time-evolving networks using spatio-temporal random walks** [[paper](https://arxiv.org/abs/2606.27850)]
- [2026] **From Ergodic Theory and Probability to Fractal Geometry and Dynamics: Themes in the Work of Manfred Denker** [[paper](https://arxiv.org/abs/2606.17857)]
- [2026] **Data-driven methods for computation of optimal linear response in high-dimensional dynamical systems** [[paper](https://arxiv.org/abs/2606.06728)]
- [2026] **Transfer Operators, Canonical Center Dynamics, and Spectral Applications for Long-Range Operators** [[paper](https://arxiv.org/abs/2606.29154)]
- [2026] **Homogeneous pre-foliations of co-degree one and degree four on the projective plane** [[paper](https://arxiv.org/abs/2605.07944)]
- [2026] **Fixed-point approximation for self-consistent transfer operators with Newton's method** [[paper](https://arxiv.org/abs/2605.08803)]
- [2026] **Transfer Operators for Stochastic Hybrid Systems on Manifolds with Guard-Induced Resets** [[paper](https://arxiv.org/abs/2604.18706)]
- [2026] **Gibbs Measures on Subshifts of Finite Type: Five Equivalent Characterizations with Explicit Constants** [[paper](https://arxiv.org/abs/2604.17528)]
- [2026] **Statistical Limit Theorems for Axiom A Diffeomorphisms: Exponential Mixing, Central Limit Theorem, and Large Deviations** [[paper](https://arxiv.org/abs/2604.18930)]
- [2026] **Transfer Operators and SRB Measures for Axiom A Diffeomorphisms: Spectral Gap, Structural Stability, and the Gibbs Equivalence Theorem** [[paper](https://arxiv.org/abs/2604.18929)]
- [2026] **Numerical approximation of the Koopman-von Neumann equation: Operator learning and quantum computing** [[paper](https://arxiv.org/abs/2604.08414)]
- [2026] **Optimal response for stochastic differential equations in \mathbb{T}^d with perturbations on the drift term** [[paper](https://arxiv.org/abs/2604.27404)]
- [2026] **Spectral theory for transfer operators on compact quotients of Euclidean buildings** [[paper](https://arxiv.org/abs/2603.26949)]
- [2026] **A Dynamical Approach to Non-Extensive Thermodynamics** [[paper](https://arxiv.org/abs/2603.08896)]
- [2026] **Dynamical compartments in stirred tank reactors and Markov state modeling for mixing quantification: a transfer operator approach** [[paper](https://arxiv.org/abs/2603.13996)]
- [2026] **Exploring Collatz Dynamics with Human-LLM Collaboration** [[paper](https://arxiv.org/abs/2603.11066)]
- [2026] **Extreme value theorem for geodesic flow on the quotient of the theta group** [[paper](https://arxiv.org/abs/2603.07649)]
- [2026] **Koopman and transfer operator techniques from the perspective of quantum theory** [[paper](https://arxiv.org/abs/2603.20102)]
- [2026] **Certified spectral approximation of transfer operators and the Gauss map** [[paper](https://arxiv.org/abs/2602.19435)]
- [2026] **Linear response for skew-product maps with contracting fibres** [[paper](https://arxiv.org/abs/2602.02317)]
- [2026] **Metastability of random maps: a resolvent approach** [[paper](https://arxiv.org/abs/2602.12400)]
- [2026] **Data-driven Reduction of Transfer Operators for Particle Clustering Dynamics** [[paper](https://arxiv.org/abs/2601.02932)]
- [2026] **Statistical Properties of Generalized Horseshoe Maps** [[paper](https://arxiv.org/abs/2601.02003)]
- [2026] **On the escape rate for intermittent maps with holes shrinking around the indifferent fixed point** [[paper](https://arxiv.org/abs/2601.15908)]

##### 2025

- [2025] **Hausdorff dimension for the weighted products of multiple digits in d-decaying Gauss like systems** [[paper](https://arxiv.org/abs/2512.02641)]
- [2025] **McMullen's game for equicontinuously-twisted badly approximable points in continued fractions and beta expansions** [[paper](https://arxiv.org/abs/2512.04236)]
- [2025] **How to Tame Your LLM: Semantic Collapse in Continuous Systems** [[paper](https://arxiv.org/abs/2512.05162)]
- [2025] **Chamber zeta function and closed galleries in the standard non-uniform complex from \operatorname{PGL}_3** [[paper](https://arxiv.org/abs/2512.23276)]
- [2025] **Selfconsistent Transfer Operators for Heterogeneous Coupled Maps** [[paper](https://arxiv.org/abs/2511.16572)]
- [2025] **Nonlinear constrained optimization of Schur test functions** [[paper](https://arxiv.org/abs/2510.05585)]
- [2025] **Data-driven approximation of transfer operators for mean-field stochastic differential equations** [[paper](https://arxiv.org/abs/2509.09891)]
- [2025] **A dimensional mass transference principle from balls to open sets and applications to dynamical Diophantine approximation** [[paper](https://arxiv.org/abs/2508.03359)]
- [2025] **Efficient computation of stationary measures and the Lyapunov Landscape for families random dynamical systems with smooth additive noise** [[paper](https://arxiv.org/abs/2508.03895)]
- [2025] **Exponential mixing of frame flows for three dimensional manifolds of quarter-pinched negative curvature** [[paper](https://arxiv.org/abs/2508.01593)]
- [2025] **A pseudospectral approach to rigorous numerical estimation of resonances of transfer operators** [[paper](https://arxiv.org/abs/2507.09021)]
- [2025] **Avoiding spectral pollution for transfer operators using residuals** [[paper](https://arxiv.org/abs/2507.16915)]
- [2025] **Discontinuous observables as an obstruction for small essential spectral radius** [[paper](https://arxiv.org/abs/2506.07613)]
- [2025] **Convergence of the Birkhoff spectrum for nonintegrable observables** [[paper](https://arxiv.org/abs/2506.21390)]
- [2025] **On fast Lyapunov spectra for Markov-Rényi maps** [[paper](https://arxiv.org/abs/2506.16291)]
- [2025] **Density of spectral gap property for positively expansive dynamics and smooth potentials, with applications to the phase transition problem** [[paper](https://arxiv.org/abs/2505.23934)]
- [2025] **Conjugacies of Expanding Skew Products on \mathbb{T}^n** [[paper](https://arxiv.org/abs/2505.09575)]
- [2025] **Dynamical zeta functions and resonance chains for infinite-area hyperbolic surfaces with large funnel widths** [[paper](https://arxiv.org/abs/2505.09840)]
- [2025] **Asymptotics of the Hausdorff measure for the Gauss map and its linearized analogue** [[paper](https://arxiv.org/abs/2504.02135)]
- [2025] **The Distributional Koopman Operator for Random Dynamical Systems** [[paper](https://arxiv.org/abs/2504.11643)]
- [2025] **Optimal linear response for Anosov diffeomorphisms** [[paper](https://arxiv.org/abs/2504.16532)]
- [2025] **General real measurable Livšic regularity via transfer operators** [[paper](https://arxiv.org/abs/2503.16088)]
- [2025] **Entropic transfer operators for stochastic systems** [[paper](https://arxiv.org/abs/2503.05308)]
- [2025] **Quasi-compactness and statistical properties for discontinuous systems semi-conjugate to piecewise convex maps with countably many branches** [[paper](https://arxiv.org/abs/2502.08751)]
- [2025] **The Eigenfunctions of the Transfer Operator for the Dyson model in a field** [[paper](https://arxiv.org/abs/2502.09588)]
- [2025] **Optimal response for stochastic differential equations by local kernel perturbations** [[paper](https://arxiv.org/abs/2502.09300)]
- [2025] **Random Dynamical Systems on the circle without a finite orbit** [[paper](https://arxiv.org/abs/2501.12158)]

##### 2024

- [2024] **On Convergents of Proper Continued Fractions** [[paper](https://arxiv.org/abs/2412.05077)]
- [2024] **Rare events statistics for \mathbb Z^d map lattices coupled by collision** [[paper](https://arxiv.org/abs/2412.12803)]
- [2024] **Quantitative recurrence properties and strong dynamical Borel-Cantelli lemma for dynamical systems with exponential decay of correlations** [[paper](https://arxiv.org/abs/2410.10211)]
- [2024] **Negative regularity mixing for random volume preserving diffeomorphisms** [[paper](https://arxiv.org/abs/2410.19251)]
- [2024] **Extravagance, irrationality and Diophantine approximation** [[paper](https://arxiv.org/abs/2409.19393)]
- [2024] **Minimal covers with continuity-preserving transfer operators for topological dynamical systems** [[paper](https://arxiv.org/abs/2408.11917)]
- [2024] **Stability of Fixed Points for Nonlinear Selfconsistent Transfer Operators via Cone Contractions** [[paper](https://arxiv.org/abs/2408.08745)]
- [2024] **The differential of self-consistent transfer operators and the local convergence to equilibrium of mean field strongly coupled dynamical systems** [[paper](https://arxiv.org/abs/2407.09314)]
- [2024] **Metric mean dimension via subshifts of compact type** [[paper](https://arxiv.org/abs/2407.07682)]
- [2024] **Identifying the onset and decay of quasi-stationary families of almost-invariant sets with an application to atmospheric blocking events** [[paper](https://arxiv.org/abs/2407.07278)]
- [2024] **Spectral gaps and Fourier decay for self-conformal measures in the plane** [[paper](https://arxiv.org/abs/2407.11688)]
- [2024] **Clustering Time-Evolving Networks Using the Spatio-Temporal Graph Laplacian** [[paper](https://arxiv.org/abs/2407.12864)]
- [2024] **Generalized multiple Borel-Cantelli Lemma in dynamics and its applications** [[paper](https://arxiv.org/abs/2406.13460)]
- [2024] **A cohomological approach to Ruelle-Pollicott resonances and speed of mixing of Anosov diffeomorphisms** [[paper](https://arxiv.org/abs/2405.17045)]
- [2024] **Horocycle flows on abelian covers of surfaces of negative curvature** [[paper](https://arxiv.org/abs/2405.08592)]
- [2024] **On an extension of a theorem by Ruelle to long-range potentials** [[paper](https://arxiv.org/abs/2404.07326)]
- [2024] **Dynamical Zeta functions for differentiable parabolic maps of the interval** [[paper](https://arxiv.org/abs/2403.17700)]
- [2024] **Exploring simplicity bias in 1D dynamical systems** [[paper](https://arxiv.org/abs/2403.06989)]
- [2024] **Equidistribution of cusp points of Hecke triangle groups** [[paper](https://arxiv.org/abs/2402.04784)]
- [2024] **Euclidean algorithms are Gaussian over imaginary quadratic fields** [[paper](https://arxiv.org/abs/2401.00734)]

##### 2023

- [2023] **Edge Laplacians and Edge Poisson Transforms for Graphs** [[paper](https://arxiv.org/abs/2312.09101)]
- [2023] **Consistent Long-Term Forecasting of Ergodic Dynamical Systems** [[paper](https://arxiv.org/abs/2312.13426)]
- [2023] **Highly accurate and fine-scale estimation of equilibrium measures** [[paper](https://arxiv.org/abs/2312.11052)]
- [2023] **Optimal linear response for expanding circle maps** [[paper](https://arxiv.org/abs/2310.19191)]
- [2023] **Phase transitions for transitive local diffeomorphism with break points on the circle and Holder continuous potentials** [[paper](https://arxiv.org/abs/2310.07034)]
- [2023] **Extreme Value theory and Poisson statistics for discrete time samplings of stochastic differential equations** [[paper](https://arxiv.org/abs/2310.13972)]
- [2023] **Gibbs measures have local product structure** [[paper](https://arxiv.org/abs/2310.17495)]
- [2023] **Some Probabilistic Properties of General Topological Markov Chains** [[paper](https://arxiv.org/abs/2310.01697)]
- [2023] **Exponential rate of decay of correlations of equilibrium states associated with non-uniformly expanding circle maps** [[paper](https://arxiv.org/abs/2309.09144)]
- [2023] **Compound Poisson statistics for dynamical systems via spectral perturbation** [[paper](https://arxiv.org/abs/2308.10798)]
- [2023] **Polynomial Fourier decay and a cocycle version of Dolgopyat's method for self conformal measures** [[paper](https://arxiv.org/abs/2306.01275)]
- [2023] **Transfer operators on graphs: Spectral clustering and beyond** [[paper](https://arxiv.org/abs/2305.11766)]
- [2023] **Continuous eigenfunctions of the transfer operator for Dyson models** [[paper](https://arxiv.org/abs/2304.04202)]

##### 2022

- [2022] **On the generalised transfer operators of the Farey map with complex temperature** [[paper](https://arxiv.org/abs/2211.11664)]
- [2022] **Statistical properties for mixing Markov chains with applications to dynamical systems** [[paper](https://arxiv.org/abs/2210.16908)]
- [2022] **Strict transfer operator approaches for non-compact hyperbolic orbisurfaces** [[paper](https://arxiv.org/abs/2209.06601)]
- [2022] **Selberg zeta functions, cuspidal accelerations, and existence of strict transfer operator approaches** [[paper](https://arxiv.org/abs/2209.05927)]
- [2022] **Emergence of quantum dynamics from chaos: The case of prequantum cat maps** [[paper](https://arxiv.org/abs/2209.02027)]
- [2022] **Quasi-compactness of transfer operators for topological Markov shifts with holes** [[paper](https://arxiv.org/abs/2207.08085)]
- [2022] **Intermittency generated by attracting and weakly repelling fixed points** [[paper](https://arxiv.org/abs/2207.11038)]
- [2022] **Cover times in dynamical systems** [[paper](https://arxiv.org/abs/2204.05008)]
- [2022] **The Bowen\unicode{x2013}Series coding and zeros of zeta functions** [[paper](https://arxiv.org/abs/2204.08203)]
- [2022] **Equilibrium states of endomorphisms of \mathbb{P}^k II: spectral stability and limit theorems** [[paper](https://arxiv.org/abs/2204.02856)]

##### 2021

- [2021] **Potential theory and \mathbb{Z}^d-extensions** [[paper](https://arxiv.org/abs/2112.08339)]
- [2021] **Quenched linear response for smooth expanding on average cocycles** [[paper](https://arxiv.org/abs/2112.14984)]
- [2021] **Open-flow mixing and transfer operators** [[paper](https://arxiv.org/abs/2112.11497)]
- [2021] **A Ruelle-Perron-Frobenius theorem for expanding circle maps with an indifferent fixed point** [[paper](https://arxiv.org/abs/2111.12882)]
- [2021] **A patch in time saves nine: Methods for the identification of localised dynamical behaviour and lifespans of coherent structures** [[paper](https://arxiv.org/abs/2109.09970)]
- [2021] **Is the Finite-Time Lyapunov Exponent Field a Koopman Eigenfunction?** [[paper](https://arxiv.org/abs/2109.12163)]
- [2021] **Dichotomy results for eventually always hitting time statistics and almost sure growth of extremes** [[paper](https://arxiv.org/abs/2109.06314)]
- [2021] **Dynamics of Ostrowski skew-product: I. Limit laws and Hausdorff dimensions** [[paper](https://arxiv.org/abs/2108.06780)]
- [2021] **Recursive divergence formulas for perturbing unstable transfer operators and physical measures** [[paper](https://arxiv.org/abs/2108.13863)]
- [2021] **Thermodynamical and spectral phase transition for local diffeomorphisms in the circle** [[paper](https://arxiv.org/abs/2106.08436)]
- [2021] **Efficient computation of statistical properties of intermittent dynamics** [[paper](https://arxiv.org/abs/2106.01498)]
- [2021] **Self consistent transfer operators. Invariant measures, convergence to equilibrium, linear response and control of the statistical properties** [[paper](https://arxiv.org/abs/2105.12388)]
- [2021] **Nonexistence of spectral gaps in Hölder spaces for continuous time dynamical systems** [[paper](https://arxiv.org/abs/2104.04608)]
- [2021] **Map lattices coupled by collisions: hitting time statistics and collisions per lattice unit** [[paper](https://arxiv.org/abs/2104.10233)]
- [2021] **Projective Cones for Sequential Dispersing Billiards** [[paper](https://arxiv.org/abs/2104.06947)]
- [2021] **Uniform resonance free regions for convex cocompact hyperbolic surfaces and expanders** [[paper](https://arxiv.org/abs/2101.05757)]
- [2021] **Decay in norm of transfer operators for semiflows** [[paper](https://arxiv.org/abs/2102.00026)]
- [2021] **Lyapunov exponents for transfer operator cocycles of metastable maps: a quarantine approach** [[paper](https://arxiv.org/abs/2101.06588)]

##### 2020

- [2020] **Precise asymptotics on the Birkhoff sums for dynamical systems** [[paper](https://arxiv.org/abs/2012.05500)]
- [2020] **Symbolic dynamics and transfer operators for Weyl chamber flows: a class of examples** [[paper](https://arxiv.org/abs/2011.14098)]
- [2020] **On the Dimension of the Space of Harmonic Functions on Transitive Shift Spaces** [[paper](https://arxiv.org/abs/2009.07209)]
- [2020] **Functional analysis behind a Family of Multidimensional Continued Fractions: Part II** [[paper](https://arxiv.org/abs/2008.07938)]
- [2020] **Conformally formal manifolds and the uniformly quasiregular non-ellipticity of (\mathbb{S}^2 \times \mathbb{S}^2) \operatorname{\#} (\mathbb{S}^2 \times \mathbb{S}^2)** [[paper](https://arxiv.org/abs/2008.10669)]
- [2020] **Lagrange approximation of transfer operators associated with holomorphic data** [[paper](https://arxiv.org/abs/2004.03534)]
- [2020] **Quenched and annealed equilibrium states for random Ruelle expanding maps and applications** [[paper](https://arxiv.org/abs/2004.04763)]
- [2020] **Sinai billiard maps with Ruelle resonances** [[paper](https://arxiv.org/abs/2002.11035)]
- [2020] **Numerical resonances for Schottky surfaces via Lagrange-Chebyshev approximation** [[paper](https://arxiv.org/abs/2002.03334)]
- [2020] **Extreme Value Theory with Spectral Techniques: application to a simple attractor** [[paper](https://arxiv.org/abs/2002.10863)]

##### 2019

- [2019] **Finite partitions for several complex continued fraction algorithms** [[paper](https://arxiv.org/abs/1911.01999)]
- [2019] **Equilibrium states for non-uniformly hyperbolic systems: statistical properties and analyticity** [[paper](https://arxiv.org/abs/1908.00066)]
- [2019] **Big Birkhoff sums in d-decaying Gauss like iterated function systems** [[paper](https://arxiv.org/abs/1905.02547)]
- [2019] **Zero-one laws for eventually always hitting points in in rapidly mixing systems** [[paper](https://arxiv.org/abs/1904.08584)]
- [2019] **Uniqueness of minimizer for countable Markov shifts and equidistribution of periodic points** [[paper](https://arxiv.org/abs/1904.04997)]
- [2019] **Transfer operators, atomic decomposition and the Bestiary** [[paper](https://arxiv.org/abs/1903.06976)]

##### 2018

- [2018] **A Transfer Operator Methodology for Optimal Sensor Placement Accounting for Uncertainty** [[paper](https://arxiv.org/abs/1812.10541)]
- [2018] **Fourier decay in nonlinear dynamics** [[paper](https://arxiv.org/abs/1810.01378)]
- [2018] **A new proof of the dimension gap for the Gauss map** [[paper](https://arxiv.org/abs/1806.00841)]
- [2018] **Decreasing height along continued fractions** [[paper](https://arxiv.org/abs/1802.09378)]

##### 2017

- [2017] **Eigendecompositions of Transfer Operators in Reproducing Kernel Hilbert Spaces** [[paper](https://arxiv.org/abs/1712.01572)]
- [2017] **Fractal uncertainty for transfer operators** [[paper](https://arxiv.org/abs/1710.05430)]
- [2017] **Spectra of expanding maps on Besov spaces** [[paper](https://arxiv.org/abs/1710.09673)]
- [2017] **Parameter regularity of dynamical determinants of expanding maps of the circle and an application to linear response** [[paper](https://arxiv.org/abs/1708.01055)]
- [2017] **Dimensions of non-autonomous meromorphic functions of finite order** [[paper](https://arxiv.org/abs/1708.05461)]
- [2017] **Gaussian Behavior of Quadratic Irrationals** [[paper](https://arxiv.org/abs/1708.00051)]
- [2017] **Variational principles for t-entropy, the spectral potential of transfer operator, and entropy statistic theorem are equivalent** [[paper](https://arxiv.org/abs/1707.01431)]
- [2017] **Thermodynamic Formalism for Iterated Function Systems with Weights** [[paper](https://arxiv.org/abs/1707.01892)]
- [2017] **Non-escaping endpoints do not explode** [[paper](https://arxiv.org/abs/1707.01843)]
- [2017] **Slow continued fractions, transducers, and the Serret theorem** [[paper](https://arxiv.org/abs/1706.00698)]
- [2017] **Rotational subsets of the circle** [[paper](https://arxiv.org/abs/1705.03851)]
- [2017] **Effective high-temperature estimates for intermittent maps** [[paper](https://arxiv.org/abs/1704.00586)]
- [2017] **Functional Analysis behind a Family of Multidimensional Continued Fractions: Part I** [[paper](https://arxiv.org/abs/1703.01589)]
- [2017] **An Almost Sure Invariance Principle for Several Classes of Random Dynamical Systems** [[paper](https://arxiv.org/abs/1702.07691)]

##### 2016

- [2016] **Phase Transitions of the Multifractal Spectrum** [[paper](https://arxiv.org/abs/1607.04786)]

##### 2015

- [2015] **Computing Coherent Sets using the Fokker-Planck Equation** [[paper](https://arxiv.org/abs/1512.03761)]
- [2015] **The random continued fraction transformation** [[paper](https://arxiv.org/abs/1507.05782)]
- [2015] **Escaping endpoints explode** [[paper](https://arxiv.org/abs/1506.05347)]
- [2015] **On fast computation of finite-time coherent sets using radial basis functions** [[paper](https://arxiv.org/abs/1505.05056)]
- [2015] **Dimension rigidity in conformal structures** [[paper](https://arxiv.org/abs/1504.01774)]
- [2015] **Symbolic dynamics, automorphic functions, and Selberg zeta functions with unitary representations** [[paper](https://arxiv.org/abs/1503.00525)]
- [2015] **A short proof that the number of division steps in the Euclidean algorithm is normally distributed** [[paper](https://arxiv.org/abs/1502.07616)]
- [2015] **Jimm, a Fundamental Involution** [[paper](https://arxiv.org/abs/1501.03787)]

##### 2014

- [2014] **Parabolic dynamics and Anisotropic Banach spaces** [[paper](https://arxiv.org/abs/1412.7181)]
- [2014] **Symmetry reduction of holomorphic iterated function schemes and factorization of Selberg zeta functions** [[paper](https://arxiv.org/abs/1407.6134)]
- [2014] **On Transfer Operators and Maps with Random Holes** [[paper](https://arxiv.org/abs/1405.0361)]
- [2014] **A thermodynamic formalism approach to the Selberg zeta function for Hecke triangle surfaces of infinite area** [[paper](https://arxiv.org/abs/1404.3934)]
- [2014] **On the asymptotics of the α-Farey transfer operator** [[paper](https://arxiv.org/abs/1404.5857)]
- [2014] **Quatre applications du lemme de Zalcman à la dynamique complexe** [[paper](https://arxiv.org/abs/1401.4086)]

##### 2013

- [2013] **Fourier transforms of Gibbs measures for the Gauss map** [[paper](https://arxiv.org/abs/1312.3619)]
- [2013] **Odd and even Maass cusp forms for Hecke triangle groups, and the billiard flow** [[paper](https://arxiv.org/abs/1303.0528)]
- [2013] **Continued fractions on the Heisenberg group** [[paper](https://arxiv.org/abs/1302.6121)]

##### 2012

- [2012] **A dynamical approach to Maass cusp forms** [[paper](https://arxiv.org/abs/1208.6178)]
- [2012] **Statistical properties of coupled expanding maps on a lattice with general infinite range couplings and Hölder densities** [[paper](https://arxiv.org/abs/1203.3992)]
- [2012] **Period functions for Maass cusp forms for Γ_0(p): a transfer operator approach** [[paper](https://arxiv.org/abs/1203.5510)]

##### 2010

- [2010] **Symbolic Dynamics for the Geodesic Flow on Two-dimensional Hyperbolic Good Orbifolds** [[paper](https://arxiv.org/abs/1008.0367)]
- [2010] **Strong renewal theorems and Lyapunov spectra for α-Farey and α-Lüroth systems** [[paper](https://arxiv.org/abs/1006.5693)]

##### 2009

- [2009] **The transfer operator for the Hecke triangle groups** [[paper](https://arxiv.org/abs/0912.2236)]
- [2009] **A thermodynamic approach to two-variable Ruelle and Selberg zeta functions via the Farey map** [[paper](https://arxiv.org/abs/0907.1471)]
- [2009] **Random iterated function systems with smooth invariant densities** [[paper](https://arxiv.org/abs/0903.2905)]

##### 2008

- [2008] **An application of Jacquet-Langlands correspondence to transfer operators for geodesic flows on Riemann surfaces** [[paper](https://arxiv.org/abs/0808.2002)]
- [2008] **Computation of Selberg zeta functions on Hecke triangle groups** [[paper](https://arxiv.org/abs/0804.4837)]
- [2008] **Renewal-type Limit Theorem for Continued Fractions with Even Partial Quotients** [[paper](https://arxiv.org/abs/0802.4459)]
- [2008] **On the Ruelle eigenvalue sequence** [[paper](https://arxiv.org/abs/0802.1468)]

##### 2007

- [2007] **Equidistribution of Horocyclic Flows on Complete Hyperbolic Surfaces of Finite Area** [[paper](https://arxiv.org/abs/0712.1300)]
- [2007] **Eigenfunctions of transfer operators and cohomology** [[paper](https://arxiv.org/abs/0707.1203)]
- [2007] **Extensions of C*-dynamical systems to systems with complete transfer operators** [[paper](https://arxiv.org/abs/math/0703800)]
- [2007] **On transfer operators for C*-dynamical systems** [[paper](https://arxiv.org/abs/math/0703798)]

##### 2006

- [2006] **Dynamical determinants and spectrum for hyperbolic diffeomorphisms** [[paper](https://arxiv.org/abs/math/0606434)]
- [2006] **Fast decay of correlations of equilibrium states of open classes of non-uniformly expanding maps and potentials** [[paper](https://arxiv.org/abs/math/0603629)]
- [2006] **On the entropy of Japanese continued fractions** [[paper](https://arxiv.org/abs/math/0601576)]
- [2006] **A degenerate Newton's Map in two complex variables: linking with currents** [[paper](https://arxiv.org/abs/math/0601223)]

##### 2005

- [2005] **A multifractal analysis for Stern-Brocot intervals, continued fractions and Diophantine growth rates** [[paper](https://arxiv.org/abs/math/0509603)]

##### 2003

- [2003] **On CP1 and CP2 maps and Weierstrass representations for surfaces immersed into multi-dimensional Euclidean spaces** [[paper](https://arxiv.org/abs/math/0309097)]

##### 1991

- [1991] **The thermodynamic formalism approach to Selberg's zeta function for PSL(2,Z)** *Bulletin of the American Mathematical Society* [[paper](https://doi.org/10.1090/s0273-0979-1991-16023-4)]

[⬆ Back to top](#paper-list)

#### Selberg Zeta & Trace Formulas

##### 2024

- [2024] **Selberg, Ihara and Berkovich** [[paper](https://arxiv.org/abs/2412.20754)]
- [2024] **The spectral concentration for damped waves on compact Anosov manifolds** [[paper](https://arxiv.org/abs/2411.02929)]
- [2024] **Exponential prime orbit theorems for Anosov subgroups** [[paper](https://arxiv.org/abs/2408.11274)]

##### 2022

- [2022] **Zeros of the Selberg zeta function for symmetric infinite area hyperbolic surfaces** [[paper](https://arxiv.org/abs/2204.08218)]
- [2022] **Zeta functions in higher Teichmuller theory** [[paper](https://arxiv.org/abs/2203.15741)]

##### 2018

- [2018] **Prime geodesic theorem for the Picard manifold** [[paper](https://arxiv.org/abs/1804.00275)]

##### 2017

- [2017] **Fourier dimension and spectral gaps for hyperbolic surfaces** [[paper](https://arxiv.org/abs/1704.02909)]

##### 2016

- [2016] **Spectral gaps without the pressure condition** [[paper](https://arxiv.org/abs/1612.09040)]

##### 2006

- [2006] **A lower bound for the remainder in Weyl's law on negatively curved surfaces** [[paper](https://arxiv.org/abs/math/0612250)]

[⬆ Back to top](#paper-list)

### Machine Learning

#### GNNs on Cayley Graphs

##### 2026

- [2026] **Spectral Gaps of Hit-and-Run and Coordinate Hit-and-Run** [[paper](https://arxiv.org/abs/2608.16878)]
- [2026] **QR-Erase: Efficient Subspace-Based Machine Unlearning with Layer Localization** [[paper](https://arxiv.org/abs/2608.01422)]
- [2026] **Riemann GeoResolver: A Non-Euclidean Attention Framework from Euclidean Resolver to Hyperbolic-Spherical Geometry** [[paper](https://arxiv.org/abs/2608.10416)]
- [2026] **Schreier-Coset Graph Rewiring** [[paper](https://arxiv.org/abs/2607.27479)]
- [2026] **A Riemannian View on Active Subspaces** [[paper](https://arxiv.org/abs/2607.25163)]
- [2026] **Persistent Gaussian Perturbations Prevent Oversmoothing in Recurrent Graph Neural Networks** [[paper](https://arxiv.org/abs/2607.28185)]
- [2026] **Improved Convergence Analysis of Topology Dependence in Decentralized SGD** [[paper](https://arxiv.org/abs/2606.09154)]
- [2026] **Analytic Torsion and Spectral Gap Capture Persistent-Laplacian Performance** [[paper](https://arxiv.org/abs/2606.16990)]
- [2026] **Denoise First, Orthogonalize Later: Understanding Momentum in Muon via Spectral Filtering** [[paper](https://arxiv.org/abs/2606.03899)]
- [2026] **Regime-Arrival Uncertainty in Generalization Bounds under Distribution Shift** [[paper](https://arxiv.org/abs/2606.02657)]
- [2026] **Near-Optimal Decentralized Stochastic Convex Optimization over Networks** [[paper](https://arxiv.org/abs/2606.04757)]
- [2026] **Accelerated Decentralized Stochastic Gradient Descent for Strongly Convex Optimization** [[paper](https://arxiv.org/abs/2606.07496)]
- [2026] **When Design Rules Break: Benchmark Composition Determines Whether Label Informativeness Predicts GNN Aggregator Choice** [[paper](https://arxiv.org/abs/2606.10249)]
- [2026] **Geometric bias in eigenspace perturbation under random heterogeneous noise** [[paper](https://arxiv.org/abs/2606.11263)]
- [2026] **Anchoring the Eigengap: Cross-Modal Spectral Stabilization for Sample-Efficient Representation Learning** [[paper](https://arxiv.org/abs/2605.08764)]
- [2026] **Self-Certifying Transport MCMC via Dual Spectral-Gap Certificates** [[paper](https://arxiv.org/abs/2605.30722)]
- [2026] **The Score Hamiltonian: Mapping Diffusion Models to Adiabatic Transport** [[paper](https://arxiv.org/abs/2606.05217)]
- [2026] **Predictive Maps of Multi-Agent Reasoning: A Successor-Representation Spectrum for LLM Communication Topologies** [[paper](https://arxiv.org/abs/2605.11453)]
- [2026] **On the Approximation Complexity of Matrix Product Operator Born Machines** [[paper](https://arxiv.org/abs/2605.11471)]
- [2026] **Entrywise Error Bounds for Spectral Ranking with Semi-Random Adversaries** [[paper](https://arxiv.org/abs/2605.23854)]
- [2026] **Dimension-Free Saddle-Point Escape in Muon** [[paper](https://arxiv.org/abs/2605.09331)]
- [2026] **Holomorphic Neural ODEs with Kolmogorov-Arnold Networks for Interpretable Discovery of Complex Dynamics** [[paper](https://arxiv.org/abs/2605.22235)]
- [2026] **Mind Dreamer: Untethering Imagination via Active Causal Intervention on Latent Manifolds** [[paper](https://arxiv.org/abs/2605.16030)]
- [2026] **Non-Vacuous Certification of Transport MCMC via Oscillation-Controlled Normalizing Flows** [[paper](https://arxiv.org/abs/2606.01078)]
- [2026] **How Much Data is Enough? The Zeta Law of Discoverability in Biomedical Data, featuring the enigmatic Riemann zeta function** [[paper](https://arxiv.org/abs/2604.17581)]
- [2026] **Decentralized Learning via Random Walk with Jumps** [[paper](https://arxiv.org/abs/2604.12260)]
- [2026] **Sheaf-Laplacian Obstruction and Projection Hardness for Cross-Modal Compatibility on a Modality-Independent Site** [[paper](https://arxiv.org/abs/2604.07632)]
- [2026] **Descending into the Modular Bootstrap** [[paper](https://arxiv.org/abs/2604.01275)]
- [2026] **Optimal Decay Spectra for Linear Recurrences** [[paper](https://arxiv.org/abs/2604.07658)] [[code](https://github.com/SiLifen/PoST)]
- [2026] **Path-Sampled Integrated Gradients** [[paper](https://arxiv.org/abs/2604.14338)]
- [2026] **Random Dot Product Graphs as Dynamical Systems: Limitations and Opportunities** [[paper](https://arxiv.org/abs/2603.05703)]
- [2026] **On the Complexity of Optimal Graph Rewiring for Oversmoothing and Oversquashing in Graph Neural Networks** [[paper](https://arxiv.org/abs/2603.26140)]
- [2026] **Uncovering Locally Low-dimensional Structure in Networks by Locally Optimal Spectral Embedding** [[paper](https://arxiv.org/abs/2603.11965)]
- [2026] **Spectral Edge Dynamics of Training Trajectories: Signal--Noise Geometry Across Scales** [[paper](https://arxiv.org/abs/2603.15678)]
- [2026] **Long Range Frequency Tuning for QML** [[paper](https://arxiv.org/abs/2602.23409)]
- [2026] **Near-Optimal Regret for Distributed Adversarial Bandits: A Black-Box Approach** [[paper](https://arxiv.org/abs/2602.06404)]
- [2026] **Tight Analysis of Decentralized SGD: A Markov Chain Perspective** [[paper](https://arxiv.org/abs/2601.07021)]
- [2026] **mHC-GNN: Manifold-Constrained Hyper-Connections for Graph Neural Networks** [[paper](https://arxiv.org/abs/2601.02451)] [[code](https://github.com/smishra-lab/mhc-gnn)]

##### 2025

- [2025] **Measuring Over-smoothing beyond Dirichlet energy** [[paper](https://arxiv.org/abs/2512.06782)]
- [2025] **A Theoretical Lens for RL-Tuned Language Models via Energy-Based Models** [[paper](https://arxiv.org/abs/2512.18730)]
- [2025] **Row-Stochastic Matrices Can Provably Outperform Doubly Stochastic Matrices in Decentralized Learning** [[paper](https://arxiv.org/abs/2511.19513)]
- [2025] **Fractional neural attention for efficient multiscale sequence processing** [[paper](https://arxiv.org/abs/2511.10208)]
- [2025] **Interpretable Multimodal Zero-Shot ECG Diagnosis via Structured Clinical Knowledge Alignment** [[paper](https://arxiv.org/abs/2510.21551)]
- [2025] **Low-Precision Streaming PCA** [[paper](https://arxiv.org/abs/2510.22440)]
- [2025] **An Introductory Guide to Koopman Learning** [[paper](https://arxiv.org/abs/2510.22002)]
- [2025] **Deeper with Riemannian Geometry: Overcoming Oversmoothing and Oversquashing for Graph Foundation Models** [[paper](https://arxiv.org/abs/2510.17457)]
- [2025] **On the Statistical Query Complexity of Learning Semiautomata: a Random Walk Approach** [[paper](https://arxiv.org/abs/2510.04115)]
- [2025] **Differentially Private Spectral Graph Clustering: Balancing Privacy, Accuracy, and Efficiency** [[paper](https://arxiv.org/abs/2510.07136)]
- [2025] **Tight Differentially Private PCA via Matrix Coherence** [[paper](https://arxiv.org/abs/2510.26679)]
- [2025] **Free Denoising Diffusion Models** [[paper](https://arxiv.org/abs/2510.22778)]
- [2025] **Alternatives to the Laplacian for Scalable Spectral Clustering with Group Fairness Constraints** [[paper](https://arxiv.org/abs/2510.20220)]
- [2025] **Empirical PAC-Bayes Bounds for Markov Chains** [[paper](https://arxiv.org/abs/2509.20985)]
- [2025] **Discrete Functional Geometry of ReLU Networks via ReLU Transition Graphs** [[paper](https://arxiv.org/abs/2509.03056)]
- [2025] **ZetA: A Riemann Zeta-Scaled Extension of Adam for Deep Learning** [[paper](https://arxiv.org/abs/2508.02719)]
- [2025] **Dynamic Triangulation-Based Graph Rewiring for Graph Neural Networks** [[paper](https://arxiv.org/abs/2508.19071)]
- [2025] **Studying Effective String Theory using deep generative models** [[paper](https://arxiv.org/abs/2508.20610)]
- [2025] **Tessellation Groups, Harmonic Analysis on Non-compact Symmetric Spaces and the Heat Kernel in view of Cartan Convolutional Neural Networks** [[paper](https://arxiv.org/abs/2508.16015)]
- [2025] **Persistent Homology as a Theory of Emergent Structure** [[paper](https://arxiv.org/abs/2507.03065)]
- [2025] **SpectralGap: Graph-Level Out-of-Distribution Detection via Laplacian Eigenvalue Gaps** [[paper](https://arxiv.org/abs/2505.15177)]
- [2025] **Schreier-Coset Graph Propagation** [[paper](https://arxiv.org/abs/2505.10392)]
- [2025] **Machine learning automorphic forms for black holes** [[paper](https://arxiv.org/abs/2505.05549)]
- [2025] **Distributed Learning over Arbitrary Topology: Linear Speed-Up with Polynomial Transient Time** [[paper](https://arxiv.org/abs/2503.16123)]
- [2025] **Riemann Tensor Neural Networks: Learning Conservative Systems with Physics-Constrained Networks** [[paper](https://arxiv.org/abs/2503.00755)]
- [2025] **Neural network-based Godunov corrections for approximate Riemann solvers using bi-fidelity learning** [[paper](https://arxiv.org/abs/2503.13248)]
- [2025] **GNNs Getting ComFy: Community and Feature Similarity Guided Rewiring** *ICLR 2025* [[paper](https://arxiv.org/abs/2502.04891)]
- [2025] **Near-Optimal Online Learning for Multi-Agent Submodular Coordination: Tight Approximation and Communication Efficiency** [[paper](https://arxiv.org/abs/2502.05028)]
- [2025] **ZETA: Leveraging Z-order Curves for Efficient Top-k Attention** [[paper](https://arxiv.org/abs/2501.14577)]

##### 2024

- [2024] **Matrix Concentration for Random Signed Graphs and Community Recovery in the Signed Stochastic Block Model** [[paper](https://arxiv.org/abs/2412.20620)]
- [2024] **Numerical Analysis of HiPPO-LegS ODE for Deep State Space Models** [[paper](https://arxiv.org/abs/2412.08595)]
- [2024] **Efficiently learning and sampling multimodal distributions with data-based initialization** [[paper](https://arxiv.org/abs/2411.09117)]
- [2024] **Covariance estimation using Markov chain Monte Carlo** [[paper](https://arxiv.org/abs/2410.17147)]
- [2024] **Mind the Gap: a Spectral Analysis of Rank Collapse and Signal Propagation in Attention Layers** [[paper](https://arxiv.org/abs/2410.07799)]
- [2024] **A Unified View of Delta Parameter Editing in Post-Trained Large-Scale Models** [[paper](https://arxiv.org/abs/2410.13841)]
- [2024] **Manifolds, Random Matrices and Spectral Gaps: The geometric phases of generative diffusion** [[paper](https://arxiv.org/abs/2410.05898)]
- [2024] **Cayley Graph Propagation** [[paper](https://arxiv.org/abs/2410.03424)]
- [2024] **A note on the standard zero-free region for L-functions** [[paper](https://arxiv.org/abs/2410.09910)]
- [2024] **Non-native Quantum Generative Optimization with Adversarial Autoencoders** [[paper](https://arxiv.org/abs/2407.13830)]
- [2024] **Transformers as Neural Operators for Solutions of Differential Equations with Finite Regularity** [[paper](https://arxiv.org/abs/2405.19166)]
- [2024] **Spectral Graph Pruning Against Over-Squashing and Over-Smoothing** *NeurIPS 2024* [[paper](https://arxiv.org/abs/2404.04612)]
- [2024] **Resistance Distance and Linearized Optimal Transport on Graphs** [[paper](https://arxiv.org/abs/2404.15261)]
- [2024] **A Survey on Applications of Reinforcement Learning in Spatial Resource Allocation** [[paper](https://arxiv.org/abs/2403.03643)]
- [2024] **Robust Graph Structure Learning under Heterophily** [[paper](https://arxiv.org/abs/2403.03659)]
- [2024] **Spectral Algorithms on Manifolds through Diffusion** [[paper](https://arxiv.org/abs/2403.03669)]
- [2024] **Comprehensive evaluation of Mal-API-2019 dataset by machine learning in malware detection** [[paper](https://arxiv.org/abs/2403.02232)]
- [2024] **BloomGML: Graph Machine Learning through the Lens of Bilevel Optimization** [[paper](https://arxiv.org/abs/2403.04763)] [[code](https://github.com/amberyzheng/BloomGML)]
- [2024] **Breaking the Language Barrier: Can Direct Inference Outperform Pre-Translation in Multilingual LLM Applications?** [[paper](https://arxiv.org/abs/2403.04792)]
- [2024] **Found in the Middle: How Language Models Use Long Contexts Better via Plug-and-Play Positional Encoding** [[paper](https://arxiv.org/abs/2403.04797)] [[code](https://github.com/VITA-Group/Ms-PoE)]
- [2024] **Enhancing Security in Federated Learning through Adaptive Consensus-Based Model Update Validation** [[paper](https://arxiv.org/abs/2403.04803)]
- [2024] **Control-based Graph Embeddings with Data Augmentation for Contrastive Learning** [[paper](https://arxiv.org/abs/2403.04923)]
- [2024] **Autonomous vehicle decision and control through reinforcement learning with traffic flow randomization** [[paper](https://arxiv.org/abs/2403.02882)]
- [2024] **MathScale: Scaling Instruction Tuning for Mathematical Reasoning** [[paper](https://arxiv.org/abs/2403.02884)]
- [2024] **AIx Speed: Playback Speed Optimization Using Listening Comprehension of Speech Recognition Models** [[paper](https://arxiv.org/abs/2403.02938)]
- [2024] **A Distance Metric Learning Model Based On Variational Information Bottleneck** [[paper](https://arxiv.org/abs/2403.02794)]
- [2024] **L_0 Regularization of Field-Aware Factorization Machine through Ising Model** [[paper](https://arxiv.org/abs/2403.01718)]
- [2024] **How Multimodal Integration Boost the Performance of LLM for Optimization: Case Study on Capacitated Vehicle Routing Problems** [[paper](https://arxiv.org/abs/2403.01757)]
- [2024] **DeepCRE: Transforming Drug R&amp;D via AI-Driven Cross-drug Response Evaluation** [[paper](https://arxiv.org/abs/2403.03768)]
- [2024] **A machine learning workflow to address credit default prediction** [[paper](https://arxiv.org/abs/2403.03785)]
- [2024] **Feature Selection as Deep Sequential Generative Learning** [[paper](https://arxiv.org/abs/2403.03838)]
- [2024] **EulerFormer: Sequential User Behavior Modeling with Complex Vector Attention** *SIGIR* [[paper](https://arxiv.org/abs/2403.17729)]
- [2024] **HealthGAT: Node Classifications in Electronic Health Records using Graph Attention Networks** [[paper](https://arxiv.org/abs/2403.18128)] [[code](https://github.com/healthylaife/HealthGAT)]
- [2024] **Impact of Employing Weather Forecast Data as Input to the Estimation of Evapotranspiration by Deep Neural Network Models** [[paper](https://arxiv.org/abs/2403.18489)]
- [2024] **Robustness and Visual Explanation for Black Box Image, Video, and ECG Signal Classification with Reinforcement Learning** [[paper](https://arxiv.org/abs/2403.18985)]
- [2024] **Towards Sustainable SecureML: Quantifying Carbon Footprint of Adversarial Machine Learning** [[paper](https://arxiv.org/abs/2403.19009)]
- [2024] **Equity in Healthcare: Analyzing Disparities in Machine Learning Predictions of Diabetic Patient Readmissions** [[paper](https://arxiv.org/abs/2403.19057)]
- [2024] **Synthetic Medical Imaging Generation with Generative Adversarial Networks For Plain Radiographs** [[paper](https://arxiv.org/abs/2403.19107)]
- [2024] **Detection of subclinical atherosclerosis by image-based deep learning on chest x-ray** [[paper](https://arxiv.org/abs/2403.18756)]
- [2024] **Divide, Conquer, Combine Bayesian Decision Tree Sampling** [[paper](https://arxiv.org/abs/2403.18147)]
- [2024] **Minimax Optimal Fair Classification with Bounded Demographic Disparity** [[paper](https://arxiv.org/abs/2403.18216)]
- [2024] **Quantum Algorithms: A New Frontier in Financial Crime Prevention** [[paper](https://arxiv.org/abs/2403.18322)]
- [2024] **Topological Cycle Graph Attention Network for Brain Functional Connectivity** [[paper](https://arxiv.org/abs/2403.19149)]
- [2024] **VDSC: Enhancing Exploration Timing with Value Discrepancy and State Counts** [[paper](https://arxiv.org/abs/2403.17542)]
- [2024] **Stragglers-Aware Low-Latency Synchronous Federated Learning via Layer-Wise Model Updates** [[paper](https://arxiv.org/abs/2403.18375)]
- [2024] **Zero-Shot Unsupervised and Text-Based Audio Editing Using DDPM Inversion** [[paper](https://arxiv.org/abs/2402.10009)] [[project](https://hilamanor.github.io/AudioEditing/)]
- [2024] **On the Complexity of Finite-Sum Smooth Optimization under the Polyak-Łojasiewicz Condition** [[paper](https://arxiv.org/abs/2402.02569)]
- [2024] **Efficient Online Crowdsourcing with Complex Annotations** [[paper](https://arxiv.org/abs/2401.15116)]
- [2024] **Interpreting Time Series Transformer Models and Sensitivity Analysis of Population Age Groups to COVID-19 Infections** [[paper](https://arxiv.org/abs/2401.15119)]
- [2024] **Large Language Model Guided Knowledge Distillation for Time Series Anomaly Detection** [[paper](https://arxiv.org/abs/2401.15123)]
- [2024] **FDR-Controlled Portfolio Optimization for Sparse Financial Index Tracking** [[paper](https://arxiv.org/abs/2401.15139)]
- [2024] **Transfer Learning for the Prediction of Entity Modifiers in Clinical Text: Application to Opioid Use Disorder Case Detection** [[paper](https://arxiv.org/abs/2401.15222)]
- [2024] **Deep Learning with Tabular Data: A Self-supervised Approach** [[paper](https://arxiv.org/abs/2401.15238)]
- [2024] **Adaptive Point Transformer** [[paper](https://arxiv.org/abs/2401.14845)]
- [2024] **P3LS: Partial Least Squares under Privacy Preservation** [[paper](https://arxiv.org/abs/2401.14884)]
- [2024] **A Korean Legal Judgment Prediction Dataset for Insurance Disputes** [[paper](https://arxiv.org/abs/2401.14654)]
- [2024] **Cyclic Group Projection for Enumerating Quasi-Cyclic Codes Trapping Sets** [[paper](https://arxiv.org/abs/2401.14810)]
- [2024] **Data-Driven Estimation of the False Positive Rate of the Bayes Binary Classifier via Soft Labels** [[paper](https://arxiv.org/abs/2401.15500)]
- [2024] **Intriguing Equivalence Structures of the Embedding Space of Vision Transformers** [[paper](https://arxiv.org/abs/2401.15568)]
- [2024] **Fairness in Algorithmic Recourse Through the Lens of Substantive Equality of Opportunity** [[paper](https://arxiv.org/abs/2401.16088)]

##### 2023

- [2023] **Why "classic" Transformers are shallow and how to make them go deep** [[paper](https://arxiv.org/abs/2312.06182)]
- [2023] **Rapid Open-World Adaptation by Adaptation Principles Learning** [[paper](https://arxiv.org/abs/2312.11138)]
- [2023] **WordScape: a Pipeline to extract multilingual, visually rich Documents with Layout Annotations from Web Crawl Data** [[paper](https://arxiv.org/abs/2312.10188)]
- [2023] **Automatic nonlinear MPC approximation with closed-loop guarantees** [[paper](https://arxiv.org/abs/2312.10199)]
- [2023] **ACCL+: an FPGA-Based Collective Engine for Distributed Applications** [[paper](https://arxiv.org/abs/2312.11742)]
- [2023] **Tokenization Matters: Navigating Data-Scarce Tokenization for Gender Inclusive Language Technologies** [[paper](https://arxiv.org/abs/2312.11779)]
- [2023] **Root Cause Explanation of Outliers under Noisy Mechanisms** *AAAI 2024* [[paper](https://arxiv.org/abs/2312.11818)]
- [2023] **SimCalib: Graph Neural Network Calibration based on Similarity between Nodes** [[paper](https://arxiv.org/abs/2312.11858)]
- [2023] **Hierarchical and Incremental Structural Entropy Minimization for Unsupervised Social Event Detection** [[paper](https://arxiv.org/abs/2312.11891)]
- [2023] **PC-Conv: Unifying Homophily and Heterophily with Two-fold Filtering** [[paper](https://arxiv.org/abs/2312.14438)] [[code](https://github.com/uestclbh/PC-Conv)]
- [2023] **Unsupervised Harmonic Parameter Estimation Using Differentiable DSP and Spectral Optimal Transport** [[paper](https://arxiv.org/abs/2312.14507)]
- [2023] **Poincaré Differential Privacy for Hierarchy-Aware Graph Embedding** [[paper](https://arxiv.org/abs/2312.12183)]
- [2023] **CUDC: A Curiosity-Driven Unsupervised Data Collection Method with Adaptive Temporal Distances for Offline Reinforcement Learning** *AAAI-24* [[paper](https://arxiv.org/abs/2312.12191)]
- [2023] **Secure Information Embedding in Images with Hybrid Firefly Algorithm** [[paper](https://arxiv.org/abs/2312.13519)]
- [2023] **Wave Physics-informed Matrix Factorizations** [[paper](https://arxiv.org/abs/2312.13584)]
- [2023] **Structure-Aware Path Inference for Neural Finite State Transducers** *NeurIPS 2023* [[paper](https://arxiv.org/abs/2312.13614)]
- [2023] **Navigating the Structured What-If Spaces: Counterfactual Generation via Structured Diffusion** [[paper](https://arxiv.org/abs/2312.13616)]
- [2023] **Integration Of Evolutionary Automated Machine Learning With Structural Sensitivity Analysis For Composite Pipelines** [[paper](https://arxiv.org/abs/2312.14770)]
- [2023] **Pangu-Agent: A Fine-Tunable Generalist Agent with Structured Reasoning** [[paper](https://arxiv.org/abs/2312.14878)]
- [2023] **Large Language Models in Medical Term Classification and Unexpected Misalignment Between Response and Reasoning** [[paper](https://arxiv.org/abs/2312.14184)]
- [2023] **A Reinforcement-Learning-Based Multiple-Column Selection Strategy for Column Generation** [[paper](https://arxiv.org/abs/2312.14213)]
- [2023] **Noninvasive Estimation of Mean Pulmonary Artery Pressure Using MRI, Computer Models, and Machine Learning** [[paper](https://arxiv.org/abs/2312.14221)]
- [2023] **WellFactor: Patient Profiling using Integrative Embedding of Healthcare Data** [[paper](https://arxiv.org/abs/2312.14129)]
- [2023] **Stochastic Quantum Sampling for Non-Logconcave Distributions and Estimating Partition Functions** [[paper](https://arxiv.org/abs/2310.11445)]
- [2023] **Tackling Combinatorial Distribution Shift: A Matrix Completion Perspective** [[paper](https://arxiv.org/abs/2307.06457)]
- [2023] **Differentially Private Low-dimensional Synthetic Data from High-dimensional Datasets** [[paper](https://arxiv.org/abs/2305.17148)]
- [2023] **Beyond Exponential Graph: Communication-Efficient Topologies for Decentralized Learning via Finite-time Convergence** [[paper](https://arxiv.org/abs/2305.11420)]
- [2023] **Improved Bound for Mixing Time of Parallel Tempering** [[paper](https://arxiv.org/abs/2304.01303)]
- [2023] **Support Recovery in Sparse PCA with Non-Random Missing Data** [[paper](https://arxiv.org/abs/2302.01535)]
- [2023] **CEDAS: A Compressed Decentralized Stochastic Gradient Method with Improved Convergence** [[paper](https://arxiv.org/abs/2301.05872)]

##### 2022

- [2022] **On the Trade-off between Over-smoothing and Over-squashing in Deep Graph Neural Networks** [[paper](https://arxiv.org/abs/2212.02374)]
- [2022] **The loss of the property of locality of the kernel in high-dimensional Gaussian process regression on the example of the fitting of molecular potential energy surfaces** [[paper](https://arxiv.org/abs/2211.11170)]
- [2022] **FoSR: First-order spectral rewiring for addressing oversquashing in GNNs** [[paper](https://arxiv.org/abs/2210.11790)]
- [2022] **Topology-aware Generalization of Decentralized SGD** [[paper](https://arxiv.org/abs/2206.12680)] [[code](https://github.com/Raiden-Zhu/Generalization-of-DSGD)]
- [2022] **Support Recovery in Sparse PCA with Incomplete Data** [[paper](https://arxiv.org/abs/2205.15215)]
- [2022] **An Improved Analysis of Gradient Tracking for Decentralized Machine Learning** *NeurIPS 2021* [[paper](https://arxiv.org/abs/2202.03836)]

##### 2021

- [2021] **Regularized Modal Regression on Markov-dependent Observations: A Theoretical Assessment** [[paper](https://arxiv.org/abs/2112.04779)]
- [2021] **On a Partition LP Relaxation for Min-Cost 2-Node Connected Spanning Subgraphs** [[paper](https://arxiv.org/abs/2111.07481)]
- [2021] **Minimax Mixing Time of the Metropolis-Adjusted Langevin Algorithm for Log-Concave Sampling** [[paper](https://arxiv.org/abs/2109.13055)]
- [2021] **On the α-lazy version of Markov chains in estimation and testing problems** [[paper](https://arxiv.org/abs/2105.09536)]
- [2021] **Improving the Transient Times for Distributed Stochastic Gradient Methods** [[paper](https://arxiv.org/abs/2105.04851)]
- [2021] **Group Testing with a Graph Infection Spread Model** [[paper](https://arxiv.org/abs/2101.05792)]

##### 2020

- [2020] **Detecting Botnet Attacks in IoT Environments: An Optimized Machine Learning Approach** [[paper](https://arxiv.org/abs/2012.11325)]
- [2020] **Collaborative residual learners for automatic icd10 prediction using prescribed medications** [[paper](https://arxiv.org/abs/2012.11327)]
- [2020] **Ensemble model for pre-discharge icd10 coding prediction** [[paper](https://arxiv.org/abs/2012.11333)]
- [2020] **Single-level Optimization For Differential Architecture Search** [[paper](https://arxiv.org/abs/2012.11337)]
- [2020] **Unifying Homophily and Heterophily Network Transformation via Motifs** [[paper](https://arxiv.org/abs/2012.11400)]
- [2020] **Data Assimilation in the Latent Space of a Neural Network** [[paper](https://arxiv.org/abs/2012.12056)]
- [2020] **Projected Stochastic Gradient Langevin Algorithms for Constrained Sampling and Non-Convex Learning** [[paper](https://arxiv.org/abs/2012.12137)]
- [2020] **Image to Bengali Caption Generation Using Deep CNN and Bidirectional Gated Recurrent Unit** [[paper](https://arxiv.org/abs/2012.12139)]
- [2020] **High-Speed Robot Navigation using Predicted Occupancy Maps** [[paper](https://arxiv.org/abs/2012.12142)]
- [2020] **General Domain Adaptation Through Proportional Progressive Pseudo Labeling** [[paper](https://arxiv.org/abs/2012.13028)]
- [2020] **Wheel-Rail Interface Condition Estimation (W-RICE)** [[paper](https://arxiv.org/abs/2012.13096)]
- [2020] **Upper Confidence Bounds for Combining Stochastic Bandits** [[paper](https://arxiv.org/abs/2012.13115)]
- [2020] **Randomized RX for target detection** [[paper](https://arxiv.org/abs/2012.12308)]
- [2020] **Fairness, Welfare, and Equity in Personalized Pricing** [[paper](https://arxiv.org/abs/2012.11066)]
- [2020] **Hop-Hop Relation-aware Graph Neural Networks** [[paper](https://arxiv.org/abs/2012.11147)]
- [2020] **Personalized fall detection monitoring system based on learning from the user movements** [[paper](https://arxiv.org/abs/2012.11195)]
- [2020] **Learning-based Prediction and Uplink Retransmission for Wireless Virtual Reality (VR) Network** [[paper](https://arxiv.org/abs/2012.12725)]
- [2020] **Diagnosis/Prognosis of COVID-19 Images: Challenges, Opportunities, and Applications** [[paper](https://arxiv.org/abs/2012.14106)]
- [2020] **Affirmative Algorithms: The Legal Grounds for Fairness as Awareness** [[paper](https://arxiv.org/abs/2012.14285)]
- [2020] **Low-Cost Maximum Entropy Covariance Matrix Reconstruction Algorithm for Robust Adaptive Beamforming** [[paper](https://arxiv.org/abs/2012.14338)]
- [2020] **Toward Compact Data from Big Data** [[paper](https://arxiv.org/abs/2012.13677)]
- [2020] **Blackwell Online Learning for Markov Decision Processes** [[paper](https://arxiv.org/abs/2012.14043)]
- [2020] **Communication-efficient Decentralized Local SGD over Undirected Networks** [[paper](https://arxiv.org/abs/2011.03255)]
- [2020] **A Comprehensive Study of Class Incremental Learning Algorithms for Visual Tasks** [[paper](https://arxiv.org/abs/2011.01844)]
- [2020] **Noise-Contrastive Estimation for Multivariate Point Processes** [[paper](https://arxiv.org/abs/2011.00717)]
- [2020] **Hierarchical Bi-Directional Self-Attention Networks for Paper Review Rating Recommendation** [[paper](https://arxiv.org/abs/2011.00802)]
- [2020] **Reinforcement Learning with Efficient Active Feature Acquisition** [[paper](https://arxiv.org/abs/2011.00825)]
- [2020] **Analyzing the Effect of Multi-task Learning for Biomedical Named Entity Recognition** [[paper](https://arxiv.org/abs/2011.00425)]
- [2020] **Synthetic Data Generation for Economists** [[paper](https://arxiv.org/abs/2011.01374)]
- [2020] **Optimal Policies for the Homogeneous Selective Labels Problem** [[paper](https://arxiv.org/abs/2011.01381)]
- [2020] **Meta-learning Transferable Representations with a Single Target Domain** [[paper](https://arxiv.org/abs/2011.01418)]
- [2020] **Frequency-compensated PINNs for Fluid-dynamic Design Problems** [[paper](https://arxiv.org/abs/2011.01456)]
- [2020] **Useful Policy Invariant Shaping from Arbitrary Advice** [[paper](https://arxiv.org/abs/2011.01297)]
- [2020] **Diverse Image Captioning with Context-Object Split Latent Spaces** *NeurIPS 2020* [[paper](https://arxiv.org/abs/2011.00966)]
- [2020] **Uncertainty Quantification of Darcy Flow through Porous Media using Deep Gaussian Process** [[paper](https://arxiv.org/abs/2011.01647)]
- [2020] **Brain Predictability toolbox: a Python library for neuroimaging based machine learning** [[paper](https://arxiv.org/abs/2011.01715)] [[code](https://github.com/sahahn/BPt)]
- [2020] **Recommendations for Bayesian hierarchical model specifications for case-control studies in mental health** *NeurIPS 2020 - Extended Abstract* [[paper](https://arxiv.org/abs/2011.01725)]
- [2020] **Conditional Generative Adversarial Networks to Model Urban Outdoor Air Pollution** [[paper](https://arxiv.org/abs/2010.02244)]
- [2020] **Transformer Transducer: One Model Unifying Streaming and Non-streaming Speech Recognition** [[paper](https://arxiv.org/abs/2010.03192)]
- [2020] **Deep learning models for predictive maintenance: a survey, comparison, challenges and prospect** [[paper](https://arxiv.org/abs/2010.03207)]
- [2020] **Meta Graph Attention on Heterogeneous Graph with Node-Edge Co-evolution** [[paper](https://arxiv.org/abs/2010.04554)]
- [2020] **Using Graph Neural Networks for Mass Spectrometry Prediction** [[paper](https://arxiv.org/abs/2010.04661)]
- [2020] **Evaluating and Characterizing Human Rationales** *EMNLP 2020. Code is available at https* [[paper](https://arxiv.org/abs/2010.04736)]
- [2020] **Characterizing Policy Divergence for Personalized Meta-Reinforcement Learning** [[paper](https://arxiv.org/abs/2010.04816)]
- [2020] **Towards Self-Regulating AI: Challenges and Opportunities of AI Model Governance in Financial Services** [[paper](https://arxiv.org/abs/2010.04827)]
- [2020] **Rao-Blackwellizing the Straight-Through Gumbel-Softmax Gradient Estimator** [[paper](https://arxiv.org/abs/2010.04838)]
- [2020] **Clustering Analysis of Interactive Learning Activities Based on Improved BIRCH Algorithm** [[paper](https://arxiv.org/abs/2010.03821)]
- [2020] **Artificial intelligence supported anemia control system (AISACS) to prevent anemia in maintenance hemodialysis patients** [[paper](https://arxiv.org/abs/2010.03948)]
- [2020] **Neurodevelopmental Age Estimation of Infants Using a 3D-Convolutional Neural Network Model based on Fusion MRI Sequences** [[paper](https://arxiv.org/abs/2010.03963)]
- [2020] **Regularized Inverse Reinforcement Learning** [[paper](https://arxiv.org/abs/2010.03691)]
- [2020] **Learning Intrinsic Symbolic Rewards in Reinforcement Learning** [[paper](https://arxiv.org/abs/2010.03694)]
- [2020] **Tatum-Level Drum Transcription Based on a Convolutional Recurrent Neural Network with Language Model-Based Regularized Training** [[paper](https://arxiv.org/abs/2010.03749)]
- [2020] **Uncertainty in Neural Processes** [[paper](https://arxiv.org/abs/2010.03753)]
- [2020] **Using Bayesian deep learning approaches for uncertainty-aware building energy surrogate models** [[paper](https://arxiv.org/abs/2010.03029)]
- [2020] **VCDM: Leveraging Variational Bi-encoding and Deep Contextualized Word Representations for Improved Definition Modeling** [[paper](https://arxiv.org/abs/2010.03124)]
- [2020] **Computational analysis of pathological image enables interpretable prediction for microsatellite instability** [[paper](https://arxiv.org/abs/2010.03130)]
- [2020] **A Self-supervised Approach for Semantic Indexing in the Context of COVID-19 Pandemic** [[paper](https://arxiv.org/abs/2010.03544)]
- [2020] **Fundamental Limits of Obfuscation for Linear Gaussian Dynamical Systems: An Information-Theoretic Approach** [[paper](https://arxiv.org/abs/2011.00718)]
- [2020] **Learning Open Set Network with Discriminative Reciprocal Points** [[paper](https://arxiv.org/abs/2011.00178)]
- [2020] **Decentralised Learning with Random Features and Distributed Gradient Descent** [[paper](https://arxiv.org/abs/2007.00360)]
- [2020] **Robust Sub-Gaussian Principal Component Analysis and Width-Independent Schatten Packing** [[paper](https://arxiv.org/abs/2006.06980)]
- [2020] **Improving Efficiency in Large-Scale Decentralized Distributed Training** [[paper](https://arxiv.org/abs/2002.01119)]
- [2020] **Fast Multi-Subset Transform and Weighted Sums Over Acyclic Digraphs** [[paper](https://arxiv.org/abs/2002.08475)]

##### 2019

- [2019] **Empirical and Instance-Dependent Estimation of Markov Chain and Mixing Time** [[paper](https://arxiv.org/abs/1912.06845)]
- [2019] **Optimality of Spectral Clustering in the Gaussian Mixture Model** [[paper](https://arxiv.org/abs/1911.00538)]
- [2019] **The Ramanujan Machine: Automatically Generated Conjectures on Fundamental Constants** [[paper](https://arxiv.org/abs/1907.00205)]
- [2019] **A Sharp Estimate on the Transient Time of Distributed Stochastic Gradient Descent** [[paper](https://arxiv.org/abs/1906.02702)]
- [2019] **Self-supervised Body Image Acquisition Using a Deep Neural Network for Sensorimotor Prediction** [[paper](https://arxiv.org/abs/1906.00825)]
- [2019] **Temporal Density Extrapolation using a Dynamic Basis Approach** [[paper](https://arxiv.org/abs/1906.00912)]
- [2019] **A Surprising Density of Illusionable Natural Speech** [[paper](https://arxiv.org/abs/1906.01040)]
- [2019] **Finding a Shortest Non-zero Path in Group-Labeled Graphs** [[paper](https://arxiv.org/abs/1906.04062)]
- [2019] **Optimal Statistical Rates for Decentralised Non-Parametric Regression with Linear Speed-Up** [[paper](https://arxiv.org/abs/1905.03135)]
- [2019] **Optimal Convergence Rate of Hamiltonian Monte Carlo for Strongly Logconcave Distributions** [[paper](https://arxiv.org/abs/1905.02313)]
- [2019] **Automatic Dataset Augmentation Using Virtual Human Simulation** [[paper](https://arxiv.org/abs/1905.00261)]
- [2019] **Collaborative and Privacy-Preserving Machine Teaching via Consensus Optimization** [[paper](https://arxiv.org/abs/1905.02796)]
- [2019] **Feature Selection and Feature Extraction in Pattern Analysis: A Literature Review** [[paper](https://arxiv.org/abs/1905.02845)]
- [2019] **Conditioning LSTM Decoder and Bi-directional Attention Based Question Answering System** [[paper](https://arxiv.org/abs/1905.02019)]
- [2019] **Robust Federated Training via Collaborative Machine Teaching using Trusted Instances** [[paper](https://arxiv.org/abs/1905.02941)]
- [2019] **Deep Landscape Forecasting for Real-time Bidding Advertising** [[paper](https://arxiv.org/abs/1905.03028)]
- [2019] **PiNet: A Permutation Invariant Graph Neural Network for Graph Classification** [[paper](https://arxiv.org/abs/1905.03046)]
- [2019] **MetaPred: Meta-Learning for Clinical Risk Prediction with Limited Patient Electronic Health Records** [[paper](https://arxiv.org/abs/1905.03218)]
- [2019] **Interpretable Subgroup Discovery in Treatment Effect Estimation with Application to Opioid Prescribing Guidelines** [[paper](https://arxiv.org/abs/1905.03297)]
- [2019] **Universal Sound Separation** [[paper](https://arxiv.org/abs/1905.03330)]
- [2019] **Learning Unsupervised Multi-View Stereopsis via Robust Photometric Consistency** [[paper](https://arxiv.org/abs/1905.02706)] [[project](https://tejaskhot.github.io/unsup_mvs)]
- [2019] **Image Matters: Scalable Detection of Offensive and Non-Compliant Content / Logo in Product Images** [[paper](https://arxiv.org/abs/1905.02234)]
- [2019] **Source Generator Attribution via Inversion** [[paper](https://arxiv.org/abs/1905.02259)]
- [2019] **CrossTrainer: Practical Domain Adaptation with Loss Reweighting** [[paper](https://arxiv.org/abs/1905.02304)]
- [2019] **Is a Single Embedding Enough? Learning Node Representations that Capture Multiple Social Contexts** [[paper](https://arxiv.org/abs/1905.02138)]
- [2019] **Back to the Future: Predicting Traffic Shockwave Formation and Propagation Using a Convolutional Encoder-Decoder Network** [[paper](https://arxiv.org/abs/1905.02197)]
- [2019] **Lessons from Contextual Bandit Learning in a Customer Support Bot** [[paper](https://arxiv.org/abs/1905.02219)]
- [2019] **User Traffic Prediction for Proactive Resource Management: Learning-Powered Approaches** [[paper](https://arxiv.org/abs/1906.00951)]
- [2019] **IAN: Combining Generative Adversarial Networks for Imaginative Face Generation** [[paper](https://arxiv.org/abs/1904.07916)]
- [2019] **SynC: A Unified Framework for Generating Synthetic Population with Gaussian Copula** [[paper](https://arxiv.org/abs/1904.07998)]
- [2019] **Neural Message Passing for Multi-Label Classification** [[paper](https://arxiv.org/abs/1904.08049)] [[code](https://github.com/QData/LaMP)]
- [2019] **Sparseout: Controlling Sparsity in Deep Networks** [[paper](https://arxiv.org/abs/1904.08050)] [[code](https://github.com/najeebkhan/sparseout)]
- [2019] **Text2Node: a Cross-Domain System for Mapping Arbitrary Phrases to a Taxonomy** [[paper](https://arxiv.org/abs/1905.01958)]
- [2019] **A Content-Based Approach to Email Triage Action Prediction: Exploration and Evaluation** [[paper](https://arxiv.org/abs/1905.01991)]
- [2019] **Flow-based generative models for Markov chain Monte Carlo in lattice field theory** [[paper](https://arxiv.org/abs/1904.12072)]
- [2019] **Weakly Supervised Open-set Domain Adaptation by Dual-domain Collaboration** [[paper](https://arxiv.org/abs/1904.13179)]
- [2019] **Test Selection for Deep Learning Systems** [[paper](https://arxiv.org/abs/1904.13195)]
- [2019] **Investigation of Initialization Strategies for the Multiple Instance Adaptive Cosine Estimator** [[paper](https://arxiv.org/abs/1904.13197)]
- [2019] **Multimodal Subspace Support Vector Data Description** [[paper](https://arxiv.org/abs/1904.07698)]
- [2019] **Rogue-Gym: A New Challenge for Generalization in Reinforcement Learning** [[paper](https://arxiv.org/abs/1904.08129)]
- [2019] **Predicting drug-target interaction using 3D structure-embedded graph representations from graph neural networks** [[paper](https://arxiv.org/abs/1904.08144)]
- [2019] **Bayesian policy selection using active inference** [[paper](https://arxiv.org/abs/1904.08149)]
- [2019] **Localization, Detection and Tracking of Multiple Moving Sound Sources with a Convolutional Recurrent Neural Network** [[paper](https://arxiv.org/abs/1904.12769)]
- [2019] **Challenges of Real-World Reinforcement Learning** [[paper](https://arxiv.org/abs/1904.12901)]
- [2019] **Neuromorphic Acceleration for Approximate Bayesian Inference on Neural Networks via Permanent Dropout** [[paper](https://arxiv.org/abs/1904.12904)]
- [2019] **Gradient Coding Based on Block Designs for Mitigating Adversarial Stragglers** [[paper](https://arxiv.org/abs/1904.13373)]
- [2019] **Ensemble Distribution Distillation** [[paper](https://arxiv.org/abs/1905.00076)]
- [2019] **Estimating the Mixing Time of Ergodic Markov Chains** [[paper](https://arxiv.org/abs/1902.01224)]

##### 2018

- [2018] **Number of Connected Components in a Graph: Estimation via Counting Patterns** [[paper](https://arxiv.org/abs/1812.00139)]
- [2018] **Geometry and clustering with metrics derived from separable Bregman divergences** [[paper](https://arxiv.org/abs/1810.10770)]
- [2018] **Does Hamiltonian Monte Carlo mix faster than a random walk on multimodal densities?** [[paper](https://arxiv.org/abs/1808.03230)]
- [2018] **A two dimensional arithmetic André-Oort problem** [[paper](https://arxiv.org/abs/1808.07900)]
- [2018] **Computationally Efficient Estimation of the Spectral Gap of a Markov Chain** [[paper](https://arxiv.org/abs/1806.06047)]

##### 2017

- [2017] **Exploring the zeros of real self-reciprocal polynomials by Chebyshev polynomials** [[paper](https://arxiv.org/abs/1709.03037)]

##### 2016

- [2016] **Polynomial-time Tensor Decompositions with Sum-of-Squares** [[paper](https://arxiv.org/abs/1610.01980)]
- [2016] **Data-driven Rank Breaking for Efficient Rank Aggregation** [[paper](https://arxiv.org/abs/1601.05495)]

##### 2015

- [2015] **On the Computational Complexity of High-Dimensional Bayesian Variable Selection** [[paper](https://arxiv.org/abs/1505.07925)]

##### 2014

- [2014] **Distributed Detection : Finite-time Analysis and Impact of Network Topology** [[paper](https://arxiv.org/abs/1409.8606)]

[⬆ Back to top](#paper-list)

#### Full-Graph GNNs

##### 2025

- [2025] **Random Walk Guided Hyperbolic Graph Distillation** [[paper](https://arxiv.org/abs/2501.15696)]

##### 2024

- [2024] **Cross-Space Adaptive Filter: Integrating Graph Topology and Node Attributes for Alleviating the Over-smoothing Problem** [[paper](https://arxiv.org/abs/2401.14876)]

##### 2023

- [2023] **Short-Term Multi-Horizon Line Loss Rate Forecasting of a Distribution Network Using Attention-GCN-LSTM** [[paper](https://arxiv.org/abs/2312.11898)]

##### 2020

- [2020] **High-Order Relation Construction and Mining for Graph Matching** [[paper](https://arxiv.org/abs/2010.04348)]

[⬆ Back to top](#paper-list)

#### ML on Hecke Traces

##### 2026

- [2026] **Zeta: Dual Whitening for Matrix Optimization via Coordinate-Adaptive Preconditioning** [[paper](https://arxiv.org/abs/2606.14187)] [[code](https://github.com/AIGCodeOS/aigcode_zeta_optimizer)]
- [2026] **The Fractal Neural Operator: Overcoming Spectral Bias in Chaotic Attractors via Prime-Harmonic Weierstrass Encodings** [[paper](https://arxiv.org/abs/2606.23123)]
- [2026] **Discovering a Zeta Map Algorithm on Dyck Paths via Mechanistic Interpretability** [[paper](https://arxiv.org/abs/2605.30482)]
- [2026] **Resilience Characterization of AI-Native Wireless Receivers via Persistent Homology** [[paper](https://arxiv.org/abs/2605.22886)]
- [2026] **Spectral Edge Dynamics: An Analytical-Empirical Study of Phase Transitions in Neural Network Training** [[paper](https://arxiv.org/abs/2603.28964)]
- [2026] **Depth, Not Data: An Analysis of Hessian Spectral Bifurcation** [[paper](https://arxiv.org/abs/2602.00545)]

##### 2025

- [2025] **From Black Box to Bijection: Interpreting Machine Learning to Build a Zeta Map Algorithm** [[paper](https://arxiv.org/abs/2511.12421)]
- [2025] **Machines Learn Number Fields, But How? The Case of Galois Groups** [[paper](https://arxiv.org/abs/2508.06670)]
- [2025] **Amorphous Solid Model of Vectorial Hopfield Neural Networks** [[paper](https://arxiv.org/abs/2507.22787)]
- [2025] **A ZeNN architecture to avoid the Gaussian trap** [[paper](https://arxiv.org/abs/2505.20553)]
- [2025] **Scalable Decentralized Learning with Teleportation** [[paper](https://arxiv.org/abs/2501.15259)]

##### 2024

- [2024] **Riemann Sum Optimization for Accurate Integrated Gradients Computation** *NeurIPS 2024* [[paper](https://arxiv.org/abs/2410.04118)]
- [2024] **GoRINNs: Godunov-Riemann Informed Neural Networks for Learning Hyperbolic Conservation Laws** [[paper](https://arxiv.org/abs/2410.22193)]
- [2024] **Minimax optimality of deep neural networks on dependent data via PAC-Bayes bounds** [[paper](https://arxiv.org/abs/2410.21702)]
- [2024] **Robust estimation of the intrinsic dimension of data sets with quantum cognition machine learning** [[paper](https://arxiv.org/abs/2409.12805)]
- [2024] **Graph Expansion in Pruned Recurrent Neural Network Layers Preserve Performance** *ICLR 2024* [[paper](https://arxiv.org/abs/2403.11100)]
- [2024] **A spatiotemporal style transfer algorithm for dynamic visual stimulus generation** [[paper](https://arxiv.org/abs/2403.04940)]
- [2024] **Modeling Collaborator: Enabling Subjective Vision Classification With Minimal Human Effort via LLM Tool-Use** [[paper](https://arxiv.org/abs/2403.02626)]
- [2024] **SGD with Partial Hessian for Deep Neural Networks Optimization** [[paper](https://arxiv.org/abs/2403.02681)] [[code](https://github.com/myingysun/SGDPH)]
- [2024] **Making Pre-trained Language Models Great on Tabular Prediction** [[paper](https://arxiv.org/abs/2403.01841)]
- [2024] **A Survey on Evaluation of Out-of-Distribution Generalization** [[paper](https://arxiv.org/abs/2403.01874)]
- [2024] **Verified Training for Counterfactual Explanation Robustness under Data Shift** *ICLR 2024* [[paper](https://arxiv.org/abs/2403.03773)]
- [2024] **Effect of Ambient-Intrinsic Dimension Gap on Adversarial Vulnerability** [[paper](https://arxiv.org/abs/2403.03967)]
- [2024] **Asymptotic Bayes risk of semi-supervised learning with uncertain labeling** [[paper](https://arxiv.org/abs/2403.17767)]
- [2024] **Image-based Novel Fault Detection with Deep Learning Classifiers using Hierarchical Labels** [[paper](https://arxiv.org/abs/2403.17891)]
- [2024] **Interpretable cancer cell detection with phonon microscopy using multi-task conditional neural networks for inter-batch calibration** [[paper](https://arxiv.org/abs/2403.17992)]
- [2024] **Towards Explainable Clustering: A Constrained Declarative based Approach** [[paper](https://arxiv.org/abs/2403.18101)]
- [2024] **On Spectrogram Analysis in a Multiple Classifier Fusion Framework for Power Grid Classification Using Electric Network Frequency** [[paper](https://arxiv.org/abs/2403.18402)]
- [2024] **Causal-StoNet: Causal Inference for High-Dimensional Complex Data** [[paper](https://arxiv.org/abs/2403.18994)]
- [2024] **InceptionTime vs. Wavelet -- A comparison for time series classification** [[paper](https://arxiv.org/abs/2403.18687)]
- [2024] **Mistake, Manipulation and Margin Guarantees in Online Strategic Classification** [[paper](https://arxiv.org/abs/2403.18176)]
- [2024] **Fourier or Wavelet bases as counterpart self-attention in spikformer for efficient visual classification** [[paper](https://arxiv.org/abs/2403.18228)]
- [2024] **Selective Mixup Fine-Tuning for Optimizing Non-Decomposable Objectives** [[paper](https://arxiv.org/abs/2403.18301)]
- [2024] **Riemann-Lebesgue Forest for Regression** [[paper](https://arxiv.org/abs/2402.04550)]
- [2024] **RiemannONets: Interpretable Neural Operators for Riemann Problems** [[paper](https://arxiv.org/abs/2401.08886)] [[code](https://github.com/apey236/RiemannONet)]
- [2024] **PruneSymNet: A Symbolic Neural Network and Pruning Algorithm for Symbolic Regression** [[paper](https://arxiv.org/abs/2401.15103)]
- [2024] **Better Representations via Adversarial Training in Pre-Training: A Theoretical Perspective** [[paper](https://arxiv.org/abs/2401.15248)]
- [2024] **Enhancement of a Text-Independent Speaker Verification System by using Feature Combination and Parallel-Structure Classifiers** [[paper](https://arxiv.org/abs/2401.15018)]
- [2024] **GT-PCA: Effective and Interpretable Dimensionality Reduction with General Transform-Invariant Principal Component Analysis** [[paper](https://arxiv.org/abs/2401.15623)]
- [2024] **BooleanOCT: Optimal Classification Trees based on multivariate Boolean Rules** [[paper](https://arxiv.org/abs/2401.16133)]
- [2024] **Constrained Bi-Level Optimization: Proximal Lagrangian Value function Approach and Hessian-free Algorithm** [[paper](https://arxiv.org/abs/2401.16164)]

##### 2023

- [2023] **Hutchinson Trace Estimation for High-Dimensional and High-Order Physics-Informed Neural Networks** [[paper](https://arxiv.org/abs/2312.14499)]
- [2023] **Deep Neural Networks and Finite Elements of Any Order on Arbitrary Dimensions** [[paper](https://arxiv.org/abs/2312.14276)]
- [2023] **Learning Arithmetic Formulas in the Presence of Noise: A General Framework and Applications to Unsupervised Learning** [[paper](https://arxiv.org/abs/2311.07284)]
- [2023] **Enhancing Motor Imagery Decoding in Brain Computer Interfaces using Riemann Tangent Space Mapping and Cross Frequency Coupling** [[paper](https://arxiv.org/abs/2310.19198)]
- [2023] **Sampling the lattice Nambu-Goto string using Continuous Normalizing Flows** [[paper](https://arxiv.org/abs/2307.01107)]
- [2023] **Spectral gap-based deterministic tensor completion** [[paper](https://arxiv.org/abs/2306.06262)]
- [2023] **Conservative Physics-Informed Neural Networks for Non-Conservative Hyperbolic Conservation Laws Near Critical States** [[paper](https://arxiv.org/abs/2305.12817)]
- [2023] **Product Jacobi-Theta Boltzmann machines with score matching** [[paper](https://arxiv.org/abs/2303.05910)]
- [2023] **Beyond spectral gap (extended): The role of the topology in decentralized learning** [[paper](https://arxiv.org/abs/2301.02151)] [[code](https://github.com/epfml/topology-in-decentralized-learning)]

##### 2022

- [2022] **Beyond spectral gap: The role of the topology in decentralized learning** [[paper](https://arxiv.org/abs/2206.03093)]
- [2022] **Baseline Computation for Attribution Methods Based on Interpolated Inputs** [[paper](https://arxiv.org/abs/2204.06120)]
- [2022] **Real order total variation with applications to the loss functions in learning schemes** [[paper](https://arxiv.org/abs/2204.04582)]
- [2022] **Neural Q-learning for solving PDEs** [[paper](https://arxiv.org/abs/2203.17128)]

##### 2021

- [2021] **Generalization Error Bounds on Deep Learning with Markov Datasets** [[paper](https://arxiv.org/abs/2201.11059)]
- [2021] **AI without networks** [[paper](https://arxiv.org/abs/2106.03354)]
- [2021] **A novel policy for pre-trained Deep Reinforcement Learning for Speech Emotion Recognition** [[paper](https://arxiv.org/abs/2101.00738)]

##### 2020

- [2020] **Design Rule Checking with a CNN Based Feature Extractor** [[paper](https://arxiv.org/abs/2012.11510)]
- [2020] **Unsupervised in-distribution anomaly detection of new physics through conditional density estimation** [[paper](https://arxiv.org/abs/2012.11638)]
- [2020] **Robustness to Spurious Correlations in Text Classification via Automatically Generated Counterfactuals** [[paper](https://arxiv.org/abs/2012.10040)]
- [2020] **Transfer Learning Based Automatic Model Creation Tool For Resource Constraint Devices** [[paper](https://arxiv.org/abs/2012.10056)]
- [2020] **Prediction of Chronic Kidney Disease Using Deep Neural Network** [[paper](https://arxiv.org/abs/2012.12089)]
- [2020] **Machine Learning Algorithm for NLOS Millimeter Wave in 5G V2X Communication** [[paper](https://arxiv.org/abs/2012.12123)]
- [2020] **Neural Joint Entropy Estimation** [[paper](https://arxiv.org/abs/2012.11197)]
- [2020] **Compliance Generation for Privacy Documents under GDPR: A Roadmap for Implementing Automation and Machine Learning** [[paper](https://arxiv.org/abs/2012.12718)]
- [2020] **Adaptive Precision Training for Resource Constrained Devices** [[paper](https://arxiv.org/abs/2012.12775)]
- [2020] **One-Shot Object Localization Using Learnt Visual Cues via Siamese Networks** [[paper](https://arxiv.org/abs/2012.13690)]
- [2020] **Deep Learning with Heterogeneous Graph Embeddings for Mortality Prediction from Electronic Health Records** [[paper](https://arxiv.org/abs/2012.14065)]
- [2020] **DeL-haTE: A Deep Learning Tunable Ensemble for Hate Speech Detection** *ICMLA20 Special Session* [[paper](https://arxiv.org/abs/2011.01861)]
- [2020] **Multitask Learning and Joint Optimization for Transformer-RNN-Transducer Speech Recognition** [[paper](https://arxiv.org/abs/2011.00771)]
- [2020] **An End-to-End ML System for Personalized Conversational Voice Models in Walmart E-Commerce** [[paper](https://arxiv.org/abs/2011.00866)]
- [2020] **Unsupervised Intrusion Detection System for Unmanned Aerial Vehicle with Less Labeling Effort** [[paper](https://arxiv.org/abs/2011.00540)]
- [2020] **Triage of Potential COVID-19 Patients from Chest X-ray Images using Hierarchical Convolutional Networks** [[paper](https://arxiv.org/abs/2011.00618)]
- [2020] **Impact of Community Structure on Consensus Machine Learning** [[paper](https://arxiv.org/abs/2011.01334)]
- [2020] **Reducing Neural Network Parameter Initialization Into an SMT Problem** [[paper](https://arxiv.org/abs/2011.01191)]
- [2020] **Instance based Generalization in Reinforcement Learning** [[paper](https://arxiv.org/abs/2011.01089)]
- [2020] **Model-Free Control of Dynamical Systems with Deep Reservoir Computing** [[paper](https://arxiv.org/abs/2010.02285)]
- [2020] **Understanding Classifier Mistakes with Generative Models** [[paper](https://arxiv.org/abs/2010.02364)]
- [2020] **Sickle-cell disease diagnosis support selecting the most appropriate machinelearning method: Towards a general and interpretable approach for cellmorphology analysis from microscopy images** [[paper](https://arxiv.org/abs/2010.04511)]
- [2020] **Upper Esophageal Sphincter Opening Segmentation with Convolutional Recurrent Neural Networks in High Resolution Cervical Auscultation** [[paper](https://arxiv.org/abs/2010.04541)]
- [2020] **Fast Fourier Transformation for Optimizing Convolutional Neural Networks in Object Recognition** [[paper](https://arxiv.org/abs/2010.04257)]
- [2020] **Neural Networks as Functional Classifiers** [[paper](https://arxiv.org/abs/2010.04305)]
- [2020] **Addressing the Real-world Class Imbalance Problem in Dermatology** *NeurIPS 2020* [[paper](https://arxiv.org/abs/2010.04308)]
- [2020] **Few-shot Learning for Spatial Regression** [[paper](https://arxiv.org/abs/2010.04360)]
- [2020] **Paying down metadata debt: learning the representation of concepts using topic models** [[paper](https://arxiv.org/abs/2010.04836)]
- [2020] **A Survey on Deep Neural Network Compression: Challenges, Overview, and Solutions** [[paper](https://arxiv.org/abs/2010.03954)]
- [2020] **A Brief Review of Domain Adaptation** [[paper](https://arxiv.org/abs/2010.03978)]
- [2020] **Sequential Changepoint Detection in Neural Networks with Checkpoints** [[paper](https://arxiv.org/abs/2010.03053)]
- [2020] **Gradient-based Causal Structure Learning with Normalizing Flow** [[paper](https://arxiv.org/abs/2010.03095)]
- [2020] **Conditional Generative Modeling via Learning the Latent Space** [[paper](https://arxiv.org/abs/2010.03132)]
- [2020] **DL-Reg: A Deep Learning Regularization Technique using Linear Regression** [[paper](https://arxiv.org/abs/2011.00368)]

##### 2019

- [2019] **Learning Representations by Maximizing Mutual Information Across Views** [[paper](https://arxiv.org/abs/1906.00910)] [[code](https://github.com/Philip-Bachman/amdim-public)]
- [2019] **NodeDrop: A Condition for Reducing Network Size without Effect on Output** [[paper](https://arxiv.org/abs/1906.01026)]
- [2019] **Adversarial Image Translation: Unrestricted Adversarial Examples in Face Recognition Systems** *AAAI Workshop on Artificial Intelligence Safety* [[paper](https://arxiv.org/abs/1905.03421)]
- [2019] **Training a Fast Object Detector for LiDAR Range Images Using Labeled Data from Sensors with Higher Resolution** [[paper](https://arxiv.org/abs/1905.03066)]
- [2019] **Regression Equilibrium** [[paper](https://arxiv.org/abs/1905.02576)]
- [2019] **Nonlinear Approximation and (Deep) ReLU Networks** [[paper](https://arxiv.org/abs/1905.02199)]
- [2019] **An ADMM Based Framework for AutoML Pipeline Configuration** [[paper](https://arxiv.org/abs/1905.00424)]
- [2019] **DNN Architecture for High Performance Prediction on Natural Videos Loses Submodule's Ability to Learn Discrete-World Dataset** [[paper](https://arxiv.org/abs/1904.07969)]
- [2019] **People infer recursive visual concepts from just a few examples** [[paper](https://arxiv.org/abs/1904.08034)]
- [2019] **Posterior-regularized REINFORCE for Instance Selection in Distant Supervision** [[paper](https://arxiv.org/abs/1904.08051)]
- [2019] **Who wrote this book? A challenge for e-commerce** [[paper](https://arxiv.org/abs/1905.01973)]
- [2019] **A Persona-based Multi-turn Conversation Model in an Adversarial Learning Framework** [[paper](https://arxiv.org/abs/1905.01998)]
- [2019] **Semantic Referee: A Neural-Symbolic Framework for Enhancing Geospatial Semantic Segmentation** [[paper](https://arxiv.org/abs/1904.13196)]
- [2019] **Medical device surveillance with electronic health records** [[paper](https://arxiv.org/abs/1904.07640)]
- [2019] **Advanced Customer Activity Prediction based on Deep Hierarchic Encoder-Decoders** [[paper](https://arxiv.org/abs/1904.07687)]
- [2019] **BS-Nets: An End-to-End Framework For Band Selection of Hyperspectral Image** [[paper](https://arxiv.org/abs/1904.08269)]
- [2019] **Unsupervised Data Augmentation for Consistency Training** [[paper](https://arxiv.org/abs/1904.12848)] [[code](https://github.com/google-research/uda)]
- [2019] **On Stationary-Point Hitting Time and Ergodicity of Stochastic Gradient Langevin Dynamics** [[paper](https://arxiv.org/abs/1904.13016)]
- [2019] **Soft edit distance for differentiable comparison of symbolic sequences** [[paper](https://arxiv.org/abs/1904.12562)]

##### 2018

- [2018] **Deep Learning Super-Diffusion in Multiplex Networks** [[paper](https://arxiv.org/abs/1811.04104)]
- [2018] **Gradient Descent for One-Hidden-Layer Neural Networks: Polynomial Convergence and SQ Lower Bounds** [[paper](https://arxiv.org/abs/1805.02677)]
- [2018] **Optimal Algorithms for Continuous Non-monotone Submodular and DR-Submodular Maximization** [[paper](https://arxiv.org/abs/1805.09480)]

##### 2017

- [2017] **Riemann-Theta Boltzmann Machine** [[paper](https://arxiv.org/abs/1712.07581)]
- [2017] **On the Consistency of Graph-based Bayesian Learning and the Scalability of Sampling Algorithms** [[paper](https://arxiv.org/abs/1710.07702)]

[⬆ Back to top](#paper-list)

#### L-Function Zero Classification

##### 2026

- [2026] **Stochastic global optimization of continuous functions via random walks on Grassmannians** [[paper](https://arxiv.org/abs/2605.14151)]
- [2026] **Modified Halley's method for computation of zeros of solution of second order ODEs** [[paper](https://arxiv.org/abs/2603.17448)]

##### 2025

- [2025] **Square Root Algorithm (PART-3): Cumulative Quantum Gravity & Deep Number Theory (QUANTUM AL-GORITHMS)** [[paper](https://doi.org/10.38124/ijisrt/25may1171)]

##### 2024

- [2024] **AE SemRL: Learning Semantic Association Rules with Autoencoders** [[paper](https://arxiv.org/abs/2403.18133)]

##### 2023

- [2023] **Auto311: A Confidence-guided Automated System for Non-emergency Calls** [[paper](https://arxiv.org/abs/2312.14185)]

##### 2020

- [2020] **I like fish, especially dolphins: Addressing Contradictions in Dialogue Modeling** [[paper](https://arxiv.org/abs/2012.13391)]
- [2020] **Neural document expansion for ad-hoc information retrieval** [[paper](https://arxiv.org/abs/2012.14005)]

##### 2019

- [2019] **Incorporating Symbolic Sequential Modeling for Speech Enhancement** [[paper](https://arxiv.org/abs/1904.13142)]

##### 2013

- [2013] **On a probabilistic interpretation of shape derivatives of Dirichlet groundstates with application to Fermion nodes** [[paper](https://arxiv.org/abs/1301.6488)]

[⬆ Back to top](#paper-list)

### RH Equivalences & Bridges

#### Nyman-Beurling Criterion

##### 2026

- [2026] **The Second Edge Theorem: The Asymptotic Collapse of Sample-Dependent Information Geometry to the Canonical Flat Canvas of Conventional Statistics in Large Sample Limits** [[paper](https://arxiv.org/abs/2608.19251)]
- [2026] **From the Half-Order Recurrence to General Fractional-Order Differentiation on Monomials: Functional Continuation and Operator Composition** [[paper](https://arxiv.org/abs/2608.19268)]
- [2026] **Euler's \ell-totients and Riemann hypothesis** [[paper](https://arxiv.org/abs/2607.26114)]
- [2026] **Compact Coefficient Formulae for Logarithmic Tangent and Hyperbolic Integrals** [[paper](https://arxiv.org/abs/2607.12306)]
- [2026] **An Algebraic-Operator Construction of the Half-Derivative on a Graded Monomial Space. Part I: Recurrence, Double Factorials, the Wallis Product, and Normalization** [[paper](https://arxiv.org/abs/2607.19482)]
- [2026] **A computational algorithm for the Hardy function Z(t), utilising sub-sequences of generalised cubic Gauss sums, with an overall operational complexity of O\bigl((t/\varepsilon_t)^{[.25,.3]}(\log t)^{2+o(1)}\bigr), for t \in [10^{23},10^{35}]** [[paper](https://arxiv.org/abs/2607.15310)]
- [2026] **How Random Is the Möbius Function? Smoothing, Probability, and the Riemann Hypothesis** [[paper](https://arxiv.org/abs/2607.25002)]
- [2026] **Novel series involving families of zeta functions and special functions and polynomials by applying Norlund sum and derivative formula** [[paper](https://arxiv.org/abs/2606.14793)]
- [2026] **Certified Arbitrary-Precision Evaluation of a Family of Generalized Multiple Zeta Functions** [[paper](https://arxiv.org/abs/2606.20091)]
- [2026] **Estimating the tail of the singular product for the Hardy Littlewood and Bateman Horn conjectures** [[paper](https://arxiv.org/abs/2606.28832)]
- [2026] **Nineteen to the Dozen: Embedding the Neo-Riemannian Tonnetz into a Cyclic 19_3 Symmetric Configuration** [[paper](https://arxiv.org/abs/2606.11246)]
- [2026] **A parametric family of primes p=km(m+1)+\varepsilon +2kq: heuristic laws, conditional theorems, and unconditional primality certificates** [[paper](https://arxiv.org/abs/2606.16189)]
- [2026] **Pseudosymmetry, Ricci soliton and Curvature Inheritance symmetries of Friedmann Lemaître Robertson Walker spacetime** [[paper](https://arxiv.org/abs/2606.05207)]
- [2026] **Pathological Large Deviations of the KMP Process in Dimension d\ge 2** [[paper](https://arxiv.org/abs/2605.26652)]
- [2026] **A Nonlinear Deficiency Identity for the Riemann Zeta Function with Optimal Approximation Rates** [[paper](https://arxiv.org/abs/2604.16530)]
- [2026] **Introduction to generalised Cesaro convergence I** [[paper](https://arxiv.org/abs/2604.18659)]
- [2026] **On Fubini type theorems for the Riemann integral** [[paper](https://arxiv.org/abs/2604.18618)]
- [2026] **Distributional Statistical Models: Weak Moments, Cumulants, and a Central Limit Theorem** [[paper](https://arxiv.org/abs/2604.20634)]
- [2026] **Analysis of the Riemann Zeta Function via Recursive Taylor Expansions** [[paper](https://arxiv.org/abs/2603.05122)]
- [2026] **Informational Cardinality: A Unifying Framework for Set Theory, Fractal Geometry, and Analytic Number Theory** [[paper](https://arxiv.org/abs/2603.08587)]
- [2026] **On the Critical Line Re(s) = 1/2, the Irrationality Measure of π, and the Automorphic Structure of the Flint Hills Series** [[paper](https://arxiv.org/abs/2603.09719)]
- [2026] **Arctanh Sums: Analytic Continuation and Prime-Restricted Theory** [[paper](https://arxiv.org/abs/2603.06682)]
- [2026] **The Lee--Yang Edge Exponent via Logarithmic Averaging** [[paper](https://arxiv.org/abs/2603.29195)]
- [2026] **Closed-Form Evaluation of Arctanh Power Sums via Infinite Products** [[paper](https://arxiv.org/abs/2602.06244)]
- [2026] **A Formal Group Perspective on the Riemann Zeta Function** [[paper](https://arxiv.org/abs/2602.20211)]
- [2026] **The Riemann Ξ-function from primitive Markovian cycles II: Strip rigidity and divisor identification** [[paper](https://arxiv.org/abs/2602.06080)]
- [2026] **Explicit Evaluations of Euler Sums Involving Harmonic Numbers with Rational Arguments** [[paper](https://arxiv.org/abs/2601.06895)]
- [2026] **Zero-free regions and concentration inequalities for hypergraph colorings in the local lemma regime** [[paper](https://arxiv.org/abs/2601.13796)]

##### 2025

- [2025] **Numerical Behavior of the Riemann Zeta Function Using Real-to-Complex Conversion Without Gram Points or Bracketing** [[paper](https://arxiv.org/abs/2512.09960)]
- [2025] **Suborbital graphs obtained by the modular congruence subgroup Γ_0(L,M)** [[paper](https://arxiv.org/abs/2512.06546)]
- [2025] **Constructive Approximation under Carleman's Condition, with Applications to Smoothed Analysis** [[paper](https://arxiv.org/abs/2512.04371)]
- [2025] **From Bernoulli Numbers to Selector Kernels: Fredholm Determinants, ζ-Regularization, and the Bridge Between Discrete and Continuous Spectra** [[paper](https://arxiv.org/abs/2511.07495)]
- [2025] **Convex Holder bound and its applications** [[paper](https://arxiv.org/abs/2511.21765)]
- [2025] **Bayes Meets Riemann Again: Large Prime Discovery and Re-emergence of the Bone of Contention** [[paper](https://arxiv.org/abs/2510.09651)]
- [2025] **Trigonometric Selector Kernels, Duality, and Odd Zeta Values** [[paper](https://arxiv.org/abs/2509.10801)]
- [2025] **Dual Bases for Analytic Bernoulli Functions** [[paper](https://arxiv.org/abs/2510.00025)]
- [2025] **The Fejér-Dirichlet Lift: Entire Functions and ζ-Factorization Identities** [[paper](https://arxiv.org/abs/2509.12297)]
- [2025] **Relaxation to equilibrium of conservative dynamics II: non-gradient exclusion processes** [[paper](https://arxiv.org/abs/2509.20797)]
- [2025] **Zero-Freeness is All You Need: A Weitz-Type FPTAS for the Entire Lee-Yang Zero-Free Region** [[paper](https://arxiv.org/abs/2509.06623)]
- [2025] **On the Explicit Expression of an Extended Version of Riemann Zeta Function** [[paper](https://arxiv.org/abs/2507.22961)]
- [2025] **Recurrence Relations for β(2k) and ζ(2k + 1)** [[paper](https://arxiv.org/abs/2508.11643)]
- [2025] **Spencer-Riemann-Roch Theory: Mirror Symmetry of Hodge Decompositions and Characteristic Classes in Constrained Geometry** [[paper](https://arxiv.org/abs/2506.05915)]
- [2025] **Mirror Duality in a Spencer-Type Complex: Analytic and Riemann-Roch Perspectives** [[paper](https://arxiv.org/abs/2506.06610)]
- [2025] **Beweis der Riemannschen Vermutung über ein reguliertes normiertes Integralmodell** [[paper](https://arxiv.org/abs/2505.23238)]
- [2025] **Scaling limit of a weakly asymmetric simple exclusion process in the framework of regularity structures** [[paper](https://arxiv.org/abs/2505.00621)]
- [2025] **Holder continuity of an alternating Erdos series on prime K-tuples** [[paper](https://arxiv.org/abs/2505.06242)]
- [2025] **Double and single integrals of the Mittag-Leffler Function: Derivation and Evaluation** [[paper](https://arxiv.org/abs/2504.21009)]
- [2025] **New high-dimensional generalizations of Nesbitt's inequality and relative applications** [[paper](https://arxiv.org/abs/2504.00005)]
- [2025] **Davenport-Heilbronn Function Ratio Properties and Non-Trivial Zeros Study** [[paper](https://arxiv.org/abs/2503.24275)]
- [2025] **Advancements in Fractional Neural Operators with Adaptive Hybrid Kernels in Multiscale Sobolev Spaces** [[paper](https://arxiv.org/abs/2503.11680)]
- [2025] **Singularity of compound stationary measures** [[paper](https://arxiv.org/abs/2503.09770)]
- [2025] **Diophantine FLINT-HILLS series** [[paper](https://arxiv.org/abs/2502.03474)]
- [2025] **On the Emergence of the Quanta Prime Sequence** [[paper](https://arxiv.org/abs/2502.06796)]
- [2025] **Riemann-Liouville type fractional a new generalization of Bernstein-Kantorovich operators** [[paper](https://arxiv.org/abs/2501.10412)]

##### 2024

- [2024] **Enumerative Geometry and Tree-Level Gromov--Witten Invariants** [[paper](https://arxiv.org/abs/2501.03232)]
- [2024] **A note on the Hurwitz-Lerch zeta function** [[paper](https://arxiv.org/abs/2411.04161)]
- [2024] **Investigation about a statement equivalent to Riemann Hypothesis (RH) applied to Dirichlet primitive L functions** [[paper](https://arxiv.org/abs/2412.00169)]
- [2024] **Phase Transitions via Complex Extensions of Markov Chains** [[paper](https://arxiv.org/abs/2411.06857)]
- [2024] **On proving an Inequality of Ramanujan using Explicit Order Estimates for the Mertens Function** [[paper](https://arxiv.org/abs/2407.12052)]
- [2024] **Inequalities involving Higher Degree Polynomial Functions in π(x)** [[paper](https://arxiv.org/abs/2407.18983)]
- [2024] **A note on the Irrationality of ζ(5) and Higher Odd Zeta Values** [[paper](https://arxiv.org/abs/2407.07121)]
- [2024] **Some Classes of series involving the Riemann zeta function, Fibonacci numbers and the Lucas numbers** [[paper](https://arxiv.org/abs/2406.16922)]
- [2024] **On Edwards' Speculation and a New Variational Method for the Zeros of the Z-Function** [[paper](https://arxiv.org/abs/2405.12657)]
- [2024] **Unifying trigonometric and hyperbolic function derivatives via negative integer order polylogarithms** [[paper](https://arxiv.org/abs/2405.19371)]
- [2024] **Series involving rational, factorial and power functions** [[paper](https://arxiv.org/abs/2405.05810)]
- [2024] **On the approximation of the Hardy Z-function via high-order sections** [[paper](https://arxiv.org/abs/2405.12557)]
- [2024] **Disproof of the Riemann Hypothesis** [[paper](https://arxiv.org/abs/2404.06306)]
- [2024] **From BCZ map to a discretized analog of the RH** [[paper](https://arxiv.org/abs/2407.03099)]
- [2024] **Attempting to Prove the Riemann Hypothesis through the Reflection Formula** [[paper](https://arxiv.org/abs/2403.05347)]
- [2024] **Chaotic Dynamics Derived from the Montgomery Conjecture: Application to Electrical Systems** [[paper](https://arxiv.org/abs/2406.12863)]
- [2024] **La relation entre ζ(4n-1), ζ(2p) et ζ(4n-1-2p)** [[paper](https://arxiv.org/abs/2403.17997)]
- [2024] **Introduction to the monodromy conjecture** [[paper](https://arxiv.org/abs/2403.03343)]
- [2024] **Strong Spatial Mixing for General 2-Spin Systems: A Unified Approach from Zero-Freeness** [[paper](https://arxiv.org/abs/2401.09317)]

##### 2023

- [2023] **Inverse application of the generalized Littlewood theorem concerning integrals of the logarithm of analytic functions: an easy method to establish equalities between different analytic functions** [[paper](https://arxiv.org/abs/2403.09657)]
- [2023] **Lie symmetry analysis for fractional evolution equation with ψ-Riemann-Liouville derivative** [[paper](https://arxiv.org/abs/2401.08601)]
- [2023] **Closed form for \sum_{k=1}^n k^p through the Hermite integral representation of the Hurwitz zeta function** [[paper](https://arxiv.org/abs/2310.14362)]
- [2023] **Intervals and Outer Measure on \mathbb{R}** [[paper](https://arxiv.org/abs/2312.12440)]
- [2023] **On the Order Estimates for Specific Functions of ζ(s) and its Contribution towards the Analytic Proof of The Prime Number Theorem** [[paper](https://arxiv.org/abs/2308.16303)]
- [2023] **On the Riemann integrability of the norm of a path in normed spaces** [[paper](https://arxiv.org/abs/2312.00248)]
- [2023] **On the equidistribution properties of patterns in prime numbers Jumping Champions, metaanalysis of properties as Low-Discrepancy Sequences, and some conjectures based on Ramanujan's master theorem and the zeros of Riemann's zeta function** [[paper](https://arxiv.org/abs/2306.00161)]
- [2023] **The conservative matrix field** [[paper](https://arxiv.org/abs/2303.09318)]
- [2023] **Stringent bounds for the non-zero Bernoulli numbers** [[paper](https://arxiv.org/abs/2303.14532)]
- [2023] **Inequality and Nyman-Beurling-Baez-Duarte criteria** [[paper](https://arxiv.org/abs/2310.03972)]

##### 2022

- [2022] **Analyzing Riemann's hypothesis** [[paper](https://arxiv.org/abs/2212.12337)]
- [2022] **Chaos Analysis in the Hybrid Quintic Duffing-Riemann Zeta System via Decomposition** [[paper](https://arxiv.org/abs/2212.12438)]
- [2022] **Loewner Theory for Bernstein functions II: applications to inhomogeneous continuous-state branching processes** [[paper](https://arxiv.org/abs/2211.12442)]
- [2022] **Polynomial Moments with a weighted Zeta Square measure on the critical line** [[paper](https://arxiv.org/abs/2209.10990)]
- [2022] **A Simple Proof of the Riemann Hypothesis** [[paper](https://arxiv.org/abs/2209.01890)]
- [2022] **Towards a proof of the Riemann Hypothesis** [[paper](https://arxiv.org/abs/2204.07643)]
- [2022] **Sum of the Hurwitz-Lerch Zeta Function over Prime Numbers: Derivation and Evaluation** [[paper](https://arxiv.org/abs/2204.03821)]
- [2022] **On the use of the generalized Littlewood theorem concerning integrals of the logarithm of analytical functions for calculations of infinite sums and analysis of zeroes of analytical functions** [[paper](https://arxiv.org/abs/2204.12925)]
- [2022] **Lee--Yang zeroes of the Curie--Weiss ferromagnet, unitary Hermite polynomials, and the backward heat flow** [[paper](https://arxiv.org/abs/2203.05533)]
- [2022] **Proof of the Riemann Hypothesis** [[paper](https://arxiv.org/abs/2201.06601)]
- [2022] **A Dynamical Systems Framework for Generating the Riemann Zeta Function and Dirichlet L-functions** [[paper](https://arxiv.org/abs/2202.01064)]
- [2022] **A Sextuple Integral Containing the Product of Associated Legendre polynomials P_v^u(x) P_{ν}^{μ}(y): Derivation and Evaluation** [[paper](https://arxiv.org/abs/2201.02617)]

##### 2021

- [2021] **Riemann's Last Theorem** [[paper](https://arxiv.org/abs/2201.00615)]
- [2021] **Bounded Solutions of a Complex Differential Equation for the Riemann Hypothesis** [[paper](https://arxiv.org/abs/2112.05521)]
- [2021] **New Formulas for the Euler-Mascheroni Constant and other Consequences derived from the Acceptance of Hyperbolicity of Jensen Polynomials and the Analysis of the Turán Moments for the ξ-Function** [[paper](https://arxiv.org/abs/2112.11228)]
- [2021] **Boundary driven Markov gas: duality and scaling limits** [[paper](https://arxiv.org/abs/2112.12698)]
- [2021] **Gaussian fluctuations for spin systems and point processes: near-optimal rates via quantitative Marcinkiewicz's theorem** [[paper](https://arxiv.org/abs/2107.08469)]
- [2021] **New generating and counting Functions of prime numbers applied to approximate Chebyschev 2nd class function and the least action principle applied to find non-trivial roots of the Zeta function and to Riemann Hypothesis** [[paper](https://arxiv.org/abs/2106.10228)]
- [2021] **Convergence of ASEP to KPZ with basic coupling of the dynamics** [[paper](https://arxiv.org/abs/2106.07727)]
- [2021] **Solution to the Riemann Hypothesis from geometric analysis of component series functions in the functional equation of zeta** [[paper](https://arxiv.org/abs/2103.02223)]
- [2021] **Weighted Prime Powers Truncation of the Asymptotic Expansion for the Logarithmic Integral: Properties and Applications** [[paper](https://arxiv.org/abs/2103.17039)]
- [2021] **The Disproof of the Riemann Hypothesis** [[paper](https://arxiv.org/abs/2102.08313)]
- [2021] **A new generalized prime random approximation procedure and some of its applications** [[paper](https://arxiv.org/abs/2102.08478)]
- [2021] **Collatz Cycles and 3n+c Cycles** [[paper](https://arxiv.org/abs/2101.04067)]
- [2021] **Application of the Argument Principle to Functions Expressed as Mellin Transforms** [[paper](https://arxiv.org/abs/2101.07651)]

##### 2020

- [2020] **Bounds of the Mertens Function** [[paper](https://arxiv.org/abs/2012.11756)]
- [2020] **Some problems in mathematics and mathematical physics** [[paper](https://arxiv.org/abs/2011.12141)]
- [2020] **All Complex Zeros of the Riemann Zeta Function Are on the Critical Line: Two Proofs of the Riemann Hypothesis** [[paper](https://arxiv.org/abs/2010.05335)]
- [2020] **The Basel Problem** [[paper](https://arxiv.org/abs/2010.03953)]
- [2020] **The recurrence formulas for primes and non-trivial zeros of the Riemann zeta function** [[paper](https://arxiv.org/abs/2009.02640)]
- [2020] **Polynomial approximations in a generalized Nyman-Beurling criterion** [[paper](https://arxiv.org/abs/2006.02953)]
- [2020] **The Riemann Hypothesis is false** [[paper](https://arxiv.org/abs/2006.12546)]
- [2020] **Exponential decay of transverse correlations for O(N) spin systems and related models** [[paper](https://arxiv.org/abs/2006.06654)]
- [2020] **The Riemann hypothesis via the Mellin transform, power series and the reflection relations** [[paper](https://arxiv.org/abs/2005.05741)]
- [2020] **More on zeros and approximation of the Ising partition function** [[paper](https://arxiv.org/abs/2005.11232)]
- [2020] **An exponentially averaged Vasyunin formula** [[paper](https://arxiv.org/abs/2004.10086)]
- [2020] **An algorithm for the prime-counting function of primes larger than three** [[paper](https://arxiv.org/abs/2002.12797)]
- [2020] **Quantum Electrodynamics (QED) Renormalization is a Logical Paradox, Zeta Function Regularization is Logically Invalid, and Both are Mathematically Invalid** [[paper](https://arxiv.org/abs/2001.04282)]

##### 2019

- [2019] **Analysis of the Riemann zeta function** [[paper](https://arxiv.org/abs/1910.08363)]
- [2019] **On the prime zeta function and the Riemann hypothesis** [[paper](https://arxiv.org/abs/1910.02954)]
- [2019] **A Proof of Riemann Hypothesis — Tao Liu, Juhao Wu (2019)** [[paper](https://arxiv.org/abs/1909.10313)]
- [2019] **Novel Results on Series of Floor and Ceiling Functions** [[paper](https://arxiv.org/abs/1910.03469)]
- [2019] **Cyclic Symmetry of Riemann Tensor in Fuzzy Graph Theory** [[paper](https://arxiv.org/abs/1909.02656)]
- [2019] **Counting Primes Rationally And Irrationally** [[paper](https://arxiv.org/abs/1907.12979)]
- [2019] **A Conjecture Regarding the Riemann Hypothesis as Visualized by t strings** [[paper](https://arxiv.org/abs/1905.06127)]
- [2019] **An Exact Formula for the Prime Counting Function** [[paper](https://arxiv.org/abs/1905.09818)]
- [2019] **Generating Prime Numbers -- A Fast New Method** [[paper](https://arxiv.org/abs/1904.11822)]
- [2019] **The limit of the Riemann zeta function and its nontrivial zeros** [[paper](https://arxiv.org/abs/1902.06695)]

##### 2018

- [2018] **On a category of cotangent sums related to the Nyman-Beurling criterion for the Riemann Hypothesis** [[paper](https://arxiv.org/abs/1811.04399)]
- [2018] **On the Riemann-Hardy hypothesis for the Ramanujan zeta function** [[paper](https://arxiv.org/abs/1811.02418)]
- [2018] **Location of zeros for the partition function of the Ising model on bounded degree graphs** [[paper](https://arxiv.org/abs/1810.01699)]
- [2018] **A disproof of the Riemann hypothesis on zeros of ζ-function** [[paper](https://arxiv.org/abs/1808.10774)]
- [2018] **On the moments of the (2+1)-dimensional directed polymer and stochastic heat equation in the critical window** [[paper](https://arxiv.org/abs/1808.03586)]
- [2018] **A fully new path to prove Riemann Hypothesis** [[paper](https://arxiv.org/abs/1807.00849)]

##### 2017

- [2017] **A proof of Riemann Hypothesis — Pengcheng Niu, Junli Zhang (2017)** [[paper](https://arxiv.org/abs/1704.05747)]
- [2017] **Proof of Riemann hypothesis** [[paper](https://arxiv.org/abs/1703.03827)]
- [2017] **Solution de l'Hypothèse de Riemann** [[paper](https://arxiv.org/abs/1703.05319)]

##### 2016

- [2016] **A Proof of the Riemann Hypothesis and Determination of the Relationship Between Non- Trivial Zeros of Zeta Functions and Prime Numbers** [[paper](https://arxiv.org/abs/1612.02664)]
- [2016] **Open ASEP in the Weakly Asymmetric Regime** [[paper](https://arxiv.org/abs/1610.04931)]
- [2016] **The Dirichlet Series for the Liouville Function and the Riemann Hypothesis** [[paper](https://arxiv.org/abs/1609.06971)]
- [2016] **On the zeros of the zeta function and eigenvalue problems** [[paper](https://arxiv.org/abs/1608.01555)]
- [2016] **Riemann's zeta function and the broadband structure of pure harmonics** [[paper](https://arxiv.org/abs/1603.03667)]
- [2016] **Proof that the real part of all non-trivial zeros of Riemann zeta function is 1/2** [[paper](https://arxiv.org/abs/1602.03553)]

##### 2015

- [2015] **On cluster properties of classical ferromagnets in an external magnetic field** [[paper](https://arxiv.org/abs/1512.05707)]
- [2015] **A proof of the Riemann hypothesis using the remainder term of the Dirichlet eta function** [[paper](https://arxiv.org/abs/1508.00533)]
- [2015] **The Development of a Hybrid Asymptotic Expansion for the Hardy Fuction Z(t), Consisting of Just [2*sqrt(2)-2]*sqrt(t/(2*pi)) Main Sum Terms, some 17% less than the celebrated Riemann-Siegel Formula** [[paper](https://arxiv.org/abs/1502.06903)]

##### 2014

- [2014] **Generalizations of a cotangent sum associated to the Estermann zeta function** [[paper](https://arxiv.org/abs/1410.2145)]
- [2014] **Zeta Functional Analysis** [[paper](https://arxiv.org/abs/1411.3244)]
- [2014] **Riemann hypothesis is not correct** [[paper](https://arxiv.org/abs/1407.4545)]
- [2014] **The proof of the correctness of the Birch and Swinnerton-Diyer conjecture** [[paper](https://arxiv.org/abs/1406.2270)]
- [2014] **On the Riemann Hypothesis and its generalizations** [[paper](https://arxiv.org/abs/1404.4333)]
- [2014] **The Riemann Hypothesis and the possible proof** [[paper](https://arxiv.org/abs/1402.2822)]
- [2014] **A Proof Of The Riemann Hypothesis — Mingchun Xu (2014)** [[paper](https://arxiv.org/abs/1402.5952)]
- [2014] **Generalized Random Energy Model at Complex Temperatures** [[paper](https://arxiv.org/abs/1402.2142)]

##### 2013

- [2013] **Local Central Limit Theorem for Determinantal Point Processes** [[paper](https://arxiv.org/abs/1311.7126)]
- [2013] **On Elementary Methods To Evaluate Values of The Riemann Zeta Function and Another Closely Related Infinite Series At Natural Numbers** [[paper](https://arxiv.org/abs/1310.8292)]
- [2013] **Diffusive-Ballistic Transition in Random Polymers with Drifts and Repulsive Long-Range Interactions** [[paper](https://arxiv.org/abs/1308.5730)]
- [2013] **Zeros of the Riemann Zeta Function** [[paper](https://arxiv.org/abs/1305.0323)]
- [2013] **Euler constant as a renormalized value of Riemann zeta function at its pole. Rationals related to Dirichlet L-functions** [[paper](https://arxiv.org/abs/1306.0496)]

##### 2012

- [2012] **An optimal choice of Dirichlet polynomials for the Nyman-Beurling criterion** [[paper](https://arxiv.org/abs/1211.5191)]
- [2012] **Renormalized-Generalized Solutions for the KPZ Equation** [[paper](https://arxiv.org/abs/1209.0820)]
- [2012] **Riemann Zeta Function Expressed as the Difference of Two Symmetrized Factorials Whose Zeros All Have Real Part of 1/2** [[paper](https://arxiv.org/abs/1208.1440)]
- [2012] **Study odd numbers with traditional functions** [[paper](https://arxiv.org/abs/1208.4527)]
- [2012] **On accuracy of mathematical languages used to deal with the Riemann zeta function and the Dirichlet eta function** [[paper](https://arxiv.org/abs/1203.4142)]

##### 2011

- [2011] **Recursion Relations and Functional Equations for the Riemann Zeta Function** [[paper](https://arxiv.org/abs/1107.3479)]

##### 2010

- [2010] **Elementary Evaluation of the Zeta and Related Functions** [[paper](https://arxiv.org/abs/1010.4320)]
- [2010] **A variational approach to the stationary solutions of Burgers equation** [[paper](https://arxiv.org/abs/1008.0550)]
- [2010] **The Riemann Hypothesis** [[paper](https://arxiv.org/abs/1006.0381)]
- [2010] **On the zeros of the Riemann Zeta function** [[paper](https://arxiv.org/abs/1004.4143)]
- [2010] **Acid zeta function and ajoint acid zeta function** [[paper](https://arxiv.org/abs/1003.3392)]
- [2010] **A Brief Note on the Riemann hypothesis II** [[paper](https://arxiv.org/abs/1003.2854)]

##### 2009

- [2009] **Fermi-Dirac integrals in terms of Zeta Functions** [[paper](https://arxiv.org/abs/0909.3653)]
- [2009] **Stationarity, time--reversal and fluctuation theory for a class of piecewise deterministic Markov processes** [[paper](https://arxiv.org/abs/0902.4195)]

##### 2008

- [2008] **Proof of Riemann's zeta-hypothesis** [[paper](https://arxiv.org/abs/0809.5120)]
- [2008] **Stationary non-equilibrium properties for a heat conduction model** [[paper](https://arxiv.org/abs/0808.0662)]
- [2008] **The nontrivial zeros of the Zeta Function lie on the Critical Line** [[paper](https://arxiv.org/abs/0803.2303)]

##### 2007

- [2007] **Factorial ratios, hypergeometric series, and a family of step functions** [[paper](https://arxiv.org/abs/0709.1977)]
- [2007] **One page proof of the Riemann hypothesis** [[paper](https://arxiv.org/abs/0709.1389)]
- [2007] **A short Brownian motion proof of the Riemann hypothesis** [[paper](https://arxiv.org/abs/0707.4196)]
- [2007] **Proof of generalized Riemann hypothesis for Dedekind zetas and Dirichlet L-functions** [[paper](https://arxiv.org/abs/0706.0256)]
- [2007] **Multivariable approximate Carleman-type theorems for complex measures** [[paper](https://arxiv.org/abs/math/0703809)]

##### 2006

- [2006] **The Continuing Story of Zeta** [[paper](https://arxiv.org/abs/math/0610108)]
- [2006] **Sums of entire functions having only real zeros** [[paper](https://arxiv.org/abs/math/0608297)]

##### 2005

- [2005] **A divergent Vasyunin correction** [[paper](https://arxiv.org/abs/math/0506318)]

##### 2003

- [2003] **A Geometric Proof of Riemann Hypothesis** [[paper](https://arxiv.org/abs/math/0307136)]
- [2003] **Glauber dynamics of continuous particle systems** [[paper](https://arxiv.org/abs/math/0306252)]
- [2003] **Partition function zeros at first-order phase transitions: A general analysis** [[paper](https://arxiv.org/abs/math-ph/0304007)]

##### 2002

- [2002] **Final steps towards a proof of the Riemann hypothesis** [[paper](https://arxiv.org/abs/hep-th/0208221)]
- [2002] **On an analytic estimate in the theory of the Riemann Zeta function and a Theorem of Baez-Duarte** [[paper](https://arxiv.org/abs/math/0202166)]

[⬆ Back to top](#paper-list)

#### Hilbert-Pólya Conjecture

##### 2026

- [2026] **Partition Functions of Hermitian and PT-Symmetric Oscillators from Integrable Models** [[paper](https://arxiv.org/abs/2608.06047)]
- [2026] **A semiclassical Hilbert space for random matrix theory** [[paper](https://arxiv.org/abs/2608.23689)]
- [2026] **Exact partition function of arithmetic Ising model** [[paper](https://arxiv.org/abs/2608.19605)]
- [2026] **A Numerical Realization of Suzuki's Weil-Quadratic-Form Operator: The Archimedean Spectral Law, its Universality, and an Operator Form of Weil's Positivity Criterion** [[paper](https://arxiv.org/abs/2607.24830)]
- [2026] **The divisor of the twisted Selberg zeta function** [[paper](https://arxiv.org/abs/2607.14981)]
- [2026] **Graph integrals, Feynman periods, and single-valued multiple zeta values** [[paper](https://arxiv.org/abs/2607.25595)]
- [2026] **Ghost Hunting in the Yang-Mills Vacuum** [[paper](https://arxiv.org/abs/2607.07954)]
- [2026] **Quantum models of the Riemann zeta function, lattice spin models and algebraic models of entanglement** [[paper](https://arxiv.org/abs/2606.29294)]
- [2026] **Weil's quadratic form via the screw function** [[paper](https://arxiv.org/abs/2606.09096)]
- [2026] **On the Berry-Keating Operator** [[paper](https://arxiv.org/abs/2606.24405)]
- [2026] **Zeta-regularization and natural boundaries: Sums and products of integers and primes** [[paper](https://arxiv.org/abs/2606.24536)]
- [2026] **Random Matrix Spectra from Boltzmann-Weighted Lattice Ensembles** [[paper](https://arxiv.org/abs/2605.21254)]
- [2026] **On ratios of theta functions** [[paper](https://arxiv.org/abs/2605.07580)]
- [2026] **Epstein vector zeta functions related to the ADE Lie algebras** [[paper](https://arxiv.org/abs/2605.16042)]
- [2026] **Semiclassical periodic-orbit theory for quantum spectra** [[paper](https://arxiv.org/abs/2605.19019)]
- [2026] **Joint distributions of eigenvectors of symmetric random tensors** [[paper](https://arxiv.org/abs/2605.09804)]
- [2026] **Non-linear geometry of multiple zeta values** [[paper](https://arxiv.org/abs/2604.22735)]
- [2026] **Quantum chaotic systems: a random-matrix approach** [[paper](https://arxiv.org/abs/2604.12141)]
- [2026] **Residues of a tropical zeta function for convex domains** [[paper](https://arxiv.org/abs/2604.21709)]
- [2026] **Level Crossing in Random Matrices. III. Analogs of Girko's circular and Wigner's semicircle laws** [[paper](https://arxiv.org/abs/2604.25785)]
- [2026] **Finite-difference zeta readout of one-loop operator spectra** [[paper](https://arxiv.org/abs/2604.11460)]
- [2026] **Moments at the hard edge and Rayleigh functions** [[paper](https://arxiv.org/abs/2604.18113)]
- [2026] **Long-Range Correlated Random Matrices** [[paper](https://arxiv.org/abs/2604.22447)]
- [2026] **Decaying Turbulence and the Riemann Hypothesis: The number theory behind the infinite-time singularity** [[paper](https://arxiv.org/abs/2604.12207)]
- [2026] **Module Lattice Security (Part I): Unconditional Verification of Weber's Conjecture for k \le 12** [[paper](https://arxiv.org/abs/2604.15858)]
- [2026] **McMullen's Curve, the Weil Locus, and the Hodge Conjecture for Abelian Sixfolds** [[paper](https://arxiv.org/abs/2603.20268)]
- [2026] **Negative energies and the breakdown of bulk geometry** [[paper](https://arxiv.org/abs/2603.25782)]
- [2026] **Non-Hermitian Disordered Systems** [[paper](https://arxiv.org/abs/2603.20393)]
- [2026] **Persistence diagrams of random matrices via Morse theory: universality and a new spectral diagnostic** [[paper](https://arxiv.org/abs/2603.27903)]
- [2026] **Theory of (Co)homological Invariants on Quantum LDPC Codes** [[paper](https://arxiv.org/abs/2603.25831)]
- [2026] **Weakening the Legendre Conjecture** [[paper](https://arxiv.org/abs/2602.22502)]
- [2026] **Spectral boundaries of deterministic matrices deformed by rotationally invariant random non-Hermitian ensembles** [[paper](https://arxiv.org/abs/2602.16878)]
- [2026] **Special values of spectral zeta functions of one-, two-photon quantum Rabi models and non-commutative harmonic oscillators** [[paper](https://arxiv.org/abs/2602.01628)]
- [2026] **Parity-dependent double degeneracy and spectral statistics in the projected dice lattice** [[paper](https://arxiv.org/abs/2602.11844)]
- [2026] **Synchronization points: growth, asymptotics, congruences, and the synchronization zeta function** [[paper](https://arxiv.org/abs/2601.21888)]
- [2026] **Fredholm Theory on Twisted Hilbert Scales: A Frame-Theoretic Approach to Half-Integer Fourier Modes** [[paper](https://arxiv.org/abs/2601.10753)]
- [2026] **The eigenvalues and eigenvectors of finite-rank normal perturbations of large rotationally invariant non-Hermitian matrices** [[paper](https://arxiv.org/abs/2601.10427)]
- [2026] **Eigenvalue degeneracy in sparse random matrices** [[paper](https://arxiv.org/abs/2601.11105)]

##### 2025

- [2025] **Average Winding Number for Determinantal Curves associated with 2-Matrix Models in the Class AIII** [[paper](https://arxiv.org/abs/2511.06669)]
- [2025] **Asymptotic expansion for multiplicative statistics in a Hermitian matrix model connected to the lower tail of the KPZ equation** [[paper](https://arxiv.org/abs/2511.01120)]
- [2025] **Lecture notes on Quantum Diffusion and Random Matrix Theory** [[paper](https://arxiv.org/abs/2511.04380)]
- [2025] **Weakly universal dynamical correlations between eigenvalues of large random matrices** [[paper](https://arxiv.org/abs/2511.05727)]
- [2025] **Feynman spectral action of the wave operator on asymptotically de Sitter spaces** [[paper](https://arxiv.org/abs/2511.17359)]
- [2025] **A Note on Optimal Soft Edge Expansions for the Gaussian β Ensembles** [[paper](https://arxiv.org/abs/2510.13092)]
- [2025] **Loop Vertex Representation for Cumulants, Part II: Weingarten Calculus** [[paper](https://arxiv.org/abs/2510.22372)]
- [2025] **Analytic Bernoulli Functions: Correspondence with Hermite Polynomials** [[paper](https://arxiv.org/abs/2509.15916)]
- [2025] **A Dynamical Criterion Equivalent to the Riemann Hypothesis** [[paper](https://arxiv.org/abs/2509.10588)]
- [2025] **A survey of moment bounds for ζ(s): from Heath Brown's work to the present** [[paper](https://arxiv.org/abs/2509.20335)]
- [2025] **Dyson Trace Flow and Multivariate Dynamic Coupled Semicircle Law** [[paper](https://arxiv.org/abs/2509.19871)]
- [2025] **Sum rules via large deviations: polynomial potentials and multi-cut regime on the unit circle** [[paper](https://arxiv.org/abs/2509.23814)]
- [2025] **The Limiting Spectral Distribution for Sparse Elliptic Random Matrices** [[paper](https://arxiv.org/abs/2508.04891)]
- [2025] **Exact Sum Rules and Zeta Generating Formulas from the ODE/IM correspondence** [[paper](https://arxiv.org/abs/2508.06366)]
- [2025] **Edge Universality for Inhomogeneous Random Matrices** [[paper](https://arxiv.org/abs/2508.17838)]
- [2025] **Koba-Nielsen local zeta functions, convex subsets, and generalized Selberg-Mehta-Macdonald and Dotsenko-Fateev-like integrals** [[paper](https://arxiv.org/abs/2507.08120)]
- [2025] **Stark-Coleman Invariants and Quantum Lower Bounds: An Integrated Framework for Real Quadratic Fields** [[paper](https://arxiv.org/abs/2506.07640)]
- [2025] **Sharp bounds for maximal sums of odd order Dirichlet characters** [[paper](https://arxiv.org/abs/2505.07651)]
- [2025] **Localization for heavy-tailed Anderson models** [[paper](https://arxiv.org/abs/2505.09079)]
- [2025] **Addition to "Structured random matrices and cyclic cumulants: A free probability approach"** [[paper](https://arxiv.org/abs/2505.21376)]
- [2025] **In memoriam: aspects of Santosh Kumar's work on exact results in RMT** [[paper](https://arxiv.org/abs/2505.04943)]
- [2025] **Resolution Of Multiplicative Anomaly Of Zeta Regularization For Polynomials** [[paper](https://arxiv.org/abs/2504.14563)]
- [2025] **On post-Lie structures for free Lie algebras** [[paper](https://arxiv.org/abs/2504.19661)]
- [2025] **A Majorana Relativistic Quantum Spectral Approach to the Riemann Hypothesis in (1+1)-Dimensional Rindler Spacetimes** [[paper](https://arxiv.org/abs/2503.09644)]
- [2025] **Moments of characteristic polynomials for classical β ensembles** [[paper](https://arxiv.org/abs/2502.07142)]
- [2025] **A notion of fractality for a class of states and noncommutative relative distance zeta functional** [[paper](https://arxiv.org/abs/2502.18896)]
- [2025] **Mixed Berndt-Type Integrals and Generalized Barnes Multiple Zeta Functions** [[paper](https://arxiv.org/abs/2502.15173)]
- [2025] **Gaussian Free Field and Discrete Gaussians in Periodic Dimer Models** [[paper](https://arxiv.org/abs/2502.07241)]
- [2025] **Grover algorithm and absolute zeta functions** [[paper](https://arxiv.org/abs/2501.13393)]
- [2025] **Periodicity and absolute zeta functions of multi-state Grover walks on cycles** [[paper](https://arxiv.org/abs/2501.18600)]
- [2025] **Signs of high order derivatives for the theta and Epstein zeta functions and application** [[paper](https://arxiv.org/abs/2501.01265)]

##### 2024

- [2024] **On Anticyclotomic Iwasawa Theory of Hecke Characters at Ordinary Primes** [[paper](https://arxiv.org/abs/2412.10980)]
- [2024] **Transition Analysis: From the Airy and Pearcey Kernels to the Sine Kernel** [[paper](https://arxiv.org/abs/2412.10596)]
- [2024] **Fractal zeta functions at infinity and the φ-shell Minkowski content** [[paper](https://arxiv.org/abs/2412.07645)]
- [2024] **Les Houches lectures on two-dimensional gravity and holography** [[paper](https://arxiv.org/abs/2412.09537)]
- [2024] **Existence of Boutroux curves, g-functions and spectral networks from Newton's polygon** [[paper](https://arxiv.org/abs/2411.11608)]
- [2024] **Topological entanglement and number theory** [[paper](https://arxiv.org/abs/2410.01492)]
- [2024] **Winding Number Statistics for Chiral Random Matrices: Universal Correlations and Statistical Moments in the Unitary Case** [[paper](https://arxiv.org/abs/2410.22808)]
- [2024] **Spectral invariants of integrable polygons** [[paper](https://arxiv.org/abs/2409.14391)]
- [2024] **Fiber decomposition of non-commutative harmonic oscillators by two-photon quantum Rabi models** [[paper](https://arxiv.org/abs/2408.04239)]
- [2024] **Eigenstate Correlations in Dual-Unitary Quantum Circuits: Partial Spectral Form Factor** [[paper](https://arxiv.org/abs/2407.19929)]
- [2024] **Absolute zeta functions and periodicity of quantum walks on cycles** [[paper](https://arxiv.org/abs/2405.05995)]
- [2024] **Spectral zeta function and ground state of quantum Rabi model** [[paper](https://arxiv.org/abs/2405.09158)]
- [2024] **k-Fold Gaussian Random Matrix Ensembles I: Forcing Structure into Random Matrices** [[paper](https://arxiv.org/abs/2405.01727)]
- [2024] **Tube Formulae for Generalized von Koch Fractals through Scaling Functional Equations** [[paper](https://arxiv.org/abs/2405.04712)]
- [2024] **If our chaotic operator is derived correctly, then the Riemann hypothesis holds true** [[paper](https://arxiv.org/abs/2404.00583)]
- [2024] **BCZ map is weakly mixing** [[paper](https://arxiv.org/abs/2403.14976)]
- [2024] **Phases and Duality in Fundamental Kazakov-Migdal Model on the Graph** [[paper](https://arxiv.org/abs/2403.07385)]
- [2024] **QW-Search/Zeta Correspondence** [[paper](https://arxiv.org/abs/2402.17183)]
- [2024] **A quantization of interacting particle systems** [[paper](https://arxiv.org/abs/2402.00280)]
- [2024] **Structural Stability Hypothesis of Dual Unitary Quantum Chaos** [[paper](https://arxiv.org/abs/2402.19096)]
- [2024] **Duality between the quantum inverted harmonic oscillator and inverse square potentials** [[paper](https://arxiv.org/abs/2402.13909)]
- [2024] **On p-adic spectral zeta functions** [[paper](https://arxiv.org/abs/2401.12775)]
- [2024] **Biorthogonal measures, polymer partition functions, and random matrices** [[paper](https://arxiv.org/abs/2401.10130)]
- [2024] **Möbius Inversion and Duality for Summations of Stable Graphs** [[paper](https://arxiv.org/abs/2401.11717)]

##### 2023

- [2023] **Partition functions for non-commutative harmonic oscillators and related divergent series** [[paper](https://arxiv.org/abs/2312.07912)]
- [2023] **Universality of extremal eigenvalues of large random matrices** [[paper](https://arxiv.org/abs/2312.08325)]
- [2023] **The role of the branch cut of the logarithm in the definition of the spectral determinant for non-selfadjoint operators** [[paper](https://arxiv.org/abs/2312.07155)]
- [2023] **Partition function zeros of zeta-urns** [[paper](https://arxiv.org/abs/2312.01806)]
- [2023] **A probabilistic interpretation of Weil's explicit sums and arithmetic spectral measures** [[paper](https://arxiv.org/abs/2311.08519)]
- [2023] **Analyzing Dynamical Systems Inspired by Montgomery's Conjecture: Insights into Zeta Function Zeros and Chaos in Number Theory** [[paper](https://arxiv.org/abs/2406.12852)]
- [2023] **Two types of Witten zeta functions** [[paper](https://arxiv.org/abs/2311.02731)]
- [2023] **Casimir energy for elliptic fixed points** [[paper](https://arxiv.org/abs/2311.12708)]
- [2023] **Transition-State Theory Revisited** [[paper](https://arxiv.org/abs/2311.08030)]
- [2023] **Vacuum energy of scalar fields on spherical shells with general matching conditions** [[paper](https://arxiv.org/abs/2310.16756)]
- [2023] **Solitons and Normal Random Matrices** [[paper](https://arxiv.org/abs/2309.09016)]

##### 2022

- [2022] **A new class of solutions to the van Dantzig problem, the Lee-Yang property, and the Riemann hypothesis** [[paper](https://arxiv.org/abs/2211.16680)]

##### 2021

- [2021] **A Proof of the Riemann Hypothesis Using Bombieri's Equivalence Theorem** [[paper](https://arxiv.org/abs/2108.02851)]

##### 2020

- [2020] **Weil positivity and Trace formula, the archimedean place** [[paper](https://arxiv.org/abs/2006.13771)]

##### 2017

- [2017] **Quantum Physics, Algorithmic Information Theory and the Riemanns Hypothesis** [[paper](https://arxiv.org/abs/1801.02459)]
- [2017] **On Hilbert's 8th Problem** [[paper](https://arxiv.org/abs/1708.02653)]
- [2017] **Quantum simulation of the integer factorization problem: Bell states in a Penning trap** [[paper](https://arxiv.org/abs/1704.03174)]

##### 2016

- [2016] **Poincare--Riemann--Hilbert boundary-value problem for The Millennium Prize Problems** [[paper](https://arxiv.org/abs/1605.06018)]

##### 2011

- [2011] **The Lee-Yang and Pólya-Schur programs. III. Zero-preservers on Bargmann-Fock spaces** [[paper](https://arxiv.org/abs/1107.1809)]
- [2011] **Nonclassical Degrees of Freedom in the Riemann Hamiltonian** [[paper](https://arxiv.org/abs/1105.2342)]
- [2011] **The Berry-Keating Hamiltonian and the Local Riemann Hypothesis** [[paper](https://arxiv.org/abs/1104.1850)]

##### 2010

- [2010] **On the Physics of the Riemann Zeros** [[paper](https://arxiv.org/abs/1004.1172)]

##### 2009

- [2009] **Eigenvalue Density, Li's Positivity, and the Critical Strip** [[paper](https://arxiv.org/abs/0903.4321)]

##### 2008

- [2008] **Lee-Yang Problems and The Geometry of Multivariate Polynomials** [[paper](https://arxiv.org/abs/0810.1007)]
- [2008] **The Lee-Yang and Pólya-Schur Programs. II. Theory of Stable Polynomials and Applications** [[paper](https://arxiv.org/abs/0809.3087)]

##### 2006

- [2006] **The One Dimensional Approachissimo Quantum Harmonic Oscillator: The Hilbert-Polya Hamiltonian for the Primes and the Zeros of the Riemann Function** [[paper](https://arxiv.org/abs/quant-ph/0611134)]

[⬆ Back to top](#paper-list)

#### Weil Criterion

##### 2026

- [2026] **Algorithmic universal étale (\varphi,Γ)-modules** [[paper](https://arxiv.org/abs/2608.01567)]
- [2026] **On the Emerton-Gee stack of potentially semistable representations** [[paper](https://arxiv.org/abs/2608.07936)]
- [2026] **An elliptic K3 surface X/Q(t) with Mordell-Weil rank 17, I: Formulas for X and base changes of rank 18 and 19** [[paper](https://arxiv.org/abs/2608.25406)]
- [2026] **Geometric Realization of Finite Residue Casimirs and Weil Operators via Szegő Kernels** [[paper](https://arxiv.org/abs/2608.23996)]
- [2026] **The Siegel-Weil formula in geometry and arithmetic** [[paper](https://arxiv.org/abs/2607.06285)]
- [2026] **Formality for rigid-analytic spaces satisfying the weight-monodromy conjecture** [[paper](https://arxiv.org/abs/2607.14517)]
- [2026] **Explicit formula for the discrete Laplace transform of the Möbius function, related special functions, and a criterion for the Riemann hypothesis** [[paper](https://arxiv.org/abs/2607.09797)]
- [2026] **Weighted Derivative Sums of a Gamma Quotient: Sun's Conjecture and Cyclotomic Specializations** [[paper](https://arxiv.org/abs/2607.15303)]
- [2026] **Spectral Riccati--Gamma Concavity, Symmetric Zero Cancellation, and Conditional Criteria for the Riemann Hypothesis** [[paper](https://arxiv.org/abs/2606.24924)]
- [2026] **Weil-Moore anima** [[paper](https://arxiv.org/abs/2605.11950)]
- [2026] **Characteristic-free approaches around Yu's construction** [[paper](https://arxiv.org/abs/2605.03638)]
- [2026] **The Bogomolov property for p-supercuspidal eigenforms** [[paper](https://arxiv.org/abs/2605.31403)]
- [2026] **Relation between Anderson Generating Functions and Weil Pairing** [[paper](https://arxiv.org/abs/2604.04124)]
- [2026] **Prime--Zero Duality: Fractal Geometry, Renormalization-Group Flow, and an Information-Ontological Framework for Number Theory** [[paper](https://arxiv.org/abs/2604.14596)]
- [2026] **A trick to ensure positive Mordell-Weil rank** [[paper](https://arxiv.org/abs/2603.04100)]
- [2026] **Regulator Constants and Cohomology** [[paper](https://arxiv.org/abs/2603.01310)]
- [2026] **On the discrete convolution of the Liouville and Möbius functions** [[paper](https://arxiv.org/abs/2603.10241)]
- [2026] **A new proof of Carlitz-Wan conjecture on exceptional polynomials** [[paper](https://arxiv.org/abs/2602.19779)]
- [2026] **Distortion maps for elliptic curves over finite fields** [[paper](https://arxiv.org/abs/2601.09904)]
- [2026] **Height moduli of elliptic surfaces: Motivic height zeta rationality and Kudla-Millson modularity of Mordell-Weil rank jumps** [[paper](https://arxiv.org/abs/2601.15543)]
- [2026] **Recovering polynomials over finite fields from noisy character values** [[paper](https://arxiv.org/abs/2601.07137)]

##### 2025

- [2025] **Areal Weil Heights** [[paper](https://arxiv.org/abs/2512.16007)]
- [2025] **An Arithmetic Topology viewpoint on Descent theory and Equivariant Categories** [[paper](https://arxiv.org/abs/2512.20551)]
- [2025] **The splitting field and generators of the elliptic surface Y^2=X^3 +t^{360} +1** [[paper](https://arxiv.org/abs/2512.25009)]
- [2025] **On inertial types of elliptic curves** [[paper](https://arxiv.org/abs/2512.05023)]
- [2025] **Families of twists of tuples of hyperelliptic curves** [[paper](https://arxiv.org/abs/2511.07131)]
- [2025] **Effective calculation of local Weil functions via presentations of Cartier divisors** [[paper](https://arxiv.org/abs/2510.18284)]
- [2025] **On the growth of Tate-Shafarevich groups of p-supersingular abelian varieties of {\rm GL}_2-type over \mathbb{Z}_p-extensions of number fields** [[paper](https://arxiv.org/abs/2510.11511)]
- [2025] **Central values of Asai L-functions and twisted Gan--Gross--Prasad conjecture** [[paper](https://arxiv.org/abs/2509.16356)]
- [2025] **Hyperelliptic Jacobians in Isogeny Classes of Abelian Threefolds Over Finite Fields** [[paper](https://arxiv.org/abs/2508.16885)]
- [2025] **On Weil Polynomials of Hyperelliptic Curves over Finite Fields of Characteristic 2** [[paper](https://arxiv.org/abs/2508.16886)]
- [2025] **Weil representations associated to isocrystals over function fields** [[paper](https://arxiv.org/abs/2507.20807)]
- [2025] **On the growth of hypergeometric sequences** [[paper](https://arxiv.org/abs/2507.22437)]
- [2025] **Refinements on higher order Weil-Oesterlé bounds via a Serre type argument** [[paper](https://arxiv.org/abs/2506.05212)]
- [2025] **Extensions of Abelian Schemes and the Additive Group** [[paper](https://arxiv.org/abs/2506.17393)]
- [2025] **Strongly compatible systems associated to semistable abelian varieties** [[paper](https://arxiv.org/abs/2505.02165)]
- [2025] **The de Rham cohomology of covers with cyclic p-Sylow subgroup** [[paper](https://arxiv.org/abs/2504.01499)]
- [2025] **Arithmetic Aspects of Weil Bundles over p-Adic Manifolds** [[paper](https://arxiv.org/abs/2503.05567)]
- [2025] **Effective Mordell for curves with enough automorphisms** [[paper](https://arxiv.org/abs/2503.10443)]
- [2025] **On the Mordell-Weil rank and 2-Selmer group of a family of elliptic curves** [[paper](https://arxiv.org/abs/2503.04561)]
- [2025] **Duality for the condensed Weil-étale realisation of 1-motives over p-adic fields** [[paper](https://arxiv.org/abs/2502.19910)]
- [2025] **Mixed Motives** [[paper](https://arxiv.org/abs/2501.14106)]
- [2025] **On the cohomology of simple Shimura varieties with non quasi-split local groups** [[paper](https://arxiv.org/abs/2501.12127)]

##### 2024

- [2024] **Bounds for Kloosterman Sums for GL_n** [[paper](https://arxiv.org/abs/2412.04976)]
- [2024] **On the abscissae of Weil representation zeta functions for procyclic groups** [[paper](https://arxiv.org/abs/2411.12848)]
- [2024] **Conic bundles and Mordell--Weil ranks of elliptic surfaces** [[paper](https://arxiv.org/abs/2410.12066)]
- [2024] **Weil-Barsotti formula for T-modules** [[paper](https://arxiv.org/abs/2409.04029)]
- [2024] **Tropical Weil's reciprocity law and Weil's pairing** [[paper](https://arxiv.org/abs/2408.06372)]
- [2024] **The basis problem for modular forms for the Weil representation** [[paper](https://arxiv.org/abs/2407.01205)]
- [2024] **Characteristic ideal of the fine Selmer group and results on μ-invariance under isogeny in the function field case** [[paper](https://arxiv.org/abs/2406.03201)]
- [2024] **Cohomology of Fuchsian groups and Fourier interpolation** [[paper](https://arxiv.org/abs/2406.19511)]
- [2024] **Lang-Weil Type Estimates in Finite Difference Fields** [[paper](https://arxiv.org/abs/2406.00880)]
- [2024] **Co-rank 1 Arithmetic Siegel--Weil IV: Analytic local-to-global** [[paper](https://arxiv.org/abs/2405.01429)]
- [2024] **Co-rank 1 Arithmetic Siegel--Weil II: Local Archimedean** [[paper](https://arxiv.org/abs/2405.01427)]
- [2024] **Co-rank 1 Arithmetic Siegel--Weil I: Local non-Archimedean** [[paper](https://arxiv.org/abs/2405.01426)]
- [2024] **On tori periods of Weil representations of unitary groups** [[paper](https://arxiv.org/abs/2402.16808)]
- [2024] **Duality for condensed cohomology of the Weil group of a p-adic field** [[paper](https://arxiv.org/abs/2402.05565)]
- [2024] **Universal Weil cohomology** [[paper](https://arxiv.org/abs/2401.14127)]
- [2024] **On Non-Noetherian Iwasawa Theory** [[paper](https://arxiv.org/abs/2401.02946)]

##### 2023

- [2023] **Prolongement analytique de fonctions ζ et de fonctions L** [[paper](https://arxiv.org/abs/2311.15905)]
- [2023] **On Weil-Stark elements, II: refined Stark conjectures** [[paper](https://arxiv.org/abs/2310.10581)]
- [2023] **The Weil bound for generalized Kloosterman sums of half-integral weight** [[paper](https://arxiv.org/abs/2309.08528)]
- [2023] **Jacobi Forms of Lattice Index I. Basic Theory** [[paper](https://arxiv.org/abs/2309.04738)]
- [2023] **Northcott numbers for generalized weighted Weil heights** [[paper](https://arxiv.org/abs/2308.03981)]
- [2023] **Sur un théorème de Lang-Weil tordu, d'après E. Hrushovski, K. V. Shuddhodan et Y. Varshavsky** [[paper](https://arxiv.org/abs/2308.16132)]
- [2023] **Rationality of Four-Valued Families of Weil Sums of Binomials** [[paper](https://arxiv.org/abs/2306.14414)]
- [2023] **On p-adic Gram-Schmidt Orthogonalization Process** [[paper](https://arxiv.org/abs/2305.07886)]

##### 2022

- [2022] **Rational points on rank 2 genus 2 bielliptic curves in the LMFDB** [[paper](https://arxiv.org/abs/2212.11635)]
- [2022] **The distribution of large quadratic character sums and applications** [[paper](https://arxiv.org/abs/2212.03227)]
- [2022] **Les conjectures de Weil : origines, approches, généralisations** [[paper](https://arxiv.org/abs/2211.14254)]
- [2022] **Weil Sums over Small Subgroups** [[paper](https://arxiv.org/abs/2211.07739)]
- [2022] **Zero-dimensional Shimura varieties and central derivatives of Eisenstein series** [[paper](https://arxiv.org/abs/2210.16218)]
- [2022] **Polynomial equations modulo prime numbers** [[paper](https://arxiv.org/abs/2207.06033)]
- [2022] **Relative Northcott numbers for the weighted Weil heights** [[paper](https://arxiv.org/abs/2206.05440)]
- [2022] **Extended Weil representations: the finite field cases** [[paper](https://arxiv.org/abs/2204.03987)]
- [2022] **Local and Global Heights on Weighted Projective Varieties** [[paper](https://arxiv.org/abs/2204.01624)]

##### 2021

- [2021] **Determination of the modular Jacobian varieties J_1(M,MN) with the Mordell-Weil rank zero** [[paper](https://arxiv.org/abs/2111.08215)]
- [2021] **Deducing information about curves over finite fields from their Weil polynomials** [[paper](https://arxiv.org/abs/2110.04221)]
- [2021] **From sum of two squares to arithmetic Siegel-Weil formulas** [[paper](https://arxiv.org/abs/2110.07457)]
- [2021] **On maximal and minimal hypersurfaces of Fermat type** [[paper](https://arxiv.org/abs/2110.07452)]
- [2021] **Arithmetic statistics and diophantine stability for elliptic curves** [[paper](https://arxiv.org/abs/2109.00830)]
- [2021] **On vector valued automorphic forms for the Weil representation** [[paper](https://arxiv.org/abs/2108.06544)]
- [2021] **Diagonal cubic forms and the large sieve** [[paper](https://arxiv.org/abs/2108.03395)]
- [2021] **On analytic properties of the standard zeta function attached to a vector valued modular form** [[paper](https://arxiv.org/abs/2108.06540)]
- [2021] **Quadratic forms in 8 prime variables** [[paper](https://arxiv.org/abs/2108.10401)]
- [2021] **Northcott numbers for the house and the Weil height** [[paper](https://arxiv.org/abs/2107.09027)]
- [2021] **On the arithmetic Siegel--Weil formula for GSpin Shimura varieties** [[paper](https://arxiv.org/abs/2106.15038)]
- [2021] **Abelian varieties of prescribed order over finite fields** [[paper](https://arxiv.org/abs/2106.13651)]
- [2021] **An improvement of the Hasse-Weil bound for Artin-Schreier curves via cyclotomic function fields** [[paper](https://arxiv.org/abs/2105.04370)]
- [2021] **Around the Chevalley-Weil Theorem** [[paper](https://arxiv.org/abs/2104.05664)]
- [2021] **On the last fall degree of Weil descent polynomial systems** [[paper](https://arxiv.org/abs/2103.07282)]

##### 2020

- [2020] **Weil-Chatelet Groups of Rational Elliptic Surfaces** [[paper](https://arxiv.org/abs/2011.14524)]
- [2020] **Explicit Weil-pairing for Drinfeld Modules** [[paper](https://arxiv.org/abs/2010.05283)]
- [2020] **A singular series average and the zeros of the Riemann zeta-function** [[paper](https://arxiv.org/abs/2007.16099)]
- [2020] **On Weil Sums, Conjectures of Helleseth, and Niho Exponents** [[paper](https://arxiv.org/abs/2006.15726)]

##### 2019

- [2019] **Quadratic points on modular curves with infinite Mordell--Weil group** [[paper](https://arxiv.org/abs/1906.05206)]
- [2019] **On the growth of Mordell-Weil ranks in p-adic Lie extensions** [[paper](https://arxiv.org/abs/1902.01068)]

##### 2018

- [2018] **The Weil bound and non-exceptional permutation polynomials over finite fields** [[paper](https://arxiv.org/abs/1811.12631)]
- [2018] **On the Siegel-Weil formula for classical groups over function fields** [[paper](https://arxiv.org/abs/1806.02049)]
- [2018] **Weil sums of binomials: properties, applications, and open problems** [[paper](https://arxiv.org/abs/1805.10452)]
- [2018] **A new explicit formula in the additive theory of primes with applications I. The explicit formula for the Goldbach and Generalized Twin Prime Problems** [[paper](https://arxiv.org/abs/1804.05561)]

##### 2017

- [2017] **The Chevalley-Weil Formula for Orbifold Curves** [[paper](https://arxiv.org/abs/1712.02437)]

##### 2016

- [2016] **Weil-etale Cohomology and Special Values of L-functions** [[paper](https://arxiv.org/abs/1611.01720)]
- [2016] **Mordell-Weil ranks of families of elliptic curves parametrized by binary quadratic forms** [[paper](https://arxiv.org/abs/1609.04715)]

##### 2015

- [2015] **Some arithmetic properties on nonstandard rationals** [[paper](https://arxiv.org/abs/1509.06474)]
- [2015] **The Riemann Hypothesis over Finite Fields: From Weil to the Present Day** [[paper](https://arxiv.org/abs/1509.00797)]
- [2015] **Computing integral points on hyperelliptic curves using quadratic Chabauty** [[paper](https://arxiv.org/abs/1504.07040)]
- [2015] **Groups of components and Weil restriction** [[paper](https://arxiv.org/abs/1501.05621)]

##### 2014

- [2014] **Bost-Connes systems, Categorification, Quantum statistical mechanics, and Weil numbers** [[paper](https://arxiv.org/abs/1411.3223)]
- [2014] **From Hodge Index Theorem to the number of points of curves over finite fields** [[paper](https://arxiv.org/abs/1409.2357)]
- [2014] **Variation of the canonical height for polynomials in several variables** [[paper](https://arxiv.org/abs/1408.5416)]

##### 2013

- [2013] **Cyclotomy of Weil Sums of Binomials** [[paper](https://arxiv.org/abs/1312.3889)]

##### 2011

- [2011] **On the Weil-étale cohomology of the ring of S-integers** [[paper](https://arxiv.org/abs/1112.0092)]
- [2011] **On the topological aspects of arithmetic elliptic curves** [[paper](https://arxiv.org/abs/1105.0850)]

##### 2010

- [2010] **The Weil-étale fundamental group of a number field II** [[paper](https://arxiv.org/abs/1006.0525)]
- [2010] **Sur l'analogie entre le système dynamique de Deninger et le topos Weil-étale** [[paper](https://arxiv.org/abs/1006.0527)]
- [2010] **Upper bounds for the growth of Mordell-Weil ranks in pro-p towers of Jacobians** [[paper](https://arxiv.org/abs/1001.4266)]

##### 2009

- [2009] **Weil restriction of p-adic analytic spaces** [[paper](https://arxiv.org/abs/0904.3884)]
- [2009] **On character values and decomposition of the Weil representation associated to a finite abelian group** [[paper](https://arxiv.org/abs/0903.1486)]

##### 2008

- [2008] **The Weil Representation in Characteristic Two** [[paper](https://arxiv.org/abs/0808.1664)]
- [2008] **Integral Points on Hyperelliptic Curves** [[paper](https://arxiv.org/abs/0801.4459)]

##### 2007

- [2007] **Three lectures on elliptic surfaces and curves of high rank** [[paper](https://arxiv.org/abs/0709.2908)]
- [2007] **On the Riemann zeta-function, Part II** [[paper](https://arxiv.org/abs/0705.2699)]

##### 2006

- [2006] **An explicit formula for Pi(x) in the form of a sum over the Non-trivial zeros of the Riemann Zeta function** [[paper](https://arxiv.org/abs/math/0610062)]
- [2006] **On Weil Numbers in Cyclotomic Fields** [[paper](https://arxiv.org/abs/math/0606332)]

##### 2004

- [2004] **Detecting linear dependence by reduction maps** [[paper](https://arxiv.org/abs/math/0407249)]

##### 2002

- [2002] **Fourier transforms and p-adic "Weil II"** [[paper](https://arxiv.org/abs/math/0210149)]

[⬆ Back to top](#paper-list)

#### Granville / Goldbach-Bridge

##### 2026

- [2026] **On a conjecture of Corradi and Katai** [[paper](https://arxiv.org/abs/2608.13266)]
- [2026] **A weighted entropy approach for the quadratic inverse large sieve conjecture** [[paper](https://arxiv.org/abs/2607.15311)]
- [2026] **Averages of diagonal Elliott-Halberstam problem twisted by Möbius function with Sobolev and Hölder-Zygmund weights** [[paper](https://arxiv.org/abs/2607.09110)]
- [2026] **On the level of distribution of Goldbach primes and its applications** [[paper](https://arxiv.org/abs/2606.29559)]
- [2026] **Theorem (1+1.9) on the Goldbach Conjecture** [[paper](https://arxiv.org/abs/2606.05224)]
- [2026] **On the binary digits of the Erdős-Borwein constant** [[paper](https://arxiv.org/abs/2605.24160)]
- [2026] **The reverse Goldbach problem and a refined Zsiflaw--Legeis theorem** [[paper](https://arxiv.org/abs/2605.21876)]
- [2026] **Multiple Gauss sums** [[paper](https://arxiv.org/abs/2604.03347)]
- [2026] **A Halász-type asymptotic formula for logarithmic means and its consequences** [[paper](https://arxiv.org/abs/2604.06848)]
- [2026] **Large values of exponential sums with multiplicative coefficients** [[paper](https://arxiv.org/abs/2604.02306)]
- [2026] **A Lock-Free, Fully GPU-Resident Architecture for the Verification of Goldbach's Conjecture** [[paper](https://arxiv.org/abs/2603.07850)]
- [2026] **Entropy of affine permutations and universality of affine atomic lengths** [[paper](https://arxiv.org/abs/2603.22256)]
- [2026] **The distribution of large values of mixed character sums** [[paper](https://arxiv.org/abs/2603.12159)]
- [2026] **GoldbachGPU: An Open Source GPU-Accelerated Framework for Verification of Goldbach's Conjecture** [[paper](https://arxiv.org/abs/2603.02621)]
- [2026] **Conjectures on Sums of Consecutive Primes** [[paper](https://arxiv.org/abs/2601.15346)]

##### 2025

- [2025] **Predicting the size ranking of minimal primes in the generalised Goldbach partitions** [[paper](https://arxiv.org/abs/2510.21870)]
- [2025] **Fiberwise Gromov-Witten theory, quantum spectra of flag bundles, and prime factorization of integers** [[paper](https://arxiv.org/abs/2510.05500)]
- [2025] **The integral Hasse principle for stacky curves associated to a family of generalized Fermat equations** [[paper](https://arxiv.org/abs/2509.13248)]
- [2025] **Small gaps between Goldbach primes** [[paper](https://arxiv.org/abs/2508.02769)]
- [2025] **The Exceptional Set in Goldbach's Problem with two Chen Primes** [[paper](https://arxiv.org/abs/2508.16400)]
- [2025] **The Hardy--Ramanujan inequality for sifted sets and its applications** [[paper](https://arxiv.org/abs/2508.06005)]
- [2025] **A series involving a product of four consecutive harmonic numbers** [[paper](https://arxiv.org/abs/2507.19502)]
- [2025] **Large Value Estimates for Dirichlet Polynomials with Characters and Zero Density of Dirichlet L-Functions** [[paper](https://arxiv.org/abs/2507.08296)]
- [2025] **Multiple sums with the Möbius function** [[paper](https://arxiv.org/abs/2506.08787)]
- [2025] **The Error in a Smooth Weighted Prime Number Formula and Zero-free Regions for the Riemann Zeta Function** [[paper](https://arxiv.org/abs/2505.23795)]
- [2025] **A metric approach to zero-free regions for L-functions** [[paper](https://arxiv.org/abs/2504.05606)]
- [2025] **Goldbach Conjecture: Violation Probability and Generalization to Prime-like Distributions** [[paper](https://arxiv.org/abs/2504.14353)]
- [2025] **Improvements on exponential sums related to Piatetski-Shapiro primes** [[paper](https://arxiv.org/abs/2504.11464)]
- [2025] **Primes of the Form m^2+1 and Goldbach's `Other Other' Conjecture** [[paper](https://arxiv.org/abs/2502.03513)]
- [2025] **On Diophantine properties for values of Dedekind zeta functions** [[paper](https://arxiv.org/abs/2502.20910)]
- [2025] **Exponential sums weighted by additive functions** [[paper](https://arxiv.org/abs/2502.05298)]

##### 2024

- [2024] **Simple Barban--Davenport--Halberstam type asymptotics for general sequences** [[paper](https://arxiv.org/abs/2412.19644)]
- [2024] **High and odd moments in the Erdős--Kac theorem** [[paper](https://arxiv.org/abs/2501.00351)]
- [2024] **Explicit estimates for the Goldbach summatory function** [[paper](https://arxiv.org/abs/2411.00323)]
- [2024] **Almost all primes are not needed in Ternary Goldbach** [[paper](https://arxiv.org/abs/2409.08968)]
- [2024] **Moments of Representation Numbers** [[paper](https://arxiv.org/abs/2410.07184)]
- [2024] **Relative class numbers and Euler-Kronecker constants of maximal real cyclotomic subfields** [[paper](https://arxiv.org/abs/2407.09113)]
- [2024] **A circle method approach to K-multimagic squares** [[paper](https://arxiv.org/abs/2406.08161)]
- [2024] **Conditional upper bounds on the least character non-residue** [[paper](https://arxiv.org/abs/2405.13316)]
- [2024] **Proof of the Complete Presence of a Modulo 4 Bias for the Semiprimes** [[paper](https://arxiv.org/abs/2405.06139)]
- [2024] **On Chen's theorem, Goldbach's conjecture and almost prime twins II** [[paper](https://arxiv.org/abs/2405.05727)]
- [2024] **Torsion subgroups of elliptic curves over quadratic fields and a conjecture of Granville** [[paper](https://arxiv.org/abs/2401.14514)]

##### 2023

- [2023] **Efficient Equidistribution of Nilsequences** [[paper](https://arxiv.org/abs/2312.10772)]
- [2023] **Weighted and Restricted Sum Formulas of Euler Sums** [[paper](https://arxiv.org/abs/2311.02547)]
- [2023] **Conjectures in number theory** [[paper](https://arxiv.org/abs/2311.11966)]
- [2023] **Remarks on additive representations of natural numbers** [[paper](https://arxiv.org/abs/2309.03218)]
- [2023] **Primes in arithmetic progressions to large moduli, and Goldbach beyond the square-root barrier** [[paper](https://arxiv.org/abs/2309.08522)]
- [2023] **Square-free values of polynomials on average** [[paper](https://arxiv.org/abs/2308.15146)]
- [2023] **Sums of proper divisors with missing digits** [[paper](https://arxiv.org/abs/2307.12859)]
- [2023] **Asymmetric Distribution of Extreme Values of Cubic L-functions at s=1** [[paper](https://arxiv.org/abs/2306.13626)]
- [2023] **Weighted Erdős-Kac Theorems via Computing Moments** [[paper](https://arxiv.org/abs/2306.11289)]
- [2023] **Spectrum of multiplicative functions over powerful numbers** [[paper](https://arxiv.org/abs/2303.01168)]
- [2023] **A note on θ_2** [[paper](https://arxiv.org/abs/2303.08093)]
- [2023] **A function-field analogue of the Goldbach counting function and the associated Dirichlet series** [[paper](https://arxiv.org/abs/2302.02549)]
- [2023] **Fermat's Last Theorem, Schur's Theorem (in Ramsey Theory), and the Infinitude of the Primes** [[paper](https://arxiv.org/abs/2302.04755)]
- [2023] **On Primorial Numbers** [[paper](https://arxiv.org/abs/2301.02770)]

##### 2022

- [2022] **A Simple Explanation for the Goldbach Conjecture** [[paper](https://arxiv.org/abs/2211.02865)]
- [2022] **How negative can \sum_{n\le x}\frac{f(n)}{n} be?** [[paper](https://arxiv.org/abs/2211.05540)]
- [2022] **A pretentious proof of Linnik's estimate for primes in arithmetic progressions** [[paper](https://arxiv.org/abs/2209.14538)]
- [2022] **Prime Solutions of Diagonal Diophantine Systems** [[paper](https://arxiv.org/abs/2209.06934)]
- [2022] **A note on Halász's Theorem in \mathbb{F}_q[t]** [[paper](https://arxiv.org/abs/2208.08355)]
- [2022] **The Exceptional Set in Goldbach's Problem with Almost Twin Primes** [[paper](https://arxiv.org/abs/2207.08805)]
- [2022] **An explicit mean-value estimate for the PNT in intervals** [[paper](https://arxiv.org/abs/2206.00433)]
- [2022] **Extreme values of derivatives of zeta and L-functions** [[paper](https://arxiv.org/abs/2204.13826)]

##### 2021

- [2021] **The structure of higher sumsets** [[paper](https://arxiv.org/abs/2110.03554)]
- [2021] **On an Average Goldbach Representation Formula of Fujii** [[paper](https://arxiv.org/abs/2110.14250)]
- [2021] **On the sum of a prime and a square-free number with divisibility conditions** [[paper](https://arxiv.org/abs/2109.11883)]
- [2021] **Lattice points on small arcs** [[paper](https://arxiv.org/abs/2107.09991)]
- [2021] **Magic squares, the symmetric group and Möbius randomness** [[paper](https://arxiv.org/abs/2102.11966)]

##### 2020

- [2020] **Condtional Bounds on Siegel Zeros** [[paper](https://arxiv.org/abs/2010.01308)]
- [2020] **On the conditional bounds for Siegel zeros** [[paper](https://arxiv.org/abs/2010.14161)]
- [2020] **Long large character sums** [[paper](https://arxiv.org/abs/2005.11386)]
- [2020] **Prime and coprime values of polynomials** [[paper](https://arxiv.org/abs/2002.02292)]

##### 2019

- [2019] **Introducing and Applying S.C.E Model Under Dusart's Inequality to Prove Goldbach's Strong Conjecture for 74 Typical Structures out of All 75 Structural Types of Even Number** [[paper](https://arxiv.org/abs/1909.13230)]
- [2019] **Exceptional autonomous components of Goldbach factorization graphs** [[paper](https://arxiv.org/abs/1909.09900)]
- [2019] **Waring-Goldbach problem for unlike powers** [[paper](https://arxiv.org/abs/1907.11918)]
- [2019] **The Theory of ramification** [[paper](https://arxiv.org/abs/1904.09835)]

##### 2017

- [2017] **Shifts of the prime divisor function of Alladi and Erdős** [[paper](https://arxiv.org/abs/1710.10875)]
- [2017] **The Asymptotic Binary Goldbach and Lemoine Conjectures** [[paper](https://arxiv.org/abs/1709.05335)]
- [2017] **Improved \ell^p-Boundedness for Integral k-Spherical Maximal Functions** [[paper](https://arxiv.org/abs/1707.08667)]
- [2017] **A progress on the binary Goldbach conjecture** [[paper](https://arxiv.org/abs/1706.09803)]
- [2017] **Divisibility in paired progressions, Goldbach's conjecture, and the infinitude of prime pairs** [[paper](https://arxiv.org/abs/1706.00317)]
- [2017] **On a conjecture of B. C. Kellner** [[paper](https://arxiv.org/abs/1705.06128)]
- [2017] **Character sums with smooth numbers** [[paper](https://arxiv.org/abs/1705.10148)]
- [2017] **On the ergodic Waring--Goldbach problem** [[paper](https://arxiv.org/abs/1703.02713)]
- [2017] **Extreme values of the Riemann zeta function on the 1-line** [[paper](https://arxiv.org/abs/1703.08315)]

##### 2016

- [2016] **Oriented Bipartite Graphs and the Goldbach Graph** [[paper](https://arxiv.org/abs/1611.10259)]
- [2016] **The Goldbach Problem for Primes That Are Sums of Two Squares Plus One** [[paper](https://arxiv.org/abs/1611.08585)]
- [2016] **Finite connected components of the aliquot graph** [[paper](https://arxiv.org/abs/1610.07471)]
- [2016] **A Lower Bound For Biases Amongst Products Of Two Primes** [[paper](https://arxiv.org/abs/1610.01943)]
- [2016] **The sharp threshold for making squares** [[paper](https://arxiv.org/abs/1608.03857)]
- [2016] **Divisor Goldbach Conjecture and its Partition Number** [[paper](https://arxiv.org/abs/1603.05233)]

##### 2015

- [2015] **An asymptotic upper bound on prime gaps** [[paper](https://arxiv.org/abs/1506.03359)]
- [2015] **Goldbach versus de Polignac numbers** [[paper](https://arxiv.org/abs/1505.03104)]
- [2015] **The ternary Goldbach problem** [[paper](https://arxiv.org/abs/1501.05438)]

##### 2014

- [2014] **Linnik's approximation to Goldbach's conjecture, and other problems** [[paper](https://arxiv.org/abs/1404.5669)]

##### 2013

- [2013] **The ternary Goldbach conjecture is true** [[paper](https://arxiv.org/abs/1312.7748)]
- [2013] **Four squares of primes and powers of 2** [[paper](https://arxiv.org/abs/1308.5492)]

##### 2012

- [2012] **Minor arcs for Goldbach's problem** [[paper](https://arxiv.org/abs/1205.5252)]
- [2012] **Prime numbers, quantum field theory and the Goldbach conjecture** [[paper](https://arxiv.org/abs/1201.6541)]
- [2012] **Every odd number greater than 1 is the sum of at most five primes** [[paper](https://arxiv.org/abs/1201.6656)]

##### 2011

- [2011] **An elementary proof of a congruence by Skula and Granville** [[paper](https://arxiv.org/abs/1108.2361)]
- [2011] **On Random Multiple Dirichlet Series** [[paper](https://arxiv.org/abs/1105.0361)]
- [2011] **Quota Complexes, Persistant Homology and the Goldbach Conjecture** [[paper](https://arxiv.org/abs/1104.4324)]

##### 2010

- [2010] **On the Geometry of the Nodal Lines of Eigenfunctions of the Two-Dimensional Torus** [[paper](https://arxiv.org/abs/1012.3843)]
- [2010] **Analytic Continuation of some zeta functions** [[paper](https://arxiv.org/abs/1001.1869)]

##### 2009

- [2009] **Expansion and Improvement of Sieve and application in Goldbach's problem** [[paper](https://arxiv.org/abs/0904.3365)]

##### 2008

- [2008] **Simultaneous generation for zeta values by the Markov-WZ method** [[paper](https://arxiv.org/abs/0801.3310)]

##### 2007

- [2007] **Carmichael number variable relations: three-prime Carmichael numbers up to 10^24** [[paper](https://arxiv.org/abs/0711.2915)]

[⬆ Back to top](#paper-list)

### Proof & Formalization

#### Lean & Mathlib

##### 2026

- [2026] **Two Machine-Checked Conditional Routes to the Riemann Hypothesis: A Formalized Fekete Criterion, Effective Positivity Targets, and an Exact-Ready Receptor Architecture** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.21416394)]
- [2026] **SIDE-lv-conservation: the Conservation-route growth interface and the h1-complete coupling ledger for the SIDE proof of the Riemann Hypothesis** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.21433178)]
- [2026] **Ars Magna: Geometrically Ordered Dynamics — Information Tension, Sovereign Cognition, and Machine-Verified Foundations** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.21302151)]
- [2026] **[SUPERSEDED — DO NOT CITE] Ars Magna: Geometrically Ordered Dynamics — Information Tension, Sovereign Cognition, and Machine-Verified Foundations** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.21277228)]
- [2026] **SIDE-kernel: Formal verification of the Riemann Hypothesis via exhaustive mechanism exclusion** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.19937590)]
- [2026] **Sturm–Liouville Eigenvalue Simplicity and a Spectral Assumption Interface in Lean 4: The Messina Nullification Framework** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.19969029)]
- [2026] **A Place To Stand: Proof of the Riemann Hypothesis via the SIDE method** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.19675356)]
- [2026] **The Riemann Hypothesis as a Latent Existence Theorem** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.19144521)]
- [2026] **Messina Nullification Framework v3; Volume 2: Riemann Hypothesis and Analytic Number Theory** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.18902325)]
- [2026] **The Archimedean Principle: Why Physics and Number Theory Share a Logical Architecture (Paper 70, Constructive Reverse Mathematics Series)** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.18854585)]
- [2026] **Numerical Computations Concerning Landau-Siegel Zeros** [[paper](https://arxiv.org/abs/2602.03626)]

##### 2025

- [2025] **Horizon A Formal Spectral Architecture for the Riemann Hypothesis** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.17944491)]
- [2025] **Two-Regime Elimination of Zeros from the Critical Strip: An Unconditional Far-Field Certificate and Effective Near-Field Barrier for the Riemann Hypothesis** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.18112047)]
- [2025] **Reflective_Number_Theory: Complete Formal Verification of the Riemann Hypothesis** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.17980826)]
- [2025] **pooriahassanpour0-bit/Reflective_Number_Theory: The Eternal Unified Circle (FULL LEAN 4 GREEN)** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.17822746)]
- [2025] **pooriahassanpour0-bit/Reflective_Number_Theory:EternalUnifiedCircle.lean** *Zenodo (CERN European Organization for Nuclear Research)* [[paper](https://doi.org/10.5281/zenodo.17829867)]

##### 2019

- [2019] **An a posteriori verification method for generalized real-symmetric eigenvalue problems in large-scale electronic state calculations** [[paper](https://arxiv.org/abs/1904.06461)]

##### 2017

- [2017] **The Number of Zeros of Unilateral Polynomials over Coquaternions Revisited** [[paper](https://arxiv.org/abs/1703.10986)]

[⬆ Back to top](#paper-list)

#### Formal Verification

##### 2026

- [2026] **Guaranteed inf-sup bounds and existence verification for semilinear elliptic problems via nonconforming finite elements** [[paper](https://arxiv.org/abs/2604.21887)]

##### 2008

- [2008] **Interval Semantics for Standard Floating-Point Arithmetic** [[paper](https://arxiv.org/abs/0810.4196)]

[⬆ Back to top](#paper-list)

## 📖 Citation

If you use this corpus, please cite:

```bibtex
@misc{riemann-research,
  author = {Weiß, Tobias},
  title = {Riemann Hypothesis Research Corpus},
  year = {2026},
  publisher = {GitHub},
  url = {https://github.com/tobias-weiss-ai-xr/riemann-research}
}
```

---

## 🎓 License & Contribution

- **License**: MIT (same as skeleton-research)
- **Contributing**: See CONTRIBUTING.md
- **Citation**: See CITATION.cff
