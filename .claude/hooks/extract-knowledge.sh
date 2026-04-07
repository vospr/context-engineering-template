#!/usr/bin/env bash
# extract-knowledge.sh — SubagentStop hook
# Mechanical knowledge extraction: after key agents complete, this hook
# signals that a haiku agent should parse the output and extract
# decisions, patterns, lessons, and failures into the knowledge base.
#
# Inspired by Atelier Pipeline v3.24.0 brain-extractor pattern.
# Instead of asking agents to "remember" things (behavioral),
# we mechanically extract after completion (mechanical).
#
# Non-blocking: advisory output to stderr, always exits 0.
# Windows/Git Bash compatible.

# SubagentStop hooks receive data via TOOL_RESULT (agent output).
# Coalesce — prefer TOOL_RESULT, fall back to TOOL_INPUT. Never concatenate.
TOOL_IN="${TOOL_RESULT:-${TOOL_INPUT:-}}"

if [ -z "$TOOL_IN" ]; then
  exit 0
fi

# Extract agent type and model
if command -v jq &>/dev/null; then
  AGENT_TYPE=$(echo "$TOOL_IN" | jq -r '.subagent_type // empty' 2>/dev/null || true)
  MODEL=$(echo "$TOOL_IN" | jq -r '.model // empty' 2>/dev/null || true)
  AGENT_OUTPUT=$(echo "$TOOL_IN" | jq -r '.output // empty' 2>/dev/null || true)
else
  # Fallback: grep-based extraction. No -P flag (not portable to macOS).
  # Truncated to 10KB — signals beyond this are missed in fallback mode.
  AGENT_TYPE=$(echo "$TOOL_IN" | grep -oE '"subagent_type"\s*:\s*"[^"]*"' | head -1 | sed 's/.*"subagent_type"[[:space:]]*:[[:space:]]*"//;s/"$//' || true)
  MODEL=$(echo "$TOOL_IN" | grep -oE '"model"\s*:\s*"[^"]*"' | head -1 | sed 's/.*"model"[[:space:]]*:[[:space:]]*"//;s/"$//' || true)
  AGENT_OUTPUT=$(echo "$TOOL_IN" | head -c 10000 || true)
  echo "WARN: jq unavailable, output truncated to 10KB for knowledge signal analysis" >&2
fi

# Skip haiku agents (scouts/readers, not knowledge producers).
# Match known haiku model prefixes to avoid false positives on future model names.
case "$MODEL" in
  haiku|*haiku*) exit 0 ;;
esac

# Only process these agent types
case "$AGENT_TYPE" in
  implementer|reviewer|tester|blind-reviewer|architect|planner) ;;
  *) exit 0 ;;
esac

# Guard: empty output
if [ -z "$AGENT_OUTPUT" ]; then
  exit 0
fi

# Count lines containing knowledge signals (grep -c = matching lines, not occurrences).
# Initialize all to "0" to guard against empty-variable arithmetic errors.
HAS_DECISION=$(echo "$AGENT_OUTPUT" | grep -ciE '(decided|decision|chose|selected|adopted|rejected|alternative)' 2>/dev/null || echo "0")
HAS_PATTERN=$(echo "$AGENT_OUTPUT" | grep -ciE '(pattern|recurring|repeated|again|consistent)' 2>/dev/null || echo "0")
HAS_LESSON=$(echo "$AGENT_OUTPUT" | grep -ciE '(lesson|learned|mistake|root.cause|worked.well|succeeded|failed.because)' 2>/dev/null || echo "0")
HAS_FAILURE=$(echo "$AGENT_OUTPUT" | grep -ciE '(CRITICAL|MAJOR|BLOCKED|NEEDS_CHANGES|bug|error|vulnerability)' 2>/dev/null || echo "0")

TOTAL_SIGNALS=$((HAS_DECISION + HAS_PATTERN + HAS_LESSON + HAS_FAILURE))

# Signal extraction to the main agent via stdout.
# The main agent (CLAUDE.md Step 6a) reads SubagentStop hook output and,
# when it sees EXTRACT_KNOWLEDGE_SIGNAL, dispatches a haiku agent to parse
# the completed agent's artifact and append to knowledge-base files.
# Threshold 5+ reduces false positives from common review language
# (e.g., "error", "again", "selected" appear in ordinary text).
if [ "$TOTAL_SIGNALS" -ge 5 ]; then
  echo "EXTRACT_KNOWLEDGE_SIGNAL: agent_type=$AGENT_TYPE decisions=$HAS_DECISION patterns=$HAS_PATTERN lessons=$HAS_LESSON failures=$HAS_FAILURE"
fi

# Always exit 0 — advisory only, never blocks pipeline
exit 0
