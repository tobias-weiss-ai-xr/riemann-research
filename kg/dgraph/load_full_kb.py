#!/usr/bin/env python3
"""
Full KB loader: Uses export_to_dgraph.py to generate JSON, then loads into Dgraph.
"""

import json
import yaml
import requests
from pathlib import Path
import sys
sys.path.insert(0, str(Path(__file__).parent.parent / "scripts"))

from export_to_dgraph import load_yaml_files, load_papers, PREDICATE_MAP, TYPE_MAP

ALPHA_URL = "http://localhost:8081"
MUTATE_URL = f"{ALPHA_URL}/mutate?commitNow=true"
HEADERS = {"Content-Type": "application/json"}


def convert_to_dgraph_json(entities):
    """Convert YAML entities to Dgraph JSON format."""
    mutations = []
    
    for entity in entities:
        mut = {}
        
        # Determine entity type and set dgraph.type
        entity_type = entity.get("type", "unknown").lower()
        dgraph_type = TYPE_MAP.get(entity_type, "Node")
        if not dgraph_type or dgraph_type == "Node":
            # Try to determine from category
            category = entity.get("category", "").lower()
            if category == "formalization":
                dgraph_type = "Research"
            elif category == "verification":
                dgraph_type = "Verification"
            elif category == "analysis":
                dgraph_type = "Analysis"
            elif category == "derivation":
                dgraph_type = "Derivation"
            elif category == "proof":
                dgraph_type = "Proof"
            elif category == "documentation":
                dgraph_type = "Documentation"
            else:
                dgraph_type = "Node"
        mut["dgraph.type"] = dgraph_type
        
        # Add UID
        if "id" in entity:
            mut["id"] = entity["id"]
        
        # Add all fields
        for key, value in entity.items():
            if key == "type":
                continue
            
            # Map the key using PREDICATE_MAP
            predicate = key
            if entity_type in PREDICATE_MAP and key in PREDICATE_MAP[entity_type]:
                predicate = PREDICATE_MAP[entity_type][key]
            
            # Handle different value types
            if isinstance(value, list):
                mut[predicate] = ",".join(str(v) for v in value)
            elif isinstance(value, dict):
                mut[predicate] = json.dumps(value)
            else:
                mut[predicate] = str(value) if value is not None else ""
        
        mutations.append(mut)
    
    return mutations


def load_mutations(mutations, batch_size=50):
    """Load mutations into Dgraph."""
    total = len(mutations)
    
    for i in range(0, total, batch_size):
        batch = mutations[i:i+batch_size]
        payload = {"set": batch}
        
        try:
            resp = requests.post(MUTATE_URL, headers=HEADERS, 
                               data=json.dumps(payload), timeout=30)
            result = resp.json()
            if 'errors' not in result:
                print(f"  Batch {i//batch_size + 1}/{len(range(0, total, batch_size))}: OK")
            else:
                print(f"  Batch {i//batch_size + 1}: ERROR - {result['errors']}")
        except Exception as e:
            print(f"  Batch {i//batch_size + 1}: EXCEPTION - {e}")


def create_indexes():
    """Create indexes for all needed predicates."""
    predicates = [
        'name', 'id', 'status', 'category', 'subcategory', 'confidence',
        'file', 'source', 'type', 'definition', 'abstract', 'date',
        'statement', 'conclusion', 'analysis', 'tags'
    ]
    
    for pred in predicates:
        try:
            resp = requests.post(f"{ALPHA_URL}/alter", 
                               data=f'{pred}: string @index(exact) .',
                               timeout=5)
            result = resp.json()
            if 'errors' not in result:
                print(f"  Indexed: {pred}")
        except Exception as e:
            print(f"  Failed to index {pred}: {e}")


def main():
    """Load full KB from prethought space."""
    
    repo_root = Path(__file__).parent.parent.parent
    prethought_dir = repo_root / "prethought"
    papers_file = repo_root / "papers.yaml"
    
    print("Loading YAML entities...", file=sys.stderr)
    
    # Load all YAML files
    entities = load_yaml_files(prethought_dir)
    
    # Load papers
    papers = load_papers(papers_file)
    if papers:
        for p in papers:
            if isinstance(p, dict):
                p['type'] = 'paper'
                entities.append(p)
    
    print(f"Found {len(entities)} total entities", file=sys.stderr)
    
    # Convert to Dgraph JSON
    mutations = convert_to_dgraph_json(entities)
    
    print("Creating indexes...", file=sys.stderr)
    create_indexes()
    
    print(f"Loading {len(mutations)} mutations...", file=sys.stderr)
    load_mutations(mutations)
    
    print("Full KB loaded!", file=sys.stderr)


if __name__ == "__main__":
    main()
