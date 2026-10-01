#!/usr/bin/env bash
# warn-dor-dod.sh — SubagentStop hook (matcher: implementer|reviewer|tester|blind-reviewer)
# Advisory only, always exit 0. Checks the subagent's final message for:
#   DoR: citations of upstream artifacts, and that cited paths exist on disk
#   DoD: acceptance-criteria IDs (AC-n)
# SubagentStop stdout/stderr only reach the debug log, so warnings are appended to
# planning-artifacts/hook-warnings.log (the dispatcher reads it; see CLAUDE.md Step 6a).

. "$(dirname "$0")/lib.sh"

AGENT="$(jget agent_type)"
case "$AGENT" in implementer|reviewer|tester|blind-reviewer) ;; *) exit 0 ;; esac

MSG="$(jget last_assistant_message)"
ROOT="$(project_root)"
LOG="$ROOT/planning-artifacts/hook-warnings.log"
warn() { note_to "$LOG" "$(date -u +%FT%TZ) $*"; echo "$*" >&2; }

if [ -z "$MSG" ]; then warn "WARN [$AGENT]: SubagentStop payload had no last_assistant_message — DoR/DoD not checked."; exit 0; fi

count() { printf '%s\n' "$MSG" | grep -cE "$1" 2>/dev/null || true; }

CITES="$(count '(planning-artifacts/|implementation-artifacts/|\.claude/|[A-Za-z0-9_/.-]+\.(md|json|yaml|ts|js|py):[0-9]+)')"
if [ "${CITES:-0}" -eq 0 ] && [ "$AGENT" != "blind-reviewer" ]; then
  warn "DoR WARNING [$AGENT]: no upstream artifact citations in the final message."
fi

while IFS= read -r cited; do
  [ -z "$cited" ] && continue
  case "$cited" in *'{'*|*'}'*) continue ;; esac
  [ -e "$ROOT/$cited" ] || warn "SUSPICIOUS_CITATION [$AGENT]: cited path '$cited' does not exist on disk."
done < <(printf '%s\n' "$MSG" | grep -oE '(planning-artifacts|implementation-artifacts|\.claude)/[A-Za-z0-9_/.-]+' | sed 's/[.]$//' | sort -u)

ACS="$(count 'AC-[0-9]+')"
if [ "${ACS:-0}" -eq 0 ] && [ "$AGENT" != "blind-reviewer" ]; then
  warn "DoD WARNING [$AGENT]: no acceptance-criteria IDs (AC-n) in the final message."
fi
exit 0
