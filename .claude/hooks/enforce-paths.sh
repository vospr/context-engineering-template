#!/usr/bin/env bash
# enforce-paths.sh — PreToolUse hook (matcher: Write|Edit)
# Blocks writes outside the allowlist in enforcement-config.json.
# Contract: payload on stdin; exit 2 = block (stderr is shown to Claude); exit 0 = no objection.
# Scope: only the Write/Edit tools. A Bash command can still write anywhere — this is a guard
# against accidental out-of-scope edits, not a sandbox.

. "$(dirname "$0")/lib.sh"

TOOL="$(jget tool_name)"
case "$TOOL" in Write|Edit|MultiEdit|"") ;; *) exit 0 ;; esac

TARGET="$(jget file_path)"
[ -z "$TARGET" ] && exit 0

ROOT="$(project_root)"
ROOT_PHYS="$(cd "$ROOT" 2>/dev/null && pwd -P || printf '%s' "$ROOT")"
CONFIG="$ROOT/.claude/enforcement-config.json"
[ -f "$CONFIG" ] || CONFIG="$(dirname "$0")/../enforcement-config.json"

TARGET="${TARGET//\\//}"                                 # Windows backslashes
case "$TARGET" in /*|[A-Za-z]:/*) ;; *) TARGET="$ROOT/$TARGET" ;; esac

# Resolve symlinks and ../ through the nearest existing parent directory.
DIR="$(dirname "$TARGET")"
if [ -d "$DIR" ]; then
  RESOLVED="$(cd "$DIR" && pwd -P)/$(basename "$TARGET")"
elif printf '%s' "$TARGET" | grep -qE '(^|/)\.\.(/|$)'; then
  echo "BLOCK: path '$TARGET' contains '..' and its parent directory does not exist." >&2
  exit 2
else
  RESOLVED="$TARGET"
fi

# Make relative to the project root (try physical root, then logical; case-insensitive for drive letters).
lc() { printf '%s' "$1" | tr 'A-Z' 'a-z'; }
REL=""
for base in "$ROOT_PHYS" "$ROOT"; do
  if [[ "$(lc "$RESOLVED")" == "$(lc "$base")/"* ]]; then REL="${RESOLVED:$((${#base}+1))}"; break; fi
done
[ -z "$REL" ] && REL="$RESOLVED"

[ "$REL" = "CLAUDE.md" ] && exit 0

if command -v jq >/dev/null 2>&1 && [ -f "$CONFIG" ]; then
  ALLOWED="$(jq -r '(.allowed_paths // [])[], (.project_source_dirs // [])[]' "$CONFIG" 2>/dev/null)"
else
  ALLOWED="$(sed -n '/allowed_paths/,/]/p;/project_source_dirs/,/]/p' "$CONFIG" 2>/dev/null | grep -oE '"[^"]*/"' | tr -d '"')"
fi
if [ -z "$ALLOWED" ]; then
  echo "BLOCK: no allowed paths could be loaded from $CONFIG — refusing to guess." >&2
  exit 2
fi

while IFS= read -r prefix; do
  [ -z "$prefix" ] && continue
  p="${prefix%/}"
  if [ "$REL" = "$p" ] || [[ "$REL" == "$p"/* ]]; then exit 0; fi
done <<< "$ALLOWED"

{
  echo "BLOCK: Write to '$REL' is outside the allowed paths."
  echo "Allowed: $(printf '%s' "$ALLOWED" | tr '\n' ' ')"
  echo "Add the directory to .claude/enforcement-config.json (allowed_paths or project_source_dirs) if this write is intended."
} >&2
exit 2
