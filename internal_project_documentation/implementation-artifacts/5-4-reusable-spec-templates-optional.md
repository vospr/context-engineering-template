# Story 5.4: Reusable Spec Templates (Optional)

Status: review

## Story

As a project lead,
I want reusable spec templates for common patterns (REST CRUD, auth flows, data pipelines),
so that spec authoring for common feature types is faster and more consistent.

## Acceptance Criteria

1. When `.claude/spec-templates/` directory exists, the planner can reference templates as starting points
2. Templates contain pre-filled assertions, file_scope patterns, and constraints for the pattern
3. Templates are optional — SDD functions fully without them
4. The planner adapts templates to the specific feature, never copies blindly

## Tasks / Subtasks

- [x]Task 1: Add Section 17 (Spec Templates Protocol) to spec-protocol.md (AC: #1, #2, #3, #4)
  - [x]Add new Section 17 after Section 16 (Constitution & Failure Pattern Library)
  - [x]Define purpose: reusable spec templates that accelerate authoring for common feature patterns
  - [x]Define location: `.claude/spec-templates/` directory
  - [x]State optionality: SDD functions fully without templates; their absence changes nothing
  - [x]Define template format: YAML files with pre-filled assertions, file_scope patterns, constraints, and intent patterns
  - [x]Document the template naming convention: `{pattern-name}.yaml` (e.g., `rest-crud-endpoint.yaml`)
- [x]Task 2: Define the template structure and required fields (AC: #2)
  - [x]Define template YAML structure: pattern_name, description, tier (typical), intent_template, assertions (pre-filled), constraints (pre-filled), file_scope_patterns
  - [x]Assertions in templates use placeholders: `{entity}`, `{endpoint}`, `{file}` that the planner fills in
  - [x]file_scope_patterns use glob-style patterns: `src/{entity}/*.ts`
  - [x]Constraints include pattern-specific rules (e.g., REST CRUD must have all 4 operations)
  - [x]Provide 2-3 example template sketches (REST CRUD, auth flow, data pipeline) — sketches only, not full templates
- [x]Task 3: Define the planner's template consumption workflow (AC: #1, #4)
  - [x]Planner checks `.claude/spec-templates/` when speccing a MODERATE+ feature
  - [x]If a matching template exists: load it as a starting point
  - [x]Planner MUST adapt the template: fill placeholders, add/remove assertions for the specific feature, adjust file_scope
  - [x]Planner MUST NOT copy templates blindly — every assertion must be relevant to the specific feature
  - [x]If no matching template exists: author spec from scratch (existing workflow)
  - [x]Reference planner.md SDD Spec Authoring section (Story 5.1) — templates integrate into step 3 of the workflow
- [x]Task 4: Document template lifecycle and governance (AC: #3)
  - [x]Templates are created by humans or architects — not by agents during execution
  - [x]Templates evolve based on failure patterns (Section 16) — if a pattern recurs, create or update a template
  - [x]Templates follow the governance cascade: constitution > spec-protocol > templates > agent freedom
  - [x]Templates are versioned alongside the project (git-tracked)
  - [x]State that templates are Slice 4 — all prior slices work without them
- [x]Task 5: Validate completeness (AC: #1-#4)
  - [x]Verify template directory and naming convention documented
  - [x]Verify template structure with placeholders documented
  - [x]Verify planner consumption workflow with anti-blind-copy rule
  - [x]Verify optionality explicitly stated
  - [x]Verify no modifications to Sections 1-16

## Dev Notes

### Architecture Compliance

- **Source of truth:** `_bmad-output/planning-artifacts/architecture.md`
- **Line 70:** Slice 4 — "Full hybrid spec model + agent extensions + agent-specific spec views + metrics dashboard + advanced governance"
- **Line 198:** `.claude/spec-templates/` — Slice 4 (optional), reusable spec patterns per project type
- **Lines 446-449:** spec-templates/ directory with 3 example files: rest-crud-endpoint.yaml, auth-flow.yaml, data-pipeline.yaml
- **Line 624:** Future enhancement — "Spec template library for common patterns (Slice 4)"

### Previous Story Intelligence (Stories 1.1, 5.1)

- Section 1 defines spec packet format — templates pre-fill this format
- Section 6 defines tier classification — templates specify typical tier
- Section 8 defines inline spec delivery — planner embeds adapted template output via TaskCreate
- Planner.md (Story 5.1) defines SDD Spec Authoring workflow — templates integrate at step 3 (write spec packets)
- spec-protocol.md now has 16 sections (~1230 lines)

### What Section 17 Adds vs What Already Exists

| Concern | Existing | Section 17 Adds |
|---------|---------|-----------------|
| Spec authoring | Planner writes from scratch (Sections 1, 8) | **Template-accelerated authoring** |
| Pattern reuse | — | **NEW: Reusable YAML templates** |
| Planner workflow | Step 3: write spec packets (Story 5.1) | **Template check before writing** |
| Governance | Section 16 (constitution, failure patterns) | **Templates in cascade** |

### Critical Constraints

- Pure markdown only (NFR3)
- Edit `.claude/skills/spec-protocol.md` — do NOT create any new files
- Do NOT create `.claude/spec-templates/` directory or any template files — those are created at runtime
- Do NOT modify Sections 1-16
- Add Section 17 AFTER Section 16
- Keep content token-efficient
- Template examples are sketches only — not full templates

### Project Structure Notes

- Target file: `.claude/skills/spec-protocol.md` (EDIT existing — append Section 17)
- No other files should be created or modified
- `.claude/spec-templates/*.yaml` — created at runtime by humans/architects, NOT by this story

### References

- [Source: _bmad-output/planning-artifacts/architecture.md#Line 198 Spec Templates]
- [Source: _bmad-output/planning-artifacts/architecture.md#Lines 446-449 Template Directory]
- [Source: _bmad-output/planning-artifacts/architecture.md#Line 624 Future Enhancement]
- [Source: _bmad-output/planning-artifacts/epics.md#Story 5.4]
- [Source: _bmad-output/implementation-artifacts/5-3-tester-assertion-execution-integration-modes.md#Completion Notes]

## Dev Agent Record

### Agent Model Used

Claude Opus 4.6

### Debug Log References

None — clean implementation.

### Completion Notes List

- Added Section 17 (Spec Templates Protocol) to spec-protocol.md — ~85 lines
- Directory & naming: `.claude/spec-templates/{pattern-name}.yaml`, git-tracked, human/architect created
- Template structure: full YAML example (REST CRUD) with pattern_name, description, typical_tier, intent_template, assertions, constraints, file_scope_patterns
- Placeholder conventions table: 4 standard placeholders ({entity}, {endpoint}, {file}, {id})
- Planner consumption workflow: 4-step (check → match → adapt → fallback)
- Anti-blind-copy rule: planner MUST adapt templates, remove irrelevant assertions, add feature-specific ones
- Template lifecycle: creation by humans, evolution from failure patterns, governance cascade position
- Template sketches table: 3 patterns (REST CRUD, auth flow, data pipeline) with tier and key details
- Tier applicability: MODERATE primary use case, COMPLEX as starting point, SIMPLE/TRIVIAL skip
- Optionality explicitly stated: SDD functions fully without templates
- Sections 1-16 untouched — verified via section header line check
- All 4 ACs verified PASS
- **Epic 5 COMPLETE — all 4 stories delivered**
- **ALL 5 EPICS COMPLETE — 17 stories delivered across 4 vertical slices**

### Change Log

- 2026-02-18: Added Section 17 (Spec Templates Protocol) to spec-protocol.md — Epic 5 complete, project complete

### File List

- `.claude/skills/spec-protocol.md` (MODIFIED — Section 17 added after Section 16)
