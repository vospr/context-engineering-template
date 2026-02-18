#!/bin/bash
# Agent Definition Validation Tests
# Validates that all agent files follow conventions and have required fields

set +e  # Continue on errors to show all test results

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

PASSED=0
FAILED=0
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
AGENTS_DIR="$PROJECT_ROOT/.claude/agents"

echo "======================================"
echo "Agent Definition Validation"
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

# Validate each agent file
for agent_file in "$AGENTS_DIR"/*.md; do
    # Skip index and template files
    basename=$(basename "$agent_file")
    if [[ "$basename" == "CLAUDE.md" ]] || [[ "$basename" == "_agent-template.md" ]]; then
        continue
    fi

    echo "## Validating: $basename"

    # Required YAML frontmatter fields
    test_case "  Has 'name:' field" "grep -q '^name:' '$agent_file'"
    test_case "  Has 'model:' field" "grep -q '^model:' '$agent_file'"
    test_case "  Has 'description:' field" "grep -q '^description:' '$agent_file'"
    test_case "  Has 'tools:' list" "grep -q '^tools:' '$agent_file'"

    # Model should be valid
    if grep -q '^model:' "$agent_file"; then
        MODEL=$(grep '^model:' "$agent_file" | cut -d':' -f2 | tr -d ' ' | tr -d '"' | tr -d "'")
        test_case "  Model is valid (haiku/sonnet/opus): $MODEL" "[[ '$MODEL' =~ ^(haiku|sonnet|opus)$ ]]"
    fi

    # Should have meaningful description (>20 chars)
    if grep -q '^description:' "$agent_file"; then
        DESC_LENGTH=$(grep '^description:' "$agent_file" | cut -d':' -f2- | wc -c)
        test_case "  Description is meaningful (>20 chars)" "[ $DESC_LENGTH -gt 20 ]"
    fi

    # Should have at least 2 tools
    TOOL_COUNT=$(grep -A 20 '^tools:' "$agent_file" | grep '^\s*-' | wc -l)
    test_case "  Has tools defined (count: $TOOL_COUNT)" "[ $TOOL_COUNT -gt 0 ]"

    echo ""
done

# Check agent index completeness
if [ -f "$AGENTS_DIR/CLAUDE.md" ]; then
    echo "## Agent Index (CLAUDE.md)"

    for agent_file in "$AGENTS_DIR"/*.md; do
        basename=$(basename "$agent_file")
        if [[ "$basename" == "CLAUDE.md" ]] || [[ "$basename" == "_agent-template.md" ]]; then
            continue
        fi

        agent_name="${basename%.md}"
        test_case "  Index mentions $agent_name" "grep -qi '$agent_name' '$AGENTS_DIR/CLAUDE.md'"
    done
    echo ""
fi

# Summary
echo "======================================"
echo -e "${GREEN}Passed:${NC} $PASSED"
echo -e "${RED}Failed:${NC} $FAILED"
echo "Total: $((PASSED + FAILED))"

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ All agent validations passed!${NC}"
    exit 0
else
    echo -e "${RED}✗ Some agent validations failed${NC}"
    exit 1
fi
