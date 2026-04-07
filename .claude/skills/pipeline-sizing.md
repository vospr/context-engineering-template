# Pipeline Sizing — 4-Tier Adaptive Model

Classify each task into one of four tiers. The tier determines which agents participate and which model to use.

## Tier Definitions

| Tier | Criteria | Agent Composition | Model Override |
|------|----------|-------------------|----------------|
| **Micro** | 1 file, mechanical change (typo, rename, config tweak), no logic decisions | Implementer only, skip review | haiku |
| **Small** | 2-3 files, bug fix or minor enhancement, no architectural impact | Implementer → Reviewer (no planner) | sonnet |
| **Medium** | 2-4 steps, typical feature | Planner → Implementer → Reviewer + Blind Reviewer (parallel) → Tester | sonnet (default) |
| **Large** | 5+ steps, new system or cross-cutting change | Full pipeline: Planner → Architect → Implementer → Reviewer + Blind Reviewer (parallel) → Tester | opus (for architect steps) |

## Classification Heuristics

**Micro** — Answer YES to all:
- Single file only (not two files)?
- Change is mechanical (no design decisions, no logic changes)?
- No new dependencies, APIs, or interfaces?

**Small** — Answer YES to all:
- 2-3 files, scope is clear without planning?
- No architectural implications?
- Existing patterns can be followed directly?

**Medium** — Any of:
- Requires task decomposition
- Touches 3+ files across different concerns
- Introduces new patterns or interfaces
- Needs test coverage beyond unit tests

**Large** — Any of:
- 5+ implementation steps
- Architectural decisions required
- Cross-cutting concerns (auth, logging, data model changes)
- Multiple agents need parallel review perspectives

## Review Composition by Tier

| Tier | Standard Review | Blind Review | Tester |
|------|----------------|--------------|--------|
| Micro | Skip | Skip | Skip |
| Small | Yes | Skip | Skip |
| Medium | Yes | Yes (parallel) | Yes |
| Large | Yes | Yes (parallel) | Yes |

## Step Sizing Gate (Medium/Large only)

Before dispatching implementer on any step, validate it passes ALL 5 checks:

| # | Check | Question | Fail Action |
|---|-------|----------|-------------|
| S1 | **Demoable** | Can you show a visible result after this step? | Split into smaller demoable units |
| S2 | **Context-bounded** | Does it fit in one agent's context (~25k working tokens)? | Extract sub-steps that can be independent |
| S3 | **Independently verifiable** | Can tests validate this step alone? | Merge with dependent step or split differently |
| S4 | **Revert-cheap** | Can you `git revert` this step without cascading failures? | Reduce scope until revert is clean |
| S5 | **Already small** | Is further splitting just churn? | Pass — stop splitting |

A step must pass S1-S4 (S5 is a stop condition). If any of S1-S4 fails, sub-slice before dispatch.

## Max Turns per Tier

Prevent agent spiraling by hinting a turn budget:

| Tier | Max Turns | Escalation |
|------|-----------|-----------|
| Micro | 5 | If exceeded → re-classify as Small and retry once; if still exceeded → mark BLOCKED |
| Small | 15 | If exceeded → re-classify as Medium and retry once; if still exceeded → mark BLOCKED |
| Medium | 25 | If exceeded → re-classify or split |
| Large | 40 | If exceeded → re-classify or split |

## Model Selection

- **Micro**: haiku for everything (cost optimization)
- **Small**: sonnet for implementer + reviewer
- **Medium**: sonnet default; escalate individual steps to opus only if ESCALATED flag returned
- **Large**: opus for architect steps; sonnet for implementation; opus for final review
