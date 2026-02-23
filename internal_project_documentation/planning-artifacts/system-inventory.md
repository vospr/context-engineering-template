# System Inventory

## Core Components
- `CLAUDE.md`: Main dispatch loop and operating rules (162 lines). Includes Step 0 (Standards Check) and compaction keep-list.
- `.claude/agents/`: Specialized agents (researcher, planner, architect, implementer, reviewer, tester).
- `.claude/skills/`: Reusable skills and governance rules (spec protocol, coding standards loader, testing strategy, architecture principles).
- `.claude/skills/overrides/`: Local project-specific coding standards that override remote and community sources (trust: override).
- `coding-standards-sources.yaml`: Registry mapping languages to coding standard sources with trust levels (override > verified > community).
- `planning-artifacts/`: Planning outputs (epics, decisions, feature tracker, knowledge base, resolved coding standards).
- `implementation-artifacts/`: Execution outputs produced by agents during work.

## Operational Artifacts (Internal Documentation)
- `internal_project_documentation/brainstorming/`: Discovery and idea generation sessions.
- `internal_project_documentation/planning-artifacts/`: Project-specific planning records.
- `internal_project_documentation/implementation-artifacts/`: Design and implementation notes for SDD features.

## Runtime Artifacts (Generated)
- `planning-artifacts/detected-stack.json`: Auto-detected project language/framework stack.
- `planning-artifacts/coding-standards-resolved.md`: Merged coding standards per language (full rules).
- `planning-artifacts/coding-standards-summary.md`: Compressed top 15-20 rules (survives compaction, ≤400 tokens).
- `.claude/standards-cache/`: Cached remote coding standard sources (populated externally, consumed by loader).

## Integrations and External Dependencies
- Git for lineage and recovery.
- Claude Code CLI for agent execution.
- Remote coding standards sources (awesome-cursorrules) — fetched out-of-band, cached locally.
No runtime services, databases, or external APIs are required by the template itself.

## Data Sources and Ownership
- Primary data source: markdown artifacts in the repository.
- Ownership: File ownership is role-based (planner writes specs, implementer writes code, reviewer writes reviews).

## Sources
- README.md
- internal_project_documentation/planning-artifacts/epics.md
