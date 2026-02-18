#!/bin/bash
# SDD Architecture Validation Tests
# Validates that SDD implementation matches architecture spec requirements

set +e  # Continue on errors to show all test results

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

PASSED=0
FAILED=0
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SPEC="$PROJECT_ROOT/.claude/skills/spec-protocol.md"
CLAUDE_MD="$PROJECT_ROOT/CLAUDE.md"
AGENTS_DIR="$PROJECT_ROOT/.claude/agents"
ARCH="$PROJECT_ROOT/_bmad-output/planning-artifacts/architecture.md"
EPICS="$PROJECT_ROOT/_bmad-output/planning-artifacts/epics.md"
IMPL_DIR="$PROJECT_ROOT/_bmad-output/implementation-artifacts"

echo "======================================"
echo "SDD Architecture Validation"
echo "======================================"
echo ""

test_case() {
    local name="$1"
    local condition="$2"

    if eval "$condition"; then
        echo -e "${GREEN}✓${NC} $name"
        ((PASSED++))
    else
        echo -e "${RED}✗${NC} $name"
        ((FAILED++))
    fi
}

# ======================================
# A. spec-protocol.md Content Validation
# ======================================
echo "## A. spec-protocol.md Content Validation"

test_case "spec-protocol.md exists" "[ -f '$SPEC' ]"

if [ -f "$SPEC" ]; then
    SPEC_LINES=$(wc -l < "$SPEC")
    test_case "spec-protocol.md is non-trivial (>500 lines, current: $SPEC_LINES)" "[ $SPEC_LINES -gt 500 ]"
    test_case "Section 1: Spec Packet Format" "grep -q '## 1\. Spec Packet Format' '$SPEC'"
    test_case "YAML delimiters: --- SPEC ---" "grep -q '\-\-\- SPEC \-\-\-' '$SPEC'"
    test_case "YAML delimiters: --- END SPEC ---" "grep -q '\-\-\- END SPEC \-\-\-' '$SPEC'"
    test_case "Section 2: Tier definitions present" "grep -q 'TRIVIAL\|SIMPLE\|MODERATE\|COMPLEX' '$SPEC'"
    test_case "Controlled vocabulary: MUST/MUST NOT/SHOULD/MAY" "grep -q 'MUST NOT' '$SPEC' && grep -q 'SHOULD' '$SPEC' && grep -q 'MAY' '$SPEC'"
    test_case "Assertion quality gate (bans vague terms)" "grep -qi 'vague\|banned.*term\|works.*correct\|proper.*appropriate' '$SPEC'"
    test_case "7x7 rule present" "grep -qi '7x7\|max 7 tasks\|max 7 assertions' '$SPEC'"
    test_case "Governance principles present" "grep -qi 'governance' '$SPEC'"
    test_case "Tier classification decision table" "grep -q 'Token budget' '$SPEC'"
    test_case "Section 7: SDD Dispatch Routing" "grep -q '## 7\. SDD Dispatch Routing' '$SPEC'"
    test_case "Section 8: Inline Spec Delivery Protocol" "grep -q '## 8\. Inline Spec' '$SPEC'"
    test_case "Section 9: Spec Overview Documents" "grep -q '## 9\. Spec Overview' '$SPEC'"
    test_case "Section 10: Spec Lifecycle States (DRAFT/ACTIVE/DONE)" "grep -q '## 10\. Spec Lifecycle' '$SPEC' && grep -q 'DRAFT.*ACTIVE.*DONE' '$SPEC'"
    test_case "Section 11: Evidence Reporting (PASS|FAIL with file:line)" "grep -q '## 11\. Evidence Reporting' '$SPEC' && grep -q 'PASS|FAIL' '$SPEC'"
    test_case "Section 12: Feature Tracker Protocol" "grep -q '## 12\. Feature Tracker' '$SPEC'"
    test_case "Section 13: Tracker State Machine & Recovery" "grep -q '## 13\.' '$SPEC'"
    test_case "Section 17: Spec Templates Protocol" "grep -q '## 17\. Spec Templates' '$SPEC'"
    test_case "Token budgets defined (500/2000/8000/25000)" "grep -q '500' '$SPEC' && grep -q '2,000\|2000' '$SPEC' && grep -q '8,000\|8000' '$SPEC' && grep -q '25,000\|25000' '$SPEC'"
fi

echo ""

# ======================================
# B. CLAUDE.md SDD Integration
# ======================================
echo "## B. CLAUDE.md SDD Integration"

