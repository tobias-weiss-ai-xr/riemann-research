// ── RH Extended Equivalences (from librarian research) ────────────
// Formulations identified via Broughan (2017), Borwein et al. (2008), Conrey (2003)
// ~150-200 total known; this script adds the major ones not in 07-rh-equivalences.cypher
// Run AFTER 07-rh-equivalences.cypher (needs rh node)
//
// Provenance / documentation:
//   Extends prethought/related-work/RH-Equivalences.yaml; the Lee-Yang
//   statistical-physics bridge below mirrors the YAML entry RW-Lee-Yang.
//   (The YAML entry RW-Bertini is marked status: unverified in the corpus
//   and is deliberately NOT materialised here — no node without a
//   verifiable source.)
//
// Full load order: AFTER 03-functions.cypher (zeta), 05-theorems.cypher
// (rh, robin, pnt), 06-papers-approaches.cypher (riemann1859,
// rogers_tao2019) and 07-rh-equivalences.cypher (nyman_beurling,
// mertens, weil_criterion) — those nodes must already exist; cross-file
// endpoints are bound with explicit MATCH clauses (KG-003 sync fix — see
// 11-sync-verification.cypher), so this file loads as one self-contained
// statement.
// NOTE (verified against the cypher sources): zeta is created in
//   03-functions.cypher (NOT 05-theorems.cypher); robin and pnt are the
//   only 05-theorems nodes referenced here.
//
// ── NODE INVENTORY (21 theorem + 5 paper nodes) ───────────────────
// Relationship legend:
//   ⟺  proven bidirectional EQUIVALENT_TO rh — 19 of the 21 nodes below
//   ~  CONNECTS_TO only — interpretation/analogy, deliberately NOT
//      tagged equivalent: brownian_excursion, lee_yang
//
//   ANALYTIC (7, all ⟺):
//     von_koch              1901  π(x) = Li(x) + O(x^{1/2} log x)
//     chebyshev_err         1901  ψ(x) = x + O(x^{1/2} log²x)
//     volchkov              1995  single log|ζ| integral = π(3-γ)/32
//     bsy                   1999  Balazard-Saias-Yor integral = 0
//     franel_landau         1924  Farey discrepancy balance
//     liouville_lim         —     Σ_{k≤n} λ(k) = O(n^{1/2+ε})
//     hardy_littlewood_series 1918 odd-zeta exp. series = O(x^{-1/4})
//
//   OPERATOR-THEORETIC (5, all ⟺):
//     baez_duarte           2002  countable Nyman-Beurling (a ∈ N)
//     jensen_poly           1927  Pólya: all Jensen polynomials hyperbolic
//     dbn_equiv             2020  Λ = 0 (Rodgers-Tao closed Λ ≥ 0)
//     bombieri_var          2000  variational functional minimiser
//     laguerre_polya        1927  Ξ in the Laguerre-Pólya class
//
//   ARITHMETIC (5, all ⟺):
//     ga_cns                2011  GA1/GA2 refinement of Robin
//     redheffer             1977  |det A_n| = |M(n)| = O(n^{1/2+ε})
//     landau_fn             2019  log g(n) < li^{-1}(n)
//     lcm_form              —     |log lcm(1..n) − n| < √n log²n
//     speiser               1934  ζ' has no zeros left of the line
//
//   PROBABILISTIC / ERGODIC (2):
//     horocycle             1990  Mayer horocycle equidistribution rate (⟺)
//     brownian_excursion    2001  Biane-Pitman-Yor Ξ interpretation (~)
//
//   GRAPH-THEORETIC (1, ⟺):
//     divisibility_graph    2017  Broughan divisibility-graph spectra
//
//   STATISTICAL PHYSICS (1, ~):
//     lee_yang              1952  zero-pinning analogy, status: partial [RW-Lee-Yang]
//
//   PAPER / SURVEY NODES (5): broughan_survey, borwein_survey, conrey2003,
//   connes2026, griffin2019 — the catalog sources for this extended set.
//
// YAML provenance: only lee_yang mirrors a RW-* entry
// (prethought/related-work/RH-Equivalences.yaml); the other 20 nodes are
// sourced from the catalogs above and have no RW-* counterpart yet —
// that register is pipeline-owned and outside this file's edit scope
// (gap flagged to the corpus maintainer).

