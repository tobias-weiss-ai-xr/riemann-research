"""Unit tests for scripts/fetch/fetch_new_papers.py classification helpers."""

import tempfile
from pathlib import Path

from fetch_new_papers import classify_subcategory, load_existing_papers
import research_config


def _cfg_with_subcategory_keywords():
    return {
        "taxonomy": {
            "subcategories": [
                {"id": "l-functions", "category": "number-theory"},
                {"id": "cayley-graphs", "category": "spectral-theory"},
                {"id": "measure", "category": "analysis"},
                {"id": "method", "category": "methodology"},
            ]
        },
        "subcategory_keywords": [
            {"id": "l-functions", "keywords": ["zeta", "l-function"]},
            {"id": "cayley-graphs", "keywords": ["cayley", "spectral gap"]},
            {"id": "method", "keywords": ["novel approach", "framework"]},
        ],
    }


def test_classify_uses_config_keyword():
    cfg = _cfg_with_subcategory_keywords()
    assert classify_subcategory("On zeta and L-functions of elliptic curves", "", cfg) == "l-functions"


def test_classify_config_rule_first_match():
    cfg = _cfg_with_subcategory_keywords()
    # 'cayley' should win over generic terms; config rules are checked in order
    assert classify_subcategory("Spectral gap of a Cayley graph", "", cfg) == "cayley-graphs"


def test_classify_category_aware_fallback():
    cfg = _cfg_with_subcategory_keywords()
    # No keyword matches, but category narrowing picks a valid subcategory.
    assert classify_subcategory("Totally neutral title", "equally neutral abstract", cfg, category="number-theory") == "l-functions"
    assert classify_subcategory("Neutral 2", "neutral abstract 2", cfg, category="spectral-theory") == "cayley-graphs"


def test_classify_last_resort_first_subcategory():
    cfg = _cfg_with_subcategory_keywords()
    assert classify_subcategory("Totally neutral title", "equally neutral abstract", cfg) == "l-functions"


def test_load_existing_papers_reads_utf8():
    # Regression: papers.yaml contains non-ASCII (Greek letters, umlauts) and
    # must be read as UTF-8, not the platform default (cp1252 on Windows).
    yaml_text = (
        "papers:\n"
        "- title: On the Γ-function and ζ zeros Schrödinger\n"
        "  date: '2020'\n"
        "  url: https://arxiv.org/abs/2001.00001\n"
        "  category: number-theory\n"
        "  subcategory: l-functions\n"
        "  authors: []\n"
        "  venue: ''\n"
        "  abstract: Über die Anzahl der Primzahlen\n"
    )
    with tempfile.TemporaryDirectory() as tmp:
        p = Path(tmp) / "papers.yaml"
        p.write_text(yaml_text, encoding="utf-8")
        by_id, titles = load_existing_papers(p)
    assert "2001.00001" in by_id
    assert titles == ["on the γ-function and ζ zeros schrödinger"]
