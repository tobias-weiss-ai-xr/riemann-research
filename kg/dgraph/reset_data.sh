#!/bin/bash
# Reset Dgraph data and reload from scratch

set -e

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd "$SCRIPT_DIR"

echo "Resetting Dgraph data..."
docker compose exec alpha dgraph alpha --my=alpha:7080 --zero=zero:5080 --security "whitelist=0.0.0.0/0" --reset_all 2>/dev/null || true

sleep 2

echo "Waiting for Dgraph to restart..."
sleep 5

echo "Loading data..."
python load_direct.py

echo "Indexing predicates..."
curl -s -X POST http://localhost:8081/alter -d 'name: string @index(term) .' >/dev/null
curl -s -X POST http://localhost:8081/alter -d 'category: string @index(exact) .' >/dev/null
curl -s -X POST http://localhost:8081/alter -d 'subcategory: string @index(exact) .' >/dev/null
curl -s -X POST http://localhost:8081/alter -d 'id: string @index(exact) .' >/dev/null
curl -s -X POST http://localhost:8081/alter -d 'status: string @index(exact) .' >/dev/null
curl -s -X POST http://localhost:8081/alter -d 'confidence: string @index(exact) .' >/dev/null

echo "Checking data..."
curl -s -X POST http://localhost:8081/query -H "Content-Type: application/json" \
  -d '{"query": "{ q(func: has(dgraph.type)) { uid } }"}' | \
  python -c "import sys,json; d=json.loads(sys.stdin.read()); print(f'Loaded {len(d[\"data\"][\"q\"])} entities')"

echo "Done!"
