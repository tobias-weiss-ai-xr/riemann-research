# Worker Task: {{TASK_ID}} — {{TASK_TITLE}}

You are an autonomous content worker for the **courses** certification learning platform.
You have been assigned **exactly one content generation task**. Do it well, verify it, commit it.

## Context (READ FIRST)

1. **Plan:** `courses/plan.md` — the master plan for learning material generation.
2. **Exam guide (reference):** `content/{{CATEGORY}}/{{EXAM_SLUG}}-exam-guide.md` — the existing exam
   guide with domains, skills measured, and study resources. Use this as the **source of truth**.
3. **Deep dive (reference):** `content/{{CATEGORY}}/{{EXAM_SLUG}}-deep-dive.md` — comprehensive
   domain-by-domain guide. Use for accurate technical content.

## Your task

**ID:** `{{TASK_ID}}`
**Title:** {{TASK_TITLE}}
**Content type:** scenario-challenges
**Exam:** `{{EXAM_CODE}}`
**Minimum challenges:** {{MIN_CHALLENGES}}

## What you must create

Create a **scenario-based challenge** file at:

```
{{OUTPUT_FILE}}
```

### What are scenario challenges?

Based on educational gamification research:
- **MedGame (2026):** Storytelling gamification transforms static cases into decision-centered learning trajectories
- **QubitQuest (2026):** Mini-games with progressive difficulty focused on specific concepts
- **CyberAGENTS (2026):** Structured autonomy through competency-based progression
- **The Effortless Trap (2026):** Productive struggle before answers doubles learning outcomes

Each challenge presents a **real-world scenario** (a workplace situation, an incident, a project requirement) and asks the learner to apply their knowledge to solve it. Unlike standard practice questions, scenario challenges:
1. Provide narrative context (a brief story/setup)
2. Often chain 2-3 related questions around the same scenario
3. Require applying multiple concepts simultaneously
4. Mimic real exam scenario-based questions

### Frontmatter (YAML)

```yaml
---
title: "{N} Scenario Challenges: {Exam Title} ({Exam Code})"
date: 2026-08-15
description: "Real-world scenario challenges for the {Exam Code} exam. Practice applying knowledge in workplace situations, incident responses, and design decisions."
categories:
  - "{Provider}"
tags:
  - "{provider}"
  - "{exam-code}"
  - "scenario-challenges"
  - "gamification"
  - "practice"
slug: "{slug}-scenario-challenges"
draft: false
---
```

### Structure

1. **Intro:** Brief intro explaining how to use scenario challenges. Link to exam guide and deep dive.
   Mention: "These challenges simulate real workplace scenarios. Read the situation carefully before answering."

2. **Challenges organized by scenario type:**
   - **🏢 Workplace Scenarios** — "You are a [role] at [company type]. [Situation]..."
   - **🚨 Incident Response** — "A [problem/issue] has occurred. [Details]..."
   - **📐 Design Decisions** — "Your organization needs to [requirement]. [Constraints]..."
   - **🔧 Troubleshooting** — "[System] is experiencing [symptom]. [Context]..."

3. **Each challenge format:**

```markdown
### Challenge {N}: {Brief Title}

**Scenario:**
{2-4 sentence narrative setup — describe the role, organization, situation, and problem}

**Question:**
{Question that requires applying knowledge to the scenario}

a) {Option A — plausible, but wrong}
b) {Option B — plausible, but wrong}
c) {Option C — plausible, but wrong}
d) {Option D — correct answer}

<details>
<summary>Show Answer</summary>

**Answer: {letter}) {option text}**

**Why this is correct:** {2-3 sentences explaining the reasoning in context of the scenario}

**Why the others are wrong:** {1 sentence each explaining why A, B, C are incorrect in this context}

</details>
```

4. **Some challenges should be multi-part** (2-3 questions per scenario):

```markdown
### Challenge 5: Azure Migration Strategy (Part 1/3)

**Scenario:**
{Scenario text}

**Question 1/3:** {First question about assessment}

a) ... b) ... c) ... d) ...

<details><summary>Show Answer</summary>...</details>

### Challenge 6: Azure Migration Strategy (Part 2/3)

**Scenario:** *(same as Challenge 5)*

**Question 2/3:** {Second question about implementation}

a) ... b) ... c) ... d) ...

<details><summary>Show Answer</summary>...</details>
```

### Requirements

1. **Minimum {{MIN_CHALLENGES}} individual challenge items** (a 3-part scenario counts as 3)
2. **Distribute across domains** proportional to exam weights
3. **Vary scenario types** — include workplace, incident, design, and troubleshooting
4. **Realistic scenarios** — use real service names, real CLI commands, real constraints
5. **No definition recall** — every challenge must require APPLYING knowledge, not just remembering it
6. **Progressive difficulty** — early challenges are easier, later ones combine multiple concepts
7. **Minimum 400 lines total**

### Quality rules

- All 4 options must be plausible in the scenario context
- Distractors should be "right answer to a different question" (common exam pattern)
- Scenarios must be realistic workplace situations (not contrived)
- Use specific numbers, names, and constraints (not vague "you have a server")
- No hallucinated services/commands — if unsure, use generic descriptions

## File scope — edit ONLY these paths

```
{{SCOPE_BLOCK}}
```

Editing files outside this scope will FAIL the verification gate.

## Acceptance gate — the orchestrator WILL run this

```sh
{{ACCEPT_COMMAND}}
```

You MUST run this command yourself before committing. If it fails, fix your work and
re-run. **Never commit content that fails the acceptance gate.**

## Hard rules

1. **No hallucinated commands or features.** Every CLI command, service name, and feature must be real.
2. **Accurate exam weights.** Match the domain percentages from the exam guide.
3. **Consistent formatting.** Match the markdown style of existing guides in the repo.
4. **Scenario must be realistic.** Not a contrived setup that would never happen in practice.
5. **No filler content.** Every challenge must test real exam-relevant skills.

## HARD REQUIREMENT: you MUST create the file

Your task is judged ONLY by the output file existing and passing the gate. The orchestrator
checks `git diff` against the base commit before running the gate.

**If you do not create the file or it doesn't pass the gate, the task FAILS immediately.**

## When finished

1. Run the acceptance gate. It must be green.
2. `git add` the output file only.
3. Commit with message: `content({{TASK_ID}}): {{TASK_TITLE}}`
4. Reply with a concise summary:
   - File created and line count
   - Number of challenges
   - Scenario types used
   - Domains covered
   - Any deviations from the spec

Do not push; the orchestrator merges and pushes.

{{PREVIOUS_ERROR}}
