# Knowledge Graph Layer

This directory contains knowledge graph artifacts in multiple formats:

```
kg/
├── cypher/                  # Neo4j Cypher scripts (mirrored from riemann/knowledge-graph/)
│   ├── 00-schema.cypher     # Node types + constraints + indexes
│   ├── 01-groups.cypher     # SL(2,Z), PSL(2,Z), SL(2,F_p),щт, etc.
│   ├── 02-graphs.cypher    # Cayley graphs, spectral gaps, Ramanujan property
│   ├── 03-functions.cypher # ζ(s), L(s), Selberg zeta, Pressure function
│   ├── 04-operators.cypher # Transfer operator, Hecke, Adjacency, Brandt
│   ├── 05-theorems.cypher  # RH equivalences, Mayer identity, Weil criterion
│   ├── 06-papers-approaches.cypher  # Papers + AI approaches
│   ├── 07-rh-equivalences.cypher # RH equivalence class
│   ├── 08-papers-extended.cypher
│   ├── 09-graphs-extended.cypher
│   └── 10-rh-equivalences-extended.cypher
│
├── dgraph/                  # Dgraph GraphQL schema + data
│   ├── schema.graphql       # GraphQL schema (to be created)
│   ├── data.rdf             # RDF triples (to be created)
│   └── scripts/
│       └── export_to_dgraph.py  # Conversion script (to be created)
│
└── README.md               # This file
```

## Neo4j KG (cypher/)

The Neo4j knowledge graph encodes the **SL(2,Z) → ζ(s) theory chain** in Cypher:

- **Nodes**: Group, Graph, MathFunction, Operator, Theorem, Paper, Researcher, Approach, Conjecture
- **Relationships**: HAS_SUBGROUP, HAS_CAYLEY_GRAPH, HAS_SPECTRUM, ACTS_ON, CORRESPONDS_TO, GENERALIZES, IMPLIES, STATES, ABOUT, PROVES, PROPOSES, CITES, AUTHORED, TARGETS, USES_CONCEPT, BASED_ON, BRIDGE, ANALOGOUS_TO, COMPUTED_VIA, EQUIVALENT_TO

**Current stats**: ~194 nodes, ~161 relationships across 10 Cypher files.