if [ -f "$CLAUDE_MD" ]; then
    test_case "CLAUDE.md references spec-protocol.md" "grep -q 'spec-protocol.md' '$CLAUDE_MD'"
    test_case "CLAUDE.md contains spec_tier classification" "grep -q 'spec_tier' '$CLAUDE_MD'"
    test_case "CLAUDE.md contains NEEDS_RESPEC handling" "grep -q 'NEEDS_RESPEC' '$CLAUDE_MD'"
    CLAUDE_LINES=$(wc -l < "$CLAUDE_MD")
    test_case "CLAUDE.md ≤ 200 lines after SDD additions (current: $CLAUDE_LINES)" "[ $CLAUDE_LINES -le 200 ]"
    test_case "CLAUDE.md preserves Dispatch Loop steps" "grep -q 'Read Current State' '$CLAUDE_MD' && grep -q 'Select Next Task' '$CLAUDE_MD' && grep -q 'Match Agent' '$CLAUDE_MD' && grep -q 'Dispatch' '$CLAUDE_MD' && grep -q 'Process Result' '$CLAUDE_MD' && grep -q 'Token Check' '$CLAUDE_MD'"
fi

echo ""

# ======================================
# C. Agent SDD Extensions
# ======================================
echo "## C. Agent SDD Extensions"

# Planner
PLANNER="$AGENTS_DIR/planner.md"
if [ -f "$PLANNER" ]; then
    test_case "planner.md: spec-protocol in skills" "grep -q 'spec-protocol' '$PLANNER'"
    test_case "planner.md: spec authoring workflow" "grep -qi 'spec authoring' '$PLANNER'"
    test_case "planner.md: just-in-time decomposition" "grep -qi 'just-in-time' '$PLANNER'"
fi

# Reviewer
REVIEWER="$AGENTS_DIR/reviewer.md"
if [ -f "$REVIEWER" ]; then
    test_case "reviewer.md: spec-protocol in skills" "grep -q 'spec-protocol' '$REVIEWER'"
    test_case "reviewer.md: spec review mode section" "grep -qi 'spec review mode' '$REVIEWER'"
    test_case "reviewer.md: spec-specific severities (CRITICAL/MAJOR/MINOR)" "grep -q 'CRITICAL' '$REVIEWER' && grep -q 'MAJOR' '$REVIEWER' && grep -q 'MINOR' '$REVIEWER'"
fi

# Tester
TESTER="$AGENTS_DIR/tester.md"
if [ -f "$TESTER" ]; then
    test_case "tester.md: spec-protocol in skills" "grep -q 'spec-protocol' '$TESTER'"
    test_case "tester.md: assertion execution mode" "grep -qi 'assertion execution' '$TESTER'"
    test_case "tester.md: integration verification mode" "grep -qi 'integration verification' '$TESTER'"
    test_case "tester.md: CONFIRMED/NEEDS_INVESTIGATION statuses" "grep -q 'CONFIRMED' '$TESTER' && grep -q 'NEEDS_INVESTIGATION' '$TESTER'"
fi

# Line count bounds (loose — just sanity checks)
if [ -f "$PLANNER" ]; then
    PL=$(wc -l < "$PLANNER")
    test_case "planner.md line count reasonable (>50, current: $PL)" "[ $PL -gt 50 ]"
fi
if [ -f "$REVIEWER" ]; then
    RL=$(wc -l < "$REVIEWER")
    test_case "reviewer.md line count reasonable (>50, current: $RL)" "[ $RL -gt 50 ]"
fi
if [ -f "$TESTER" ]; then
    TL=$(wc -l < "$TESTER")
    test_case "tester.md line count reasonable (>50, current: $TL)" "[ $TL -gt 50 ]"
fi

echo ""

# ======================================
# D. Architecture Compliance
# ======================================
echo "## D. Architecture Compliance"

test_case "architecture.md exists" "[ -f '$ARCH' ]"

if [ -f "$ARCH" ]; then
    test_case "Contains 6 Irreducible Truths" "grep -qi 'irreducible' '$ARCH'"
    test_case "Contains ADR-001" "grep -q 'ADR-001' '$ARCH'"
    test_case "Contains ADR-002" "grep -q 'ADR-002' '$ARCH'"
    test_case "Contains ADR-003" "grep -q 'ADR-003' '$ARCH'"
    test_case "Contains ADR-004" "grep -q 'ADR-004' '$ARCH'"
    test_case "Contains ADR-005" "grep -q 'ADR-005' '$ARCH'"
    test_case "Contains vulnerability register" "grep -qi 'vulnerability register' '$ARCH'"
    test_case "Contains vertical slices description" "grep -qi 'vertical slice' '$ARCH'"
fi

test_case "epics.md exists" "[ -f '$EPICS' ]"

if [ -f "$EPICS" ]; then
    test_case "Epics contains Epic 1" "grep -q 'Epic 1' '$EPICS'"
    test_case "Epics contains Epic 2" "grep -q 'Epic 2' '$EPICS'"
    test_case "Epics contains Epic 3" "grep -q 'Epic 3' '$EPICS'"
    test_case "Epics contains Epic 4" "grep -q 'Epic 4' '$EPICS'"
    test_case "Epics contains Epic 5" "grep -q 'Epic 5' '$EPICS'"
