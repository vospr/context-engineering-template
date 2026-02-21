# Story 2.2: Graduated Spec Tier Router

Status: review

## Story

As a main agent,
I want a graduated complexity router that classifies tasks into spec tiers and routes accordingly,
so that trivial tasks have zero overhead while complex tasks get full spec treatment.

## Acceptance Criteria

1. TRIVIAL tasks are dispatched directly with no spec (zero overhead)
2. SIMPLE tasks trigger planner to write a minimal spec packet (~60 tokens, 4 required fields) inline in task description
3. MODERATE tasks trigger planner to write full spec packet + spec overview document
4. COMPLEX tasks trigger architect pre-check before planner writes spec suite + overview
5. The router extends (not replaces) the existing model selection in Step 4

## Tasks / Subtasks

- [x] Task 1: Add Section 7 (SDD Dispatch Routing) to spec-protocol.md (AC: #1, #2, #3, #4, #5)
  - [x] Add new Section 7 after Section 6 (Tier Definitions) — this is the actionable dispatch behavior per tier
  - [x] Document TRIVIAL routing: direct dispatch to implementer with standard prompt, no spec packet, no planner involvement
  - [x] Document SIMPLE routing: dispatch planner to write minimal spec packet (~60 tokens) inline in TaskCreate description → then dispatch implementer
  - [x] Document MODERATE routing: dispatch planner to write full spec packet + create spec overview document at `planning-artifacts/spec-F-{NNN}-{kebab-name}-overview.md` → then dispatch implementer → then dispatch reviewer
  - [x] Document COMPLEX routing: dispatch architect for pre-check → dispatch planner to write spec suite (multiple task specs + overview) → then dispatch implementer → then dispatch reviewer
  - [x] Include a routing flowchart or decision tree showing the dispatch sequence per tier
  - [x] State that spec_tier classification extends (does not replace) model selection — both are outputs of Step 4
- [x] Task 2: Add dispatch prompt templates per tier to Section 7 (AC: #1, #2, #3, #4)
  - [x] TRIVIAL dispatch prompt: minimal standard prompt, no spec reference
  - [x] SIMPLE+ dispatch prompt: reference "spec packet in task description" per Pattern 5 from architecture
  - [x] Include the architect pre-check prompt template for COMPLEX tier
  - [x] All prompts follow Pattern 5 rule: never paste spec into dispatch prompt, always reference task description
- [x] Task 3: Validate routing completeness and backward compatibility (AC: #1-#5)
  - [x] Verify all 4 tiers have explicit dispatch routing documented
  - [x] Verify TRIVIAL has literally zero overhead (no planner dispatch, no spec, no extra steps)
  - [x] Verify routing extends model selection — Step 4 produces two outputs (model + spec_tier)
  - [x] Verify Section 7 references Section 6 for classification criteria (no duplication)
  - [x] Verify no modifications to Sections 1-6

## Dev Notes

### Architecture Compliance

- **Source of truth:** `_bmad-output/planning-artifacts/architecture.md`
- **FR1 (line 42):** Graduated spec format router extending CLAUDE.md's complexity classifier
- **Decision 2 (lines 230-240):** Step 4 extends to multi-output: selects model AND spec_tier. TRIVIAL = no spec, direct dispatch. SIMPLE+ = planner writes spec per spec-protocol.md.
- **Lines 486-502:** Dispatch loop boundary diagram — shows exact routing per tier:
  - TRIVIAL → direct dispatch, no spec
  - SIMPLE → planner writes minimal spec packet in task description
  - MODERATE → planner writes full spec + overview
  - COMPLEX → architect pre-check → planner writes spec suite + overview
- **Pattern 5 (lines 376-388):** Dispatch prompt templates — always reference "spec packet in task description", never paste spec
- **Lines 240:** "All SDD logic beyond these 3 lines lives in spec-protocol.md" — routing logic belongs in spec-protocol.md
- **NFR1 (line 51):** Token budgets: TRIVIAL=500, SIMPLE=2000, MODERATE=8000, COMPLEX=25000
- **Pattern 3 (lines 336-348):** Spec overview naming: `spec-F-{NNN}-{kebab-name}-overview.md`

### Previous Story Intelligence (Story 2.1)

- CLAUDE.md Step 4 (line 36) now says: "If SDD mode (`.claude/skills/spec-protocol.md` exists): also classify spec_tier per spec-protocol.md Section 6"
- This means spec-protocol.md is the authoritative source for BOTH classification (Section 6) AND routing (new Section 7)
- The main agent reads spec-protocol.md to know what to do — Section 6 tells it HOW to classify, Section 7 tells it WHAT to do after classification
- CLAUDE.md is at 145 lines — no further CLAUDE.md changes needed for this story

### Previous Story Intelligence (Stories 1.1-1.3)

- spec-protocol.md has 6 sections, ~350 lines
- Section 6 already defines tier classification criteria (decision table, 5 signals, token budgets)
- Section 2 has tier EXAMPLES (YAML samples) — Section 7 adds routing BEHAVIOR (what the dispatch loop does)
- Controlled vocabulary from Section 3 should be used (MUST/SHOULD/MAY)
- 7x7 constraint from Section 5 applies

### What Section 7 Adds vs What Already Exists

| Concern | Already Exists | Section 7 Adds |
|---------|---------------|----------------|
| Classification criteria | Section 6 (decision table) | — (references Section 6) |
| Spec format examples | Section 2 (tier examples) | — (no duplication) |
| Token budgets | Section 6 (per tier) | — (no duplication) |
| **Dispatch routing per tier** | — | **NEW: what the main agent DOES after classification** |
| **Dispatch prompt templates** | — | **NEW: standardized prompts per tier (Pattern 5)** |
| **Routing flowchart** | — | **NEW: visual decision tree** |

### Critical Constraints

- Pure markdown only (NFR3)
- Edit `.claude/skills/spec-protocol.md` — do NOT create any new files
- Do NOT modify Sections 1-6 — those belong to Stories 1.1-1.3
- Add Section 7 AFTER Section 6
- Keep content token-efficient — agents will read this via skill consumption
- Reference Section 6 for classification — do NOT duplicate the decision table
- Dispatch prompt templates must follow Pattern 5 from architecture (never paste spec)

### Project Structure Notes

- Target file: `.claude/skills/spec-protocol.md` (EDIT existing — append Section 7)
- No other files should be created or modified

### References

- [Source: _bmad-output/planning-artifacts/architecture.md#FR1 Graduated Spec Format Router]
- [Source: _bmad-output/planning-artifacts/architecture.md#Decision 2: Dispatch Loop Integration]
- [Source: _bmad-output/planning-artifacts/architecture.md#Lines 486-502 Dispatch Loop Boundary]
- [Source: _bmad-output/planning-artifacts/architecture.md#Pattern 5: Dispatch Prompt Templates]
- [Source: _bmad-output/planning-artifacts/architecture.md#Pattern 3: Spec Overview Naming]
- [Source: _bmad-output/planning-artifacts/architecture.md#NFR1 Token Budgets]
- [Source: _bmad-output/planning-artifacts/epics.md#Story 2.2]
- [Source: _bmad-output/implementation-artifacts/2-1-sdd-detection-dispatch-loop-integration.md#Completion Notes]

## Dev Agent Record

### Agent Model Used

Claude Opus 4.6

### Debug Log References

None — clean implementation.

### Completion Notes List

- Added Section 7 (SDD Dispatch Routing) to spec-protocol.md — ~97 lines of routing behavior, flowchart, and dispatch prompt templates
- Routing decision tree covers all 4 tiers with visual ASCII flowchart
- Per-tier routing: TRIVIAL (3-step, zero overhead), SIMPLE (4-step), MODERATE (5-step with reviewer), COMPLEX (6-step with architect pre-check)
- 3 dispatch prompt templates: TRIVIAL (no spec), SIMPLE+ (with spec reference), COMPLEX (architect pre-check)
- All prompts follow Pattern 5: reference "spec packet in task description", never paste spec
- Section 7 references Section 6 for classification — no duplication of decision table or token budgets
- Sections 1-6 untouched — verified no modifications outside scope
- All 5 ACs verified PASS

### Change Log

- 2026-02-17: Added Section 7 (SDD Dispatch Routing) to spec-protocol.md

### File List

- `.claude/skills/spec-protocol.md` (MODIFIED — Section 7 added after Section 6)