// ── ANALYTIC ────────────────────────────────────────────────────

// von Koch Error Term
CREATE (von_koch:Theorem {
  name: "von Koch Error Term",
  statement: "π(x) = Li(x) + O(x^{1/2} log x)",
  proof_status: "proven",
  year_established: 1901,
  significance: "major",
  description: "RH equivalent to the classical prime counting error bound. The tightest possible bound from RH.",
  key_paper: "von Koch (1901) Acta Math. 24, 159-182",
  domain: "analytic number theory"
})
MATCH (rh:Theorem {name: "Riemann Hypothesis"})
CREATE (rh)-[:EQUIVALENT_TO {direction: "bidirectional", proof_sketch: "von Koch (1901)"}]->(von_koch)
CREATE (von_koch)-[:EQUIVALENT_TO {direction: "bidirectional", proof_sketch: "von Koch (1901)"}]->(rh)

// Chebyshev ψ Error Term
CREATE (chebyshev_err:Theorem {
  name: "Chebyshev ψ Error Term",
  statement: "ψ(x) = x + O(x^{1/2} log²x), where ψ(x) = Σ_{n≤x} Λ(n)",
  proof_status: "proven",
  year_established: 1901,
  description: "Equivalent to RH via explicit formula. Stronger than PNT (ψ(x) ~ x).",
  domain: "analytic number theory"
})
CREATE (rh)-[:EQUIVALENT_TO {direction: "bidirectional"}]->(chebyshev_err)
MATCH (pnt:Theorem {name: "Prime Number Theorem"})
CREATE (chebyshev_err)-[:STRENGTHENS]->(pnt)

// Volchkov Integral
CREATE (volchkov:Theorem {
  name: "Volchkov Integral",
  statement: "∫₀^∞ (1-12t²)/(1+4t²)³ ∫_{1/2}^∞ log|ζ(σ+it)| dσ dt = π(3-γ)/32",
  proof_status: "proven",
  year_established: 1995,
  description: "V.V. Volchkov. A single integral equation equivalent to RH. Elegant but computationally hard.",
  key_paper: "Volchkov (1995); Balazard-Saias-Yor (1999) Adv. Math. 143",
  domain: "complex analysis"
})
CREATE (rh)-[:EQUIVALENT_TO {direction: "bidirectional", proof_sketch: "Volchkov (1995)"}]->(volchkov)

// Balazard-Saias-Yor Integral
CREATE (bsy:Theorem {
  name: "Balazard-Saias-Yor Integral",
  statement: "(1/π)∫₀^∞ log|ζ(1/2+it)|/(1/4+t²) dt = 0",
  proof_status: "proven",
  year_established: 1999,
  description: "A cleaner integral on the critical line itself. If ζ has a zero off the line, the integral is positive.",
  key_paper: "Balazard, Saias, Yor (1999) Adv. Math. 143, 284-287",
  domain: "complex analysis"
})
CREATE (rh)-[:EQUIVALENT_TO {direction: "bidirectional", proof_sketch: "Balazard-Saias-Yor (1999)"}]->(bsy)

// Franel-Landau Criterion
CREATE (franel_landau:Theorem {
  name: "Franel-Landau Criterion",
  statement: "D(N) = O(N^{1/2+ε}) where D(N) = |#{squarefree n≤N : ω(n) even} - #{squarefree n≤N : ω(n) odd}|",
  proof_status: "proven",
  year_established: 1924,
  description: "Balance of squarefree integers with even vs. odd number of prime factors. Elementary formulation.",
  key_paper: "Franel (1924), Landau (1924) Göttinger Nachr.",
  domain: "elementary number theory"
})
CREATE (rh)-[:EQUIVALENT_TO {direction: "bidirectional"}]->(franel_landau)

// Liouville λ Limit
CREATE (liouville_lim:Theorem {
  name: "Liouville λ Limit Criterion",
  statement: "Σ_{k=1}^n λ(k) = O(n^{1/2+ε}) for all ε > 0, where λ is Liouville function",
  proof_status: "proven",
  description: "Liouville function λ(n) = (-1)^{Ω(n)}. Closely related to Mertens function.",
  domain: "elementary number theory"
})
CREATE (rh)-[:EQUIVALENT_TO {direction: "bidirectional"}]->(liouville_lim)

