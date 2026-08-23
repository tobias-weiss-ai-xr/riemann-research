# Riemann Research: Prethought Space

> **Purpose**: Capture structured knowledge BEFORE diving into new work.
> Every new task should begin by consulting this space.

## Structure

```
prethought/
├── concepts/          # Core mathematical entities (groups, graphs, functions, operators)
│   ├── cayley-graphs.yaml
│   ├── spectral-gaps.yaml
│   ├── l-functions.yaml
│   ├── hecke-operators.yaml
│   └── transfer-operators.yaml
├── findings/          # Empirical results from experiments (honest assessment)
│   ├── gnn-failures.yaml
│   ├── ml-successes.yaml
│   ├── spectral-constants.yaml
│   └── cm-forms.yaml
├── related-work/      # External papers, approaches, tools
│   ├── surveys.yaml
│   ├── key-papers.yaml
│   ├── approaches.yaml
│   └── bridges.yaml (RH equivalences)
└── open-problems/     # Known gaps, TODOs, research directions
    ├── formalization-gaps.yaml
    ├── experimental-gaps.yaml
    └── theoretical-gaps.yaml
```

## Usage Principles (Minimal Stoic Unix)

1. **Do one thing**: Each file has a single responsibility
2. **Fail fast**: If a concept isn't documented here, don't assume it's understood
3. **Compose**: Files reference each other by ID, forming a directed knowledge graph
4. **Machine-readable**: YAML format — grep-able, parse-able, diff-able
5. **Human-readable**: Every entry has a `description` and `notes` field

## Knowledge Graph Structure

Entities are referenced by `id` across files. The implicit graph has these node types:
- `Concept` — Mathematical concepts (SL(2,F_p), spectral gap, ζ(s))
- `Finding` — Empirical discoveries (Friedli constant = 1.1367, GNN R² < 0)
- `Paper` — External literature (Mayer 1991, Granville 2007)
- `Approach` — Research strategies (Pfad A: LPS Bridge, Pfad B: Hecke GNN)
- `Problem` — Open questions (What CAUSES GNN failure on Cayley graphs?)

## Integration with Corpus

This prethought space integrates with:
- `papers.yaml` — the corpus of literature
- `kg/` — the Dgraph/Neo4j knowledge graph (concepts → findings → papers → approaches)
- `taskfleet/tasks.json` — parallel task dispatch (each task references prethought items)

## Query Examples (grep-based, minimal deps)

```bash
# Find all findings related to GNNs
grep -r "gnn\|GNN" prethought/findings/

# Find concepts that GNNs target
grep -l "target.*spectral" prethought/concepts/ prethought/findings/

# Find open problems with high priority
grep -A5 'priority:.*high' prethought/open-problems/*.yaml
```
