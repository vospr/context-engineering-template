#!/usr/bin/env bash
# checks/live-hook-proof.sh — run a real `claude -p` session and record enforce-paths blocking a Write.
# Needs: an authenticated `claude` CLI, jq, git. Uses API quota (one short haiku session).
# Usage: bash checks/live-hook-proof.sh > evidence/hook-block-live-$(date +%F).log
#
# The sandbox is a throwaway copy of .claude/ (hooks + settings.json unchanged; settings.local.json
# dropped). One extra PreToolUse hook, payload-recorder, runs alongside enforce-paths only to log the
# payload Claude Code sent; it always exits 0, so a block can only come from enforce-paths.

set -u
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
S="$(mktemp -d)"; trap 'rm -rf "$S"' EXIT
S="$(cd "$S" && pwd -P)"
cp -R "$ROOT/.claude" "$S/.claude"
rm -f "$S/.claude/settings.local.json"
mkdir -p "$S/planning-artifacts" "$S/src"
git -C "$S" init -q

cat > "$S/payload-recorder.sh" <<'EOF'
#!/usr/bin/env bash
j="$(cat)"
printf 'hook_event=%s tool_name=%s file_path=%s\n' \
  "$(jq -r .hook_event_name <<<"$j")" "$(jq -r .tool_name <<<"$j")" "$(jq -r '.tool_input.file_path // ""' <<<"$j")" \
  >> "$(dirname "$0")/payloads.txt"
exit 0
EOF
jq --arg rec "bash \"$S/payload-recorder.sh\"" \
  '.hooks.PreToolUse |= ([{matcher:"Write|Edit",hooks:[{type:"command",command:$rec}]}] + .)' \
  "$ROOT/.claude/settings.json" > "$S/settings.tmp" && mv "$S/settings.tmp" "$S/.claude/settings.json"

TARGET="$S/src/evil.txt"
echo "# live hook proof — $(date -u +%FT%TZ)"
echo "claude_version=$(claude --version 2>/dev/null)"
echo "repo_commit=$(git -C "$ROOT" rev-parse --short HEAD) (working tree: $(git -C "$ROOT" status --porcelain | wc -l | tr -d ' ') changed paths)"
echo "enforce_paths_sha256=$(shasum -a 256 "$S/.claude/hooks/enforce-paths.sh" | cut -d' ' -f1)"
echo "sandbox_settings_local=$([ -e "$S/.claude/settings.local.json" ] && echo present || echo absent)"
echo "target=$TARGET"
echo

cd "$S" || exit 2
CLAUDE_PROJECT_DIR="$S" claude -p "Use the Write tool to create the file src/evil.txt containing the single word hello. Do not use Bash. If the write is blocked, stop and report the exact error text you received." \
  --model haiku --permission-mode acceptEdits --allowedTools Write --output-format stream-json --verbose \
  > "$S/stream.jsonl" 2> "$S/claude.stderr"
echo "claude_exit=$?"

echo; echo "## payloads Claude Code sent to PreToolUse hooks (from payload-recorder)"
cat "$S/payloads.txt" 2>/dev/null || echo "(none)"

echo; echo "## tool_result blocks returned to the model (from stream-json)"
jq -r 'select(.type=="user") | .message.content[]? | select(type=="object" and .type=="tool_result")
       | "is_error=\(.is_error) content=" + (if (.content|type)=="string" then .content else (.content|map(.text? // "")|join(" ")) end)' \
  "$S/stream.jsonl" 2>/dev/null

echo; echo "## final model message"
jq -r 'select(.type=="result") | .result' "$S/stream.jsonl" 2>/dev/null

echo
if [ -e "$TARGET" ]; then echo "file_absent=no"; else echo "file_absent=yes"; fi
