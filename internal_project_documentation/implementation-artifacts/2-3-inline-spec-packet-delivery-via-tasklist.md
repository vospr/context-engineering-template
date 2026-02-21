# Story 2.3: Inline Spec Packet Delivery via TaskList

Status: review

## Story

As a planner agent,
I want to embed YAML spec packets directly in TaskList task descriptions,
so that implementers receive specs automatically via TaskGet with zero extra file reads.

## Acceptance Criteria

1. When the planner creates a SIMPLE+ task via TaskCreate, the task description contains a YAML spec packet delimited by `--- SPEC ---` and `--- END SPEC ---`
2. The spec packet follows the exact format from spec-protocol.md Section 1 (Pattern 1)
3. The implementer can read the full spec via TaskGet without any additional Read calls
4. The dispatch prompt references "spec packet in task description" (never pastes the spec)

## Tasks / Subtasks

- [x] Task 1: Add Section 8 (Inline Spec Delivery Protocol) to spec-protocol.md (AC: #1, #2, #3)
  - [x] Add new Section 8 after Section 7 (SDD Dispatch Routing)
  - [x] Document the planner's spec embedding workflow: how to embed a spec packet in TaskCreate description field
  - [x] Specify the exact structure: task context (plain text summary) + spec packet (delimited YAML) in a single description field
  - [x] Document the TaskCreate description template showing where the spec packet goes within the task description
  - [x] Document the implementer's consumption workflow: TaskGet → parse spec between delimiters → execute against assertions
  - [x] State that spec packets MUST use the delimiters from Section 1 (`# --- SPEC ---` / `# --- END SPEC ---`)
  - [x] Include a complete example of a TaskCreate call with embedded spec packet
- [x] Task 2: Document the forgiving parser fallback for malformed specs (AC: #1, #2)
  - [x] Document the retry cycle: malformed YAML → 1 lint-retry with error feedback → forgiving parser fallback → BLOCKED if both fail
  - [x] Reference Section 1 delimiter rules that enable the forgiving parser
  - [x] State that the forgiving parser extracts content between `# --- SPEC ---` and `# --- END SPEC ---` markers even if YAML is malformed
- [x] Task 3: Document dispatch prompt integration (AC: #4)
  - [x] Reference Section 7 dispatch prompt templates (already created in Story 2.2)
  - [x] Add explicit rule: planner embeds spec in task description, dispatch loop references it in prompt — spec is NEVER duplicated
  - [x] Document the anti-pattern: pasting spec content into the dispatch prompt (causes token waste and version drift)
- [x] Task 4: Validate completeness (AC: #1-#4)
  - [x] Verify TaskCreate embedding workflow is documented end-to-end
  - [x] Verify implementer consumption via TaskGet is documented
  - [x] Verify forgiving parser fallback is documented
  - [x] Verify no modifications to Sections 1-7

## Dev Notes

### Architecture Compliance

- **Source of truth:** `_bmad-output/planning-artifacts/architecture.md`
- **FR6 (line 22 of epics):** Spec packets embedded inline in TaskList task descriptions (zero extra file reads)
- **Decision 3 (lines 242-259):** File Organization — spec packets inline in TaskList task descriptions. Planner embeds YAML spec directly in task description. Agent receives spec automatically via TaskGet — zero extra file reads.
- **Pattern 1 (lines 287-316):** Spec Packet Authoring — exact YAML structure with delimiters, field rules, assertion quality gate
- **Pattern 5 (lines 376-388):** Dispatch Prompt Templates — always reference "spec packet in task description", never paste spec
- **Pattern 2 (lines 317-333):** Implementer Evidence Reporting — how implementer reports back after consuming spec
- **Decision 5 (lines 269-278):** Failure & Recovery Matrix — malformed spec YAML: retry once with error → forgiving parser fallback → BLOCKED if both fail
- **Lines 53:** Forgiving parser fallback — malformed spec YAML gets 1 lint-retry cycle + forgiving parser fallback before marking BLOCKED
- **Lines 55:** Spec packet delimiters — `--- SPEC ---` and `--- END SPEC ---` markers required for forgiving parser

### Previous Story Intelligence (Story 2.2)

- Section 7 (SDD Dispatch Routing) added to spec-protocol.md with:
  - Per-tier routing: TRIVIAL (no spec), SIMPLE (planner writes minimal spec), MODERATE (full spec + overview), COMPLEX (architect + spec suite)
  - Dispatch prompt templates already reference "spec packet in task description"
  - Section 7 tells the dispatch loop WHAT to do; Section 8 tells the planner HOW to embed specs

### Previous Story Intelligence (Stories 1.1-1.3)

- Section 1 defines spec packet YAML format with delimiters (`# --- SPEC ---` / `# --- END SPEC ---`)
- Section 1 already mentions the forgiving parser: "If the YAML between markers fails to parse, the system retries once with error feedback, then falls back to the forgiving parser before marking the task BLOCKED."
- Section 2 has complete tier examples showing what spec packets look like
- spec-protocol.md now has 7 sections (~447 lines)

### What Section 8 Adds vs What Already Exists

| Concern | Already Exists | Section 8 Adds |
|---------|---------------|----------------|
| Spec YAML format | Section 1 (format + delimiters) | — (references Section 1) |
| Tier examples | Section 2 (YAML samples) | — (no duplication) |
| Routing behavior | Section 7 (dispatch routing) | — (references Section 7) |
| **Planner embedding workflow** | — | **NEW: how planner puts spec in TaskCreate** |
| **TaskCreate description template** | — | **NEW: exact structure of description field** |
| **Implementer consumption workflow** | — | **NEW: TaskGet → parse → execute** |
| **Forgiving parser details** | Section 1 (brief mention) | **EXPANDED: full retry/fallback cycle** |
| **Anti-pattern: spec duplication** | — | **NEW: never paste spec in dispatch prompt** |

### Critical Constraints

- Pure markdown only (NFR3)
- Edit `.claude/skills/spec-protocol.md` — do NOT create any new files
- Do NOT modify Sections 1-7 — those belong to Stories 1.1-1.3 and 2.2
- Add Section 8 AFTER Section 7
- Keep content token-efficient
- Reference Sections 1, 2, and 7 — do NOT duplicate their content

### Project Structure Notes

- Target file: `.claude/skills/spec-protocol.md` (EDIT existing — append Section 8)
- No other files should be created or modified

### References

- [Source: _bmad-output/planning-artifacts/architecture.md#Decision 3: File Organization]
- [Source: _bmad-output/planning-artifacts/architecture.md#Pattern 1: Spec Packet Authoring]
- [Source: _bmad-output/planning-artifacts/architecture.md#Pattern 5: Dispatch Prompt Templates]
- [Source: _bmad-output/planning-artifacts/architecture.md#Pattern 2: Implementer Evidence Reporting]
- [Source: _bmad-output/planning-artifacts/architecture.md#Decision 5: Failure & Recovery Matrix]
- [Source: _bmad-output/planning-artifacts/epics.md#Story 2.3]
- [Source: _bmad-output/implementation-artifacts/2-2-graduated-spec-tier-router.md#Completion Notes]

## Dev Agent Record

### Agent Model Used

Claude Opus 4.6

### Debug Log References

None — clean implementation.

### Completion Notes List

- Added Section 8 (Inline Spec Delivery Protocol) to spec-protocol.md — ~70 lines covering full delivery lifecycle
- Planner embedding workflow: 4-step process from skill read to TaskCreate with embedded spec
- TaskCreate description template: plain-text summary + delimited YAML spec packet
- Implementer consumption workflow: 6-step TaskGet → parse → execute → report cycle
- Forgiving parser fallback: 3-stage recovery (lint retry → forgiving parser → BLOCKED)
- Anti-pattern documentation: spec duplication in dispatch prompt explicitly forbidden with rationale
- References Sections 1, 4, and 7 — no content duplication
- Sections 1-7 untouched — verified via section header line number check
- All 4 ACs verified PASS

### Change Log

- 2026-02-17: Added Section 8 (Inline Spec Delivery Protocol) to spec-protocol.md

### File List

- `.claude/skills/spec-protocol.md` (MODIFIED — Section 8 added after Section 7)
