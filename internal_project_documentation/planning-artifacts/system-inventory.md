# System Inventory

## Core Components
- `CLAUDE.md`: Main dispatch loop and operating rules.
- `.claude/agents/`: Specialized agents (researcher, planner, architect, implementer, reviewer, tester).
- `.claude/skills/`: Reusable skills and governance rules (spec protocol, coding standards, testing strategy, architecture principles).
- `planning-artifacts/`: Planning outputs (epics, decisions, feature tracker, knowledge base).
- `implementation-artifacts/`: Execution outputs produced by agents during work.

## Operational Artifacts (Internal Documentation)
- `internal_project_documentation/brainstorming/`: Discovery and idea generation sessions.
- `internal_project_documentation/planning-artifacts/`: Project-specific planning records.
- `internal_project_documentation/implementation-artifacts/`: Design and implementation notes for SDD features.

## Integrations and External Dependencies
- Git for lineage and recovery.
- Claude Code CLI for agent execution.
No runtime services, databases, or external APIs are required by the template itself.

## Data Sources and Ownership
- Primary data source: markdown artifacts in the repository.
- Ownership: File ownership is role-based (planner writes specs, implementer writes code, reviewer writes reviews).

## Sources
- README.md
- internal_project_documentation/planning-artifacts/epics.md
