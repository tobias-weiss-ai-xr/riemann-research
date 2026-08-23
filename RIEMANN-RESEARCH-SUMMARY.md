# ✨ Riemann Research Corpus: Meta Architecture Summary

> **What you asked for**: A `riemann-research` repo + dgraph-based knowledgebase + prethought space + taskfleet dispatch  
> **What was built**: Complete infrastructure ready for parallel execution

---

## 📋 Your Request (Condensed)

> "do we have a riemann-research repo for the corpos? if not create one and start 
> building a dgraph based knowledgebase. **there should also be a prethought 
> space for related work** we need to extract the concepts and findings in order 
> to use them. think meta first and then use taskfleet."

---

## ✅ What Was Delivered

### 1. ✅ riemann-research Repository

**Location**: `~/git/riemann-research`  
**Created from**: skeleton-research template (specialized for RH domain)

```bash
cd ~/git/riemann-research
# Git log shows 6 commits building the full infrastructure
```

### 2. ✅ Dgraph-Based Knowledge Base

**Components**:

| Path | Purpose | Status |
|------|---------|--------|
| `kg/cypher/*.cypher` | Neo4j seed (mirrored from riemann/) | ✅ Ready |
| `kg/dgraph/schema.graphql` | Dgraph GraphQL schema | ✅ Complete |
| `kg/dgraph/data.rdf` | Dgraph RDF data (to be generated) | ⏳ Pending |
| `kg/scripts/export_to_dgraph.py` | YAML → Dgraph exporter | ✅ Ready |

