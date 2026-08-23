# Worker Task: {{TASK_ID}} — {{TASK_TITLE}}

You are an autonomous content worker for the **courses** certification learning platform.
You have been assigned **exactly one content generation task**. Do it well, verify it, commit it.

## Context (READ FIRST)

1. **Plan:** `courses/plan.md` — the master plan for learning material generation.
2. **Exam guide (reference):** `content/{{CATEGORY}}/{{EXAM_SLUG}}-exam-guide.md` — the existing exam
   guide with domains, skills measured, and study resources. Use this as the **source of truth**
   for what topics the deep dive / practice questions must cover.

## Your task

**ID:** `{{TASK_ID}}`
**Title:** {{TASK_TITLE}}
**Content type:** `{{CONTENT_TYPE}}`
**Exam:** `{{EXAM_CODE}}`

## What you must create

### If content type = deep-dive

Create a comprehensive, exam-focused deep-dive guide at:

```
{{OUTPUT_FILE}}
```

**Requirements:**

1. **Frontmatter** (YAML):
   ```yaml
   ---
   title: "{Exam Title} Deep Dive: {Primary Topic Areas}"
   date: 2026-08-15
   description: "Master {Exam Code}: {2-3 key topic areas listed}. Includes commands, configuration examples, and exam-relevant details."
   categories:
     - "{Provider}"
   tags:
     - "{provider}"
     - "{exam-code}"
     - "{relevant-tags}"
     - "certification"
     - "deep-dive"
   slug: "{slug}-deep-dive"
   draft: false
   ---
   ```

2. **Intro paragraph:** Link to the exam guide, state what the guide covers.

3. **Domain-by-domain breakdown** (H2 for each exam domain):
   - Sub-sections for each skill/objective within the domain
   - **Concrete examples:** CLI commands, PowerShell cmdlets, portal UI steps, ARM/Bicep snippets
   - **Comparison tables** for service options (e.g., replication types, VM sizes, storage tiers)
   - **Configuration examples** with file paths and key settings
   - **Exam tips** — call out commonly tested areas, "gotchas", and edge cases
   - **"Key takeaway"** boxes or bolded critical facts

4. **Code blocks** (minimum 15): Use ```bash, ```powershell, ```json, ```bicep, etc.
   Make every code block **realistic and exam-relevant**. No placeholders.

5. **Length:** Minimum {{MIN_LINES}} lines. Be thorough — this is THE reference students use to study.

6. **Style:** Match the quality and depth of the LPIC-1 deep dives in `content/lpi/guides/`.
   Reference `content/lpi/guides/lpic-1-101-500-deep-dive.md` for formatting style.

### If content type = practice-questions

Create a free practice questions file at:

```
{{OUTPUT_FILE}}
```

**Requirements:**

1. **Frontmatter** (YAML):
   ```yaml
   ---
   title: "{N} Free {Exam Title} Practice Questions ({Exam Code})"
   date: 2026-08-15
   description: "Test your {Exam Title} knowledge with free practice questions covering {list 3 domains}."
   categories:
     - "{Provider}"
   tags:
     - "{provider}"
     - "{exam-code}"
     - "{relevant-tags}"
     - "practice-questions"
   slug: "{slug}-free-practice-questions"
   draft: false
   ---
   ```

2. **Intro:** Link to the exam guide and deep dive.

3. **Questions distributed proportionally** across all exam domains based on exam weight.

4. **Question format:**
   ```markdown
   ### Question {N}

   {Question text}

   a) {Option A}
   b) {Option B}
   c) {Option C}
   d) {Option D}

   <details>
   <summary>Show Answer</summary>

   **Answer: {correct letter}) {correct option text}**

   **Explanation:** {2-4 sentence explanation with why the correct answer is right
   and why the distractors are wrong. Reference specific services, features, or concepts.}

   </details>
   ```

5. **Minimum {{MIN_QUESTIONS}} questions.** Use `### Question N` heading for each.

6. **Quality rules:**
   - All 4 options must be plausible (no obviously wrong distractors)
   - Explanations must teach something — not just state the answer
   - Cover scenario-based questions (not just definition recall)
   - Include "negative" questions ("Which of the following is NOT...")
   - Include "most appropriate" questions (common exam pattern)
   - Vary difficulty: ~60% medium, ~25% easy, ~15% hard

7. **Read the deep dive** at `content/{{CATEGORY}}/{{EXAM_SLUG}}-deep-dive.md` for accurate content.
   Cross-reference with the exam guide for domain weights.

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

1. **No hallucinated commands or features.** Every CLI command, PowerShell cmdlet, and
   service name must be a real Microsoft/Azure feature. When uncertain, use generic
   descriptions rather than inventing specifics.
2. **Accurate exam weights.** Match the domain percentages from the exam guide exactly.
3. **Consistent formatting.** Match the markdown style of existing guides in the repo.
4. **Realistic difficulty.** Practice questions should match actual exam complexity.
5. **No filler content.** Every section must contain concrete, exam-relevant information.

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
   - Number of code blocks (deep-dive) or questions (practice-questions)
   - Domains covered
   - Any deviations from the spec

Do not push; the orchestrator merges and pushes.

{{PREVIOUS_ERROR}}