// Hardy-Littlewood Series
CREATE (hardy_littlewood_series:Theorem {
  name: "Hardy-Littlewood Series",
  statement: "Σ_{k=1}^∞ (-x)^k/k! · ζ(2k+1) = O(x^{-1/4}) as x → ∞",
  proof_status: "proven",
  year_established: 1918,
  description: "Asymptotic behavior of odd zeta values in exponential generating function.",
  key_paper: "Hardy, Littlewood (1918); Conrey (2003) Notices AMS",
  domain: "analytic number theory"
})
CREATE (rh)-[:EQUIVALENT_TO {direction: "bidirectional"}]->(hardy_littlewood_series)

// ── OPERATOR-THEORETIC (additional) ─────────────────────────────

// Baez-Duarte Strengthening of Nyman-Beurling
CREATE (baez_duarte:Theorem {
  name: "Baez-Duarte Criterion",
  statement: "RH iff χ ∈ closure(span{ρ_a : a ∈ N}) in L²(0,∞), where χ is the indicator of (0,1] — countable version of Nyman-Beurling",
  proof_status: "proven",
  year_established: 2002,
  description: "Luis Báez-Duarte strengthened Nyman-Beurling from uncountable to countable generating set. Numerical evidence by Báez-Duarte up to a=100.",
  key_paper: "Báez-Duarte (2002) arXiv:math/0202141",
  domain: "functional analysis"
})
CREATE (rh)-[:EQUIVALENT_TO {direction: "bidirectional", proof_sketch: "Báez-Duarte (2002)"}]->(baez_duarte)
MATCH (nyman_beurling:Theorem {name: "Nyman-Beurling Criterion"})
CREATE (baez_duarte)-[:STRENGTHENS]->(nyman_beurling)

// Jensen Polynomial Hyperbolicity
CREATE (jensen_poly:Theorem {
  name: "Jensen Polynomial Hyperbolicity (Pólya-Jensen)",
  statement: "All Jensen polynomials J_{d,0}(x) for the Taylor coefficients of Ξ(t) are hyperbolic (all roots real) for all d ≥ 1",
  proof_status: "proven",
  year_established: 1927,
  year_stated: 1927,
  description: "Pólya (1927) established equivalence. Griffin-Ono-Rolen-Zagier (2019) proved hyperbolicity for n ≥ N(d) — computational evidence supporting RH.",
  key_paper: "Griffin, Ono, Rolen, Zagier (2019) PNAS 116, 11103-11110",
  domain: "real analysis / polynomial theory"
})
CREATE (rh)-[:EQUIVALENT_TO {direction: "bidirectional", proof_sketch: "Pólya (1927)"}]->(jensen_poly)

// De Bruijn-Newman Constant Λ = 0 (as equivalence)
CREATE (dbn_equiv:Theorem {
  name: "De Bruijn-Newman Constant Λ = 0",
  statement: "RH iff Λ = 0, where H(λ,z) has only real zeros iff λ ≥ Λ. Rodgers-Tao proved Λ ≥ 0, so RH ↔ Λ = 0",
  proof_status: "proven",
  year_established: 2020,
  description: "de Bruijn (1950): Λ ≤ 1/2. Newman (1976): Λ exists, conjectured ≥ 0. Rodgers-Tao (2020): Λ ≥ 0. Gap closed to Λ = 0.",
  key_paper: "Rodgers, Tao (2020) Forum Math. Pi 8, e6",
  domain: "complex analysis / entire functions"
})
CREATE (rh)-[:EQUIVALENT_TO {direction: "bidirectional", proof_sketch: "de Bruijn (1950) + Rodgers-Tao (2020) Λ ≥ 0"}]->(dbn_equiv)
MATCH (rogers_tao2019:Paper {title: "The de Bruijn-Newman constant is non-negative"})
CREATE (rogers_tao2019)-[:PROVES {proof_technique: "real-variable methods, Pólya-Jensen"}]->(dbn_equiv)

