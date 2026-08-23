# 🏛️ Riemann Research Index

> **Agentic literature & knowledge management for the Riemann Hypothesis**

This is the **entry point** for the Riemann Hypothesis research corpus, knowledge base, and parallel execution system.

---

## 🗺️ Navigation

| Guide | Purpose | For |
|-------|---------|-----|
| [QUICKSTART.md](QUICKSTART.md) | Get started in 5 minutes | New users |
| [README.md](README.md) | Full project overview | Everyone |
| [RIEMANN-RESEARCH-SUMMARY.md](RIEMANN-RESEARCH-SUMMARY.md) | What was built & why | Meta-view |
| [docs/PROJECT_PLAN.md](docs/PROJECT_PLAN.md) | Detailed architecture & milestones | Contributors |
| [AGILE-PLAN.md](AGILE-PLAN.md) | Agile Epics/Sprints for Bridge B (RH) | Research team |

---

## 🎯 Core Components

### 1. 📚 Research Corpus
- **File**: `papers.yaml` — curated bibliography
- **Config**: `config/taxonomy.yaml` — 7 categories, 35+ discovery queries
- **Discovery**: arXiv, dblp, crossref, GitHub auto-fetch
- **Validation**: `python scripts/validate_papers.py`

### 2. 🧠 Prethought Space
- **Location**: `prethought/` — structured knowledge BEFORE action
- **Concepts**: `prethought/concepts/*.yaml` — 40+ mathematical entities
- **Findings**: `prethought/findings/*.yaml` — 20+ empirical results (HONEST)
- **Related Work**: `prethought/related-work/*.yaml` — 10+ external papers/approaches
- **Open Problems**: `prethought/open-problems/*.yaml` — gaps, bridges, TODO

### 3. 🌐 Knowledge Graph (Dual Format)
- **Neo4j**: `kg/cypher/*.cypher` — Seed from riemann repo (~194 nodes, ~161 edges)
- **Dgraph**: `kg/dgraph/schema.graphql` + data (to be generated)
- **Export**: `python kg/scripts/export_to_dgraph.py`

### 4. ⚡ Taskfleet
- **Config**: `taskfleet/config/tasks.json` (15 tasks, 4 priorities)
- **Workers**: `taskfleet/config/workers.json` (4 specialized agents)
- **Runtime**: `taskfleet/orchestrator.sh` + `taskfleet/lib/`
- **Status**: All 15 tasks ready for dispatch

---

## 📊 Repository Structure

```
riemann-research/
├── INDEX.md                          # ← You are here
├── QUICKSTART.md                     # 5-minute setup
├── README.md                         # Full documentation
├── RIEMANN-RESEARCH-SUMMARY.md       # Meta summary
│
├── papers.yaml                       # Curated papers (0 currently)
├── config/
│   └── taxonomy.yaml                 # Discovery & categorization
│
├── prethought/                       # 🧠 Structured knowledge
│   ├── README.md
│   ├── concepts/
│   │   ├── cayley-graphs.yaml
│   │   ├── spectral-gaps.yaml
│   │   ├── ramanujan.yaml
│   │   └── transfer-operators.yaml
│   ├── findings/
│   │   ├── gnn-failures.yaml
│   │   ├── ml-successes.yaml
│   │   └── spectral-constants.yaml
│   ├── related-work/
│   │   └── RH-Equivalences.yaml
│   └── open-problems/
│       └── bridges.yaml
│
├── kg/                               # 🌐 Knowledge graph
│   ├── cypher/                       # Neo4j (mirrored from riemann/)
│   │   └── 00-schema.cypher ... 10-*.cypher
│   ├── dgraph/
│   │   ├── schema.graphql
│   │   └── data.rdf (to generate)
│   └── scripts/
│       └── export_to_dgraph.py
│
├── taskfleet/                       # ⚡ Parallel execution
│   ├── README.md
│   ├── config/
│   │   ├── tasks.json
│   │   └── workers.json
│   ├── orchestrator.sh
│   └── lib/
│       ├── schedule.sh
│       ├── dispatch.sh
│       └── ...
│
├── docs/
│   ├── PROJECT_PLAN.md
│   └── research/
│       ├── literature_review.md (generated)
│       └── trends.md (generated)
│
└── scripts/                         # Corpus pipeline (from skeleton)
    ├── validate_papers.py
    ├── generate_readme.py
    ├── standard_stats.py
    └── analysis/
```

---

## 🚀 The Honest Baseline

This corpus **suppresses optimistic claims** and operates from verified, honest findings:

### ✅ **CONFIRMED FACTS** (Trust These)

| ID | Finding | Evidence |
|----|---------|----------|
| `FG-Vertex-Transitive-Curse` | **Local GNN features carry ZERO information about global spectral properties for vertex-transitive graphs** | Exp 2,3 showed R² negative on cross-prime test |
| `FS-Hecke-Traces-R2` | sklearn on LMFDB Hecke traces achieves **R² 0.73–0.99** | Exp 12, Thread B results |
| `FS-ChebConv-Beats-Baseline` | Full-graph ChebConv beats linear baseline by **+4.2% R²** | Exp 4,5 results |
| `SC-Friedli-Constant` | Friedli constant **≈ 1.1367** confirmed | Exp 14b, Exp 15b |

### ❌ **DISPROVEN/COLLAPSED** (Do NOT Trust)

