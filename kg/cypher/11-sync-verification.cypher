// ── KG-003 Sync Verification ─────────────────────────────────────
// Read-only post-load checks for the Neo4j KG mirrored from the riemann
// repo (knowledge-graph/cypher @ its initial commit) into kg/cypher/.
//
// WHAT THIS FILE VERIFIES
//   The loaded graph matches the statically audited inventory of
//   kg/cypher/00..10 (statement-level parse): 146 nodes / 155 relationships.
//   Every query below returns a row ONLY on mismatch — a fully synced,
//   correctly loaded graph produces NO rows from any query.
//
// USAGE (after loading 00-schema .. 10-rh-equivalences-extended in order):
//   cypher-shell -u neo4j -p <pass> -f 11-sync-verification.cypher
//   PASS  = no output rows.
//   FAIL  = any row with status = 'MISMATCH' names the drifted check.
//
// SYNC PROVENANCE (KG-003)
//   * Source of truth: riemann repo, knowledge-graph/cypher/ (11 files).
//   * Mirror relation: every node and every distinct relationship in the
//     source is present in this mirror (graph-level superset). The mirror
//     adds corpus-level enrichment in 07/10 (RW-* cross-links, the
//     Nicolas-criterion correction, the Lee-Yang analogy node) and drops
//     three duplicate relationship statements present upstream.
//   * KG-003 fix applied here: 52 cross-file relationship endpoints were
//     referenced as bare Cypher variables (e.g. `rh`, `zeta`) that no
//     longer exist once a file is loaded statement-by-statement — under
//     the upstream ingest.py (one session per statement) or cypher-shell
//     (one query per file), ~50 relationship CREATEs failed silently
//     with "Variable not defined". Each such endpoint is now bound with
//     an explicit MATCH clause, so every data file is one self-contained
//     statement and loads cleanly in file order.
//
// FLAGGED UPSTREAM (not fixed here — schema/00 stays a byte-identical
// mirror; back-port to the riemann repo is a follow-up):
//   * Upstream 07 still attributes Lagarias' sigma/H criterion to the
//     Nicolas node; this mirror carries the corrected primorial
//     criterion (guarded by a check below).
//   * 00-schema.cypher constrains label :Approach, but the data creates
//     :AIApproach nodes — the constraint never fires.
//   * Upstream ingest.py logs statement failures as warnings and
//     continues, which is why the binding defect went unnoticed.
//
// MAINTENANCE: expected values below are a snapshot of the audited
// inventory. When enriching kg/cypher, re-audit and update them.

// ── Node counts by label (10 labels + total) ─────────────────────────────────────────
MATCH (n:AIApproach)
WITH count(*) AS actual
WHERE actual <> 4
RETURN 'nodes:AIApproach' AS check, actual, 4 AS expected, 'MISMATCH' AS status
UNION ALL
MATCH (n:Conjecture)
WITH count(*) AS actual
WHERE actual <> 11
RETURN 'nodes:Conjecture' AS check, actual, 11 AS expected, 'MISMATCH' AS status
UNION ALL
MATCH (n:Graph)
WITH count(*) AS actual
WHERE actual <> 14
RETURN 'nodes:Graph' AS check, actual, 14 AS expected, 'MISMATCH' AS status
UNION ALL
MATCH (n:Group)
WITH count(*) AS actual
WHERE actual <> 7
RETURN 'nodes:Group' AS check, actual, 7 AS expected, 'MISMATCH' AS status
UNION ALL
MATCH (n:MathFunction)
WITH count(*) AS actual
WHERE actual <> 10
RETURN 'nodes:MathFunction' AS check, actual, 10 AS expected, 'MISMATCH' AS status
UNION ALL
MATCH (n:OpenProblem)
WITH count(*) AS actual
WHERE actual <> 3
RETURN 'nodes:OpenProblem' AS check, actual, 3 AS expected, 'MISMATCH' AS status
UNION ALL
MATCH (n:Operator)
WITH count(*) AS actual
WHERE actual <> 7
RETURN 'nodes:Operator' AS check, actual, 7 AS expected, 'MISMATCH' AS status
UNION ALL
MATCH (n:Paper)
WITH count(*) AS actual
WHERE actual <> 34
RETURN 'nodes:Paper' AS check, actual, 34 AS expected, 'MISMATCH' AS status
UNION ALL
MATCH (n:Researcher)
WITH count(*) AS actual
WHERE actual <> 17
RETURN 'nodes:Researcher' AS check, actual, 17 AS expected, 'MISMATCH' AS status
UNION ALL
MATCH (n:Theorem)
WITH count(*) AS actual
WHERE actual <> 53
RETURN 'nodes:Theorem' AS check, actual, 53 AS expected, 'MISMATCH' AS status
UNION ALL
MATCH (n)
WITH count(*) AS actual
WHERE actual <> 146
RETURN 'nodes:TOTAL' AS check, actual, 146 AS expected, 'MISMATCH' AS status;

