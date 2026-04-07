#!/usr/bin/env bash
# warn-dor-dod.sh — SubagentStop hook
# Advisory: warns when agents don't prove they read upstream artifacts (DoR)
# or covered acceptance criteria (DoD).
# Only checks: implementer, reviewer, tester, blind-reviewer
# Skips: researcher, haiku lookups
# Non-blocking: warnings to stderr only, always exits 0
# Windows/Git Bash compatible.

# P4: SubagentStop hooks may receive data via TOOL_INPUT or TOOL_RESULT.
# Use both with fallback. Do NOT use set -e — always exit 0.
set -o pipefail

TOOL_IN="${TOOL_INPUT:-}${TOOL_RESULT:-}"

if [ -z "$TOOL_IN" ]; then
  echo "WARN: warn-dor-dod.sh could not read agent output (no TOOL_INPUT or TOOL_RESULT)" >&2
  exit 0
fi

# Extract agent type and output
if command -v jq &>/dev/null; then
  AGENT_TYPE=$(echo "$TOOL_IN" | jq -r '.subagent_type // empty' 2>/dev/null || true)
  AGENT_OUTPUT=$(echo "$TOOL_IN" | jq -r '.output // empty' 2>/dev/null || true)
  MODEL=$(echo "$TOOL_IN" | jq -r '.model // empty' 2>/dev/null || true)
else
  echo "WARN: jq not available; DoR/DoD check may be unreliable" >&2
  AGENT_TYPE=$(echo "$TOOL_IN" | grep -oE '"subagent_type"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"subagent_type"[[:space:]]*:[[:space:]]*"//;s/"$//' || true)
  AGENT_OUTPUT=$(echo "$TOOL_IN" | head -c 10000 || true)
  MODEL=$(echo "$TOOL_IN" | grep -oE '"model"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"model"[[:space:]]*:[[:space:]]*"//;s/"$//' || true)
fi

# Skip for researcher agents and haiku model dispatches
if [[ "$AGENT_TYPE" == "researcher" ]] || [[ "$MODEL" == *"haiku"* ]]; then
  exit 0
fi

# Only check for: implementer, reviewer, tester, blind-reviewer
case "$AGENT_TYPE" in
  implementer|reviewer|tester|blind-reviewer) ;;
  *) exit 0 ;;
esac

# Guard: if output is empty, warn and skip rather than false-positive
if [ -z "$AGENT_OUTPUT" ]; then
  echo "WARN: warn-dor-dod.sh could not extract agent output — skipping DoR/DoD check" >&2
  exit 0
fi

# DoR Check: look for file path citations in output
DOR_CITATIONS=$(echo "$AGENT_OUTPUT" | grep -cE '(planning-artifacts/|implementation-artifacts/|\.claude/|[a-zA-Z0-9_/.-]+\.(md|json|yaml|ts|js|py):[0-9]+)' 2>/dev/null || echo "0")

if [ "$DOR_CITATIONS" -eq 0 ] && [ "$AGENT_TYPE" != "blind-reviewer" ]; then
  echo "⚠️ DoR WARNING [$AGENT_TYPE]: No upstream artifact citations found in output." >&2
fi

# Cross-check: verify cited paths exist on disk
PROJECT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
CITED_PATHS=$(echo "$AGENT_OUTPUT" | grep -oE '(planning-artifacts|implementation-artifacts|\.claude)/[a-zA-Z0-9_/.-]+' 2>/dev/null | sort -u || true)

while IFS= read -r cited; do
  [ -z "$cited" ] && continue
  # Skip template placeholders (paths containing { or })
  if echo "$cited" | grep -q '[{}]'; then
    continue
  fi
  # Windows compat: normalize backslashes to forward slashes
  cited=$(echo "$cited" | sed 's|\\|/|g')
  if [ ! -f "$PROJECT_ROOT/$cited" ] && [ ! -d "$PROJECT_ROOT/$cited" ]; then
    echo "⚠️ SUSPICIOUS_CITATION [$AGENT_TYPE]: Cited path '$cited' does not exist on disk." >&2
  fi
done <<< "$CITED_PATHS"

# DoD Check: look for AC ID mentions (AC-1, AC-2, etc.)
DOD_MENTIONS=$(echo "$AGENT_OUTPUT" | grep -cE 'AC-[0-9]+' 2>/dev/null || echo "0")

if [ "$DOD_MENTIONS" -eq 0 ] && [ "$AGENT_TYPE" != "blind-reviewer" ]; then
  echo "⚠️ DoD WARNING [$AGENT_TYPE]: No acceptance criteria IDs (AC-*) found in output." >&2
fi

# Always exit 0 — advisory only
exit 0