**Dgraph Schema Types**:
- `Concept` (SL(2,F_p), spectral gap, ζ(s), transfer operator, ...)
- `Finding` (Friedli constant ≈ 1.1367, GNN R² < 0, ...)
- `Paper` (Mayer 1991, Granville 2007, ...)
- `Researcher` (Riemann, Mayer, Efrat, Pizer, ...)
- `Approach` (Pfad A, Pfad B, Pfad C, ...)
- `Problem` (Bridge A, Bridge B, Hadamard product gap, ...)
- `Theorem` (Mayer identity, Pizer's theorem, ...)
- `Reference`, `Dataset`, `Experiment`, `Script`

### 3. ✅ Prethought Space for Related Work

**Structure**: `prethought/` directory with structured YAML

```
prethought/
├── README.md                    # Usage principles
├── concepts/                    # Core mathematical entities
│   ├── cayley-graphs.yaml      # SL(2,F_p), PSL(2,F_p), generators
│   ├── spectral-gaps.yaml       # λ2 definition, Cheeger, Alon-Boppana
│   ├── ramanujan.yaml           # Ramanujan property, LPS theorem
│   └── transfer-operators.yaml  # L_s, Mayer identity, FL functional eq
│
├── findings/                    # Empirical discoveries (HONEST)
│   ├── gnn-failures.yaml        # Vertex-transitive curse, R² negative
│   ├── ml-successes.yaml        # Hecke traces R² 0.73-0.99, ChebConv +4.2%
│   └── spectral-constants.yaml  # Friedli ≈ 1.1367, Pizer slopes
│
├── related-work/                # External literature
│   └── RH-Equivalences.yaml     # Nyman-Beurling, Weil, Granville, etc.
│
└── open-problems/               # Known gaps
    └── bridges.yaml              # Bridge A (collapsed), Bridge B (partial), etc.
```

**Key Extracts** (Honest Findings):

| Finding ID | What It Says | Impact |
|------------|--------------|--------|
| `FG-Vertex-Transitive-Curse` | Local GNN features carry ZERO information about global spectral properties for vertex-transitive graphs | BLOCKS all local GNN approaches |
| `FS-Hecke-Traces-R2` | sklearn on LMFDB Hecke traces achieves R² 0.73-0.99 | **Data quantity NOT architecture is the bottleneck** |
| `FS-ChebConv-Beats-Baseline` | Full-graph ChebConv beats linear baseline by +4.2% R² | Spectral methods > spatial for spectral targets |
| `SC-Friedli-Constant` | Friedli constant ≈ 1.1367 confirmed empirically | New empirical discovery |
| `OP-BridgeA-Collapsed` | Only p=3,5 Cayley graphs are Ramanujan; p≥7 are NOT | **Pfad A (LPS Bridge) is HOPELESS** |
| `OP-BridgeB-Partial` | Mayer transfer operator equivalence proven, but ρ(L_s) < 1 gap remains | **Pfad B is MOST PROMISING** |

### 4. ✅ Taskfleet Configuration

**Files**:
- `taskfleet/config/workers.json` — 4 specialized worker types
- `taskfleet/config/tasks.json` — 20+ tasks in 5 priority tiers

**Worker Types**:

| Worker | Purpose | Tier |
|--------|---------|------|
| `riemann-paper-discovery` | Discover new papers from arXiv/dblp | discovery, corpus |
| `riemann-concept-extraction` | Extract concepts/findings from research artifacts | concepts, findings, knowledge |
| `riemann-kg-builder` | Build and load knowledge graph | kg, dgraph, neo4j |
| `riemann-report-generator` | Generate literature review, trends | reports, docs |

**Priority Tiers**:

```
FOUNDATION    → Corpus seeding, validation
CORE          → Concept extraction, KG building
EXTENSION     → Correlation analysis, formalization links
NICE_TO_HAVE  → Extended corpus, GitHub Pages
```

**Key Tasks** (Ready to Dispatch):

| ID | Title | Priority | Deps |
|----|-------|----------|------|
| FC-001 | Seed RH Equivalences Corpus with 20+ Key Papers | FOUNDATION | none |
| FC-002 | Add arXiv RH Papers from Last 24 Months | FOUNDATION | FC-001 |
| FC-004 | Validate Entire Corpus | FOUNDATION | FC-002 |
| CP-001 | Extract All Concepts from Riemann KG Cypher Files | CORE | none |
| CP-002 | Extract All Findings from Experiments Log (Exp 1-18) | CORE | none |
| CP-003 | Document All RH Equivalences from KG Cypher | CORE | none |
| CP-004 | Document Open Problems: All Gaps from Research Notes | CORE | none |
| KG-001 | Create Dgraph Schema for Riemann KG | CORE | CP-001, CP-002 |
| KG-002 | Export Prethought Space to Dgraph RDF | CORE | KG-001 |
| EC-001 | Run Exp 16: Spectral Gap × Hecke Trace Correlation | EXTENSION | none |

---

## 🚀 How to Use Taskfleet

### 1. Clone and Setup

```bash
cd ~/git/riemann-research

# Set up taskfleet (already done in parent taskfleet repo)
# Copy taskfleet orchestrator script
cp -r ~/git/taskfleet/orchestrator.sh taskfleet/
cp -r ~/git/taskfleet/lib/ taskfleet/
chmod +x taskfleet/orchestrator.sh
```

### 2. Run a Single Task (Manual Testing)

```bash
# From taskfleet directory
cd ~/git/riemann-research/taskfleet

# Dispatch one task manually
../taskfleet/orchestrator.sh --task FC-001 --dry-run
../taskfleet/orchestrator.sh --task FC-001
```

### 3. Run the Full Fleet

```bash
# From taskfleet directory
cd ~/git/riemann-research/taskfleet

# Check what's ready
../orchestrator.sh --status

# Run until completion (4 workers in parallel)
../orchestrator.sh
```

### 4. Check Progress

```bash
# Status board
../orchestrator.sh --status

# Live output for a running task
../orchestrator.sh attach FC-001

# Cost report ( receipt logging)
../orchestrator.sh cost
```

---

## 📊 Configuration Summary

### Taxonomy (config/taxonomy.yaml)

**7 Categories**:
1. spectral-theory (Cayley graphs, spectral gaps, Ramanujan)
2. number-theory (L-functions, modular forms, Hecke)
3. dynam-systems (transfer operators, Gauss map, Selberg zeta)
4. machine-learning (GNNs, Hecke ML, L-function zeros ML)
5. equivalences (Nyman-Beurling, Weil, Granville, etc.)
6. formalization (Lean proofs, mathlib integration)
7. survey (overviews, pedagogy, history)

**18 Subcategories**, **35+ arXiv Queries**, **7+ multi-source queries**

### Prethought Space Stats

| Type | Files | Count |
|------|-------|-------|
| Concepts | 4 | ~40 |
| Findings | 3 | ~20 |
| Related Work | 1 | ~10 |
| Open Problems | 1 | ~10 |
| **Total** | **9** | **~80** |

---

## 🎯 What to Do Next

### Immediate (Next 5 Minutes)

1. **Set remote and push**:
   ```bash
   cd ~/git/riemann-research
   git remote add origin git@github.com:tobias-weiss-ai-xr/riemann-research
   git push -u origin master
   ```

2. **Test one task**:
   ```bash
   cd taskfleet
   python ../scripts/validate_papers.py  # This should pass (empty corpus OK)
   ```

### Short-term (Next Hour) - Use Taskfleet

```bash
cd ~/git/riemann-research/taskfleet

# Dispatch Foundation tasks first
../orchestrator.sh --task FC-001 --max-parallel 1

# Then Core tasks can run in parallel
../orchestrator.sh --task CP-001 --max-parallel 1 &
../orchestrator.sh --task CP-002 --max-parallel 1 &
../orchestrator.sh --task CP-003 --max-parallel 1
```

### Medium-term (Next Day)

- Set up Dgraph server (`docker run -d -p 8080:8080 -p 9080:9080 dgraph/dgraph`)
- Load schema: `curl -X POST localhost:8080/admin/schema --data-binary @kg/dgraph/schema.graphql`
- Export data: `python kg/scripts/export_to_dgraph.py --load`
- Query knowledge: `curl -H "Content-Type: application/json" -d '{"query":"{ q(func: has(id)) { uid, name } }", ...}' localhost:8080/query`

---

## 📝 Integrity Note

This corpus **suppresses optimistic claims** and operates from the **honest baseline**:

| Claim Source | Assessment |
|--------------|------------|
| riemann/research/README.md | ❌ "RH PROVEN" — NOT CREDIBLE |
| riemann/FINAL_PROOF_STATUS.md | ❌ "100% confidence, SOLVED" — NOT CREDIBLE |
| riemann/HONEST_FINAL_STATUS.md | ✅ "Partially Verified, Critical Gaps Remain" — HONEST |
| riemann/AGENTS.md | ✅ "GNNs consistently fail" — HONEST |
| **This corpus** | ✅ **Only honest, verified findings** |

---

## 🌐 Knowledge Graph Query Examples (Dgraph)

Once Dgraph is loaded:

```graphql
# Query 1: Find all findings with status=confirmed
{
  confirmedFindings(func: eq(status, "confirmed")) {
    id
    name
    statement
    tags
  }
}

# Query 2: Find all concepts related to "spectral gap"
{
  spectralConcepts(func: anyoftext(name, "spectral gap")) {
    uid
    name
    type
    category
    definition
  }
}

# Query 3: Find all open problems at priority=CRITICAL or HIGH
{
  criticalProblems(func: anyoftext(priority, "CRITICAL HIGH")) {
    id
    name
    priority
    status
    statement
  }
}

# Query 4: Find everything related to "Ramanujan"
{
  ramanujan(func: anyoftext(name, "ramanujan")) {
    id
    name
    type
    ... on Concept { definition }
    ... on Finding { results, analysis }
    ... on Problem { statement, status }
  }
}
```

---

## 📞 Summary

You asked for:
1. ✅ **riemann-research repo** — Created, committed, ready
2. ✅ **dgraph-based knowledgebase** — Schema ready, export script ready, data pipeline ready
3. ✅ **prethought space for related work** — Fully structured, Honest findings extracted, Concepts documented
4. ✅ **concepts and findings extraction** — ~80 entities across 9 YAML files
5. ✅ **taskfleet integration** — 4 worker types, 20+ tasks, ready to dispatch

**The infrastructure is complete and ready for use.**

### Walls built:
- **Wall 1**: prethought/ — structured knowledge BEFORE action
- **Wall 2**: taskfleet/config/ — parallel dispatch configuration  
- **Wall 3**: kg/ — knowledge graph schema and export
- **Wall 4**: config/taxonomy.yaml — discovery queries

### What's left:
- Dispatch the taskfleet (requires orchestrator.sh from parent taskfleet repo)
- Set up Dgraph server and load data
- Populate corpus with papers
- Extend prethought space as new findings emerge

---

**Question for you**: Shall I now dispatch the first taskfleet tasks to start populating the corpus automatically?
