# ⚡ Quick Start: Riemann Research Corpus

Get the corpus, knowledge graph, and taskfleet up and running in 5 minutes.

---

## 1️⃣ Clone & Setup

```bash
cd ~/git
git clone git@github.com:tobias-weiss-ai-xr/riemann-research
cd riemann-research
```

---

## 2️⃣ Explore the Structure

```bash
# Repository structure
tree -L 2 --dirsfirst -I '.git'

# Key directories:
ls -la prethought/            # Structured knowledge (concepts, findings, etc.)
ls -la kg/                    # Knowledge graph (Dgraph + Neo4j)
ls -la taskfleet/config/     # Taskfleet configuration
```

---

## 3️⃣ Query the Prethought Space

```bash
# Find all findings about GNNs
grep -r "gnn\|GNN" prethought/findings/

# Find concepts related to spectral gaps
grep -r "spectral.*gap\|gap.*spectral" prethought/concepts/

# List all open problems
grep "^  - id:" prethought/open-problems/*.yaml

# Find everything about Friedli
grep -r "Friedli" prethought/
```

---

## 4️⃣ Run Taskfleet

Taskfleet automates corpus population, concept extraction, and KG building with parallel LLM workers.

```bash
cd taskfleet

# Set repo root for worktree resolution
export TF_REPO_DIR=$(cd .. && pwd)

# Check status of all 15 tasks
bash orchestrator.sh --status

# Run FOUNDATION tasks first (corpus setup)
bash orchestrator.sh --task FC-001  # Seed papers
bash orchestrator.sh --task FC-002  # Fetch arXiv
bash orchestrator.sh --task FC-004  # Validate

# Then run in parallel
bash orchestrator.sh --max-parallel 4

# Watch a task live
bash orchestrator.sh attach FC-002

# Check cost / history
bash orchestrator.sh cost
```

---

## 5️⃣ Set Up Dgraph Knowledge Graph

```bash
# Start Dgraph (Docker)
docker run -d --name dgraph-zero -p 5080:5080 dgraph/dgraph zero
docker run -d --name dgraph-alpha -p 8080:8080 -p 9080:9080 \
  dgraph/dgraph alpha --zero dgraph-zero:5080

# Apply schema
curl -X POST localhost:8080/admin/schema \
  --data-binary @kg/dgraph/schema.graphql

# Export and load prethought data
python kg/scripts/export_to_dgraph.py --load
```

---

## 6️⃣ Query Dgraph

```bash
# Basic query: list all concepts
curl -H "Content-Type: application/json" \
  -d '{"query": "{ q(func: has(dgraph.type)) { uid, name @filter(eq(dgraph.type, \"Concept\")) } }"}' \
  http://localhost:8080/query

# Find all confirmed findings
curl -H "Content-Type: application/json" \
  -d '{"query": "{ q(func: eq(status, \"confirmed\")) { uid, name, statement } }"}' \
  http://localhost:8080/query

# Find vertex-transitive concepts
curl -H "Content-Type: application/json" \
  -d '{"query": "{ q(func: anyoftext(tags, \"vertex-transitive\")) { uid, name, definition } }"}' \
  http://localhost:8080/query
```

Use [Dgraph Ratel UI](http://localhost:8000) for interactive querying.

---

## 7️⃣ Add a New Paper

```bash
# Edit papers.yaml
nano papers.yaml

# Add a paper entry
cat >> papers.yaml << 'EOF'
- id: new-paper-2025
  title: "New Results on Spectral Gaps"
  authors: ["A. Researcher", "B. Scientist"]
  date: 2025-01
  url: "https://arxiv.org/abs/2501.12345"
  venue: "arXiv preprint"
  category: spectral-theory
  subcategory: spectral-gaps
  abstract: "Latest findings on spectral gaps..."
  doi: "10.48550/arXiv.2501.12345"
  status: new
  tags: ["spectral-gap", "cayley-graphs"]
EOF

# Validate
python scripts/validate_papers.py

# Re-generate reports
python scripts/generate_readme.py
python scripts/analysis/generate_reports.py

# Commit
git add papers.yaml && git commit -m "Add new-paper-2025"
```

---

## 8️⃣ Add a New Finding

```bash
# Edit or create a findings file
nano prethought/findings/new-experiment.yaml

# Add a finding
cat >> prethought/findings/new-experiment.yaml << 'EOF'
- id: FG-New-Finding-2025
  name: "New Experimental Result"
  type: finding
  category: machine-learning
  subcategory: gnn-fullgraph
  experiment: [Exp-19]
  date: 2025-01-23
  statement: "GNNs with X feature engineering achieve R² > 0.8"
  configuration:
    model: ChebConv
    layers: 5
    hidden_dim: 256
  results:
    train_r2: 0.85
    test_r2: 0.82
  analysis: "Feature X is the key predictor"
  status: confirmed
  confidence: high
  tags: ["chebconv", "high-R2", "new-features"]
EOF

# Commit
git add prethought/findings/new-experiment.yaml
 git commit -m "Add new experimental finding"
```

---

## 9️⃣ Alternative: Pure grep-based Knowledge Discovery

Dgraph is optional. Without Dgraph, use grep for query-like functionality:

```bash
# Find all R² values in findings
rg "R[²2]" prethought/findings/

# Find all negative R² results (GNN failures)
rg "R[²2].*-?[0-9]" prethought/findings/

# Find all verified findings
rg "status:.*confirmed" prethought/findings/

# Count findings by status
rg "status:" prethought/findings/ | sort | uniq -c | sort -rn

# Find all open problems
rg "^  - id:" prethought/open-problems/

# Find concepts with Lean formalization
rg "lean_status" prethought/concepts/
```

---

## 🚀 Common Workflows

### Discover new papers from arXiv
```bash
python scripts/fetch/fetch_new_papers.py --months 12
python scripts/validate_papers.py
```

### Regenerate all reports
```bash
python scripts/analysis/generate_reports.py
python scripts/generate_readme.py
python scripts/standard_stats.py
```

### Validate everything
```bash
python scripts/validate_papers.py
```

---

## 🔗 Related Repositories

| Repo | Purpose |
|------|---------|
| [riemann](https://github.com/tobias-weiss-ai-xr/riemann) | Parent: Lean formalization, KG, experiments, Docker |
| [taskfleet](https://github.com/tobias-weiss-ai-xr/taskfleet) | Task orchestrator (upstream) |
| [skeleton-research](https://github.com/tobias-weiss-ai-xr/skeleton-research) | Template (forked from) |

---

## 💡 Tips

1. **Always check the prethought space first** before starting new work
2. **Use taskfleet for multi-step workflows** — it handles dependencies and retries
3. **Start with FOUNDATION tasks** before moving to CORE or EXTENSION
4. **Dgraph is optional** — grep-based queries work fine for most use cases
5. **The honest findings are in `prethought/findings/`** — trust these over optimistic claims

---

## ❓ Help

- **Taskfleet**: See `taskfleet/README.md`
- **Knowledge Graph**: See `kg/README.md`
- **Prethought Space**: See `prethought/README.md`
- **Corpus Pipeline**: See `README.md`

---

**You're ready!** Start with:
```bash
# If you have pi-coding-agent running as a service:
export TF_REPO_DIR=~/git/riemann-research/taskfleet
cd ~/git/riemann-research/taskfleet
bash orchestrator.sh --status
bash orchestrator.sh --task FC-001 --dry-run  # Test one
bash orchestrator.sh --task FC-001            # Run one
```
