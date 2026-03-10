# Architectural Decision Records

---

## ADR-001 — Adopt Atomic Agents-Inspired Observability & Routing Patterns (P1–P5)

**Date:** 2026-03-10
**Status:** ACCEPTED
**Trace:** TRACE-2026-03-10-party-mode-estimation
**Decided by:** Party Mode estimation — Winston (Architect), Mary (Business Analyst), John (PM), Amelia (Developer), Murat (Test Architect)
**Source research:** `internal_project_documentation/docs/e2e/atomic.md` §3 (Sonnet Synthesis) + §4 (Opus Deep Analysis)

---

### Context

Research comparing Atomic Agents (BrainBlend-AI) to the Context Engineering Template identified 7 adoptable patterns. The team estimated and prioritized 5 items (P1–P5) as immediately implementable with no architectural blockers. Items 3 and 7 are deferred pending prerequisite work.

### Decision

Implement the following 5 patterns in priority order:

| Priority | Item | Description | Complexity |
|----------|------|-------------|------------|
| P1 | Machine-Readable Summary Block | Add mandatory `## Machine-Readable Summary` YAML terminal section to every agent artifact. Dispatcher reads only this block — never parses free text for machine signals. | LOW-MEDIUM |
| P2 | Named Error Hook Protocol | Add `## Artifact Health` as mandatory first section in every agent artifact output (STATUS_LINE_PRESENT, REQUIRED_SECTIONS_PRESENT, PARSE_ERROR). | LOW |
| P3 | Confidence-Scored Dispatch | In `CLAUDE.md` step 3, self-score top 2 candidate agents on 3 criteria (0–2 each). If top candidate scores <4/6 → ask user or route to planner. | LOW |
| P4 | Agent-Compact View Sections | Add `## Agent-Compact View` (≤10 lines structured YAML) to every planning artifact for token-efficient agent-to-agent transfer. | LOW |
| P5 | Strict session-context.md Schema | Define strict YAML schema for compaction entries: turn_id, timestamp, agent, task_id, status, key_decisions (max 3 bullets). | LOW |

### Deferred (not in this increment)

- **Item 3** (Failure Pattern Injection) — requires extraction to `.claude/skills/failure-pattern-inject.md` first + keyword false-positive guard. Estimated 14h risk-adjusted. Revisit after P1–P5 ship.
- **Item 7** (MCP Guard at Dispatch Time) — depends on P1 (Machine-Readable Summary Block) being validated in production first. Estimated 6h.

### Consequences

- **Positive:** Eliminates silent parsing failures; makes every agent output auditable; reduces token waste on artifact reads; enables evidence-based compaction.
- **Positive:** All P1–P5 changes are additive — no existing behavior removed.
- **Risk:** P1 requires `CLAUDE.md` step 6 logic change (parsing YAML not prose) — existing artifacts won't have the block; backward-compat transition needed in docs.
- **Constraint:** `CLAUDE.md` must remain ≤200 lines. P3 addition to step 3 is ~5 lines — acceptable. P5 addition to step 7 is ~8 lines — acceptable.

### Estimated Effort

| Scope | Dev | Test | Total |
|-------|-----|------|-------|
| P1–P5 combined | 9h | 5.5h | **14.5h** |

### Implementation Order

P1 → P2 (ship together in one PR, natural co-location in artifact template) → P3 → P4 → P5

---

*Record created by BMad Party Mode session — 2026-03-10*

---

## Agent-Compact View

```yaml
decision: Add Machine-Readable Summary Block + Named Error Hook to all agent artifacts
constraints:
  - CLAUDE.md must remain ≤200 lines
  - All P1–P5 changes are additive — remove nothing
  - Backward-compat: absent block falls back to legacy prose-scan with warning
impact_files:
  - .claude/agents/
  - CLAUDE.md
  - planning-artifacts/session-context.md
status: ACCEPTED
supersedes: none
```
