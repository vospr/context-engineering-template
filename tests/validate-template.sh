#!/bin/bash
# Template Structure Validation Tests
# Tests the Claude Code Context Engineering Template for structural integrity

set +e  # Continue on errors to show all test results

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PASSED=0
FAILED=0
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

echo "======================================"
echo "Template Validation Test Suite"
echo "======================================"
echo ""

# Test function
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

# Test 1: CLAUDE.md exists and size check
echo "## Core Files"
test_case "CLAUDE.md exists" "[ -f '$PROJECT_ROOT/CLAUDE.md' ]"

if [ -f "$PROJECT_ROOT/CLAUDE.md" ]; then
    LINE_COUNT=$(wc -l < "$PROJECT_ROOT/CLAUDE.md")
    test_case "CLAUDE.md ≤ 200 lines (current: $LINE_COUNT)" "[ $LINE_COUNT -le 200 ]"
fi

# Test 2: Required sections in CLAUDE.md
if [ -f "$PROJECT_ROOT/CLAUDE.md" ]; then
    echo ""
    echo "## CLAUDE.md Content"
    test_case "Contains 'Core Operating Principles'" "grep -q 'Core Operating Principles' '$PROJECT_ROOT/CLAUDE.md'"
    test_case "Contains 'Dispatch Loop'" "grep -q 'Dispatch Loop' '$PROJECT_ROOT/CLAUDE.md'"
    test_case "Contains 'Communication Patterns'" "grep -q 'Communication Patterns' '$PROJECT_ROOT/CLAUDE.md'"
    test_case "Contains 'Token Budget'" "grep -q 'Token Budget' '$PROJECT_ROOT/CLAUDE.md'"
    test_case "Contains 'Git Workflow'" "grep -q 'Git Workflow' '$PROJECT_ROOT/CLAUDE.md'"
fi

# Test 3: Agent files
echo ""
echo "## Agent Definitions"
AGENTS_DIR="$PROJECT_ROOT/.claude/agents"

test_case "Agents directory exists" "[ -d '$AGENTS_DIR' ]"

if [ -d "$AGENTS_DIR" ]; then
    test_case "researcher.md exists" "[ -f '$AGENTS_DIR/researcher.md' ]"
    test_case "planner.md exists" "[ -f '$AGENTS_DIR/planner.md' ]"
    test_case "architect.md exists" "[ -f '$AGENTS_DIR/architect.md' ]"
    test_case "implementer.md exists" "[ -f '$AGENTS_DIR/implementer.md' ]"
    test_case "reviewer.md exists" "[ -f '$AGENTS_DIR/reviewer.md' ]"
    test_case "tester.md exists" "[ -f '$AGENTS_DIR/tester.md' ]"
    test_case "CLAUDE.md index exists" "[ -f '$AGENTS_DIR/CLAUDE.md' ]"
    test_case "_agent-template.md exists" "[ -f '$AGENTS_DIR/_agent-template.md' ]"
fi

# Test 4: Agent file structure (check one as sample)
if [ -f "$AGENTS_DIR/researcher.md" ]; then
    echo ""
    echo "## Agent File Structure (researcher.md)"
    test_case "Has 'name:' field" "grep -q '^name:' '$AGENTS_DIR/researcher.md'"
    test_case "Has 'model:' field" "grep -q '^model:' '$AGENTS_DIR/researcher.md'"
    test_case "Has 'description:' field" "grep -q '^description:' '$AGENTS_DIR/researcher.md'"
    test_case "Has 'tools:' field" "grep -q '^tools:' '$AGENTS_DIR/researcher.md'"
fi

# Test 5: Skills
echo ""
echo "## Skills"
SKILLS_DIR="$PROJECT_ROOT/.claude/skills"

test_case "Skills directory exists" "[ -d '$SKILLS_DIR' ]"

if [ -d "$SKILLS_DIR" ]; then
    test_case "git-workflow.md exists" "[ -f '$SKILLS_DIR/git-workflow.md' ]"
    test_case "coding-standards.md exists" "[ -f '$SKILLS_DIR/coding-standards.md' ]"
    test_case "review-checklist.md exists" "[ -f '$SKILLS_DIR/review-checklist.md' ]"
    test_case "testing-strategy.md exists" "[ -f '$SKILLS_DIR/testing-strategy.md' ]"
    test_case "architecture-principles.md exists" "[ -f '$SKILLS_DIR/architecture-principles.md' ]"
    test_case "CLAUDE.md index exists" "[ -f '$SKILLS_DIR/CLAUDE.md' ]"

    # Check for placeholders
    PLACEHOLDER_COUNT=$(grep -r "\[PLACEHOLDER\]" "$SKILLS_DIR" 2>/dev/null | wc -l || echo 0)
    test_case "No [PLACEHOLDER] markers (found: $PLACEHOLDER_COUNT)" "[ $PLACEHOLDER_COUNT -eq 0 ]"
fi

# Test 6: Security files
echo ""
echo "## Security & Configuration"
test_case ".gitignore exists" "[ -f '$PROJECT_ROOT/.gitignore' ]"

if [ -f "$PROJECT_ROOT/.gitignore" ]; then
    test_case ".gitignore blocks .env files" "grep -q '\.env' '$PROJECT_ROOT/.gitignore'"
    test_case ".gitignore blocks secrets/" "grep -q 'secrets/' '$PROJECT_ROOT/.gitignore'"
fi

test_case "settings.json exists" "[ -f '$PROJECT_ROOT/.claude/settings.json' ]"

# Test 7: Git repository
echo ""
echo "## Git Repository"
test_case "Git repository initialized" "[ -d '$PROJECT_ROOT/.git' ]"

if [ -d "$PROJECT_ROOT/.git" ]; then
    cd "$PROJECT_ROOT"
    test_case "Has commits" "git rev-parse HEAD >/dev/null 2>&1"
    test_case "Main branch exists" "git show-ref --verify --quiet refs/heads/main || git show-ref --verify --quiet refs/heads/master"
fi

# Test 8: Directory structure
echo ""
echo "## Directory Structure"
test_case ".claude/ directory exists" "[ -d '$PROJECT_ROOT/.claude' ]"
test_case "planning-artifacts/ exists" "[ -d '$PROJECT_ROOT/planning-artifacts' ]"

# Summary
echo ""
echo "======================================"
echo "Test Summary"
echo "======================================"
echo -e "${GREEN}Passed:${NC} $PASSED"
echo -e "${RED}Failed:${NC} $FAILED"
echo "Total: $((PASSED + FAILED))"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}✗ Some tests failed${NC}"
    exit 1
fi
