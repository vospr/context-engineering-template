# Constraints and Risks

## Non-Negotiable Constraints
- Markdown-first, zero-runtime design. All behavior lives in markdown and file conventions.
- File system is the durable source of truth; Git provides lineage and recovery.
- No new agents required for SDD; extend the existing agent set only.
- Incremental adoption: SDD is opt-in and must not break non-SDD workflows.
- Kernel constraint: CLAUDE.md remains compact (under the documented limit).

## Operating Constraints
- Spec packets are embedded in task descriptions to minimize context loading.
- Controlled vocabulary for requirements (MUST/SHOULD/MAY/MUST NOT).
- 7x7 structural constraint: max 7 tasks per feature, max 7 assertions per task.

## Key Risks (Brownfield Context)
- Legacy behavior drift if specs are incomplete or ambiguous.
- Context loss or artifact inconsistency leading to incorrect dispatch decisions.
- Overgrowth of planning artifacts without periodic curation.
- Spec governance overhead if constraints are applied inconsistently.

## Mitigations (Existing or Planned)
- Spec protocol and validation gates to reduce ambiguity.
- Feature tracker for continuity across sessions.
- Trace ID and escalation protocols for debugging and resilience.
- Two-layer verification for early defect detection.

## Sources
- README.md
- internal_project_documentation/brainstorming/brainstorming-session-2026-02-21.md
- internal_project_documentation/planning-artifacts/epics.md