fi

# Implementation artifacts (14 expected)
IMPL_ARTIFACTS=(
    "1-1-define-spec-packet-yaml-format.md"
    "1-2-define-controlled-vocabulary-assertion-quality-gate.md"
    "1-3-define-constraints-governance-seed-7x7-rule.md"
    "2-1-sdd-detection-dispatch-loop-integration.md"
    "2-2-graduated-spec-tier-router.md"
    "2-3-inline-spec-packet-delivery-via-tasklist.md"
    "2-4-spec-overview-documents.md"
    "2-5-spec-lifecycle-states-evidence-reporting.md"
    "3-1-feature-tracker-json-schema-initialization.md"
    "3-2-tracker-state-transitions-recovery.md"
    "5-1-planner-agent-spec-authoring-extension.md"
    "5-2-reviewer-spec-review-mode.md"
    "5-3-tester-assertion-execution-integration-modes.md"
    "5-4-reusable-spec-templates-optional.md"
)

IMPL_FOUND=0
for artifact in "${IMPL_ARTIFACTS[@]}"; do
    if [ -f "$IMPL_DIR/$artifact" ]; then
        ((IMPL_FOUND++))
    fi
done
test_case "All 14 implementation artifacts exist (found: $IMPL_FOUND)" "[ $IMPL_FOUND -eq 14 ]"

test_case "Test summary exists" "[ -f '$IMPL_DIR/tests/test-summary.md' ]"

echo ""

# ======================================
# E. Cross-Cutting SDD Invariants
# ======================================
echo "## E. Cross-Cutting SDD Invariants"

# No non-reviewer agent has both Write and TaskCreate in disallowedTools
# (reviewer is intentionally read-only — outputs via agent return value)
BROKEN_AGENTS=0
for agent_file in "$AGENTS_DIR"/*.md; do
    basename=$(basename "$agent_file")
    if [[ "$basename" == "CLAUDE.md" ]] || [[ "$basename" == "_agent-template.md" ]] || [[ "$basename" == "reviewer.md" ]]; then
        continue
    fi
    DISALLOWED=$(grep -A 1 '^disallowedTools:' "$agent_file" 2>/dev/null || echo "")
    if echo "$DISALLOWED" | grep -q 'Write' && echo "$DISALLOWED" | grep -q 'TaskCreate'; then
        ((BROKEN_AGENTS++))
    fi
done
test_case "No non-reviewer agent blocks both Write and TaskCreate (found: $BROKEN_AGENTS)" "[ $BROKEN_AGENTS -eq 0 ]"

# All agents with spec-protocol skill have Read in tools
MISSING_READ=0
for agent_file in "$AGENTS_DIR"/*.md; do
    basename=$(basename "$agent_file")
    if [[ "$basename" == "CLAUDE.md" ]] || [[ "$basename" == "_agent-template.md" ]]; then
        continue
    fi
    if grep -q 'spec-protocol' "$agent_file" 2>/dev/null; then
        if ! grep '^tools:' "$agent_file" | grep -q 'Read'; then
            ((MISSING_READ++))
        fi
    fi
done
test_case "All spec-protocol agents have Read tool (missing: $MISSING_READ)" "[ $MISSING_READ -eq 0 ]"

# Governance cascade
test_case "Governance cascade documented in spec-protocol" "grep -qi 'governance cascade' '$SPEC'"

# Token budgets per tier
test_case "Token budget per tier in spec-protocol" "grep -q '500' '$SPEC' && grep -q '25,000\|25000' '$SPEC'"

# Schema versioning
test_case "Schema versioning (version: 1) in spec-protocol" "grep -q 'version: 1' '$SPEC'"

# Backward compatibility — file-presence activation
test_case "Backward compatibility documented" "grep -qi 'backward compat' '$SPEC'"

# Feature tracker JSON schema fields
test_case "Feature tracker schema fields documented" "grep -q 'spec_overview' '$SPEC' && grep -q 'verified' '$SPEC' && grep -q 'tasks' '$SPEC'"

# Evidence format
test_case "Evidence format (PASS/FAIL with file:line)" "grep -q 'PASS|FAIL' '$SPEC' && grep -q 'file:line\|{file}:{line}' '$SPEC'"

# Summary
echo ""
echo "======================================"
echo -e "${GREEN}Passed:${NC} $PASSED"
echo -e "${RED}Failed:${NC} $FAILED"
echo "Total: $((PASSED + FAILED))"

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ All SDD architecture validations passed!${NC}"
    exit 0
else
    echo -e "${RED}✗ Some SDD architecture validations failed${NC}"
    exit 1
fi