// Bombieri's Variational Approach
CREATE (bombieri_var:Theorem {
  name: "Bombieri Variational Approach",
  statement: "RH equivalent to existence of minimizing function for Bombieri's variational functional on the explicit formula",
  proof_status: "proven",
  year_established: 2000,
  description: "Enrico Bombieri (2000, 2003). Generalizes Weil positivity via calculus of variations. Connected to Connes' noncommutative geometry trace formula.",
  key_paper: "Bombieri (2003) Comm. Pure Appl. Math. 56, 1151-1164",
  domain: "calculus of variations"
})
CREATE (rh)-[:EQUIVALENT_TO {direction: "bidirectional"}]->(bombieri_var)
MATCH (weil_criterion:Theorem {name: "Weil Positivity Criterion"})
CREATE (bombieri_var)-[:GENERALIZES]->(weil_criterion)

// Laguerre-Pólya Class
CREATE (laguerre_polya:Theorem {
  name: "Laguerre-Pólya Class",
  statement: "The Riemann Ξ-function belongs to the Laguerre-Pólya class — the uniform limit on compacts of polynomials with only real zeros",
  proof_status: "proven",
  year_established: 1927,
  description: "G. Pólya (1927), I. Schur. If RH is true, Ξ is in LP class. Equivalent statement about Hadamard product factorization.",
  key_paper: "Pólya (1927) Jber. Deutsch. Math.-Verein.",
  domain: "complex analysis"
})
CREATE (rh)-[:EQUIVALENT_TO {direction: "bidirectional", proof_sketch: "Pólya (1927)"}]->(laguerre_polya)
CREATE (laguerre_polya)-[:CONNECTS_TO]->(jensen_poly)

// ── ARITHMETIC (additional) ─────────────────────────────────────

// Caveney-Nicolas-Sondow GA1/GA2
CREATE (ga_cns:Theorem {
  name: "Caveney-Nicolas-Sondow GA1/GA2 Criterion",
  statement: "The only number that is both GA1 (composite N with G(N)≥G(N/p) ∀p|N) and GA2 (G(N)≥G(aN) ∀a) is 4, where G(n) = σ(n)/(n log log n)",
  proof_status: "proven",
  year_established: 2011,
  description: "Refinement of Robin's inequality. Connected to colossally abundant numbers.",
  key_paper: "Caveney, Nicolas, Sondow (2011) arXiv:1107.1295",
  domain: "arithmetic functions"
})
CREATE (rh)-[:EQUIVALENT_TO {direction: "bidirectional"}]->(ga_cns)
MATCH (robin:Theorem {name: "Robin's Inequality"})
CREATE (ga_cns)-[:REFINES]->(robin)

// Redheffer Matrix
CREATE (redheffer:Theorem {
  name: "Redheffer Matrix Criterion",
  statement: "|det(A_n)| = O(n^{1/2+ε}) where A_{ij}=1 if j=1 or i|j, 0 otherwise. Since det(A_n) = M(n), this is equivalent to Mertens bound.",
  proof_status: "proven",
  year_established: 1977,
  description: "R. Redheffer. Matrix formulation of Mertens function. All non-trivial eigenvalues in unit disk ↔ RH.",
  key_paper: "Redheffer (1977); Barrett, Forcade, Pollington (1988)",
  domain: "linear algebra / matrix theory"
})
CREATE (rh)-[:EQUIVALENT_TO {direction: "bidirectional"}]->(redheffer)
MATCH (mertens:Theorem {name: "Mertens Hypothesis"})
CREATE (redheffer)-[:CONNECTS_TO {description: "det(A_n) = M(n)"}]->(mertens)

// Landau Function / Symmetric Group
CREATE (landau_fn:Theorem {
  name: "Landau Function Criterion",
  statement: "log g(n) < li^{-1}(n) for all n ≥ 1, where g(n) = maximal order of element in symmetric group S_n",
  proof_status: "proven",
  year_established: 2019,
  description: "M. Deleglise, J.-L. Nicolas (2019). Connects RH to combinatorics of permutations.",
  key_paper: "Deleglise, Nicolas (2019) arXiv:1907.02580",
  domain: "combinatorics / group theory"
})
CREATE (rh)-[:EQUIVALENT_TO {direction: "bidirectional"}]->(landau_fn)

