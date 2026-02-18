# ScenarioA vs ScenarioB: Context Engineering Stage Impact

Date: 2026-02-13

## Stage-by-stage comparison

| Context engineering stage | ScenarioA (with CE template patterns) | ScenarioB (bare/minimal) | Impact on final realization |
|---|---|---|---|
| Offloading | Decisions, status, plans, reviews, and implementation logs persisted in artifacts (`planning-artifacts/*`, `implementation-artifacts/*`) | No equivalent planning/decision/status artifact set | ScenarioA maintained continuity and consistency; ScenarioB remained ad-hoc and less traceable |
| Retrieval | Agent/skill/index files available (`.claude/agents`, `.claude/skills`, `CLAUDE.md`) | Only `.claude/settings.local.json`; no agents/skills/indexes | ScenarioA had better guided execution and broader, more consistent implementation |
| Reduction | Work decomposed into tasks (`T-1..T-11`) with scoped implementation and review cycles | No comparable decomposition artifacts | ScenarioA delivered larger validated scope (more modules/tests/docs); ScenarioB stayed narrower |
| Isolation | Specialized roles (researcher, planner, architect, implementer, reviewer, tester) | No specialized-agent structure present | ScenarioA process produced stronger separation of concerns in both workflow and codebase |
| Orchestration | Dispatcher + subagent flow documented in `session-token-usage.md` (14 dispatches total incl. main) | No orchestration/session telemetry artifact found | ScenarioA realization is auditable and systematically coordinated; ScenarioB is simpler but less governed |
| Governance | Structured review and quality gates present; lint and tests executed/passing post-fix | Tests pass, but no lint script defined | ScenarioA finished with stronger quality governance; ScenarioB remains baseline quality |

## Net outcome

- ScenarioA final realization is significantly more comprehensive and production-leaning: layered architecture, persistent SQLite data layer, broader tests, and formal governance artifacts.
- ScenarioB final realization is intentionally simpler and easier to follow, but prototype-level: in-memory storage, limited process artifacts, and weaker quality-gate coverage.

## Evidence basis

- `SCENARIOA-vs-SCENARIOB-REPORT-2026-02-13.md`
- `SCENARIO-PROMPTS.txt`
- `planning-artifacts/2026-02-13-token-comparison-test-scenarios.md`
- `Context_Engineering_Article.docx`
- `C:\Users\AndreyPopov\Documents\EPAM\ScenarioA` and `C:\Users\AndreyPopov\Documents\EPAM\ScenarioB` folder contents
