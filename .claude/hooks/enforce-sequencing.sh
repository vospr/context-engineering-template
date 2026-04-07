#!/usr/bin/env bash
# enforce-sequencing.sh — PreToolUse hook for Agent tool
# Blocks implementer dispatch if no tasks exist (prevents premature implementation)
# Bypass: task-file existence only. No prompt scanning, no env-var bypass.
# (per Red Team hardening H3 + code review D1)
# Windows/Git Bash compatible.

set -eo pipefail

# Only check Agent tool invocations
if [ "${TOOL_NAME:-}" != "Agent" ]; then
  exit 0
fi

# Extract subagent_type from TOOL_INPUT
TOOL_IN="${TOOL_INPUT:-}"
if [ -z "$TOOL_IN" ]; then
  exit 0
fi

if command -v jq &>/dev/null; then
  AGENT_TYPE=$(echo "$TOOL_IN" | jq -r '.subagent_type // empty')
else
  AGENT_TYPE=$(echo "$TOOL_IN" | grep -oP '"subagent_type"\s*:\s*"[^"]*"' | head -1 | sed 's/.*"subagent_type"\s*:\s*"//;s/"$//' || true)
fi

# Only gate implementer dispatches
if [ -z "$AGENT_TYPE" ] || [ "$AGENT_TYPE" != "implementer" ]; then
  exit 0
fi

# Check if planning artifacts with task decomposition exist
PROJECT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
TASK_FILES=$(find "$PROJECT_ROOT/planning-artifacts" -name "*plan-*.md" 2>/dev/null | head -1)

if [ -z "$TASK_FILES" ]; then
  echo "BLOCK: Cannot dispatch implementer — no planning artifacts found."
  echo "Create tasks via planner agent first, or classify as Micro tier."
  exit 1
fi

exit 0
