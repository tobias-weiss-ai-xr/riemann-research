#!/usr/bin/env python3
"""
Export Riemann prethought space to Dgraph.

Usage:
    python export_to_dgraph.py                    # Export to RDF, print mutations
    python export_to_dgraph.py --load            # Load into Dgraph via API
    python export_to_dgraph.py --dry-run         # Test export without loading
    python export_to_dgraph.py --output file.rdf  # Save to file
    python export_to_dgraph.py --format mutations # Output GraphQL mutations

Environment:
    DGRAPH_ALPHA: http://localhost:8080    # Dgraph Alpha server
    DGRAPHZERO:   http://localhost:5080     # Dgraph Zero server
"""

from __future__ import annotations

import argparse
import json
import os
import sys
from pathlib import Path
from typing import Any

try:
    import yaml
    import requests
except ImportError as e:
    print(f"Missing dependency: {e}")
    print("Install: pip install pyyaml requests")
    sys.exit(1)

# =============================================================================
# Configuration
# =============================================================================

REPO_ROOT = Path(__file__).resolve().parent.parent.parent
PRETHOUGHT_DIR = REPO_ROOT / "prethought"
PAPERS_FILE = REPO_ROOT / "papers.yaml"
DGRAPH_DIR = REPO_ROOT / "kg" / "dgraph"

# Dgraph predicated (these become Schema predicates)
# Each predicate maps a YAML field to a Dgraph predicate name
PREDICATE_MAP = {
    "Concept": {
        "id": "id",
        "name": "name",
        "type": "entity_type",
        "category": "category",
        "subcategory": "subcategory",
        "definition": "definition",
        "abstract": "abstract",
        "properties": "properties",
        "tags": "tags",
        "lean_status": "lean_status",
        "lean_file": "lean_file",
        "cypher_file": "cypher_file",
    },
    "Finding": {
        "id": "id",
        "name": "name",
        "type": "entity_type",
        "category": "category", 
        "subcategory": "subcategory",
        "statement": "statement",
        "experiment": "experiment",
        "date": "date",
        "configuration": "configuration",
        "results": "results",
        "analysis": "analysis",
        "conclusion": "conclusion",
        "status": "status",
        "confidence": "confidence",
        "tags": "tags",
        "related_concepts": "related_concepts",
        "references": "references",
        "depends_on": "depends_on",
        "supports": "supports",
        "contradicts": "contradicts",
    },
    "Paper": {
        "id": "id",
        "title": "title",
        "date": "date",
        "year": "year",
        "url": "url",
        "venue": "venue",
        "abstract": "abstract",
        "doi": "doi",
        "category": "category",
        "subcategory": "subcategory",
        "status": "status",
        "open_access": "open_access",
        "notes": "notes",
        "tags": "tags",
    },
}

# Dgraph type for each YAML entity type
TYPE_MAP = {
    "concept": "Concept",
    "finding": "Finding", 
    "paper": "Paper",
    "gap": "Problem",
    "problem": "Problem",
    "open-problem": "Problem",
    "theorem": "Theorem",
    "conjecture": "Conjecture",
    "equivalence": "Equivalence",
    "rh-equivalence": "RHEquivalence",
    "bridge": "Bridge",
    "data": "Dataset",
    "researcher": "Researcher",
    "approach": "Approach",
    "experiment": "Experiment",
    "reference": "Reference",
    "script": "Script",
    "dataset": "Dataset",
    "refutation": "Refutation",
    "research": "Research",
    "analysis": "Analysis",
    "verification": "Verification",
    "derivation": "Derivation",
    "documentation": "Documentation",
    "assessment": "Assessment",
    "proof": "Proof",
    # Methodology and philosophy types
    "philosophy": "Philosophy",
    "strategy": "Strategy",
    "audit": "Audit",
    "roadmap": "Roadmap",
    "warning": "Warning",
    "assignment": "Research",
    "solution": "Research",
    "cayley_graph": "Graph",
    "isogeny_graph": "Graph",
    "expander_graph": "Graph",
    "geometric_graph": "Graph",
    "regular_graph": "Graph",
}

# =============================================================================
# YAML Loading
# =============================================================================

def load_yaml_files(directory: Path) -> list[dict[str, Any]]:
    """Load all YAML files from a directory tree."""
    result = []
    for yaml_file in directory.rglob("*.yaml"):
        with open(yaml_file, "r", encoding="utf-8", errors="replace") as f:
            data = yaml.safe_load(f)
            if isinstance(data, list):
                result.extend(data)
            elif isinstance(data, dict):
                result.append(data)
    return result


