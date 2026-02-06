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
  - **Status**: COMPLETED | NEEDS_REVIEW | BLOCKED
  - **Summary**: 2-3 sentence description of what was done
  - **Artifacts**: List of files created or modified
  - **Next Steps**: What should happen after this task

## Constraints
- {Hard limits on scope, file count, token usage}
- {Quality requirements}
- {Security rules: never commit secrets, never modify main branch}
- NEVER hold decisions only in context — write to files immediately
