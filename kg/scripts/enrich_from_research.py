#!/usr/bin/env python3
"""
Enrich Knowledge Graph from riemann/research markdown files.
Extracts papers, proofs, theorems, concepts and loads them into Dgraph.
"""

import re
import json
import requests
from pathlib import Path
from datetime import datetime

# Dgraph
ALPHA_URL = "http://localhost:8081"
MUTATE_URL = f"{ALPHA_URL}/mutate?commitNow=true"
HEADERS = {"Content-Type": "application/json"}


def extract_metadata(text):
    """Extract title, authors, date, status from markdown frontmatter or blockquote."""
    result = {}
    
    # Match YAML-style frontmatter (must start with --- and not be a table)
    frontmatter = re.search(r'^---[\s\S]*?^[\s]*---', text, re.MULTILINE)
    if frontmatter:
        front = frontmatter.group(0)
        # Parse YAML-like key: value pairs
        for match in re.finditer(r'^([\w\s-]+):\s*(.*)$', front, re.MULTILINE):
            key = match.group(1).strip().lower()
            val = match.group(2).strip()
            result[key] = val
    else:
        # Try to extract from blockquote-style metadata
        for match in re.finditer(r'>\s*\*\*(Authors?|Date|Status)\*\*:\s*(.*)$', text, re.MULTILINE):
            key = match.group(1).lower()
            val = match.group(2).strip()
            result[key] = val
    
    # Extract title from first heading
    title_match = re.search(r'^#\s+(.*)$', text, re.MULTILINE)
    if title_match:
        result['title'] = title_match.group(1).strip()
    # Match heading-style metadata
    if not result:
        title_match = re.search(r'^#\s+(.*)', text)
        if title_match:
            result['title'] = title_match.group(1).strip()
        
        authors_match = re.search(r'^(?:>\s*)*Authors?[:\s]+(.*?)$', text, re.IGNORECASE | re.MULTILINE)
        if authors_match:
            result['authors'] = authors_match.group(1).strip()
        
        date_match = re.search(r'^(?:>\s*)*Date[:\s]+(.*?)$', text, re.IGNORECASE | re.MULTILINE)
        if date_match:
            result['date'] = date_match.group(1).strip()
        
        status_match = re.search(r'^(?:>\s*)*Status[:\s]+(.*?)$', text, re.IGNORECASE | re.MULTILINE)
        if status_match:
            result['status'] = status_match.group(1).strip()
    
    return result


def extract_sections(text):
    """Extract sections and subsections from markdown."""
    sections = {}
    
    # Find all headings
    headings = re.finditer(r'^((?:#{1,6})\s+)(.*)$', text, re.MULTILINE)
    
    current_section = None
    current_subsection = None
    content_buffer = []
    
    for match in headings:
        level, title = match.groups()
        level = len(level.strip('#'))
        
        # Save previous content
        if content_buffer and current_section:
            section_key = f"{current_section}"
            if current_subsection:
                section_key = f"{current_section}.{current_subsection}"
            sections[section_key] = '\n'.join(content_buffer)
        
        # Reset for new section
        content_buffer = []
        
        if level == 1:
            current_section = title.strip()
            current_subsection = None
        elif level == 2:
            current_subsection = title.strip()
        else:
            current_subsection = title.strip()
    
    # Save last section
    if content_buffer and current_section:
        section_key = f"{current_section}"
        if current_subsection:
            section_key = f"{current_section}.{current_subsection}"
        sections[section_key] = '\n'.join(content_buffer)
    
    return sections


def extract_theorems(text):
    """Extract theorems, lemmas, propositions from markdown."""
    results = []
    
    patterns = [
        (r'^(?:**|\*\*)Theorem\s+([^\n]+?)(?=\n)', 'Theorem'),
        (r'^(?:**|\*\*)Lemma\s+([^\n]+?)(?=\n)', 'Lemma'),
        (r'^(?:**|\*\*)Proposition\s+([^\n]+?)(?=\n)', 'Proposition'),
        (r'^(?:**|\*\*)Corollary\s+([^\n]+?)(?=\n)', 'Corollary'),
        (r'^(?:**|\*\*)Conjecture\s+([^\n]+?)(?=\n)', 'Conjecture'),
        (r'^(?:**|\*\*)Definition\s+([^\n]+?)(?=\n)', 'Definition'),
    ]
    
    for pattern, type_name in patterns:
        matches = re.finditer(pattern, text, re.MULTILINE)
        for match in matches:
            results.append({
                'type': type_name,
                'name': match.group(1).strip(),
                'source_file': 'unknown'
            })
    
    return results


def extract_concepts(text):
    """Extract key concepts using patterns like **Concept Name** or `Concept Name`."""
    results = []
    
    # Bold concepts
    bold_matches = re.finditer(r'\*\*(.*?)\*\*', text)
    for match in bold_matches:
        concept = match.group(1).strip()
        if len(concept) > 2 and not concept.startswith('Theorem') and not concept.startswith('Lemma'):
            results.append(concept)
    
    # Code-style concepts
    code_matches = re.finditer(r'`(.*?)`', text)
    for match in code_matches:
        concept = match.group(1).strip()
        if len(concept) > 2:
            results.append(concept)
    
    return list(set(results))[:50]  # Limit to 50 unique concepts


