#!/usr/bin/env bash
# enforce-paths.sh — PreToolUse hook for Write/Edit tools
# Blocks writes outside designated paths defined in enforcement-config.json
# Windows/Git Bash compatible. Graceful degradation if jq missing.

set -eo pipefail

# P3: Only fire on Write/Edit tools
if [ "${TOOL_NAME:-}" != "Write" ] && [ "${TOOL_NAME:-}" != "Edit" ]; then
  exit 0
fi

CONFIG_FILE="$(cd "$(dirname "$0")/.." && pwd)/enforcement-config.json"

# P2: Use ${TOOL_INPUT:-} to avoid unset variable crash
TOOL_IN="${TOOL_INPUT:-}"
if [ -z "$TOOL_IN" ]; then
  exit 0
fi

# Extract file_path from TOOL_INPUT (JSON)
if command -v jq &>/dev/null; then
  TARGET_PATH=$(echo "$TOOL_IN" | jq -r '.file_path // empty')
else
  echo "WARN: jq not found, falling back to grep for path extraction" >&2
  TARGET_PATH=$(echo "$TOOL_IN" | grep -oP '"file_path"\s*:\s*"[^"]*"' | head -1 | sed 's/.*"file_path"\s*:\s*"//;s/"$//' || true)
fi

if [ -z "$TARGET_PATH" ]; then
  exit 0
fi

# P1: Normalize target path — resolve symlinks and traversal
if command -v realpath &>/dev/null; then
  TARGET_DIR=$(dirname "$TARGET_PATH")
  if [ -d "$TARGET_DIR" ]; then
    RESOLVED_PATH="$(realpath -P "$TARGET_DIR" 2>/dev/null)/$(basename "$TARGET_PATH")"
  else
    # Parent doesn't exist — check for traversal patterns and block
    if echo "$TARGET_PATH" | grep -qE '(\.\./|/\.\.)'; then
      echo "BLOCK: Path '$TARGET_PATH' contains traversal and parent directory does not exist."
      exit 1
    fi
    RESOLVED_PATH="$TARGET_PATH"
  fi
else
  # P1: No realpath — block any path containing .. (fail closed for traversal)
  if echo "$TARGET_PATH" | grep -qE '(\.\./|/\.\.)'; then
    echo "BLOCK: Path '$TARGET_PATH' contains traversal and realpath is not available for safe resolution."
    exit 1
  fi
  RESOLVED_PATH="$TARGET_PATH"
  echo "WARN: realpath not found, path normalization limited" >&2
fi

# Normalize to forward slashes (Windows compat)
RESOLVED_PATH=$(echo "$RESOLVED_PATH" | sed 's|\\|/|g')

# Get project root (two levels up from hooks dir)
PROJECT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
PROJECT_ROOT=$(echo "$PROJECT_ROOT" | sed 's|\\|/|g')

# Make path relative to project root if absolute (case-insensitive for Windows drive letters)
RESOLVED_LOWER=$(echo "$RESOLVED_PATH" | tr 'A-Z' 'a-z')
ROOT_LOWER=$(echo "$PROJECT_ROOT" | tr 'A-Z' 'a-z')

if [[ "$RESOLVED_LOWER" == "$ROOT_LOWER"* ]]; then
  REL_PATH="${RESOLVED_PATH:${#PROJECT_ROOT}}"
  REL_PATH="${REL_PATH#/}"
else
  REL_PATH="$RESOLVED_PATH"
fi

# Load allowed paths from config
if [ ! -f "$CONFIG_FILE" ]; then
  echo "WARN: enforcement-config.json not found at $CONFIG_FILE, allowing write" >&2
  exit 0
fi

# P5: Use jq for reliable parsing; grep fallback scoped to allowed_paths array
if command -v jq &>/dev/null; then
  ALLOWED_PATHS=$(jq -r '.allowed_paths[]' "$CONFIG_FILE" 2>/dev/null || true)
  PROJECT_DIRS=$(jq -r '.project_source_dirs[]' "$CONFIG_FILE" 2>/dev/null || true)
else
  # Best-effort: extract only values from allowed_paths and project_source_dirs arrays
  ALLOWED_PATHS=$(sed -n '/allowed_paths/,/]/p' "$CONFIG_FILE" | grep -oP '"[^"]*"' | tr -d '"' || true)
  PROJECT_DIRS=$(sed -n '/project_source_dirs/,/]/p' "$CONFIG_FILE" | grep -oP '"[^"]*"' | tr -d '"' || true)
fi

# If allowed paths is empty (parse failure), fail open with warning
ALL_ALLOWED=$(printf "%s\n%s" "$ALLOWED_PATHS" "$PROJECT_DIRS" | grep -v '^$' || true)

if [ -z "$ALL_ALLOWED" ]; then
  echo "WARN: No allowed paths loaded from config — allowing write (parse failure?)" >&2
  exit 0
fi

# Check if relative path starts with any allowed prefix
while IFS= read -r prefix; do
  [ -z "$prefix" ] && continue
  if [[ "$REL_PATH" == "$prefix"* ]] || [[ "$REL_PATH" == "$prefix" ]]; then
    exit 0
  fi
done <<< "$ALL_ALLOWED"

# Also allow CLAUDE.md at project root
if [[ "$REL_PATH" == "CLAUDE.md" ]]; then
  exit 0
fi

# Block the write
echo "BLOCK: Write to '$REL_PATH' is outside allowed paths."
echo "Allowed paths: $(echo "$ALL_ALLOWED" | tr '\n' ', ')"
echo "Update .claude/enforcement-config.json to add new allowed paths."
exit 1
