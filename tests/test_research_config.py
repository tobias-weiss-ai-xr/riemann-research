"""Unit tests for scripts/research_config.py shared config loader."""

import research_config as rc


def _cfg(**overrides):
    cfg = {
        "topic": {"name": "Test Topic", "short": "test-topic", "description": "desc",
                  "openalex_mailto": "cfg@example.com"},
        "taxonomy": {
            "categories": [{"id": "method", "display": "Methods"}],
            "subcategories": [{"id": "agentic", "display": "Agentic"}],
        },
        "arxiv_queries": ["cat:cs.AI"],
        "other_sources_queries": [],
        "openalex_queries": [],
        "trend_keywords": ["alpha", "beta"],
        "subcategory_keywords": [{"id": "method", "keywords": ["novel"]}],
    }
    cfg.update(overrides)
    return cfg


def test_get_categories_and_subcategories():
    cfg = _cfg()
    assert [c["id"] for c in rc.get_categories(cfg)] == ["method"]
    assert [s["id"] for s in rc.get_subcategories(cfg)] == ["agentic"]


def test_category_display_known():
    assert rc.category_display(_cfg(), "method") == "Methods"


def test_category_display_unknown_falls_back_to_id():
    assert rc.category_display(_cfg(), "nope") == "nope"


def test_subcategory_display_known():
    assert rc.subcategory_display(_cfg(), "agentic") == "Agentic"


def test_trend_keywords_from_config():
    assert rc.get_trend_keywords(_cfg()) == ["alpha", "beta"]


def test_trend_keywords_fallback_to_default_when_empty():
    assert rc.get_trend_keywords(_cfg(trend_keywords=[])) == rc._DEFAULT_TREND_KEYWORDS


def test_subcategory_keywords():
    kws = rc.get_subcategory_keywords(_cfg())
    assert ("method", ["novel"]) in kws


def test_display_name_uses_category_display():
    cfg = _cfg()  # category 'method' -> 'Methods'
    assert rc.display_name(cfg, "method") == "Methods"


def test_display_name_uses_subcategory_display():
    cfg = _cfg()  # subcategory 'agentic' -> 'Agentic'
    assert rc.display_name(cfg, "agentic") == "Agentic"


def test_display_name_fallback_title_case():
    cfg = _cfg()
    assert rc.display_name(cfg, "real-world") == "Real World"
    assert rc.display_name(cfg, "deep_learning") == "Deep Learning"


def test_openalex_mailto_from_config(monkeypatch):
    monkeypatch.delenv("OPENALEX_MAILTO", raising=False)
    assert rc.get_openalex_mailto(_cfg()) == "cfg@example.com"


def test_openalex_mailto_env_override(monkeypatch):
    monkeypatch.setenv("OPENALEX_MAILTO", "env@example.com")
    assert rc.get_openalex_mailto(_cfg()) == "env@example.com"


def test_openalex_mailto_final_fallback(monkeypatch):
    monkeypatch.delenv("OPENALEX_MAILTO", raising=False)
    assert "example" in rc.get_openalex_mailto(_cfg(topic={})) or \
        "@" in rc.get_openalex_mailto(_cfg(topic={}))


# ── validate_config ────────────────────────────────────────────────────────

def _valid_cfg():
    return {"topic": {"name": "X"},
            "taxonomy": {"categories": [{"id": "method"}],
                          "subcategories": [{"id": "core"}]}}


def test_validate_config_accepts_valid():
    assert rc.validate_config(_valid_cfg()) == []


def test_validate_config_duplicate_category():
    cfg = _valid_cfg()
    cfg["taxonomy"]["categories"] = [{"id": "a"}, {"id": "a"}]
    errs = rc.validate_config(cfg)
    assert any("duplicate id 'a'" in e for e in errs)


def test_validate_config_bad_id_case():
    cfg = _valid_cfg()
    cfg["taxonomy"]["categories"] = [{"id": "Method"}]
    errs = rc.validate_config(cfg)
    assert any("lowercase kebab-case" in e for e in errs)


def test_validate_config_missing_name():
    cfg = _valid_cfg()
    cfg["topic"] = {}
    errs = rc.validate_config(cfg)
    assert any("topic.name" in e for e in errs)


def test_validate_config_empty_categories():
    cfg = _valid_cfg()
    cfg["taxonomy"]["categories"] = []
    errs = rc.validate_config(cfg)
    assert any("non-empty list" in e for e in errs)


def test_validate_config_ghost_subcategory_keyword():
    cfg = _valid_cfg()
    cfg["subcategory_keywords"] = [{"id": "ghost", "keywords": ["x"]}]
    errs = rc.validate_config(cfg)
    assert any("does not match any subcategory" in e for e in errs)


def test_validate_config_non_mapping():
    assert rc.validate_config("hello") != []
    assert rc.validate_config(None) != []


def test_fetch_other_sources_classifier_is_taxonomy_aware(tmp_path, monkeypatch):
    """fetch_other_sources.classify_subcategory must return only configured
    taxonomy labels, respect category scoping, and never emit template labels."""
    import sys
    from pathlib import Path as _P
    sys.path.insert(0, str(_P("scripts/fetch").resolve()))
    import fetch_other_sources as fos
    cfg = {
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
    c = fos.classify_subcategory
    assert c("On zeta and L-functions of elliptic curves", "", cfg=cfg) == "l-functions"
    assert c("Spectral gap of a Cayley graph", "", cfg=cfg) == "cayley-graphs"
    # category-scoped fallback: neutral text returns a valid category default
    assert c("Totally neutral", "neutral abstract", cfg=cfg, category="number-theory") == "l-functions"
    # never emits undeclared template labels: build config WITHOUT 'method'
    cfg2 = {
        "taxonomy": {"subcategories": [
            {"id": "l-functions", "category": "number-theory"},
            {"id": "cayley-graphs", "category": "spectral-theory"}]},
        "subcategory_keywords": [
            {"id": "l-functions", "keywords": ["zeta", "l-function"]},
            {"id": "cayley-graphs", "keywords": ["cayley", "spectral gap"]},
            {"id": "method", "keywords": ["novel approach", "framework"]}],
    }
    res = c("A novel framework for systems theory", "", cfg=cfg2)
    assert res not in ("method", "theory", "application", "evaluation", "review")
    assert res in ("l-functions", "cayley-graphs")
