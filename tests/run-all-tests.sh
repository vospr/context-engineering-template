#!/bin/bash
# Master Test Runner - Executes all validation test suites

set +e  # Don't exit on first failure - run all tests

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TESTS_DIR="$PROJECT_ROOT/tests"

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Claude Code Template Test Suite${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

TOTAL_PASSED=0
TOTAL_FAILED=0
SUITES_PASSED=0
SUITES_FAILED=0

# Function to run a test suite
run_suite() {
    local suite_name="$1"
    local suite_script="$2"

    echo -e "${BLUE}Running: $suite_name${NC}"
    echo "--------------------------------------"

    if [ ! -f "$suite_script" ]; then
        echo -e "${RED}✗ Test suite not found: $suite_script${NC}"
        ((SUITES_FAILED++))
        echo ""
        return 1
    fi

    # Make executable
    chmod +x "$suite_script"

    # Run the test
    if bash "$suite_script"; then
        echo -e "${GREEN}✓ $suite_name: PASSED${NC}"
        ((SUITES_PASSED++))
    else
        echo -e "${RED}✗ $suite_name: FAILED${NC}"
        ((SUITES_FAILED++))
    fi

    echo ""
}

# Run all test suites
run_suite "Template Structure" "$TESTS_DIR/validate-template.sh"
run_suite "Agent Definitions" "$TESTS_DIR/validate-agents.sh"
run_suite "BMAD Workflows" "$TESTS_DIR/validate-bmad-workflows.sh"
run_suite "SDD Architecture" "$TESTS_DIR/validate-sdd.sh"

# Final Summary
echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Final Summary${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "Test Suites Passed: ${GREEN}$SUITES_PASSED${NC}"
echo -e "Test Suites Failed: ${RED}$SUITES_FAILED${NC}"
echo -e "Total Suites: $((SUITES_PASSED + SUITES_FAILED))"
echo ""

if [ $SUITES_FAILED -eq 0 ]; then
    echo -e "${GREEN}✓✓✓ ALL TEST SUITES PASSED ✓✓✓${NC}"
    echo ""
    exit 0
else
    echo -e "${RED}✗✗✗ SOME TEST SUITES FAILED ✗✗✗${NC}"
    echo ""
    exit 1
fi