def load_papers(papers_file: Path) -> list[dict[str, Any]]:
    """Load papers.yaml"""
    if not papers_file.exists():
        return []
    with open(papers_file, "r", encoding="utf-8", errors="replace") as f:
        return yaml.safe_load(f) or []


def load_all() -> list[dict[str, Any]]:
    """Load everything into a unified list with source tracking."""
    entities = []
    
    # Load prethought space
    for yaml_dir in [
        PRETHOUGHT_DIR / "concepts",
        PRETHOUGHT_DIR / "findings", 
        PRETHOUGHT_DIR / "related-work",
        PRETHOUGHT_DIR / "open-problems",
    ]:
        if yaml_dir.exists():
            items = load_yaml_files(yaml_dir)
            for item in items:
                if isinstance(item, dict):
                    item["_source"] = str(yaml_dir.relative_to(REPO_ROOT))
                    item["_type"] = item.get("type", "concept")
                    entities.append(item)
    
    # Load papers
    papers = load_papers(PAPERS_FILE)
    for p in papers:
        p["_source"] = "papers.yaml"
        p["_type"] = "paper"
        entities.append(p)
    
    return entities


# =============================================================================
# Field Value Handling
# =============================================================================

def escape_string(value: Any) -> str:
    """Escape special characters for Dgraph RDF."""
    if value is None:
        return ""
    if not isinstance(value, str):
        value = str(value)
    # Escape backslashes, quotes, newlines
    value = value.replace("\\", "\\\\")
    value = value.replace('"', '\\"')
    value = value.replace("\n", "\\n")
    value = value.replace("\t", "\\t")
    return value


def format_value(value: Any) -> str:
    """Format a YAML value for Dgraph."""
    if isinstance(value, list):
        return ", ".join(format_value(v) for v in value)
    if isinstance(value, dict):
        return escape_string(json.dumps(value))
    if isinstance(value, bool):
        return "true" if value else "false"
    if value is None:
        return ""
    return escape_string(str(value))


# =============================================================================
# N-Triples / RDF Export
# =============================================================================

def uid_for_entity(entity: dict[str, Any]) -> str:
    """Generate a consistent UID for an entity."""
    return f"<{entity.get('id', '')}>"


def to_rdf(entities: list[dict[str, Any]]) -> str:
    """Convert entities to RDF N-Triples format."""
    lines = []
    
    for entity in entities:
        entity_id = entity.get("id", "")
        entity_type = entity.get("_type", "")
        dgraph_type = TYPE_MAP.get(entity_type, "Concept")
        
        uid = uid_for_entity(entity)
        
        # Add type triple
        lines.append(f"{uid} <dgraph.type> \"{dgraph_type}\" .")
        
        # Map entity fields to predicates
        node_type = entity.get("type", entity_type)
        predicate_map = PREDICATE_MAP.get(dgraph_type, {})
        
        for yaml_field, dgraph_pred in predicate_map.items():
            if yaml_field in entity:
                value = entity[yaml_field]
                if value is not None:
                    if isinstance(value, list):
                        for v in value:
                            if isinstance(v, dict):
                                # Reference another entity by ID
                                ref_id = v.get("id") or v.get("_id")
                                if ref_id:
                                    lines.append(f"{uid} <{dgraph_pred}> {uid_for_entity({'id': ref_id})} .")
                            else:
                                formatted = format_value(v)
                                if formatted:
                                    lines.append(f"{uid} <{dgraph_pred}> \"{formatted}\" .")
                    else:
                        formatted = format_value(value)
                        if formatted:
                            lines.append(f"{uid} <{dgraph_pred}> \"{formatted}\" .")
        
        # Add tags
        tags = entity.get("tags", [])
        for tag in tags:
            formatted = format_value(tag)
            if formatted:
                lines.append(f"{uid} <tags> \"{formatted}\" .")
        
        lines.append("")  # blank line between entities
    
    return "\n".join(lines)


# =============================================================================
# Dgraph GraphQL+ Mutations
# =============================================================================

