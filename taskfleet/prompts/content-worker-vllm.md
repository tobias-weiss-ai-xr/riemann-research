# Content Generation Task: {{TASK_ID}} — {{TASK_TITLE}}

You are generating content for the **courses** certification learning platform.
Generate ONLY the file content below. Do not include any meta-commentary, instructions,
or notes about what you did. Output starts immediately after this prompt.

## Exam Info

- **Exam code:** {{EXAM_CODE}}
- **Content type:** {{CONTENT_TYPE}}
- **Category:** {{CATEGORY}}

## Source material

Read these files for accurate content:
- `{{CATEGORY}}/{{EXAM_SLUG}}-exam-guide.md` — exam domains, skills measured, weights
{{CONTENT_TYPE_SECTION}}

## Requirements

### If generating a deep-dive (content_type = deep-dive)

Create a comprehensive, exam-focused deep-dive guide.

**Structure:**
1. YAML frontmatter with title, date (2026-08-15), description, categories, tags, slug
2. Intro paragraph linking to the exam guide
3. Domain-by-domain breakdown (H2 for each domain) with:
   - Sub-sections for each skill/objective
   - Concrete examples: CLI commands, PowerShell, portal steps, ARM/Bicep snippets
   - Comparison tables for service options
   - Configuration examples
   - Exam tips and "gotchas"
   - Key takeaway boxes / bolded critical facts
4. At least 15 code blocks (```bash, ```powershell, ```json, ```bicep, etc.)
5. Minimum {{MIN_LINES}} lines total
6. Match the quality of LPIC-1 deep dives in the repo

**Frontmatter format:**
```yaml
---
title: "{Exam Title} Deep Dive: {Topic Areas}"
date: 2026-08-15
description: "Master {Exam Code}: {topics}. Commands, examples, exam tips."
categories:
  - "{provider}"
tags:
  - "{provider}"
  - "{exam-code}"
  - "certification"
  - "deep-dive"
slug: "{slug}-deep-dive"
draft: false
---
```

### If generating practice questions (content_type = practice-questions)

Create a free practice questions file.

**Structure:**
1. YAML frontmatter
2. Intro linking to exam guide and deep dive
3. Questions distributed proportionally across domains by exam weight
4. Each question in this format:

```markdown
### Question {N}

{Question text}

a) {Option A}
b) {Option B}
c) {Option C}
d) {Option D}

<details>
<summary>Show Answer</summary>

**Answer: {letter}) {option text}**

**Explanation:** {2-4 sentence explanation}

</details>
```

5. Minimum {{MIN_QUESTIONS}} questions
6. Quality: plausible distractors, teaching explanations, scenario-based, varied difficulty (60% medium, 25% easy, 15% hard)

**Frontmatter format:**
```yaml
---
title: "{N} Free {Exam Title} Practice Questions ({Exam Code})"
date: 2026-08-15
description: "Test your {Exam Title} knowledge with free practice questions."
categories:
  - "{provider}"
tags:
  - "{provider}"
  - "{exam-code}"
  - "practice-questions"
slug: "{slug}-free-practice-questions"
draft: false
---
```

## Hard rules

1. No hallucinated commands/features — every CLI, cmdlet, service must be real
2. Match domain weights from the exam guide exactly
3. No filler — every section must contain concrete exam-relevant information
4. Output ONLY the file content starting with `---` frontmatter. No preamble.

OUTPUT THE COMPLETE FILE NOW:
