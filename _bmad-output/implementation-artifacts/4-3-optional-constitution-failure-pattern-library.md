# Story 4.3: Optional Constitution & Failure Pattern Library

Status: done

## Story

As a project lead,
I want an optional constitution with immutable principles and a failure pattern library that captures lessons learned,
so that governance scales with project maturity and past mistakes aren't repeated.

## Acceptance Criteria

1. When a `planning-artifacts/constitution.md` is created, it contains formal articles defining immutable project principles with Phase -1 gates
2. The governance cascade applies: constitution.md > spec-protocol.md > skills > agent freedom
3. `planning-artifacts/knowledge-base/failure-patterns.md` captures categorized failure patterns with root cause and resolution
4. Constitution is optional — SDD functions fully without it
5. Only humans can amend the constitution (formal amendment protocol)

## Tasks / Subtasks

- [x] Task 1: Add Section 16 (Constitution Protocol) to spec-protocol.md (AC: #1, #2, #4, #5)
  - [x] Add new Section 16 after Section 15 (Expanded Lifecycle States & Graduated Escalation)
  - [x] Define constitution.md purpose: immutable project principles that override all other governance layers
  - [x] Define Phase -1 gates: constitution checks run BEFORE any spec lifecycle transition (before even DRAFT → LINT_PASS)
  - [x] Define article format: numbered articles with rationale and enforcement mechanism
  - [x] Document the governance cascade enforcement: constitution.md > spec-protocol.md > skills > agent freedom (reference Section 5)
  - [x] State optionality: SDD functions fully without constitution.md; its absence means governance cascade starts at spec-protocol.md
  - [x] Document location: `planning-artifacts/constitution.md`
  - [x] Document ownership: only humans create and amend (architecture line 480)
- [x] Task 2: Define the Formal Amendment Protocol (AC: #5)
  - [x] Only humans can propose amendments
  - [x] Amendments require explicit rationale for why the existing article is insufficient
  - [x] Amendment takes effect only after the human writes it to constitution.md
  - [x] In-progress tasks continue against the previous constitution version (immutability during execution)
  - [x] Document the amendment workflow: propose → rationale → write → effective
- [x] Task 3: Define Failure Pattern Library Protocol (AC: #3)
  - [x] Define purpose: captures categorized failure patterns with root cause and resolution so past mistakes are not repeated
  - [x] Define location: `planning-artifacts/knowledge-base/failure-patterns.md`
  - [x] Define entry format: pattern name, category, root cause, detection, resolution, prevention
  - [x] Define categories: spec quality, assertion gaps, scope violations, decomposition failures, governance gaps
  - [x] Document how the library is populated: after any task reaches BLOCKED or Red escalation (Section 15), the dispatch loop records the failure pattern
  - [x] Document how the library is consumed: planner reads before speccing new features to avoid known patterns; reviewer checks against during review
  - [x] State that the library is append-only — entries are never deleted, only annotated with status (active, mitigated, resolved)
- [x] Task 4: Document integration with existing sections (AC: #1, #2, #3)
  - [x] Connect Phase -1 gates to Section 15 expanded lifecycle — constitution check happens before DRAFT → LINT_PASS
  - [x] Connect failure patterns to Section 15 graduated escalation — Red triggers pattern capture
  - [x] Connect failure patterns to Section 13 feature stall detection — NEEDS_RESPEC triggers pattern review
  - [x] Reference Section 5 governance cascade — Section 16 formalizes what Section 5 seeds
  - [x] Reference Section 14 Gate 1 (Spec Lint) — constitution compliance could be a future lint check
- [x] Task 5: Validate completeness (AC: #1-#5)
  - [x] Verify constitution protocol with Phase -1 gates defined
  - [x] Verify governance cascade enforcement documented
  - [x] Verify failure pattern library format and categories defined
  - [x] Verify optionality explicitly stated
  - [x] Verify amendment protocol is human-only
  - [x] Verify no modifications to Sections 1-15

## Dev Notes

### Architecture Compliance

- **Source of truth:** `_bmad-output/planning-artifacts/architecture.md`
- **ADR-005 (lines 121-130):** Governance — Progressive, from Lightweight to Full Constitution. Slice 3: optional constitution.md with formal articles and Phase -1 gates.
- **Line 47:** Tier 7 — "Spec immutability + mutation protocol; escape clauses; failure pattern library; difficulty scaling"
- **Line 69:** Slice 3 goals — "Constitution + spec ratification + two-layer verification + graduated escalation"
- **Line 144:** Governance cascade — "constitution (if present) > spec overview > per-task criteria > agent freedom"
- **Line 197:** constitution.md — Slice 3 (optional), immutable project principles with Phase -1 gates
- **Line 461:** failure-patterns.md — Slice 3, learning from past failures, located in knowledge-base/
- **Line 480:** constitution.md ownership — Human/Architect creates, Human only amends
- **Line 544:** Slice 3 deliverables — constitution.md (opt), failure-patterns.md

### Previous Story Intelligence (Stories 1.3, 4.1, 4.2)

- Section 5 (Story 1.3) already defines governance seed principles (8 principles) and governance cascade — Section 16 formalizes this for Slice 3
- Section 5 governance cascade (lines 294-303) already states: constitution.md > spec-protocol.md > skills > agent freedom
- Section 14 (Story 4.1) defines automated verification gates — Phase -1 gates run before these
- Section 15 (Story 4.2) defines expanded lifecycle and graduated escalation — Red level triggers failure pattern capture
- Section 13 (Story 3.2) defines feature stall detection — NEEDS_RESPEC should trigger failure pattern review
- spec-protocol.md now has 15 sections (~1115 lines)

### What Section 16 Adds vs What Already Exists

| Concern | Existing Section | Section 16 Adds |
|---------|-----------------|-----------------|
| Governance principles | Section 5 (seed, 8 principles) | **Formal constitution protocol** |
| Governance cascade | Section 5 (cascade defined) | **Enforcement mechanism (Phase -1 gates)** |
| Failure handling | Section 14/15 (gates, escalation) | **NEW: Failure pattern library protocol** |
| Amendment | Section 10 (immutability rule) | **NEW: Formal amendment protocol** |
| Knowledge capture | — | **NEW: Categorized failure patterns** |

### Critical Constraints

- Pure markdown only (NFR3)
- Edit `.claude/skills/spec-protocol.md` — do NOT create any new files
- Do NOT create constitution.md or failure-patterns.md — those are created at runtime
- Do NOT modify Sections 1-15
- Add Section 16 AFTER Section 15
- Keep content token-efficient
- Reference existing sections — do NOT duplicate governance cascade or principles

### Project Structure Notes

- Target file: `.claude/skills/spec-protocol.md` (EDIT existing — append Section 16)
- No other files should be created or modified
- `planning-artifacts/constitution.md` — created at runtime by human/architect, NOT by this story
- `planning-artifacts/knowledge-base/failure-patterns.md` — created at runtime by dispatch loop, NOT by this story

### References

- [Source: _bmad-output/planning-artifacts/architecture.md#ADR-005 Governance Progressive]
- [Source: _bmad-output/planning-artifacts/architecture.md#Line 47 Tier 7 Governance]
- [Source: _bmad-output/planning-artifacts/architecture.md#Line 144 Governance Cascade]
- [Source: _bmad-output/planning-artifacts/architecture.md#Line 461 Failure Patterns]
- [Source: _bmad-output/planning-artifacts/architecture.md#Line 480 Constitution Ownership]
- [Source: _bmad-output/planning-artifacts/architecture.md#Line 544 Slice 3 Deliverables]
- [Source: _bmad-output/planning-artifacts/epics.md#Story 4.3]
- [Source: _bmad-output/implementation-artifacts/4-2-expanded-lifecycle-states-graduated-escalation.md#Completion Notes]

## Dev Agent Record

### Agent Model Used

Claude Opus 4.6

### Debug Log References

None — clean implementation.

### Completion Notes List

- Added Section 16 (Constitution & Failure Pattern Library) to spec-protocol.md — ~115 lines
- Constitution protocol: purpose, optionality, file location (`planning-artifacts/constitution.md`)
- Article format: numbered articles with principle, rationale, enforcement, violation response + filled example
- Phase -1 gates: constitution checks run before DRAFT → LINT_PASS with flowchart showing skip-if-absent logic
- Governance cascade enforcement table: 4 layers mapped to check timing and responsible agent
- Ownership & amendment protocol: human-only, 4-step workflow (propose → rationale → write → effective), immutability during execution
- Failure pattern library: purpose, file location (`planning-artifacts/knowledge-base/failure-patterns.md`)
- Entry format: FP-{NNN} with 6 fields (category, detected, status, root cause, detection, resolution, prevention)
- 5 categories table with descriptions and examples
- Population triggers: Red escalation, feature stall (NEEDS_RESPEC), reviewer findings
- Consumption table: planner (before speccing), reviewer (during review), dispatch loop (after Red)
- Library rules: append-only, status transitions (active → mitigated → resolved), sequential IDs
- Tier applicability table for both constitution and failure patterns
- Sections 1-15 untouched — verified via section header line check
- All 5 ACs verified PASS
- Epic 4 COMPLETE — all 3 stories delivered

### Change Log

- 2026-02-18: Added Section 16 (Constitution & Failure Pattern Library) to spec-protocol.md — Epic 4 complete

### File List

- `.claude/skills/spec-protocol.md` (MODIFIED — Section 16 added after Section 15)