// ── Relationship counts by type (40 types + total) ─────────────────────────────────────────
MATCH ()-[r:ACHIEVES]->()
WITH count(*) AS actual
WHERE actual <> 1
RETURN 'rels:ACHIEVES' AS check, actual, 1 AS expected, 'MISMATCH' AS status
UNION ALL
MATCH ()-[r:ACTS_ON]->()
WITH count(*) AS actual
WHERE actual <> 3
RETURN 'rels:ACTS_ON' AS check, actual, 3 AS expected, 'MISMATCH' AS status
UNION ALL
MATCH ()-[r:ANALOGOUS_TO]->()
WITH count(*) AS actual
WHERE actual <> 1
RETURN 'rels:ANALOGOUS_TO' AS check, actual, 1 AS expected, 'MISMATCH' AS status
UNION ALL
MATCH ()-[r:APPROACHES_TOWARDS]->()
WITH count(*) AS actual
WHERE actual <> 1
RETURN 'rels:APPROACHES_TOWARDS' AS check, actual, 1 AS expected, 'MISMATCH' AS status
UNION ALL
MATCH ()-[r:APPROACHES_VIA]->()
WITH count(*) AS actual
WHERE actual <> 4
RETURN 'rels:APPROACHES_VIA' AS check, actual, 4 AS expected, 'MISMATCH' AS status
UNION ALL
MATCH ()-[r:AUTHORED]->()
WITH count(*) AS actual
WHERE actual <> 16
RETURN 'rels:AUTHORED' AS check, actual, 16 AS expected, 'MISMATCH' AS status
UNION ALL
MATCH ()-[r:BASED_ON_THEOREM]->()
WITH count(*) AS actual
WHERE actual <> 2
RETURN 'rels:BASED_ON_THEOREM' AS check, actual, 2 AS expected, 'MISMATCH' AS status
UNION ALL
MATCH ()-[r:CITES]->()
WITH count(*) AS actual
WHERE actual <> 8
RETURN 'rels:CITES' AS check, actual, 8 AS expected, 'MISMATCH' AS status
UNION ALL
MATCH ()-[r:COMPUTES_VIA]->()
WITH count(*) AS actual
WHERE actual <> 1
RETURN 'rels:COMPUTES_VIA' AS check, actual, 1 AS expected, 'MISMATCH' AS status
UNION ALL
MATCH ()-[r:CONNECTS]->()
WITH count(*) AS actual
WHERE actual <> 2
RETURN 'rels:CONNECTS' AS check, actual, 2 AS expected, 'MISMATCH' AS status
UNION ALL
MATCH ()-[r:CONNECTS_TO]->()
WITH count(*) AS actual
WHERE actual <> 10
RETURN 'rels:CONNECTS_TO' AS check, actual, 10 AS expected, 'MISMATCH' AS status
UNION ALL
MATCH ()-[r:CONTAINS]->()
WITH count(*) AS actual
WHERE actual <> 2
RETURN 'rels:CONTAINS' AS check, actual, 2 AS expected, 'MISMATCH' AS status
UNION ALL
MATCH ()-[r:DERIVED_FROM]->()
WITH count(*) AS actual
WHERE actual <> 1
RETURN 'rels:DERIVED_FROM' AS check, actual, 1 AS expected, 'MISMATCH' AS status
UNION ALL
MATCH ()-[r:DISPROVES]->()
WITH count(*) AS actual
WHERE actual <> 1
RETURN 'rels:DISPROVES' AS check, actual, 1 AS expected, 'MISMATCH' AS status
UNION ALL
MATCH ()-[r:EQUIVALENT_TO]->()
WITH count(*) AS actual
WHERE actual <> 36
RETURN 'rels:EQUIVALENT_TO' AS check, actual, 36 AS expected, 'MISMATCH' AS status
UNION ALL
MATCH ()-[r:FACTOR_OF]->()
WITH count(*) AS actual
WHERE actual <> 1
RETURN 'rels:FACTOR_OF' AS check, actual, 1 AS expected, 'MISMATCH' AS status
UNION ALL
MATCH ()-[r:GENERALIZES]->()
WITH count(*) AS actual
WHERE actual <> 4
RETURN 'rels:GENERALIZES' AS check, actual, 4 AS expected, 'MISMATCH' AS status
UNION ALL
MATCH ()-[r:GENERAL_THEORY_FOR]->()
WITH count(*) AS actual
WHERE actual <> 2
RETURN 'rels:GENERAL_THEORY_FOR' AS check, actual, 2 AS expected, 'MISMATCH' AS status
UNION ALL
MATCH ()-[r:GENERATED_BY]->()
WITH count(*) AS actual
WHERE actual <> 1
RETURN 'rels:GENERATED_BY' AS check, actual, 1 AS expected, 'MISMATCH' AS status
UNION ALL
MATCH ()-[r:HAS_CAYLEY_GRAPH]->()
WITH count(*) AS actual
WHERE actual <> 3
RETURN 'rels:HAS_CAYLEY_GRAPH' AS check, actual, 3 AS expected, 'MISMATCH' AS status
UNION ALL
MATCH ()-[r:HAS_L_FUNCTION]->()
WITH count(*) AS actual
WHERE actual <> 3
RETURN 'rels:HAS_L_FUNCTION' AS check, actual, 3 AS expected, 'MISMATCH' AS status
UNION ALL
MATCH ()-[r:HAS_SPECTRUM]->()
WITH count(*) AS actual
WHERE actual <> 1
RETURN 'rels:HAS_SPECTRUM' AS check, actual, 1 AS expected, 'MISMATCH' AS status
UNION ALL
MATCH ()-[r:HAS_SUBGRAPH]->()
WITH count(*) AS actual
WHERE actual <> 1
RETURN 'rels:HAS_SUBGRAPH' AS check, actual, 1 AS expected, 'MISMATCH' AS status
UNION ALL
MATCH ()-[r:IMPLIES]->()
WITH count(*) AS actual
WHERE actual <> 5
RETURN 'rels:IMPLIES' AS check, actual, 5 AS expected, 'MISMATCH' AS status
UNION ALL
MATCH ()-[r:INSTANCE_OF]->()
WITH count(*) AS actual
WHERE actual <> 4
RETURN 'rels:INSTANCE_OF' AS check, actual, 4 AS expected, 'MISMATCH' AS status
UNION ALL
MATCH ()-[r:INTRODUCES]->()
WITH count(*) AS actual
WHERE actual <> 2
RETURN 'rels:INTRODUCES' AS check, actual, 2 AS expected, 'MISMATCH' AS status
UNION ALL
MATCH ()-[r:IS_INSTANCE_OF]->()
WITH count(*) AS actual
WHERE actual <> 3
RETURN 'rels:IS_INSTANCE_OF' AS check, actual, 3 AS expected, 'MISMATCH' AS status
UNION ALL
MATCH ()-[r:LOWER_BOUND_FOR]->()
WITH count(*) AS actual
WHERE actual <> 1
RETURN 'rels:LOWER_BOUND_FOR' AS check, actual, 1 AS expected, 'MISMATCH' AS status
UNION ALL
MATCH ()-[r:MOTIVATED]->()
WITH count(*) AS actual
WHERE actual <> 1
RETURN 'rels:MOTIVATED' AS check, actual, 1 AS expected, 'MISMATCH' AS status
UNION ALL
MATCH ()-[r:PROPOSES]->()
WITH count(*) AS actual
WHERE actual <> 1
RETURN 'rels:PROPOSES' AS check, actual, 1 AS expected, 'MISMATCH' AS status
UNION ALL
MATCH ()-[r:PROVES]->()
WITH count(*) AS actual
WHERE actual <> 7
RETURN 'rels:PROVES' AS check, actual, 7 AS expected, 'MISMATCH' AS status
UNION ALL
MATCH ()-[r:P_ADIC_ANALOGUE_OF]->()
WITH count(*) AS actual
WHERE actual <> 1
RETURN 'rels:P_ADIC_ANALOGUE_OF' AS check, actual, 1 AS expected, 'MISMATCH' AS status
UNION ALL
MATCH ()-[r:REFINES]->()
WITH count(*) AS actual
WHERE actual <> 1
RETURN 'rels:REFINES' AS check, actual, 1 AS expected, 'MISMATCH' AS status
UNION ALL
MATCH ()-[r:RELATED_TO]->()
WITH count(*) AS actual
WHERE actual <> 3
RETURN 'rels:RELATED_TO' AS check, actual, 3 AS expected, 'MISMATCH' AS status
UNION ALL
MATCH ()-[r:STRENGTHENS]->()
WITH count(*) AS actual
WHERE actual <> 3
RETURN 'rels:STRENGTHENS' AS check, actual, 3 AS expected, 'MISMATCH' AS status
UNION ALL
MATCH ()-[r:TARGETS]->()
WITH count(*) AS actual
WHERE actual <> 4
RETURN 'rels:TARGETS' AS check, actual, 4 AS expected, 'MISMATCH' AS status
UNION ALL
MATCH ()-[r:USED_IN]->()
WITH count(*) AS actual
WHERE actual <> 3
RETURN 'rels:USED_IN' AS check, actual, 3 AS expected, 'MISMATCH' AS status
UNION ALL
MATCH ()-[r:USES]->()
WITH count(*) AS actual
WHERE actual <> 3
RETURN 'rels:USES' AS check, actual, 3 AS expected, 'MISMATCH' AS status
UNION ALL
MATCH ()-[r:USES_METHOD]->()
WITH count(*) AS actual
WHERE actual <> 6
RETURN 'rels:USES_METHOD' AS check, actual, 6 AS expected, 'MISMATCH' AS status
UNION ALL
MATCH ()-[r:USES_OBJECT]->()
WITH count(*) AS actual
WHERE actual <> 2
RETURN 'rels:USES_OBJECT' AS check, actual, 2 AS expected, 'MISMATCH' AS status
UNION ALL
MATCH ()-[r]->()
WITH count(*) AS actual
WHERE actual <> 155
RETURN 'rels:TOTAL' AS check, actual, 155 AS expected, 'MISMATCH' AS status;