def create_paper_entity(filepath):
    """Create a Paper entity from a markdown paper file."""
    with open(filepath, 'r', encoding='utf-8', errors='replace') as f:
        content = f.read()
    
    metadata = extract_metadata(content)
    sections = extract_sections(content)
    theorems = extract_theorems(content)
    concepts = extract_concepts(content)
    
    entity = {
        'dgraph.type': 'Paper',
        'id': f"P-{Path(filepath).stem}",
        'title': metadata.get('title', Path(filepath).name),
        'file': str(filepath.relative_to(Path(filepath).parent.parent)),
        'abstract': metadata.get('abstract', ''),
        'authors': metadata.get('authors', ''),
        'date': metadata.get('date', ''),
        'status': metadata.get('status', 'draft'),
        'source': 'riemann-research-papers',
        'sections': list(sections.keys())[:10],
        'keywords': concepts[:10]
    }
    
    if sections.get('Abstract'):
        entity['abstract'] = sections['Abstract'][:500]
    
    if sections.get('1. Introduction') or sections.get('Introduction'):
        intro_key = '1. Introduction' if sections.get('1. Introduction') else 'Introduction'
        entity['introduction'] = sections[intro_key][:1000]
    
    return entity


def create_research_entity(filepath):
    """Create Research/Proof/Theorem entities from research markdown files."""
    try:
        with open(filepath, 'r', encoding='utf-8', errors='replace') as f:
            content = f.read()
    except:
        try:
            with open(filepath, 'r', encoding='latin-1') as f:
                content = f.read()
        except:
            return None
    
    metadata = extract_metadata(content)
    sections = extract_sections(content)
    
    # Determine type based on filename
    stem = Path(filepath).stem.lower()
    
    if 'proof' in stem:
        entity_type = 'Proof'
    elif 'assignment' in stem or 'verification' in stem:
        entity_type = 'Assessment'
    elif 'analysis' in stem:
        entity_type = 'Analysis'
    elif 'derivation' in stem:
        entity_type = 'Derivation'
    else:
        entity_type = 'Research'
    
    entity = {
        'dgraph.type': entity_type,
        'id': f"R-{Path(filepath).stem}",
        'title': metadata.get('title', Path(filepath).name),
        'file': str(filepath.relative_to(Path(filepath).parent.parent)),
        'date': metadata.get('date', ''),
        'status': metadata.get('status', 'draft'),
        'source': 'riemann-research',
        'sections': list(sections.keys())[:10]
    }
    
    if sections.get('Abstract') or sections.get('Summary'):
        abstract_key = 'Abstract' if sections.get('Abstract') else 'Summary'
        entity['abstract'] = sections[abstract_key][:500]
    
    return entity


def load_entities(entities):
    """Load entities into Dgraph."""
    batch_size = 50
    total = len(entities)
    
    for i in range(0, total, batch_size):
        batch = entities[i:i+batch_size]
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


def index_predicates():
    """Create indexes for new predicates."""
    predicates = ['file', 'source', 'authors', 'date', 'status', 'sections', 'keywords', 'abstract', 'introduction']
    
    for pred in predicates:
        try:
            resp = requests.post(f"{ALPHA_URL}/alter", 
                               data=f'{pred}: string @index(exact) .',
                               timeout=5)
            print(f"  Indexed: {pred}")
        except Exception as e:
            print(f"  Failed to index {pred}: {e}")


def main():
    """Main enrichment process."""
    
    # riemann repo is sibling to riemann-research
    riemann_base = Path(__file__).parent.parent.parent.parent / "riemann"
    
    # 1. Load papers from papers directory
    papers_dir = riemann_base / "papers"
    paper_files = list(papers_dir.glob("*.md"))
    
    # 2. Load research files (but skip files with encoding issues)
    research_dir = riemann_base / "research"
    research_files = list(research_dir.glob("*.md"))
    
    # 3. Create entities
    entities = []
    
    print("Extracting from papers...")
    for pf in paper_files:
        if pf.name.startswith('_'):
            continue
        try:
            entity = create_paper_entity(pf)
            entities.append(entity)
            print(f"  Paper: {entity['id']} - {entity['title'][:50]}")
        except Exception as e:
            print(f"  ERROR processing {pf.name}: {e}")
    
    print("\nExtracting from research...")
    for rf in research_files:
        if rf.name.startswith('_'):
            continue
        try:
            entity = create_research_entity(rf)
            entities.append(entity)
            print(f"  Research: {entity['id']} - {entity['title'][:50]}")
        except Exception as e:
            print(f"  ERROR processing {rf.name}: {e}")
    
    print(f"\nTotal entities to add: {len(entities)}")
    
    # 4. Index new predicates
    print("\nIndexing new predicates...")
    index_predicates()
    
    # 5. Load into Dgraph
    print("\nLoading entities...")
    load_entities(entities)
    
    print("\nEnrichment complete!")


if __name__ == "__main__":
    main()