def to_mutations(entities: list[dict[str, Any]]) -> str:
    """Convert entities to Dgraph GraphQL+- mutations."""
    mutations = []
    
    for entity in entities:
        entity_id = entity.get("id", "")
        entity_type = entity.get("_type", "")
        dgraph_type = TYPE_MAP.get(entity_type, "Concept")
        
        set_block_parts = []
        
        # Map all valid fields
        predicate_map = PREDICATE_MAP.get(dgraph_type, {})
        
        for yaml_field, dgraph_pred in predicate_map.items():
            if yaml_field in entity:
                value = entity[yaml_field]
                if value is not None:
                    if isinstance(value, list):
                        for v in value:
                            if isinstance(v, dict):
                                ref_id = v.get("id") or v.get("_id")
                                if ref_id:
                                    set_block_parts.append(f"<{ref_id}> <{dgraph_pred}> <{entity_id}>")
                            else:
                                formatted = format_value(v)
                                set_block_parts.append(f"\"{formatted}\" <{dgraph_pred}> <{entity_id}>")
                    else:
                        formatted = format_value(value)
                        set_block_parts.append(f"\"{formatted}\" <{dgraph_pred}> <{entity_id}>")
        
        # Add tags
        tags = entity.get("tags", [])
        for tag in tags:
            formatted = format_value(tag)
            set_block_parts.append(f"\"{formatted}\" <tags> <{entity_id}>")
        
        # Add type last
        set_block_parts.append(f"\"{entity_id}\" <dgraph.type> \"{dgraph_type}\"")
        
        if set_block_parts:
            set_clause = "\n      ".join(set_block_parts)
            mutation = f"# {entity_id} ({dgraph_type})\n" + \
                       f'{{ set {{ {set_clause} }} }}\n'
            mutations.append(mutation)
    
    return "\n\n".join(mutations)


# =============================================================================
# Dgraph API Loading
# =============================================================================

def load_via_api(rdf_content: str, alpha_url: str = None, zero_url: str = None) -> bool:
    """Load RDF content into Dgraph via HTTP API."""
    alpha_url = alpha_url or os.getenv("DGRAPH_ALPHA", "http://localhost:8080")
    
    # Send mutation
    mutation_endpoint = f"{alpha_url}/mutate?commitNow=true"
    
    try:
        response = requests.post(
            mutation_endpoint,
            data=rdf_content,
            headers={"Content-Type": "application/rdf"},
            timeout=30
        )
        response.raise_for_status()
        data = response.json()
        keys = data.get("keys", [])
        print(f"✅ Loaded {len(keys)} keys into Dgraph")
        return True
    except requests.exceptions.RequestException as e:
        print(f"❌ Failed to load into Dgraph: {e}")
        return False


# =============================================================================
# Main
# =============================================================================

def main():
    parser = argparse.ArgumentParser(
        description="Export Riemann prethought space to Dgraph"
    )
    parser.add_argument(
        "--load",
        action="store_true",
        help="Load into Dgraph via HTTP API"
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Parse and validate export without loading"
    )
    parser.add_argument(
        "--output", "-o",
        type=str,
        default=None,
        help="Output file path (default: stdout)"
    )
    parser.add_argument(
        "--format",
        choices=["rdf", "mutations"],
        default="rdf",
        help="Output format (default: rdf)"
    )
    parser.add_argument(
        "--alpha",
        type=str,
        default=None,
        help="Dgraph Alpha URL (default: http://localhost:8080)"
    )
    parser.add_argument(
        "--verbose", "-v",
        action="store_true",
        help="Verbose output"
    )
    args = parser.parse_args()
    
    # Load entities
    if args.verbose:
        print(f"📂 Loading from {REPO_ROOT}")
    
    entities = load_all()
    
    if args.verbose:
        print(f"📊 Loaded {len(entities)} entities")
        type_counts = {}
        for e in entities:
            t = e.get("_type", "unknown")
            type_counts[t] = type_counts.get(t, 0) + 1
        print(f"   Types: {type_counts}")
    
    # Validate
    if not entities:
        print("❌ No entities found! Check your prethought/ and papers.yaml paths.")
        sys.exit(1)
    
    # Convert to target format
    if args.format == "rdf":
        output = to_rdf(entities)
    else:
        output = to_mutations(entities)
    
    if args.verbose:
        print(f"📄 Generated {len(output)} characters of {args.format}")
    
    # Output or save
    if args.output:
        with open(args.output, "w", encoding="utf-8") as f:
            f.write(output)
        print(f"OK: Saved to {args.output}")
        return
    
    if not args.load:
        print(output)
        return
    
    # Load into Dgraph
    if args.dry_run:
        print("[DRY RUN] Not loading into Dgraph:")
        print(output[:500])
        if len(output) > 500:
            print("...")
        return
    
    success = load_via_api(output, args.alpha)
    if not success:
        sys.exit(1)


if __name__ == "__main__":
    main()
