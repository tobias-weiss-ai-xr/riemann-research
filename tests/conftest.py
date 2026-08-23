"""Shared pytest fixtures / path setup for the *-research corpus test suite.

Ensures that ``scripts/`` and ``tools/`` are importable when running tests
from the repository root, mirroring how the pipeline scripts import
``research_config`` and each other.
"""

import sys
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent

for _p in ("scripts", "scripts/fetch", "tools"):
    _path = str(REPO / _p)
    if _path not in sys.path:
        sys.path.insert(0, _path)