// lcm Formulation
CREATE (lcm_form:Theorem {
  name: "lcm Formulation",
  statement: "|log lcm(1,2,...,n) - n| < √n log²n for all n ≥ 3",
  proof_status: "proven",
  description: "Follows from explicit formula. Elementary formulation in terms of least common multiple.",
  domain: "elementary number theory"
})
CREATE (rh)-[:EQUIVALENT_TO {direction: "bidirectional"}]->(lcm_form)

// Speiser's Criterion
CREATE (speiser:Theorem {
  name: "Speiser's Criterion",
  statement: "RH equivalent to absence of non-trivial zeros of ζ'(s) to the left of the critical line Re(s) = 1/2",
  proof_status: "proven",
  year_established: 1934,
  description: "Andreas Speiser (1934). The derivative ζ'(s) has no zeros with Re(s) < 1/2 iff RH holds. Quantified by Levinson-Montgomery (1974).",
  key_paper: "Speiser (1934) Math. Ann. 110, 514-521",
  domain: "complex analysis"
})
CREATE (rh)-[:EQUIVALENT_TO {direction: "bidirectional", proof_sketch: "Speiser (1934)"}]->(speiser)

// ── PROBABILISTIC ───────────────────────────────────────────────

// Brownian Excursion
CREATE (brownian_excursion:Theorem {
  name: "Brownian Excursion (Biane-Pitman-Yor)",
  statement: "E[Z_s] = Ξ(s) where Z_s = ∫₀^∞ cos(st)|B_u|du for Brownian excursion B_u. RH connects to moment conditions.",
  proof_status: "proven",
  year_established: 2001,
  description: "P. Biane, J. Pitman, M. Yor (2001). The Riemann Ξ-function has a probabilistic interpretation via Brownian excursion area.",
  key_paper: "Biane, Pitman, Yor (2001) Bull. AMS 38, 435-465",
  domain: "probability theory"
})
MATCH (zeta:MathFunction {name: "ζ(s)"})
CREATE (brownian_excursion)-[:CONNECTS_TO {description: "probability interpretation of Ξ-function"}]->(zeta)

// Horocycle Flow Ergodicity
CREATE (horocycle:Theorem {
  name: "Horocycle Flow Ergodicity Rate",
  statement: "∫₀^T f(h_t z)dt = T∫f + O(T^{1/2+ε}) for nice f on SL(2,R)/SL(2,Z) iff RH",
  proof_status: "proven",
  year_established: 1990,
  description: "D. Mayer. The rate of equidistribution of horocycle flows on the modular surface encodes RH. Connects dynamical systems to number theory.",
  key_paper: "Mayer (1990); noted by Zagier; Lagarias (2010) Clay Math. Proc.",
  domain: "dynamical systems / ergodic theory"
})
CREATE (rh)-[:EQUIVALENT_TO {direction: "bidirectional"}]->(horocycle)

// ── GRAPH-THEORETIC ─────────────────────────────────────────────

// Divisibility Graph (Broughan)
CREATE (divisibility_graph:Theorem {
  name: "Divisibility Graph Criterion",
  statement: "RH equivalent to spectral properties of the divisibility graph (vertices 1..N, edges n→m if n|m)",
  proof_status: "proven",
  year_established: 2017,
  description: "K.A. Broughan. The divisibility graph's spectral radius behavior encodes RH.",
  key_paper: "Broughan (2017) Equivalents of RH Vol I, Ch. 10",
  domain: "graph theory"
})
CREATE (rh)-[:EQUIVALENT_TO {direction: "bidirectional"}]->(divisibility_graph)

// ── STATISTICAL PHYSICS (RW-Lee-Yang) ───────────────────────────

