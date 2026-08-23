#!/usr/bin/env python3
"""Clean load of KB into Dgraph using JSON mutations."""

import json
import yaml
import requests
from pathlib import Path

ALPHA_URL = "http://localhost:8081"
MUTATE_URL = f"{ALPHA_URL}/mutate?commitNow=true"
HEADERS = {"Content-Type": "application/json"}

# Type mapping
TYPE_MAP = {
    "concept": "Concept",
    "finding": "Finding", 
    "paper": "Paper",
    "gap": "Problem",
    "problem": "Problem",
    "open-problem": "Problem",
    "theorem": "Theorem",
    "researcher": "Researcher",
    "approach": "Approach",
    "experiment": "Experiment",
    "reference": "Reference",
    "script": "Script",
    "dataset": "Dataset",
    "rh-equivalence": "RHEquivalence",
    "equivalence": "Equivalence",
}

EXCLUDED_KEYS = {"type", "statement", "conclusion", "references", "dependencies"}


def load_entities():
    """Load all entities from YAML files."""
    entities = []
    repo_root = Path(__file__).parent.parent.parent
    
    # Load prethought
    for yaml_file in (repo_root / "prethought").rglob("*.yaml"):
        with open(yaml_file, "r", encoding="utf-8", errors="replace") as f:
            data = yaml.safe_load(f)
            if isinstance(data, list):
                entities.extend(data)
            elif isinstance(data, dict):
                entities.append(data)
    
    # Load papers
    papers_file = repo_root / "papers.yaml"
    if papers_file.exists():
        with open(papers_file, "r", encoding="utf-8") as f:
            papers = yaml.safe_load(f) or []
            for p in papers:
                p["type"] = "paper"
                entities.append(p)
    
    return entities


def load(entities):
    """Load entities to Dgraph."""
    print(f"Loading {len(entities)} entities...")
    
    mutations = []
    for e in entities:
        mut = {"dgraph.type": TYPE_MAP.get(e.get("type", "").lower(), "Node")}
        for k, v in e.items():
            if k == "type":
                continue
            if isinstance(v, list):
                mut[k] = ",".join(str(x) for x in v)
            elif isinstance(v, dict):
                mut[k] = json.dumps(v)
            else:
                mut[k] = str(v) if v else ""
        if "id" in e:
            mut["id"] = e["id"]
        mutations.append(mut)
    
    # Batch load
    batch_size = 50
    for i in range(0, len(mutations), batch_size):
        batch = mutations[i:i+batch_size]
        payload = {"set": batch}
        try:
            resp = requests.post(MUTATE_URL, headers=HEADERS, data=json.dumps(payload), timeout=30)
            result = resp.json()
            if 'errors' in result:
                print(f"  Batch {i//batch_size + 1}: ERROR - {result['errors']}")
            else:
                print(f"  Batch {i//batch_size + 1}: {result.get('message', 'OK')}")
        except Exception as e:
            print(f"  Batch {i//batch_size + 1}: EXCEPTION - {e}")
    
    print("Done!")


if __name__ == "__main__":
    entities = load_entities()
    load(entities)
