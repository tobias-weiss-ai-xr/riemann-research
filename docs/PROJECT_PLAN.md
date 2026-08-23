# Riemann Research: Meta Project Plan

> **Version**: 1.0  
> **Date**: 2025-01  
> **Status**: Active Development  
> **Repo**: https://github.com/tobias-weiss-ai-xr/skeleton-riemann → **NOW**: https://github.com/tobias-weiss-ai-xr/riemann-research

---

## 🎯 Executive Summary

**Goal**: Build a structured research corpus, knowledge base, and parallel execution system for the Riemann Hypothesis project.

**Problem**: The parent [riemann](https://github.com/tobias-weiss-ai-xr/riemann) repo contains rich research artifacts (18+ experiments, Lean formalization, Neo4j KG, 53k LMFDB records) but the **knowledge is fragmented** across markdown files, experiment logs, Python scripts, Lean files, and Cypher scripts. There is no unified, queryable knowledge base.

**Worse**: There are **inconsistent claims** — some files state "RH PROVEN" while others honestly state "Partially Verified, Critical Gaps Remain."

**Solution**: Create a **riemann-research** corpus repo with:

1. **📚 Research Corpus** — Fork skeleton-research, specialize taxonomy to RH/number theory/spectral theory
2. **🧠 Prethought Space** — Structured YAML files capturing concepts, findings, related work, open problems
3. **🌐 Knowledge Graph** — Dgraph + Neo4j knowledge graph of all entities and relationships
4. **⚡ Taskfleet** — Parallel LLM task dispatch for corpus population, extraction, KG building

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         riemann-research/                                │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                           │
│  ┌─────────────┐     ┌─────────────┐    ┌─────────────────────────────┐ │
│  │ papers.yaml │────▶│ taxonomy    │    │                              │ │
│  │             │     │ config/     │    │                              │ │
│  └─────────────┘     └─────────────┘    │                              │ │
│          ▲                    │             │                              │ │
│          │                    ▼             │  ⚡ taskfleet/               │ │
│          │         ┌─────────────────────▼──────────────────┐          │ │
│          │         │            prethought/                   │          │ │
│          │         │   ┌──────────┐ ┌──────────┐ ┌────────┐  │          │ │
│          │         │   │ concepts/ │ │ findings/ │ │related / │  │          │ │
│          │         │   │ * Right   │ │ size ↓   │ │ in      │  │          │ │
│          │         │   └──────────┘ └──────────┘ └────────┘  │          │ │
│          │         │                                              │          │ │
│          │         │         Knowledge Graph Layer               │          │ │
│          │         │   ┌──────────────┐   ┌──────────────┐    │          │ │
│          │         │   │  kg/cypher/  │   │ kg/dgraph/   │    │          │ │
│          │         │   │   (Mirror)   │   │  (slant)     │    │          │ │
│          │         │   └──────────────┘   └──────────────┘    │          │ │
│          │         └──────────────────────────────────────────────┘          │ │
│          │                                                     By           │ │
│          └──────────────────────┬────────────────────────────────────────┘ │
│                              jobs                                  S        │
│  ┌──────────────────────────────────────────────────────┐ ... - ┘        │
│  │                  Skeleton  (Upstream)                │                   │
└──┴──────────────────────────────────────────────────────┘───────────────────┘
    ▲                                           ▲
    │                                           │
    └────── Mirror Cypher──────────────────────┘
                 from riemann/

```

---

## 📁 Repository Structure

```
riemann-research/
├── README.md                          # This project overview
├── papers.yaml                        # Curated bibliography
├── config/
│   └── taxonomy.yaml                  # Categories, queries, discovery
├── prethought/                        # 🧠 Prethought Space
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
├── kg/                                 # 🌐 Knowledge Graph
│   ├── cypher/                         # Neo4j (mirrored from riemann/)
│   │   ├── 00-schema.cypher
│   │   ├── 01-groups.cypher
│   │   └── ... 10 files
│   ├── dgraph/
│   │   ├── schema.graphql
│   │   └── data.rdf (generated)
│   └── scripts/
│       └── export_to_dgraph.py
├── taskfleet/                         # ⚡ Taskfleet
│   └── config/
│       ├── workers.json               # 4 specialized worker types
│       └── tasks.json                 # 20+ tasks in 5 priority tiers
├── docs/
│   ├── research/
│   │   ├── literature_review.md       # Auto-generated
│   │   └── trends.md                  # Auto-generated
│   └── PROJECT_PLAN.md                # This file
└── scripts/                           # Corpus pipeline (from skeleton)
    └── ...
```

---

## 📊 Current Status (as of 2025-01)

| Component | Status | Details |
|-----------|--------|---------|
| **Repository** | ✅ Created | Forked skeleton-research, specialized |
| **Taxonomy** | ✅ Complete | 7 categories, 18 subcategories, 35+ arXiv queries |
| **Prethought Space** | ✅ Seeded | ~12 YAML files, ~40 concepts, ~20 findings |
| **Concepts** | ✅ 4 files | Cayley graphs, spectral gaps, Ramanujan, transfer operators |
| **Findings** | ✅ 3 files | GNN failures, ML successes, spectral constants |
| **Related Work** | ✅ 1 file | RH equivalences (9+ entries) |
| **Open Problems** | ✅ 1 file | Bridges A/B, data gaps, formalization gaps, Hadamard |
| **Neo4j KG** | ✅ Mirrored | 10 cypher files, ~194 nodes, ~161 relationships |
| **Dgraph Schema** | ✅ Complete | GraphQL schema with 10+ types |
| **Dgraph Export** | ✅ Ready | export_to_dgraph.py (RDF + GraphQL mutations) |
| **Taskfleet Config** | ✅ Complete | workers.json + tasks.json (20+ tasks) |

---

## 🎯 Phases & Milestones

### Phase 0: Foundation ✅ **COMPLETE**

**Milestone M0**: Repository structure, taxonomy, prethought space seed, taskfleet config.

| Task | ID | Status | Owner |
|------|-----|--------|-------|
| Fork skeleton-research → riemann-research | - | ✅ | User |
| Specialize taxonomy.yaml for RH domain | - | ✅ | User |
| Create prethought/ structure | - | ✅ | User |
| Extract initial concepts fromKG cypher | CP-001 | ⏳ | Taskfleet |
| Extract initial findings from experiments | CP-002 | ⏳ | Taskfleet |
| Document RH equivalences | CP-003 | ⏳ | Taskfleet |
| Document open problems | CP-004 | ⏳ | Taskfleet |
| Create Dgraph schema | KG-001 | ✅ | User |
| Create export script | KG-002 | ✅ | User |
| Configure taskfleet | - | ✅ | User |

---

### Phase 1: Corp

**Mil

---
