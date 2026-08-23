#!/usr/bin/env python3
"""
Direct Dgraph loader - uses JSON mutation API to load YAML entities.
This bypasses GraphQL schema loading issues with Dgraph v25.
"""

import json
import yaml
import requests
import glob
from pathlib import Path
from typing import Any, Dict

# Dgraph endpoints
ALPHA_URL = "http://localhost:8081"
MUTATE_URL = f"{ALPHA_URL}/mutate?commitNow=true"
HEADERS = {"Content-Type": "application/json"}

# Map YAML entity types to Dgraph dgraph.type values
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
    "equivalence": "Equivalence",
    "related-work": "RelatedWork",
    "rh-equivalence": "RHEquivalence",
}

# Predicates we want to index
INDEXED_PREDICATES = {
    "id", "name", "title", "type", "entity_type", "category", 
    "subcategory", "status", "confidence", "tags"
}


def load_yaml_entities() -> list[Dict[str, Any]]:
    """Load all entities from YAML files."""
    entities = []
    
    # Load prethought space
    script_dir = Path(__file__).parent
    repo_root = script_dir.parent.parent
    prethought_dir = repo_root / "prethought"
    for yaml_file in prethought_dir.rglob("*.yaml"):
        with open(yaml_file, "r", encoding="utf-8", errors="replace") as f:
            data = yaml.safe_load(f)
            if isinstance(data, list):
                entities.extend(data)
            elif isinstance(data, dict):
                entities.append(data)
    
    # Load papers
    papers_file = repo_root / "papers.yaml"
    if papers_file.exists():
        with open(papers_file, "r", encoding="utf-8", errors="replace") as f:
            papers = yaml.safe_load(f) or []
            for paper in papers:
                paper["type"] = "paper"
                entities.append(paper)
    
    return entities


def entity_to_json(entity: Dict[str, Any]) -> Dict[str, Any]:
    """Convert YAML entity to Dgraph JSON mutation."""
    json_obj = {}
    
    # Set dgraph.type
    entity_type = entity.get("type", "Unknown")
    dgraph_type = TYPE_MAP.get(entity_type.lower(), "Node")
    json_obj["dgraph.type"] = dgraph_type
    
    # Copy all fields
    for key, value in entity.items():
        if key == "type":
            continue  # Already handled as dgraph.type
        
        if isinstance(value, list):
            # Convert list to string for storage
            # or store as separate nodes (simpler: join)
            json_obj[key] = ",".join(str(v) for v in value) if value else ""
        elif isinstance(value, dict):
            # Convert nested dict to JSON string
            json_obj[key] = json.dumps(value)
        else:
            json_obj[key] = str(value) if value is not None else ""
    
    # Let Dgraph assign UIDs automatically
    # But store the original id as a predicate
    if "id" in entity:
        json_obj["id"] = entity["id"]
    
    return json_obj


def load_to_dgraph(entities: list[Dict[str, Any]], batch_size: int = 50) -> None:
    """Load entities to Dgraph in batches."""
    print(f"Loading {len(entities)} entities to Dgraph at {ALPHA_URL}")
    
    # Test connection
    try:
        resp = requests.get(f"{ALPHA_URL}/health", timeout=5)
        if resp.status_code != 200:
            print(f"ERROR: Cannot connect to Dgraph at {ALPHA_URL}")
            return
        print("OK: Connected to Dgraph")
    except Exception as e:
        print(f"ERROR: Connection failed: {e}")
        return
    
    # Load in batches
    for i in range(0, len(entities), batch_size):
        batch = entities[i:i+batch_size]
        mutations = [entity_to_json(e) for e in batch]
        
        payload = {"set": mutations}
        
        try:
            print(f"Loading batch {i//batch_size + 1} ({len(mutations)} entities)...")
            # Debug: print first mutation
            if i == 0:
                print(f"  First mutation: {json.dumps(mutations[0], indent=2)}")
            resp = requests.post(MUTATE_URL, headers=HEADERS, 
                               data=json.dumps(payload), timeout=30)
            
            if resp.status_code == 200:
                result = resp.json()
                print(f"  OK: Batch loaded: {result.get('message', 'OK')}")
            else:
                print(f"  ERROR: Batch failed: {resp.status_code} - {resp.text}")
                break
        except Exception as e:
            print(f"  ERROR: Batch error: {e}")
            break
    
    print("Done!")


if __name__ == "__main__":
    entities = load_yaml_entities()
    print(f"Found {len(entities)} entities in prethought space")
    load_to_dgraph(entities)