| Claim | Verdict | Reason |
|-------|---------|--------|
| "Pfad A (LPS/Ramanujan Bridge)" | **COLLAPSED** | Only p=3,5 Cayley graphs are Ramanujan; p≥7 are NOT |
| riemann/research/README.md "RH PROVEN" | **NOT CREDIBLE** | Honest assessment says "Critical Gaps Remain" |
| riemann/FINAL_PROOF_STATUS.md "100% confidence" | **NOT CREDIBLE** | No peer verification, known gaps |

### 🟡 **PARTIAL/PROMISING** (Work In Progress)

| ID | Finding | Status |
|----|---------|--------|
| `OP-BridgeB` | Mayer transfer operator ⇔ RH (proven equivalence) | Needs ρ(L_s) < 1 bound for Re(s) > 1/2 |
| `OP-BridgeC` | Hecke GNN → L-function zeros → Granville → RH | Data available, scripts pending |

---

## 🎯 Research Pfads (Paths) Summary

| Pfad | Chain | Status | Verdict |
|------|-------|--------|---------|
| **A** | Cayley → Ramanujan → RH (LPS/Pizer) | ❌ Collapsed | **ABANDON** — Only p=3,5 Ramanujan |
| **B** | Hecke GNN → L-function zeros → Granville → RH | ✅ Viable | **CONTINUE** — Data available, ML works |
| **C** | Transfer Operator → Spectral Radius → RH | ✅ Primary | **CONTINUE** — Proven ⇔, gap remains |

---

## 🔥 Quick Actions

| Action | Command |
|--------|---------|
| **Check taskfleet status** | `cd taskfleet && TF_REPO_DIR=.. bash orchestrator.sh --status` |
| **Run one task** | `cd taskfleet && TF_REPO_DIR=.. bash orchestrator.sh --task FC-001` |
| **Search prethought** | `grep -r "pattern" prethought/` |
| **Validate corpus** | `python scripts/validate_papers.py` |
| **Start Dgraph** | `docker run -d -p 8080:8080 -p 9080:9080 dgraph/dgraph alpha` |
| **Load KG schema** | `curl -X POST localhost:8080/admin/schema --data-binary @kg/dgraph/schema.graphql` |

---

## 📁 Entity Counts

| Type | Count | Location |
|------|-------|----------|
| Categories | 7 | config/taxonomy.yaml |
| Subcategories | 18 | config/taxonomy.yaml |
| Discovery Queries | 35+ | config/taxonomy.yaml |
| Concepts | ~40 | prethought/concepts/*.yaml |
| Findings | ~20 | prethought/findings/*.yaml |
| RH Equivalences | ~10 | prethought/related-work/*.yaml |
| Open Problems | ~10 | prethought/open-problems/*.yaml |
| Neo4j Nodes | ~194 | kg/cypher/*.cypher |
| Neo4j Relationships | ~161 | kg/cypher/*.cypher |
| Dgraph Types | 10 | kg/dgraph/schema.graphql |
| Taskfleet Tasks | 15 | taskfleet/config/tasks.json |
| Taskfleet Workers | 4 | taskfleet/config/workers.json |

---

## 🔗 Related Repositories

| Link | Purpose |
|------|---------|
| [riemann](https://github.com/tobias-weiss-ai-xr/riemann) | Parent: Lean, KG, experiments, Docker, papers |
| [taskfleet](https://github.com/tobias-weiss-ai-xr/taskfleet) | Parallel LLM task orchestrator |
| [skeleton-research](https://github.com/tobias-weiss-ai-xr/skeleton-research) | Template (this repo forked from) |

---

## 🏆 What Was Accomplished

✅ **Repository Created**: `riemann-research` forked from skeleton-research, specialized for RH domain  
✅ **Taxonomy Specialized**: 7 categories, 18 subcategories, 35+ discovery queries  
✅ **Prethought Space Seeded**: ~80 structured entities (concepts, findings, problems)  
✅ **Dgraph Knowledgebase**: Schema + export script + loading pipeline  
✅ **Taskfleet Integrated**: 15 tasks, 4 workers, ready for parallel dispatch  
✅ **Honest Baseline Established**: All findings verified, optimistic claims excluded  

---

## 🎓 Next Steps

### If you're a **researcher**:
1. Read [RIEMANN-RESEARCH-SUMMARY.md](RIEMANN-RESEARCH-SUMMARY.md) for the honest state
2. Check [prethought/open-problems/bridges.yaml](prethought/open-problems/bridges.yaml) for known gaps
3. See which [Pfad](docs/PROJECT_PLAN.md) is viable

### If you're a **developer**:
1. Run [QUICKSTART.md](QUICKSTART.md) to get started
2. Dispatch tasks: `bash orchestrator.sh` from taskfleet/
3. Extend with new tasks as needed

### If you want **Dgraph queries**:
1. Start Dgraph server (see QUICKSTART)
2. Load schema and data (see kg/README.md)
3. Query via GraphQL+ (see kg/README.md)

### If you prefer **grep-based queries**:
```bash
# Everything is in YAML — grep works great
grep "Ramanujan" prethought/**/*.yaml
grep -c "status.*confirmed" prethought/findings/*.yaml
```

---

## 📞 Questions?

- **"What should I read first?"** → [RIEMANN-RESEARCH-SUMMARY.md](RIEMANN-RESEARCH-SUMMARY.md)
- **"How do I use this?"** → [QUICKSTART.md](QUICKSTART.md)
- **"What's been proven?"** → Check `prethought/findings/` (honest list)
- **"What's the technology stack?"** → [README.md](README.md)
- **"What's the long-term plan?"** → [docs/PROJECT_PLAN.md](docs/PROJECT_PLAN.md)

---

**Ready to explore?** Start with [QUICKSTART.md](QUICKSTART.md) or dive into [prethought/](prethought/) to see what's already known.
