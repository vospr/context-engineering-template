# Story 1.2: Define Controlled Vocabulary & Assertion Quality Gate

Status: review

## Story

As a planner agent,
I want clear rules for assertion language and controlled vocabulary,
so that every spec I author is unambiguous and verifiable.

## Acceptance Criteria

1. `spec-protocol.md` contains a controlled vocabulary section defining MUST, MUST NOT, SHOULD, MAY with precise semantics (RFC 2119 style)
2. The assertion quality gate explicitly bans "works," "correct," "proper," "appropriate" without a specific observable
3. Every assertion must name a specific observable: an endpoint, file, UI element, return value, or error code
4. Examples of valid and invalid assertions are provided

## Tasks / Subtasks

- [x] Task 1: Populate Section 3 (Controlled Vocabulary) in spec-protocol.md (AC: #1)
  - [x] Replace the `<!-- Placeholder: Story 1.2 will populate this section -->` comment in Section 3
  - [x] Define MUST — absolute requirement, non-negotiable
  - [x] Define MUST NOT — absolute prohibition
  - [x] Define SHOULD — recommended but may be deviated from with documented rationale
  - [x] Define MAY — optional, at implementer's discretion within constraints
  - [x] Include brief usage examples showing each keyword in an assertion context
- [x] Task 2: Populate Section 4 (Assertion Quality Gate) in spec-protocol.md (AC: #2, #3, #4)
  - [x] Replace the `<!-- Placeholder: Story 1.2 will populate this section -->` comment in Section 4
  - [x] State the core rule: every assertion MUST name a specific observable
  - [x] List banned vague terms: "works," "correct," "proper," "appropriate," "handles correctly," "functions as expected"
  - [x] Define what qualifies as a specific observable: endpoint path, file path + line, UI element ID, return value/type, error code, HTTP status, database state
  - [x] Provide 3-4 examples of VALID assertions (specific observables, controlled vocabulary)
  - [x] Provide 3-4 examples of INVALID assertions (vague language, missing observables)
  - [x] Include the "double-entry" rule: each assertion needs both `positive` and `negative` to validate from both directions

## Dev Notes

### Architecture Compliance

- **Source of truth:** `_bmad-output/planning-artifacts/architecture.md`
- **Lines 42-43:** Controlled vocabulary (MUST/SHOULD/MAY/MUST NOT) is a Tier 1-2 requirement
- **Lines 165-167:** Assertion quality gate text — copy the exact ban rule from architecture
- **Pattern 1 (lines 309-314):** Assertions use controlled vocabulary; quality gate enforced
- **Truth 2 (line 28):** "A spec is only useful if the agent that consumes it can act on it without asking for clarification"

### Architecture Quality Gate Text (verbatim)

> Every assertion must name a *specific observable*: an endpoint, a file, a UI element, a return value, or an error code. Assertions containing "works," "correct," "proper," or "appropriate" without a specific observable are invalid.

### Previous Story Intelligence (Story 1.1)

- spec-protocol.md exists at `.claude/skills/spec-protocol.md`
- Sections 3 and 4 contain placeholder comments: `<!-- Placeholder: Story 1.2 will populate this section -->`
- File is ~161 lines; Sections 3-4 are near lines 131-140
- MUST edit the existing file — do NOT recreate it
- Maintain consistent markdown formatting with Sections 1-2 (use `###` for subsections, tables where appropriate)

### Critical Constraints

- Pure markdown only (NFR3)
- Edit `.claude/skills/spec-protocol.md` — do NOT create any new files
- Do NOT modify Sections 1, 2, 5, or 6 — those belong to Stories 1.1 and 1.3
- Keep content token-efficient — agents will read this via skill consumption

### Project Structure Notes

- Target file: `.claude/skills/spec-protocol.md` (EDIT existing, do not recreate)
- No other files should be created or modified

### References

- [Source: _bmad-output/planning-artifacts/architecture.md#Lines 165-167 Assertion Quality Gate]
- [Source: _bmad-output/planning-artifacts/architecture.md#Lines 42-43 Tier 1-2 Requirements]
- [Source: _bmad-output/planning-artifacts/architecture.md#Pattern 1: Spec Packet Authoring]
- [Source: _bmad-output/planning-artifacts/architecture.md#Truth 2]
- [Source: _bmad-output/planning-artifacts/epics.md#Story 1.2]
- [Source: _bmad-output/implementation-artifacts/1-1-define-spec-packet-yaml-format.md#Completion Notes]

## Dev Agent Record

### Agent Model Used

Claude Opus 4.6

### Debug Log References

None — clean implementation.

### Completion Notes List

- Populated Section 3 (Controlled Vocabulary): keyword definitions table (MUST/MUST NOT/SHOULD/MAY) with RFC 2119 semantics, usage examples per keyword, usage rules for assertion fields vs constraints
- Populated Section 4 (Assertion Quality Gate): core rule (verbatim from architecture), banned vague terms list (7 terms), specific observable types table (7 types), double-entry rule explanation, 3 valid examples, 4 invalid examples with FIX suggestions
- Sections 1, 2, 5, 6 untouched — verified no modifications outside scope
- All 4 ACs verified PASS

### Change Log

- 2026-02-17: Populated Sections 3-4 of spec-protocol.md with controlled vocabulary and assertion quality gate

### File List

- `.claude/skills/spec-protocol.md` (MODIFIED — Sections 3 and 4 populated)