This KG is a **static seed** — the canonical living KG lives in the parent [riemann](https://github.com/tobias-weiss-ai-xr/riemann) repo at `knowledge-graph/`.

## Dgraph KG (dgraph/)

The Dgraph knowledge graph will encode the **structured prethought space** + **corpus**:

- **Node types**: Concept, Finding, Paper, Approach, Problem, Researcher, Dataset
- **Predicate types**: relates_to, implies, contradicts, proven_by, disproven_by, referenced_by, implies_open, blocks, equivalent_to, generalizes, specializes_of, etc.

### Planned Schema (schema.graphql)

```graphql
# Main types
type Concept @index(exact: [.id]) {
  id: ID!
  name: String! @index(term)
  type: String @index(exact)
  category: String @index(exact)
  subcategory: String @index(exact)
  definition: String
  properties: [String!]
  references: [Reference!]
  tags: [String!] @index(term)
}

type Finding @index(exact: [.id]) {
  id: ID!
  name: String! @index(term)
  type: String @index(exact)
  category: String @index(exact)
  subcategory: String @index(exact)
  statement: String
  experiment: [String!]
  date: String
  configuration: JSON
  results: JSON
  analysis: String
  status: String @index(exact)  # confirmed | disproven | unverified | partial | unknown
  confidence: String @index(exact)  # low | medium | high | very-high
  tags: [String!] @index(term)
}

type Paper @index(exact: [.id]) {
  id: ID!
  title: String! @index(term)
  authors: [Res sprcher!]
  date: String
  url: String!
  venue: String
  abstract: String
  doi: String
  category: String @index(exact)
  subcategory: String @index(exact)
  tags: [String!] @index(term)
}

type Approach @index(exact: [.id]) {
  id: ID!
  name: String! @index(term)
  description: String
  strategy: String
  confidence: Float
  status: String @index(exact)
  targets: [Problem!]
  uses_concepts: [Concept!]
  referenced_by: [Paper!]
}

type Problem @index(exact: [.id]) {
  id: ID!
  name: String! @index(term)
  statement: String!
  priority: String @index(exact)  # CRITICAL | HIGH | MEDIUM | LOW
  status: String @index(exact)  # open | partial | resolved | disproven
  difficulty: String @index(exact)
  blocking: [Problem!]  # Problems that block this one
  blocked_by: [Problem!]  # Problems blocked by this one
}

# Relationship predicates
# (These are predicates that appear as edges in the graph)
# Examples:
#   <0x1> <relates_to> <0x2> .
#   <0x1> <proven_by> <0x2> .
#   <0x1> <contradicts> <0x2> .
#
# The schema above defines node types.
# Predicates are defined separately and reference node types via @index
```

## Export Strategy

### From Prethought Space → Dgraph RDF/GraphQL

The `prethought/` directory contains YAML files in structured format (id, name, type, category, etc.). These can be directly mapped to Dgraph types.

Example mapping rule for `prethought/concepts/cayley-graphs.yaml`:
```yaml
- id: CG-SL2Fp
  name: "Cayley Graph of SL(2,F_p)"
  type: concept
  category: spectral-theory
  subcategory: cayley-graphs
  definition: "..."
  properties: {...}
```

→ Dgraph RDF:
```turtle
<CG-SL2Fp> <dgraph.type> "Concept" .
<CG-SL2Fp> <name> "Cayley Graph of SL(2,F_p)" .
<CG-SL2Fp> <type> "concept" .
<CG-SL2Fp> <category> "spectral-theory" .
<CG-SL2Fp> <subcategory> "cayley-graphs" .
<CG-SL2Fp> <definition> "..." .
```

→ Dgraph GraphQL mutation:
```graphql
mutation {
  set {
    <CG-SL2Fp> <dgraph.type> "Concept" .
    <CG-SL2Fp> <name> "Cayley Graph of SL(2,F_p)" .
    <CG-SL2Fp> <type> "concept" .
    <CG-SL2Fp> <category> "spectral-theory" .
    <CG-SL2Fp> <subcategory> "cayley-graphs" .
    <CG-SL2Fp> <definition> "..." .
  }
}
```

### Export Script

`kg/scripts/export_to_dgraph.py` will:
1. Parse `prethought/**/*.yaml` files
2. Parse `papers.yaml`
3. Convert to Dgraph RDF or GraphQL mutations
4. Load into Dgraph via HTTP API

## Usage

### Load Neo4j KG

```bash
# From the riemann repo (not riemann-research)
cd ~/git/riemann
make ingest     # Loads all cypher files into Neo4j
# or
python knowledge-graph/scripts/ingest.py --all
```

### Load Dgraph KG (once schema script is created)

```bash
# Start Dgraph (zero, alpha, ratel queens on standard ports)
docker run -d -p 8080:8080 -p 9080:9080 dgraph/dgraph.slf -p zero=zero:5080
docker run -d -p 8081:8080 -p 9081:9080 dgraph/dgraph Ratel --alpha alpha:9080

# Apply schema
curl -X POST localhost:8080/admin/schema --data-binary @kg/dgraph/schema.graphql

# Load data (once export script is ready)
python kg/scripts/export_to_dgraph.py --load
```

## Sync with Parent Repo

The Neo4j KG files in `kg/cypher/` are **mirrored** from the parent `riemann/knowledge-graph/cypher/`. Use a soft link or copy:

```bash
# Update mirror (from riemann-research/):
cd kg/cypher
rm *.cypher 2>/dev/null
cp ~/git/riemann/knowledge-graph/cypher/*.cypher .
git add *. cypher && git commit -m "Sync Neo4j KG from riemann"
```

## Status

| Component | Status | Notes |
|-----------|--------|-------|
| Neo4j KG | ✅ Mirrored | Static seed, living KG in parent riemann repo |
| Dgraph Schema | 📝 Pending | Needs GraphQL schema design |
| Dgraph Data | 📝 Pending | Needs export script from prethought → Dgraph |
| Export Script | 📝 Pending | Taskfleet task KG-002 |
