# Dgraph Knowledge Base - Files Generated

## 📁 Generated Files

| File | Size | Format | Purpose |
|------|------|--------|---------|
| `data.rdf` | 44 KB | RDF N-Triples | Raw triples for Dgraph loading |
| `data.mutations` | 49 KB | GraphQL+- | Mutation form for Dgraph loading |
| `docker-compose.yml` | 0.7 KB | Docker Compose | Start Dgraph (zero, alpha, ratel) |
| `load_kg.sh` | 3.2 KB | Bash script | Load schema + data into Dgraph |

## 🔧 How to Load

### 1. Start Dgraph

```bash
cd kg/dgraph
docker compose up -d
```

This starts:
- `dgraph-zero` (port 5080) - Cluster coordination
- `dgraph-alpha` (port 8080/9080) - Data server
- `dgraph-ratel` (port 8000) - GraphQL UI

### 2. Load Schema + Data

```bash
# Load with RDF (faster)
./load_kg.sh

# Or load with GraphQL mutations (alternative)
./load_kg.sh --mutations

# Reset everything first (wipes all data)
./load_kg.sh --reset
```

### 3. Query the Knowledge Graph

```bash
# Query 1: List all Concept nodes
curl -H "Content-Type: application/json" \
  -d '{"query": "{ q(func: has(dgraph.type)) { uid, name @filter(eq(dgraph.type, \"Concept\")) } }"}' \
  http://localhost:8080/query

# Query 2: Find all confirmed findings
curl -H "Content-Type: application/json" \
  -d '{"query": "{ q(func: eq(status, \"confirmed\")) { uid, name, statement } }"}' \
  http://localhost:8080/query

# Query 3: Find vertex-transitive concepts
curl -H "Content-Type: application/json" \
  -d '{"query": "{ q(func: anyoftext(tags, \"vertex-transitive\")) { uid, name, definition } }"}' \
  http://localhost:8080/query

# Query 4: Find all open problems
curl -H "Content-Type: application/json" \
  -d '{"query": "{ q(func: has(open_problems)) { uid, name, priority, status } }"}' \
  http://localhost:8080/query
```

## 📊 Contents Summary

### Extracted from Prethought Space

| Type | Count | Examples |
|------|-------|----------|
| Concepts | ~40 | Cayley graphs, spectral gaps, Ramanujan property, transfer operators |
| Findings | ~20 | GNN failures, ML successes, spectral constants |
| Open Problems | ~10 | Bridge A, Bridge B, data gaps, formalization gaps |
| Related Work | ~10 | RH equivalences (Nyman-Beurling, Weil, Granville, etc.) |

### Dgraph Types Used

From `schema.graphql`:
- `Concept` - Mathematical concepts
- `Finding` - Empirical discoveries
- `Paper` - Research papers
- `Researcher` - Authors
- `Approach` - Methodologies
- `Problem` - Open problems
- `Reference` - Cross-references
- `Dataset` - Data collections
- `Theorem` - Formal theorems
- `Experiment` - Experimental runs
- `Script` - Code scripts

### Sample RDF Output

```turtle
<FG-Vertex-Transitive-Curse> <dgraph.type> "Finding" .
<FG-Vertex-Transitive-Curse> <name> "Vertex-transitive curse: Local GNN features cannot predict global spectral properties" .
<FG-Vertex-Transitive-Curse> <category> "machine-learning" .
<FG-Vertex-Transitive-Curse> <status> "confirmed" .
<FG-Vertex-Transitive-Curse> <confidence> "very-high" .
<FG-Vertex-Transitive-Curse> <tags> "gnn" .
<FG-Vertex-Transitive-Curse> <tags> "vertex-transitive" .
<FG-Vertex-Transitive-Curse> <tags> "spectral" .
```

### Sample GraphQL+ Mutation

```graphql
{
  set {
    <FG-Vertex-Transitive-Curse> <dgraph.type> "Finding" .
    <FG-Vertex-Transitive-Curse> <name> "Vertex-transitive curse: Local GNN features cannot predict global spectral properties" .
    <FG-Vertex-Transitive-Curse> <category> "machine-learning" .
    <FG-Vertex-Transitive-Curse> <status> "confirmed" .
    <FG-Vertex-Transitive-Curse> <confidence> "very-high" .
    <FG-Vertex-Transitive-Curse> <tags> "gnn" .
    <FG-Vertex-Transitive-Curse> <tags> "vertex-transitive" .
    <FG-Vertex-Transitive-Curse> <tags> "spectral" .
  }
}
```

## 🎯 Next Steps

1. **Start Dgraph**: `docker compose up -d`
2. **Load KB**: `./load_kg.sh`
3. **Query**: Use Ratel UI at http://localhost:8000
4. **Extend**: Add more papers to `prethought/` and re-export

## 📝 regeneration

To regenerate all KB files:

```bash
# Re-export from prethought space
python kg/scripts/export_to_dgraph.py --format rdf --output kg/dgraph/data.rdf
python kg/scripts/export_to_dgraph.py --format mutations --output kg/dgraph/data.mutations

# Commit new data
cd ..
git add kg/dgraph/data.*
git commit -m "KG: Regenerate RDF and mutations from updated prethought space"
```

## 🔗 Queries Documentation

See `kg/README.md` for full query documentation and examples.

## 💡 Notes

- The export script automatically resolves references between entities
- All `prethought/**/*.yaml` files are included
- `papers.yaml` is also included as Paper nodes
- Tags are indexed for fast querying
- The schema includes both node types and relationship predicates

---

**Status**: ✅ **Ready for Dgraph loading**

All files are generated and committed. Docker Compose configuration is ready.
When Docker Desktop is available, run `docker compose up -d && ./load_kg.sh`.
