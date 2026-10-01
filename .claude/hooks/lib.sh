#!/usr/bin/env bash
# lib.sh — shared helpers for the hooks. Source it; do not execute it.
#
# Claude Code hook contract (https://code.claude.com/docs/en/hooks, checked 2026-10-01):
#   - the event payload arrives as ONE JSON object on stdin (tool_name, tool_input, agent_type,
#     last_assistant_message, cwd, ...). There are no TOOL_* environment variables.
#   - exit 2 blocks (PreToolUse) and shows stderr to Claude; any other non-zero exit is non-blocking.
#   - on exit 0, stdout/stderr of SubagentStop hooks go to the debug log only, so advisory hooks
#     write to files under planning-artifacts/ instead.

HOOK_JSON="$(cat || true)"

# jget <key>  -> first string value for "key" anywhere in the payload (jq if present, grep fallback)
jget() {
  local key="$1"
  [ -z "$HOOK_JSON" ] && return 0
  if command -v jq >/dev/null 2>&1; then
    printf '%s' "$HOOK_JSON" | jq -r --arg k "$key" '[.. | objects | select(has($k)) | .[$k]] | first // empty | if type=="string" then . else tojson end' 2>/dev/null
  else
    printf '%s' "$HOOK_JSON" | grep -oE "\"$key\"[[:space:]]*:[[:space:]]*\"([^\"\\\\]|\\\\.)*\"" | head -1 \
      | sed -E "s/^\"$key\"[[:space:]]*:[[:space:]]*\"//; s/\"\$//" || true
  fi
}

# Project root: CLAUDE_PROJECT_DIR when Claude Code sets it, else two levels above the hooks dir.
project_root() {
  if [ -n "${CLAUDE_PROJECT_DIR:-}" ]; then printf '%s' "$CLAUDE_PROJECT_DIR"
  else (cd "$(dirname "${BASH_SOURCE[1]}")/../.." && pwd); fi
}

# note_to <file> <line>  -> append to a file under planning-artifacts/ (created if needed)
note_to() {
  local f="$1"; shift
  mkdir -p "$(dirname "$f")" 2>/dev/null && printf '%s\n' "$*" >> "$f"
}
