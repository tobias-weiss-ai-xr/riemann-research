"""Unit tests for scripts/fetch/fetch_new_papers.py classification helpers."""

from fetch_new_papers import classify_subcategory
import research_config


def _cfg_with_subcategory_keywords():
    return {
        "taxonomy": {
            "subcategories": [{"id": "theory"}, {"id": "method"}, {"id": "survey"}]
        },
        "subcategory_keywords": [
            {"id": "survey", "keywords": ["survey", "overview"]},
            {"id": "method", "keywords": ["novel approach", "framework"]},
        ],
    }


def test_classify_uses_config_keyword():
    cfg = _cfg_with_subcategory_keywords()
    assert classify_subcategory("A Survey of the Field", "", cfg) == "survey"


def test_classify_config_rule_wins_over_heuristic():
    cfg = _cfg_with_subcategory_keywords()
    # 'overview' should map to survey via config even though heuristic would
    # also catch 'survey'
    assert classify_subcategory("An overview of methods", "", cfg) == "survey"


def test_classify_heuristic_fallback():
    cfg = _cfg_with_subcategory_keywords()
    # 'formal proof' matches heuristic 'theory' (not in config rules)
    assert classify_subcategory("Formal Proof of Convergence", "", cfg) == "theory"


def test_classify_last_resort_first_subcategory():
    cfg = _cfg_with_subcategory_keywords()
    assert classify_subcategory("Totally neutral title", "equally neutral abstract", cfg) == "theory"
