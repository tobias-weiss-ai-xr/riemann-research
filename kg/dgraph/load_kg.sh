#!/bin/bash
# Load Riemann Research Knowledge Graph into Dgraph
#
# Prerequisites:
#   - Docker Desktop running
#   - Dgraph containers started (docker compose up -d)
#   - Schema and data files present (schema.graphql, data.rdf/data.mutations)
#
# Usage:
#   ./load_kg.sh              # Load schema + RDF data
#   ./load_kg.sh --mutations  # Load schema + GraphQL mutations
#   ./load_kg.sh --reset      # Delete all data first, then load

set -e

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd "$SCRIPT_DIR/../../" && pwd)

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default settings
USE_MUTATIONS=false
SCHEMA_FILE="$SCRIPT_DIR/schema.graphql"
RDF_FILE="$SCRIPT_DIR/data.rdf"
MUTATIONS_FILE="$SCRIPT_DIR/data.mutations"
ALPHA_URL="http://localhost:8080"

echo -e "${YELLOW}=== Riemann Research Knowledge Graph Loader ===${NC}"
echo

# Parse arguments
for arg in "$@"; do
    case $arg in
        --mutations)
            USE_MUTATIONS=true
            shift
            ;;
        --reset)
            echo -e "${YELLOW}Resetting Dgraph data...${NC}"
            curl -X POST "$ALPHA_URL/admin" -H "Content-Type: application/json" \
                -d '{"drop_op": "DATA", "drop_all": true}' | jq .
            echo
            shift
            ;;
        --alpha)
            ALPHA_URL="$2"
            shift 2
            ;;
        *)
            ;;
    esac
done

# Check if Dgraph is running
check_dgraph() {
    echo -e "${YELLOW}Checking Dgraph Alpha at $ALPHA_URL...${NC}"
    if ! curl -s "$ALPHA_URL/health" > /dev/null 2>&1; then
        echo -e "${RED}ERROR: Dgraph Alpha is not running at $ALPHA_URL${NC}"
        echo "Start Dgraph with: docker compose -f $SCRIPT_DIR/docker-compose.yml up -d"
        exit 1
    fi
    echo -e "${GREEN}✓ Dgraph Alpha is running${NC}"
    echo
}

# Load schema
load_schema() {
    echo -e "${YELLOW}Loading schema...${NC}"
    if curl -X POST "$ALPHA_URL/admin/schema" \
            -H "Content-Type: application/graphql" \
            --data-binary @"$SCHEMA_FILE" 2>&1 | jq .; then
        echo -e "${GREEN}✓ Schema loaded${NC}"
    else
        echo -e "${RED}ERROR: Failed to load schema${NC}"
        exit 1
    fi
    echo
}

# Load data
load_data() {
    if $USE_MUTATIONS; then
        echo -e "${YELLOW}Loading data (GraphQL mutations)...${NC}"
        curl -X POST "$ALPHA_URL/mutate?commitNow=true" \
            -H "Content-Type: application/graphql" \
            --data-binary @"$MUTATIONS_FILE" 2>&1 | jq .
    else
        echo -e "${YELLOW}Loading data (RDF)...${NC}"
        curl -X POST "$ALPHA_URL/mutate?commitNow=true" \
            -H "Content-Type: application/rdf" \
            --data-binary @"$RDF_FILE" 2>&1 | jq .
    fi
    echo -e "${GREEN}✓ Data loaded${NC}"
    echo
}

# Main
check_dgraph
load_schema
load_data

echo -e "${GREEN}=== Knowledge Graph loaded successfully! ===${NC}"
echo
echo "Query at: http://localhost:8080"
echo "Ratel UI at: http://localhost:8000"
echo
echo "Try: curl -H \"Content-Type: application/json\" \"
      -d '{\"query\": \"{ q(func: has(dgraph.type)) { uid, name @filter(eq(dgraph.type, \\\"Concept\\\")) } }\"}' \"
      $ALPHA_URL/query"
