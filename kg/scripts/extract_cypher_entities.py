#!/usr/bin/env python3
"""
Extract entities from Cypher files and convert to YAML for KB.
"""

import re
import yaml
from pathlib import Path
from collections import defaultdict

CYPHER_DIR = Path(__file__).parent.parent.parent.parent / "riemann" / "knowledge-graph" / "cypher"
OUTPUT_DIR = Path(__file__).parent.parent.parent / "prethought" / "cypher-entities"

def parse_cypher_file(path):
    """Parse a Cypher file and extract CREATE statements."""
    with open(path, 'r', encoding='utf-8', errors='replace') as f:
        content = f.read()
    
    # Find all CREATE statements
    create_pattern = r'CREATE\s+\(([^)]+)\{([^}]+(?:\{[^}]*\}[^}]*)*)\}\s*\)'
    creates = re.finditer(create_pattern, content, re.DOTALL)
    
    entities = []
    for match in creates:
        var_name = match.group(1).strip()
        props_str = match.group(2).strip()
        
        # Parse properties
        props = {}
        for prop_match in re.finditer(r'(\w+)\s*:\s*([^,]+?)(?=,\s*\w+\s*:|$)', props_str):
            key = prop_match.group(1).strip()
            value = prop_match.group(2).strip()
            
            # Clean value
            value = value.rstrip(',')
            
            # Remove quotes if string
            if value.startswith('"') and value.endswith('"'):
                value = value[1:-1]
            elif value.startswith("'") and value.endswith("'"):
                value = value[1:-1]
            
            props[key] = value
        
        # Add Neo4j labels as type
        if ':' in var_name:
            labels = [l.strip() for l in var_name.split(':')]
            var_name = labels[0]
            props['labels'] = labels
        
        # Determine type from labels
        if 'labels' in props:
            props['cypher_type'] = props['labels']
            # Remove labels from output
            del props['labels']
        
        # Remove neo4j-specific properties
        remove_props = ['lean4', 'mathlib_name', 'latex_statement', 'wiki', 'arxiv']
        for prop in remove_props:
            if prop in props:
                del props[prop]
        
        # Set ID with CE- prefix
        if 'name' in props:
            name = props['name'].replace(' ', '-').replace('/', '-').replace('.', '-').replace(',', '')
            props['id'] = f"CE-{name}"
        else:
            props['id'] = f"CE-{var_name}"
        
        if 'type' not in props:
            if 'cypher_type' in props:
                props['type'] = props['cypher_type'][0].lower()
        
        # Set category based on cypher_type
        if 'cypher_type' in props:
            types = props['cypher_type']
            if 'Theorem' in types:
                props.setdefault('category', 'theorems')
            elif 'Conjecture' in types:
                props.setdefault('category', 'conjectures')
            elif 'OpenProblem' in types:
                props.setdefault('category', 'open-problems')
            elif 'Researcher' in types or 'Person' in types:
                props.setdefault('category', 'researchers')
            elif 'Paper' in types:
                props.setdefault('category', 'papers')
            elif 'Corpus' in types:
                props.setdefault('category', 'corpora')
            elif 'Approach' in types:
                props.setdefault('category', 'approaches')
        
        entities.append(props)
    
    return entities


def extract_relationships(path):
    """Extract relationships (edges) from Cypher file."""
    with open(path, 'r', encoding='utf-8', errors='replace') as f:
        content = f.read()
    
    # Find all relationship patterns
    rel_pattern = r'CREATE\s+\([^)]+\)\s*-+\[:(\w+)\s*\{?([^\]]*)\}?\]\s*->\s*\([^)]+\)'
    rels = re.finditer(rel_pattern, content, re.DOTALL)
    
    relationships = []
    for match in rels:
        rel_type = match.group(1)
        props_str = match.group(2)
        props = {}
        # Parse properties if present
        for prop_match in re.finditer(r'(\w+)\s*:\s*([^,\]]+)', props_str):
            key = prop_match.group(1)
            value = prop_match.group(2).rstrip(',')
            if value.startswith('"') and value.endswith('"'):
                value = value[1:-1]
            elif value.startswith("'") and value.endswith("'"):
                value = value[1:-1]
            props[key] = value
        
        if props:
            relationships.append({
                'type': rel_type,
                'properties': props
            })
        else:
            relationships.append({'type': rel_type})
    
    return relationships


def group_entities_by_file(entities, file_stem):
    """Group entities by source file category."""
    categories = {
        '00-schema': 'schema',
        '01-groups': 'groups',
        '02-graphs': 'graphs',
        '03-functions': 'functions',
        '04-operators': 'operators',
        '05-theorems': 'theorems',
        '06-papers-approaches': 'papers',
        '07-rh-equivalences': 'equivalences',
        '08-papers-extended': 'papers',
        '09-graphs-extended': 'graphs',
        '10-rh-equivalences-extended': 'equivalences',
    }
    
    category = categories.get(file_stem, 'other')
    
    # Split into multiple files per category to keep them manageable
    # Group by subcategory
    entities_by_sub = defaultdict(list)
    for e in entities:
        sub = e.get('category', category)
        entities_by_sub[sub].append(e)
    
    return dict(entities_by_sub)


def main():
    """Extract all entities from Cypher files."""
    
    if not CYPHER_DIR.exists():
        print(f"Cypher directory not found: {CYPHER_DIR}")
        return
    
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    
    all_entities = {}
    total_count = 0
    
    # Process each cypher file
    for cypher_file in sorted(CYPHER_DIR.glob("*.cypher")):
        file_stem = cypher_file.stem
        print(f"Processing {cypher_file.name}...")
        
        entities = parse_cypher_file(cypher_file)
        grouped = group_entities_by_file(entities, file_stem)
        
        for subcategory, ents in grouped.items():
            sub_dir = OUTPUT_DIR / file_stem
            sub_dir.mkdir(parents=True, exist_ok=True)
            
            output_file = sub_dir / f"{subcategory}.yaml"
            
            # Deduplicate by ID
            seen_ids = set()
            unique_ents = []
            for e in ents:
                eid = e.get('id', '')
                if eid and eid in seen_ids:
                    continue
                seen_ids.add(eid)
                unique_ents.append(e)
            
            # Save to YAML
            with open(output_file, 'w', encoding='utf-8') as f:
                yaml.dump(unique_ents, f, allow_unicode=True, default_flow_style=False)
            
            all_entities[subcategory] = all_entities.get(subcategory, 0) + len(unique_ents)
            total_count += len(unique_ents)
        
        print(f"Extracted {len(entities)} entities")
    
    print(f"\nTotal entities extracted: {total_count}")
    print(f"By category: {dict(all_entities)}")
    print(f"\nOutput directory: {OUTPUT_DIR}")


if __name__ == "__main__":
    main()
