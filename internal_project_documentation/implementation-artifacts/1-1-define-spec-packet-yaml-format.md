# Story 1.1: Define Spec Packet YAML Format

Status: review

## Story

As a planner agent,
I want a documented YAML spec packet format with required fields and delimiters,
so that I can author machine-parseable, consistent specs for any task.

## Acceptance Criteria

1. `spec-protocol.md` exists at `.claude/skills/spec-protocol.md`
2. Contains the exact YAML spec packet structure with fields: `version`, `intent`, `assertions` (each with `id`, `positive`, `negative`), `constraints`, `file_scope`
3. Spec packets are delimited by `--- SPEC ---` and `--- END SPEC ---` markers
4. A filled example is provided for each tier:
   - TRIVIAL: no spec needed (document the skip rationale)
   - SIMPLE: ~60 tokens, 4 required fields only
   - MODERATE: full spec packet with all fields
   - COMPLEX: full spec packet + reference to spec overview document
5. Schema version field is present: `version: 1`

## Tasks / Subtasks

- [x] Task 1: Create `.claude/skills/spec-protocol.md` with document structure (AC: #1)
  - [x] Create file with title, purpose statement, and section headers
  - [x] Sections to stub: Spec Packet Format, Tier Examples, Controlled Vocabulary (placeholder for Story 1.2), Constraints & Governance (placeholder for Story 1.3)
- [x] Task 2: Write the Spec Packet Format section (AC: #2, #3, #5)
  - [x] Document the canonical YAML structure exactly as defined in architecture Pattern 1
  - [x] Document `--- SPEC ---` / `--- END SPEC ---` delimiters
  - [x] Document each field's purpose and requirements:
    - `version`: integer, always `1` for Slice 1
    - `intent`: imperative verb + specific observable outcome
    - `assertions`: array of objects with `id` (A1, A2...), `positive`, `negative`
    - `constraints`: array of MUST/MUST NOT strings
    - `file_scope`: array of file paths the implementer may modify
  - [x] Note: Slice 3+ adds 6 more fields (`freedom`, `assumptions`, `escape_clause`, `checksum`, `parent_feature`, `tier`) — mention as future but do NOT include in Slice 1 format
- [x] Task 3: Write filled examples for each tier (AC: #4)
  - [x] TRIVIAL example: explain that tasks classified TRIVIAL get no spec — direct dispatch, zero overhead
  - [x] SIMPLE example: ~60 token spec with only required fields (version, intent, assertions with 1-2 items, file_scope)
  - [x] MODERATE example: complete spec with 3-5 assertions, constraints, full file_scope
  - [x] COMPLEX example: complete spec + line referencing a spec overview at `planning-artifacts/spec-F-NNN-name-overview.md`

## Dev Notes

### Architecture Compliance

- **Source of truth:** `_bmad-output/planning-artifacts/architecture.md`
- **Pattern 1 (lines 292-316):** The exact YAML structure — copy this precisely, do not improvise
- **ADR-001 (lines 76-86):** Slice 1 required fields are `version`, `intent`, `assertions`, `file_scope`, `constraints`
- **ADR-002 (lines 88-96):** spec-protocol.md is a skill consumed by planner via dispatch prompt in Slice 1
- **Vulnerability #2 (line 157):** Include filled template examples to prevent LLM YAML generation failures

### Canonical YAML Format (from Architecture Pattern 1)

```yaml
# --- SPEC ---
version: 1
intent: "[imperative verb] [specific observable outcome]"
assertions:
  - id: A1
    positive: "[subject] [MUST/MUST NOT] [specific observable]"
    negative: "[subject] [MUST NOT/MUST] [opposite observable]"
constraints:
  - "[MUST/MUST NOT] [specific constraint]"
file_scope:
  - path/to/file.ext
# --- END SPEC ---
```

### Critical Constraints

- File MUST be pure markdown — no code, no build steps (NFR3)
- This file activates SDD mode when present (Decision 2, line 232) — its mere existence is the trigger
- Keep the file focused and token-efficient — agents will read this via skill consumption
- Stub placeholder sections for Stories 1.2 (vocabulary) and 1.3 (governance) but do NOT populate them — those stories own that content
- Use RFC 2119 keywords (MUST, SHOULD, MAY) in the protocol text itself

### Project Structure Notes

- Target file: `.claude/skills/spec-protocol.md` (new file)
- No other files should be created or modified by this story
- The `.claude/skills/` directory may not exist yet — create it if needed

### References

- [Source: _bmad-output/planning-artifacts/architecture.md#Pattern 1: Spec Packet Authoring]
- [Source: _bmad-output/planning-artifacts/architecture.md#ADR-001: Spec Format]
- [Source: _bmad-output/planning-artifacts/architecture.md#Vulnerability Register]
- [Source: _bmad-output/planning-artifacts/architecture.md#Starter Template Evaluation - SDD Additions]
- [Source: _bmad-output/planning-artifacts/epics.md#Story 1.1]

## Dev Agent Record

### Agent Model Used

Claude Opus 4.6

### Debug Log References

None — clean implementation, no errors.

### Completion Notes List

- Created `.claude/skills/spec-protocol.md` (new file, 161 lines)
- Section 1 (Spec Packet Format): Canonical YAML structure from architecture Pattern 1 with field reference table, delimiter docs, schema versioning note
- Section 2 (Tier Examples): 4 filled examples — TRIVIAL (skip rationale), SIMPLE (~60 tokens), MODERATE (4 assertions), COMPLEX (5 assertions + overview reference)
- Sections 3-6: Placeholder stubs for Stories 1.2 (vocabulary, quality gate) and 1.3 (constraints, governance, tiers)
- All 5 acceptance criteria verified PASS
- Zero-code constraint (NFR3) satisfied — pure markdown
- File activates SDD mode by its presence (Decision 2)

### Change Log

- 2026-02-17: Story implemented — created spec-protocol.md with format definition and tier examples

### File List

- `.claude/skills/spec-protocol.md` (NEW)
