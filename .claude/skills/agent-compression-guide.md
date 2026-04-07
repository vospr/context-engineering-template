# Agent Spec Compression Guide

Atelier Pipeline v3.21.0 achieved 58% agent spec reduction. This guide applies the same principles to Context Engineering agent and skill definitions.

## Core Principle

Every token in an agent prompt is **multiplied by every dispatch**. A 2000-token persona dispatched 4 times = 8000 tokens on persona alone. Compression directly multiplies session capacity.

## Compression Rules

### 1. Identity vs. Operations Split
Split every agent/skill into two sections:
- **Identity** (always loaded): role, constraints, output format — ≤200 tokens
- **Operations** (loaded on demand): step-by-step procedures, templates, examples — loaded only when that specific operation is invoked

### 2. Remove Redundant Context
- Delete examples that duplicate what the rule already says
- Remove "do NOT" lists that restate positive rules as negatives
- Remove motivation/rationale paragraphs — agents don't need to know *why* a rule exists
- Collapse multi-line rules into single-line rules where meaning is preserved

### 3. Compress Reference Tables
- Replace prose descriptions with tables
- Use abbreviations in column headers
- Remove rows that describe default behavior (only document deviations)

### 4. Template Minimization
- Templates should contain placeholders and structure only
- Remove inline commentary within templates
- Reference separate template files instead of inlining large templates

### 5. Token Budget per Agent Type

| Agent Type | Max Identity Tokens | Max Operations Tokens | Total Budget |
|------------|--------------------|-----------------------|-------------|
| Implementer | 200 | 800 | 1000 |
| Reviewer | 200 | 600 | 800 |
| Blind Reviewer | 150 | 400 | 550 |
| Tester | 200 | 600 | 800 |
| Planner | 200 | 800 | 1000 |
| Architect | 250 | 1000 | 1250 |
| Researcher | 150 | 300 | 450 |

## Audit Checklist

When reviewing an agent spec for compression:
1. [ ] Can any paragraph be replaced by a single sentence?
2. [ ] Are there examples that don't add information beyond the rule?
3. [ ] Are there "do NOT" rules that are just negations of existing positive rules?
4. [ ] Can any multi-step instruction be collapsed into a table row?
5. [ ] Is any template content inlined that could be a file reference?
6. [ ] Are there motivation/history paragraphs that agents don't need?
7. [ ] Does the identity section exceed 200 tokens?

## Measurement

After compression, measure with:
```
wc -w .claude/agents/*.md .claude/skills/*.md
```

Target: 40-60% reduction from pre-compression word count.

## When NOT to Compress

- Security constraints (keep explicit and redundant for safety)
- Output format specifications (precision matters)
- Tool permission lists (exactness required)
