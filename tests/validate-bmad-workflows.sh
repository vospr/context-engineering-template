#!/bin/bash
# BMAD Workflow System Validation Tests
# Validates the BMAD workflow engine and configurations

set +e  # Continue on errors to show all test results

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

PASSED=0
FAILED=0
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

echo "======================================"
echo "BMAD Workflow System Validation"
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

# Test BMAD core structure
echo "## BMAD Core Structure"
test_case "_bmad/ directory exists" "[ -d '$PROJECT_ROOT/_bmad' ]"
test_case "_bmad/core/ exists" "[ -d '$PROJECT_ROOT/_bmad/core' ]"
test_case "_bmad/bmm/ exists" "[ -d '$PROJECT_ROOT/_bmad/bmm' ]"

# Test core workflow engine
echo ""
echo "## Workflow Engine"
test_case "workflow.xml exists" "[ -f '$PROJECT_ROOT/_bmad/core/tasks/workflow.xml' ]"

if [ -f "$PROJECT_ROOT/_bmad/core/tasks/workflow.xml" ]; then
    test_case "workflow.xml has <flow> section" "grep -q '<flow>' '$PROJECT_ROOT/_bmad/core/tasks/workflow.xml'"
    test_case "workflow.xml has protocols" "grep -q '<protocols' '$PROJECT_ROOT/_bmad/core/tasks/workflow.xml'"
    test_case "workflow.xml has discover_inputs protocol" "grep -q 'protocol name=\"discover_inputs\"' '$PROJECT_ROOT/_bmad/core/tasks/workflow.xml'"
fi

# Test BMM configuration
echo ""
echo "## BMM Configuration"
test_case "config.yaml exists" "[ -f '$PROJECT_ROOT/_bmad/bmm/config.yaml' ]"

if [ -f "$PROJECT_ROOT/_bmad/bmm/config.yaml" ]; then
    test_case "Has project_name" "grep -q '^project_name:' '$PROJECT_ROOT/_bmad/bmm/config.yaml'"
    test_case "Has output_folder" "grep -q '^output_folder:' '$PROJECT_ROOT/_bmad/bmm/config.yaml'"
    test_case "Has user_name" "grep -q '^user_name:' '$PROJECT_ROOT/_bmad/bmm/config.yaml'"
fi

# Test QA Automate workflow
echo ""
echo "## QA Automate Workflow"
QA_WORKFLOW_DIR="$PROJECT_ROOT/_bmad/bmm/workflows/qa/automate"
test_case "QA automate workflow dir exists" "[ -d '$QA_WORKFLOW_DIR' ]"

if [ -d "$QA_WORKFLOW_DIR" ]; then
    test_case "workflow.yaml exists" "[ -f '$QA_WORKFLOW_DIR/workflow.yaml' ]"
    test_case "instructions.md exists" "[ -f '$QA_WORKFLOW_DIR/instructions.md' ]"

    if [ -f "$QA_WORKFLOW_DIR/workflow.yaml" ]; then
        test_case "Has config_source" "grep -q '^config_source:' '$QA_WORKFLOW_DIR/workflow.yaml'"
        test_case "Has instructions path" "grep -q '^instructions:' '$QA_WORKFLOW_DIR/workflow.yaml'"
        test_case "References config.yaml" "grep -q 'config.yaml' '$QA_WORKFLOW_DIR/workflow.yaml'"
    fi
fi

# Test output directories
echo ""
echo "## Output Directories"
test_case "_bmad-output/ exists" "[ -d '$PROJECT_ROOT/_bmad-output' ]"

if [ -d "$PROJECT_ROOT/_bmad-output" ]; then
    test_case "planning-artifacts/ exists" "[ -d '$PROJECT_ROOT/_bmad-output/planning-artifacts' ]"
    test_case "implementation-artifacts/ exists" "[ -d '$PROJECT_ROOT/_bmad-output/implementation-artifacts' ]"
fi

# Summary
echo ""
echo "======================================"
echo -e "${GREEN}Passed:${NC} $PASSED"
echo -e "${RED}Failed:${NC} $FAILED"
echo "Total: $((PASSED + FAILED))"

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ All BMAD workflow validations passed!${NC}"
    exit 0
else
    echo -e "${RED}✗ Some BMAD workflow validations failed${NC}"
    exit 1
fi
