# Story 2.1: SDD Detection & Dispatch Loop Integration

Status: review

## Story

As a main agent (dispatch loop),
I want to detect SDD mode via file presence and route tasks through spec-aware classification,
so that SDD activates automatically when spec-protocol.md exists without breaking non-SDD projects.

## Acceptance Criteria

1. When `.claude/skills/spec-protocol.md` exists, SDD mode is active and Step 4 classifies both model AND spec_tier (TRIVIAL/SIMPLE/MODERATE/COMPLEX)
2. When spec-protocol.md is absent, the dispatch loop behaves identically to the original template
3. CLAUDE.md remains under 200 lines after modifications
4. Step 2 modification: "If no tasks AND spec-protocol.md exists AND feature-tracker.json has unverified features → dispatch planner to spec next feature"
5. Step 6 modification: "If NEEDS_RESPEC → dispatch planner to re-spec affected subtree"

## Tasks / Subtasks

- [x] Task 1: Add SDD-aware task selection to Step 2 (AC: #2, #4)
  - [x] Read current CLAUDE.md Step 2 (lines 18-20)
  - [x] Add conditional after line 20: "If no tasks AND `.claude/skills/spec-protocol.md` exists AND `planning-artifacts/feature-tracker.json` has unverified features → dispatch planner to spec next feature"
  - [x] Ensure non-SDD behavior is preserved — the original "If no tasks: ask user for next goal" remains as the default fallback
  - [x] Verify the addition is concise (1-2 lines max)
- [x] Task 2: Extend Step 4 with spec_tier classification (AC: #1, #2)
  - [x] Read current CLAUDE.md Step 4 (lines 31-34)
  - [x] Add SDD-conditional tier classification after existing model selection
  - [x] Add: "If SDD mode active (spec-protocol.md exists): also classify spec_tier per `.claude/skills/spec-protocol.md` Section 6"
  - [x] Reference spec-protocol.md Section 6 tier definitions — do NOT duplicate tier logic in CLAUDE.md
  - [x] Ensure non-SDD projects see zero change — tier classification only triggers when spec-protocol.md exists
- [x] Task 3: Add NEEDS_RESPEC handling to Step 6 (AC: #2, #5)
  - [x] Read current CLAUDE.md Step 6 (lines 40-43)
  - [x] Add after the ARCHITECTURE_IMPACT line: "If NEEDS_RESPEC flag in result → dispatch planner to re-spec affected subtree"
  - [x] This is a new flag analogous to ARCHITECTURE_IMPACT but triggers spec revision instead of DAG rebuild
- [x] Task 4: Validate line count and backward compatibility (AC: #2, #3)
  - [x] Count total lines in CLAUDE.md after edits — MUST be ≤ 200
  - [x] Verify the 3 additions are conditional on file presence (backward compatible)
  - [x] Confirm no existing behavior is removed or altered — only additive changes

## Dev Notes

### Architecture Compliance

- **Source of truth:** `_bmad-output/planning-artifacts/architecture.md`
- **Decision 2 (lines 230-240):** Dispatch Loop Integration — SDD detection via file presence, 3 CLAUDE.md modifications
- **Lines 232-233:** SDD Detection: "if `.claude/skills/spec-protocol.md` exists, SDD mode is active"
- **Lines 234-239:** The exact 3 modifications: Step 2 (auto-spec next feature), Step 4 (multi-output classification), Step 6 (NEEDS_RESPEC)
- **Lines 183:** "+3 lines (ADR-005, Step 5 of migration)" — confirms 3-line budget
- **NFR2 (line 52):** Backward compatibility — SDD is opt-in via file presence detection; absence preserves original behavior
- **Lines 136-137:** CLAUDE.md kernel must remain under 200 lines; SDD logic lives in skills and agent definitions

### Current CLAUDE.md State

- **Total lines:** 142 (58 lines of headroom before 200-line limit)
- **Step 2 (lines 18-20):** Select Next Task — add SDD-aware feature speccing
- **Step 4 (lines 31-34):** Classify Complexity & Select Model — extend with spec_tier
- **Step 6 (lines 40-43):** Process Result — add NEEDS_RESPEC handling
- **3 additions should add ~3-6 lines total** — well within 200-line budget

### Exact Modification Targets

**Step 2 — After line 20 (`- If no tasks: ask user for next goal`):**
```
- If no tasks AND `.claude/skills/spec-protocol.md` exists AND `planning-artifacts/feature-tracker.json` has unverified features → dispatch planner to spec next feature
```

**Step 4 — After line 34 (COMPLEX model selection):**
```
- If SDD mode (`.claude/skills/spec-protocol.md` exists): also classify spec_tier per spec-protocol.md Section 6
```

**Step 6 — After line 43 (ARCHITECTURE_IMPACT line):**
```
- If NEEDS_RESPEC flag in result → dispatch planner to re-spec affected subtree
```

### Previous Story Intelligence (Stories 1.1-1.3)

- All 3 Epic 1 stories completed → spec-protocol.md is FULLY POPULATED at `.claude/skills/spec-protocol.md` (350 lines)
- Section 6 of spec-protocol.md contains the tier definitions (TRIVIAL/SIMPLE/MODERATE/COMPLEX) with classification decision table — Step 4 should REFERENCE this, not duplicate it
- Governance cascade in Section 5: constitution.md > spec-protocol.md > skills > agent freedom
- spec-protocol.md existence activates SDD mode — this is the detection mechanism being wired in

### Critical Constraints

- Pure markdown only (NFR3)
- Edit `CLAUDE.md` — do NOT create any new files
- Do NOT modify any content beyond the 3 targeted steps (2, 4, 6)
- Keep additions concise — each modification should be 1-2 lines max
- All SDD logic beyond these lines lives in spec-protocol.md (architecture line 240)
- Do NOT duplicate tier definitions or classification logic from spec-protocol.md
- Backward compatibility is MANDATORY — non-SDD projects must see zero behavior change

### Project Structure Notes

- Target file: `CLAUDE.md` (root of project — EDIT existing, do not recreate)
- Reference file: `.claude/skills/spec-protocol.md` (read-only — do not modify)
- No other files should be created or modified

### References

- [Source: _bmad-output/planning-artifacts/architecture.md#Decision 2: Dispatch Loop Integration]
- [Source: _bmad-output/planning-artifacts/architecture.md#Lines 232-240 SDD Detection + 3 Modifications]
- [Source: _bmad-output/planning-artifacts/architecture.md#Lines 183 +3 Lines Budget]
- [Source: _bmad-output/planning-artifacts/architecture.md#NFR2 Backward Compatibility]
- [Source: _bmad-output/planning-artifacts/architecture.md#Lines 136-137 200-Line Constraint]
- [Source: _bmad-output/planning-artifacts/epics.md#Story 2.1]
- [Source: _bmad-output/implementation-artifacts/1-3-define-constraints-governance-seed-7x7-rule.md#Completion Notes]

## Dev Agent Record

### Agent Model Used

Claude Opus 4.6

### Debug Log References

None — clean implementation.

### Completion Notes List

- Added 3 lines to CLAUDE.md (142 → 145 lines, well under 200-line limit)
- Step 2 (line 21): SDD-aware task selection — auto-specs next feature when spec-protocol.md + feature-tracker.json present
- Step 4 (line 36): spec_tier classification — references spec-protocol.md Section 6, no duplication of tier logic
- Step 6 (line 46): NEEDS_RESPEC flag — triggers planner re-spec, analogous to existing ARCHITECTURE_IMPACT pattern
- All 3 additions are conditional on file presence — backward compatible with non-SDD projects
- No existing content removed or altered — purely additive changes
- All 5 ACs verified PASS

### Change Log

- 2026-02-17: Added 3 SDD dispatch loop integration lines to CLAUDE.md (Steps 2, 4, 6)
- 2026-02-21: Story 6.x enhancements — Step 5 Trace ID generation (+2 lines, Story 6.1); Step 6 ESCALATED handler and failure-pattern append handler (+2 lines, Stories 6.2/6.3); System Health Checks section in Quality Gates (+6 lines, Story 6.4). CLAUDE.md now 157 lines.

### File List

- `CLAUDE.md` (MODIFIED — 3 lines added to Steps 2, 4, and 6 for SDD dispatch integration)
- `CLAUDE.md` (MODIFIED 2026-02-21 — Step 5 Trace ID, Step 6 ESCALATED+failure-pattern handlers, System Health Checks)
