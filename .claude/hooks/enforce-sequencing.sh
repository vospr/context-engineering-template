#!/usr/bin/env bash
# enforce-sequencing.sh — PreToolUse hook (matcher: Agent)
# Blocks dispatching the implementer while no plan file exists under planning-artifacts/.
# Contract: payload on stdin; exit 2 = block (stderr is shown to Claude).
# Bypass: the existence of a planning-artifacts/*plan-*.md file. No prompt scanning, no env-var bypass.

. "$(dirname "$0")/lib.sh"

TOOL="$(jget tool_name)"
case "$TOOL" in Agent|Task|"") ;; *) exit 0 ;; esac

[ "$(jget subagent_type)" = "implementer" ] || exit 0

ROOT="$(project_root)"
if [ -z "$(find "$ROOT/planning-artifacts" -name '*plan-*.md' 2>/dev/null | head -1)" ]; then
  {
    echo "BLOCK: cannot dispatch the implementer — no plan file (planning-artifacts/*plan-*.md) exists."
    echo "Run the planner first. The hook does not know task tiers: a Micro task also needs a (one-line) plan file."
  } >&2
  exit 2
fi
exit 0
