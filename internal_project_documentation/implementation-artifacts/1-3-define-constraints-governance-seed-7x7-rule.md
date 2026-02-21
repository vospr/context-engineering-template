# Story 1.3: Define Constraints, Governance Seed & 7x7 Rule

Status: review

## Story

As a project lead,
I want the spec protocol to include structural constraints and a lightweight governance seed,
so that specs stay focused and the system has foundational principles from day one.

## Acceptance Criteria

1. `spec-protocol.md` contains a constraints and governance section with the 7x7 rule: max 7 tasks per feature, max 7 assertions per task
2. A governance seed section contains 5-10 lightweight project principles
3. The graduated tier definitions are documented: TRIVIAL (no spec), SIMPLE (4 required fields, ~60 tokens), MODERATE (full spec + overview), COMPLEX (architect pre-check + spec suite)
4. The governance cascade precedence is stated: constitution.md > spec-protocol.md > skills > agent freedom

## Tasks / Subtasks

- [x] Task 1: Populate Section 5 (Constraints & Governance) in spec-protocol.md (AC: #1, #2, #4)
  - [x] Replace the `<!-- Placeholder: Story 1.3 will populate this section -->` comment in Section 5
  - [x] Document the 7x7 constraint: max 7 tasks per feature, max 7 assertions per task
  - [x] Explain the rationale: keeps specs focused, prevents scope creep, forces decomposition of large features
  - [x] Write 5-10 governance seed principles derived from the 6 Irreducible Truths in architecture
  - [x] State the governance cascade: constitution.md > spec-protocol.md > skills > agent freedom
  - [x] Note that constitution.md is optional (Slice 3) — SDD functions fully without it
- [x] Task 2: Populate Section 6 (Tier Definitions) in spec-protocol.md (AC: #3)
  - [x] Replace the `<!-- Placeholder: Story 1.3 will populate this section -->` comment in Section 6
  - [x] Define TRIVIAL tier: no spec, zero overhead, direct dispatch; examples of qualifying tasks
  - [x] Define SIMPLE tier: 4 required fields (version, intent, assertions, file_scope + constraints), ~60 tokens; classification criteria
  - [x] Define MODERATE tier: full spec packet + spec overview document; classification criteria
  - [x] Define COMPLEX tier: architect pre-check before planner writes spec suite + overview; classification criteria
  - [x] Include a decision table or flowchart for classifying tasks into tiers

## Dev Notes

### Architecture Compliance

- **Source of truth:** `_bmad-output/planning-artifacts/architecture.md`
- **Lines 42-43:** 7x7 constraint from Tier 1-2 requirements
- **Lines 23-33:** The 6 Irreducible Truths — governance seed principles should derive from these
- **Lines 63-71:** Slice definitions with tier details
- **ADR-005 (lines 121-130):** Progressive governance — lightweight in Slice 1, full constitution in Slice 3
- **Decision 2 (lines 232-240):** Dispatch loop integration — tier classification triggers in Step 4
- **Lines 51-52:** Token budgets per tier: TRIVIAL=500, SIMPLE=2000, MODERATE=8000, COMPLEX=25000

### 6 Irreducible Truths (for governance seed derivation)

1. An agent cannot autonomously verify its own work without a definition of "done" that exists outside its own context
2. A spec is only useful if the agent that consumes it can act on it without asking for clarification
3. The cost of specifying must be less than the cost of not specifying
4. State must survive context death
5. Agents must not need to understand the whole to execute a part
6. The system must be able to answer "where are we?" at any moment from files alone

### Previous Story Intelligence (Stories 1.1 + 1.2)

- spec-protocol.md at `.claude/skills/spec-protocol.md` now has Sections 1-4 populated
- Sections 5 and 6 contain placeholder comments: `<!-- Placeholder: Story 1.3 will populate this section -->`
- Section 2 already has tier EXAMPLES (TRIVIAL/SIMPLE/MODERATE/COMPLEX) — Section 6 adds the formal DEFINITIONS and classification criteria (do not duplicate examples)
- Controlled vocabulary from Section 3 should be used in governance principles (MUST/SHOULD/MAY)
- MUST edit existing file, do NOT recreate

### Critical Constraints

- Pure markdown only (NFR3)
- Edit `.claude/skills/spec-protocol.md` — do NOT create any new files
- Do NOT modify Sections 1, 2, 3, or 4 — those belong to Stories 1.1 and 1.2
- Keep content token-efficient
- Governance seed should be 5-10 principles, not a full constitution (that's Slice 3)

### Project Structure Notes

- Target file: `.claude/skills/spec-protocol.md` (EDIT existing, do not recreate)
- No other files should be created or modified

### References

- [Source: _bmad-output/planning-artifacts/architecture.md#Lines 23-33 Six Irreducible Truths]
- [Source: _bmad-output/planning-artifacts/architecture.md#Lines 42-43 7x7 Constraint]
- [Source: _bmad-output/planning-artifacts/architecture.md#Lines 63-71 Slice Definitions]
- [Source: _bmad-output/planning-artifacts/architecture.md#ADR-005 Governance]
- [Source: _bmad-output/planning-artifacts/architecture.md#Lines 51-52 Token Budgets]
- [Source: _bmad-output/planning-artifacts/epics.md#Story 1.3]
- [Source: _bmad-output/implementation-artifacts/1-2-define-controlled-vocabulary-assertion-quality-gate.md#Completion Notes]

## Dev Agent Record

### Agent Model Used

Claude Opus 4.6

### Debug Log References

None — clean implementation.

### Completion Notes List

- Populated Section 5 (Constraints & Governance): 7x7 rule with rationale, 8 governance seed principles derived from 6 Irreducible Truths, governance cascade with 4 precedence levels, constitution.md noted as optional (Slice 3)
- Populated Section 6 (Tier Definitions): classification decision table (5 signals × 4 tiers), token budgets per tier, 4 tier definitions each with spec output, dispatch flow, examples, and criteria. "Classify UP" rule for conflicting signals.
- Sections 1-4 untouched — verified no modifications outside scope
- All 4 ACs verified PASS
- spec-protocol.md is now FULLY POPULATED (all 6 sections complete across Stories 1.1-1.3)

### Change Log

- 2026-02-17: Populated Sections 5-6 of spec-protocol.md — Epic 1 implementation complete

### File List

- `.claude/skills/spec-protocol.md` (MODIFIED — Sections 5 and 6 populated, file now complete)
