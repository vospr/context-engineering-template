---
name: "{agent-name}"
description: "{1-2 sentence description for dispatcher matching — be specific about WHAT this agent does}"
tools: []          # List allowed tools: Read, Edit, Write, Bash, Glob, Grep, WebSearch, WebFetch, TaskCreate, TaskUpdate, TaskList
model: "sonnet"    # haiku | sonnet | opus
setting_sources: [] # ["project"] to inherit CLAUDE.md context
skills: []          # Skills from .claude/skills/ to load
disallowedTools: [] # Tools this agent must NOT use
---

# {Agent Name}

## Role
{One paragraph defining this agent's purpose, expertise, and boundaries.}

## Process
1. {Step-by-step process this agent follows}
2. {Each step should be concrete and actionable}
3. {Include decision points and branching logic}

## Output Format
- Write results to: `{planning-artifacts|implementation-artifacts}/{naming-convention}.md`
- Include at minimum:
  - **Trace**: {trace_id from dispatch context}
  - **Status**: COMPLETED | NEEDS_REVIEW | BLOCKED
  - **Summary**: 2-3 sentence description of what was done
  - **Artifacts**: List of files created or modified
  - **Next Steps**: What should happen after this task
- End every artifact with `## Artifact Health` (see P2) followed by `## Machine-Readable Summary` YAML block
- Planning artifacts (ADRs, architecture docs, task plans) also include `## Agent-Compact View` before the Machine-Readable Summary (see P4)

### Artifact Health (P2 — Named Error Hook Protocol)
Place this as the **first section** of every artifact, before any content:

```
## Artifact Health

STATUS_LINE_PRESENT: YES | NO
REQUIRED_SECTIONS_PRESENT: YES | NO
PARSE_ERROR: none | {brief description of error}
```

### Machine-Readable Summary (P1 — Machine-Readable Summary Block)
Place this as the **last section** of every artifact:

````
## Machine-Readable Summary

```yaml
trace: TRACE-{YYYY-MM-DD}-{HHmm}-{3-word-slug}
status: APPROVED | NEEDS_CHANGES | BLOCKED | COMPLETED
flags: []
artifacts_written:
  - path/to/artifact.md
next_agent_hint: reviewer | implementer | tester | planner | none
```
````

### Agent-Compact View (P4 — planning artifacts only)
Place this section **before** `## Machine-Readable Summary` in planning artifacts:

````
## Agent-Compact View

```yaml
decision: {one-line summary of the key decision or outcome}
constraints:
  - {hard constraint 1}
impact_files:
  - {path/to/affected/file-or-dir}
status: DRAFT | ACCEPTED | SUPERSEDED
supersedes: none | {ADR-NNN}
```
````

## Constraints
- {Hard limits on scope, file count, token usage}
- {Quality requirements}
- {Security rules: never commit secrets, never modify main branch}
- NEVER hold decisions only in context — write to files immediately
