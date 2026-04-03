# Failure Patterns
**Last Updated:** 2026-02-27
**Scope:** Persistent catalog of recurring implementation/spec failures used by reviewer and planner agents.

## Purpose

This file starts as a template and is appended over time when reviewers report repeated failure modes.

## Entry Template

```markdown
### {pattern-name}
- **Pattern:** {short pattern label}
- **Trigger:** {condition that causes the failure}
- **Prevention:** {concrete mitigation and enforcement}
- **Task Ref:** {task-id or n/a}
- **First Detected:** {YYYY-MM-DD} ({trace-id or n/a})
```

## Seed Categories

### Evidence Quality Drift
- **Pattern:** Missing concrete evidence locator
- **Trigger:** Assertion results use vague statements without `file:line` or `path.md#Heading`.
- **Prevention:** Enforce Section 11 evidence format in `spec-protocol.md` before marking PASS.
- **Task Ref:** n/a
- **First Detected:** n/a

### Scope Violation
- **Pattern:** Out-of-scope file modifications
- **Trigger:** Implementer edits files not listed in `file_scope`.
- **Prevention:** Reviewer validates touched files against `file_scope` and returns NEEDS_CHANGES on mismatch.
- **Task Ref:** n/a
- **First Detected:** n/a

## See Also
- planning-artifacts/knowledge-base/rag-sources.md
- .claude/skills/spec-protocol.md