// ── Structural checks ───────────────────────────────────────────
MATCH (rh:Theorem {name: "Riemann Hypothesis"})-[r:EQUIVALENT_TO]-()
WITH count(r) AS actual
WHERE actual <> 36
RETURN 'struct:rh_equivalence_degree' AS check, actual, 36 AS expected, 'MISMATCH' AS status;
MATCH (rh:Theorem {name: "Riemann Hypothesis"})-[:EQUIVALENT_TO]-(other)
WITH count(DISTINCT other) AS actual
WHERE actual <> 30
RETURN 'struct:rh_equivalence_partners' AS check, actual, 30 AS expected, 'MISMATCH' AS status;
MATCH (n) WHERE NOT (n)--()
WITH count(n) AS actual
WHERE actual <> 24
RETURN 'struct:orphan_nodes' AS check, actual, 24 AS expected, 'MISMATCH' AS status;
// Guard: the Nicolas node must carry the corrected primorial criterion
// (upstream riemann repo still mis-attributes Lagarias' sigma/H form).
MATCH (n:Theorem {name: "Nicolas Criterion"})
WHERE NOT n.statement CONTAINS "primorial"
RETURN 'guard:nicolas_criterion_corrected' AS check, n.statement AS actual, 'primorial form' AS expected, 'MISMATCH' AS status;
// (optional) list current orphans for review:
// MATCH (n) WHERE NOT (n)--() RETURN labels(n) AS labels, n.name AS name, n.title AS title;
