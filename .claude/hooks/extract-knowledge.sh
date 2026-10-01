#!/usr/bin/env bash
# extract-knowledge.sh — SubagentStop hook (matcher: implementer|reviewer|tester|blind-reviewer|architect|planner)
# Counts knowledge signals (decisions, patterns, lessons, failures) in the subagent's final message
# and, at >=5 matching lines, appends EXTRACT_KNOWLEDGE_SIGNAL to planning-artifacts/.hook-signals.
# The dispatcher (CLAUDE.md Step 6a) reads that file and then dispatches a haiku extractor.
# SubagentStop stdout only reaches the debug log, which is why the signal goes to a file.
# Adapted from the brain-extractor idea in Atelier Pipeline v3.24.0 (see README, "Status and lineage").
# Advisory: always exit 0.

. "$(dirname "$0")/lib.sh"

AGENT="$(jget agent_type)"
case "$AGENT" in implementer|reviewer|tester|blind-reviewer|architect|planner) ;; *) exit 0 ;; esac

MSG="$(jget last_assistant_message)"
[ -z "$MSG" ] && exit 0

count() { printf '%s\n' "$MSG" | grep -ciE "$1" 2>/dev/null || true; }   # matching LINES, not occurrences
D="$(count '(decided|decision|chose|selected|adopted|rejected|alternative)')"
P="$(count '(pattern|recurring|repeated|again|consistent)')"
L="$(count '(lesson|learned|mistake|root.cause|worked.well|succeeded|failed.because)')"
F="$(count '(CRITICAL|MAJOR|BLOCKED|NEEDS_CHANGES|bug|error|vulnerability)')"
TOTAL=$(( ${D:-0} + ${P:-0} + ${L:-0} + ${F:-0} ))

if [ "$TOTAL" -ge 5 ]; then
  note_to "$(project_root)/planning-artifacts/.hook-signals" \
    "$(date -u +%FT%TZ) EXTRACT_KNOWLEDGE_SIGNAL: agent_type=$AGENT decisions=$D patterns=$P lessons=$L failures=$F"
fi
exit 0
