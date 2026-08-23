#!/usr/bin/env python3
"""Standard topic planner for a *-research corpus.

Ranks categories by paper count + recent (12-month) activity and writes
docs/topics/ARTICLE_TOPICS.md. Self-contained taxonomy discovery.

Standard pipeline mimic shared across all research repos.

Usage:
    python3 tools/topic_planner.py --top 10
"""

import argparse
import collections
import sys
from pathlib import Path

import yaml

sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "scripts"))
import research_config

REPO = Path(__file__).resolve().parent.parent


def _display(kebab):
    """Display name from config, falling back to title-casing the id."""
    d = research_config.category_display(_CFG, kebab)
    if d == kebab:
        d = research_config.subcategory_display(_CFG, kebab)
    if d == kebab:
        d = kebab.replace("-", " ").replace("_", " ").title()
    return d


_CFG = research_config.require_valid_config()


def load_papers():
    with open(REPO / "papers.yaml", encoding="utf-8") as f:
        data = yaml.safe_load(f)
    return data.get("papers", [])


def _year(p):
    d = p.get("date", "")
    return d[:4] if isinstance(d, str) and len(d) >= 4 and d[:4].isdigit() else ""


def main():
    ap = argparse.ArgumentParser(description="Standard topic planner")
    ap.add_argument("--top", type=int, default=10)
    a = ap.parse_args()

    papers = load_papers()
    by_cat = collections.Counter(p.get("category", "unknown") for p in papers)
    years = sorted({y for y in (_year(p) for p in papers) if y})
    latest = years[-1] if years else "0000"
    cut = str(int(latest) - 1)
    recent = collections.Counter(
        p.get("category", "unknown") for p in papers if _year(p) >= cut
    )
    rn = sum(1 for p in papers if _year(p) >= cut)

    rows = []
    for c, n in by_cat.items():
        r = recent.get(c, 0)
        score = n + (r / max(rn, 1)) * 10
        rows.append({"category": c, "papers": n, "recent": r, "score": round(score, 2)})
    rows.sort(key=lambda x: -x["score"])

    top = rows[: a.top]
    print(f"Top {len(top)} evidence-ranked topics:\n")
    for i, r in enumerate(top, 1):
        print(f"{i:>2}. {_display(r['category'])} (papers={r['papers']}, recent={r['recent']}, score={r['score']})")

    md = ["# Article Topics (auto-generated)\n"]
    for r in top:
        md += [f"\n## {_display(r['category'])}\n",
               f"Evidence-based topic: {r['papers']} curated papers, "
               f"{r['recent']} in the last 12 months.\n"]
    out = REPO / "docs" / "topics" / "ARTICLE_TOPICS.md"
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text("\n".join(md), encoding="utf-8")
    print(f"\nWrote {out}")


if __name__ == "__main__":
    main()