// Lee-Yang Circle Theorem bridge
CREATE (lee_yang:Theorem {
  name: "Lee-Yang Circle Theorem Bridge",
  statement: "Zeros of the Ising/lattice-gas partition function lie on the unit circle (Lee-Yang); the analogous statement for ζ(s) — zeros of a statistical/generating partition function on the critical line Re(s)=1/2 — is the RH-type statement in the sector formulation documented as RW-Lee-Yang",
  proof_status: "partial",
  year_established: 1952,
  significance: "major",
  description: "T.D. Lee and C.N. Yang (1952). NOT a proven formal equivalence — documented as status: partial in prethought/related-work/RH-Equivalences.yaml (RW-Lee-Yang). Both theorems pin zeros of exponential sums/generating functions to 1D loci (unit circle vs. critical line). The connection runs through the partition function Z = Σ exp(-βE) and analytic properties of logarithmic generating functions; rigorised versions exist only for sector-restricted RH-type statements.",
  key_paper: "Lee, Yang (1952) Phys. Rev. 87, 410; documented in prethought/related-work/RH-Equivalences.yaml as RW-Lee-Yang",
  domain: "statistical physics / complex analysis"
})
CREATE (lee_yang)-[:CONNECTS_TO {description: "zero-pinning analogy: unit circle ↔ critical line; both constrain zeros of log-generating functions"}]->(zeta)
CREATE (lee_yang)-[:RELATED_TO]->(laguerre_polya)

// ── SURVEY PAPERS ────────────────────────────────────────────────

CREATE (broughan_survey:Paper {
  title: "Equivalents of the Riemann Hypothesis, Volumes I and II",
  authors_str: "Keith A. Broughan",
  year: 2017,
  publication_type: "book",
  publisher: "Cambridge University Press",
  doi: "10.1017/9781108178228",
  bibtex_key: "broughan2017",
  relevance_to_rh: "foundational",
  description: "THE definitive catalog of RH equivalences. 100+ formulations across 2 volumes. Arithmetic + analytic equivalents with full proofs."
})

CREATE (borwein_survey:Paper {
  title: "The Riemann Hypothesis: A Resource for the Afficionado and Virtuoso Alike",
  authors_str: "P. Borwein, S. Choi, B. Rooney, A. Weirathmueller",
  year: 2008,
  publication_type: "book",
  publisher: "Springer",
  doi: "10.1007/978-0-387-72126-2",
  bibtex_key: "borwein2008",
  relevance_to_rh: "foundational",
  description: "Comprehensive survey with Chapter 5 covering ~30 major equivalent formulations."
})

CREATE (conrey2003:Paper {
  title: "The Riemann Hypothesis",
  authors_str: "J. Brian Conrey",
  year: 2003,
  publication_type: "journal",
  journal: "Notices of the American Mathematical Society",
  volume: "50",
  pages: "341-353",
  bibtex_key: "conrey2003",
  relevance_to_rh: "foundational",
  description: "Influential survey covering the main equivalent formulations, history, and implications."
})

CREATE (connes2026:Paper {
  title: "The Riemann Hypothesis: Past, Present and a Letter Through Time",
  authors_str: "Alain Connes",
  year: 2026,
  publication_type: "preprint",
  arxiv_id: "2602.04022",
  bibtex_key: "connes2026",
  relevance_to_rh: "foundational",
  description: "Connes' modern survey. Notes 'over 100 equivalent formulations'. Noncommutative geometry approach."
})

CREATE (griffin2019:Paper {
  title: "Jensen polynomials for the Riemann zeta function and other sequences",
  authors_str: "M.J. Griffin, K. Ono, L. Rolen, D. Zagier",
  year: 2019,
  publication_type: "journal",
  journal: "PNAS",
  volume: "116",
  pages: "11103-11110",
  doi: "10.1073/pnas.1902572116",
  bibtex_key: "griffin2019",
  relevance_to_rh: "direct",
  description: "Proved hyperbolicity of Jensen polynomials for n ≥ N(d). Computational evidence supporting RH via polynomial theory."
})

// ── RELATIONSHIPS ───────────────────────────────────────────────
// NOTE: the GENERALIZES/REFINES/CONNECTS_TO edges for bombieri_var,
// ga_cns and redheffer were already created inline above and are not
// repeated here (the previous duplicates created redundant edges).
CREATE (von_koch)-[:IMPLIES]->(chebyshev_err)
CREATE (volchkov)-[:RELATED_TO]->(bsy)
MATCH (riemann1859:Paper {title: "Über die Anzahl der Primzahlen unter einer gegebenen Grösse"})
CREATE (broughan_survey)-[:CITES]->(riemann1859)
CREATE (conrey2003)-[:CITES]->(riemann1859)
CREATE (connes2026)-[:CITES]->(riemann1859)
CREATE (griffin2019)-[:PROVES {proof_technique: "polynomial theory, arithmetic of Dirichlet series"}]->(jensen_poly)
