#!/usr/bin/env bash
# checks/run.sh — acceptance checks for the 2026-10 redo.
# Requires: bash, jq, git. No network. Exit 0 only if every check passes.
# Usage: bash checks/run.sh            (log a run: bash checks/run.sh | tee evidence/checks-run-YYYY-MM-DD.log)

set -u
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT" || exit 2

PASS=0; FAIL=0
pass() { PASS=$((PASS+1)); printf 'PASS  %-6s %s\n' "$1" "$2"; }
fail() { FAIL=$((FAIL+1)); printf 'FAIL  %-6s %s\n' "$1" "$2"; [ -n "${3:-}" ] && printf '        -> %s\n' "$3"; }
check() { # id, description, command...
  local id="$1" desc="$2"; shift 2
  local out; out="$("$@" 2>&1)"
  if [ $? -eq 0 ]; then pass "$id" "$desc"; else fail "$id" "$desc" "$(printf '%s' "$out" | head -3 | tr '\n' ' ')"; fi
}

# ---------- sandbox: a throwaway project root so hooks never touch the real tree ----------
T="$(mktemp -d)"; trap 'rm -rf "$T"' EXIT
mkdir -p "$T/planning-artifacts" "$T/implementation-artifacts"
cp -R .claude "$T/.claude"
run_hook() { # hook-name, json  -> sets RC, ERR, OUT
  local h="$1" json="$2"
  OUT="$(printf '%s' "$json" | CLAUDE_PROJECT_DIR="$T" bash "$T/.claude/hooks/$h.sh" 2>"$T/stderr")"; RC=$?
  ERR="$(cat "$T/stderr")"
}
pre() { jq -nc --arg t "$1" --argjson i "$2" '{hook_event_name:"PreToolUse",tool_name:$t,tool_input:$i,cwd:"/x"}'; }
stop() { jq -nc --arg a "$1" --arg m "$2" '{hook_event_name:"SubagentStop",agent_type:$a,agent_id:"a1",last_assistant_message:$m}'; }

# ================= H: hooks follow the current Claude Code contract =================
h_settings_shape() {
  jq -e '
    [.hooks[][]] | length > 0 and all(.[]; (has("command")|not) and ((.hooks // [])|length>0)
      and all(.hooks[]; .type=="command" and (.command|length>0)))' .claude/settings.json >/dev/null
}
check H1 "settings.json: matcher groups hold nested hooks[{type:command,command}]; no bare command" h_settings_shape

h_no_env_vars() { ! grep -nE 'TOOL_INPUT|TOOL_NAME|TOOL_RESULT' .claude/hooks/*.sh; }
check H2 "no hook reads the obsolete TOOL_INPUT/TOOL_NAME/TOOL_RESULT env vars" h_no_env_vars

h_paths_block() {
  run_hook enforce-paths "$(pre Write "$(jq -nc --arg p "$T/src/evil.txt" '{file_path:$p,content:"x"}')")"
  [ "$RC" -eq 2 ] && echo "$ERR" | grep -q 'BLOCK'
}
check H3 "enforce-paths: Write outside allowlist -> exit 2 with BLOCK on stderr" h_paths_block

h_paths_traversal() {
  run_hook enforce-paths "$(pre Edit "$(jq -nc --arg p "$T/planning-artifacts/../src/x.txt" '{file_path:$p}')")"
  [ "$RC" -eq 2 ]
}
check H4 "enforce-paths: ../ traversal out of an allowed dir -> exit 2" h_paths_traversal

h_paths_allow() {
  run_hook enforce-paths "$(pre Write "$(jq -nc --arg p "$T/planning-artifacts/plan-1.md" '{file_path:$p}')")"; [ "$RC" -eq 0 ] || return 1
  run_hook enforce-paths "$(pre Write "$(jq -nc --arg p "$T/CLAUDE.md" '{file_path:$p}')")"; [ "$RC" -eq 0 ] || return 1
  run_hook enforce-paths "$(pre Bash '{"command":"ls"}')"; [ "$RC" -eq 0 ]
}
check H5 "enforce-paths: allowed paths, CLAUDE.md and non-write tools -> exit 0" h_paths_allow

h_seq_block() {
  run_hook enforce-sequencing "$(pre Agent '{"subagent_type":"implementer","prompt":"go"}')"
  [ "$RC" -eq 2 ] && echo "$ERR" | grep -q 'BLOCK'
}
check H6 "enforce-sequencing: implementer with no plan -> exit 2 with BLOCK" h_seq_block

h_seq_allow() {
  run_hook enforce-sequencing "$(pre Agent '{"subagent_type":"researcher"}')"; [ "$RC" -eq 0 ] || return 1
  : > "$T/planning-artifacts/2026-01-01-plan-x.md"
  run_hook enforce-sequencing "$(pre Agent '{"subagent_type":"implementer"}')"; local rc=$RC
  rm -f "$T/planning-artifacts/2026-01-01-plan-x.md"; [ "$rc" -eq 0 ]
}
check H7 "enforce-sequencing: researcher allowed; implementer allowed once a plan file exists" h_seq_allow

h_dor_warn() {
  : > "$T/planning-artifacts/hook-warnings.log"
  run_hook warn-dor-dod "$(stop implementer 'Done. Everything works.')"; [ "$RC" -eq 0 ] || return 1
  grep -q 'DoR WARNING' "$T/planning-artifacts/hook-warnings.log" && grep -q 'DoD WARNING' "$T/planning-artifacts/hook-warnings.log"
}
check H8 "warn-dor-dod: reads last_assistant_message from stdin; logs DoR+DoD warnings; exit 0" h_dor_warn

h_dor_quiet_and_suspicious() {
  : > "$T/planning-artifacts/pipeline-state.md"; : > "$T/planning-artifacts/hook-warnings.log"
  run_hook warn-dor-dod "$(stop reviewer 'Read planning-artifacts/pipeline-state.md; AC-1 covered.')"
  [ ! -s "$T/planning-artifacts/hook-warnings.log" ] || return 1
  run_hook warn-dor-dod "$(stop reviewer 'See planning-artifacts/does-not-exist.md AC-1')"
  grep -q 'SUSPICIOUS_CITATION' "$T/planning-artifacts/hook-warnings.log"
}
check H9 "warn-dor-dod: no warning on cited+AC output; SUSPICIOUS_CITATION for a missing path" h_dor_quiet_and_suspicious

h_extract_signal() {
  rm -f "$T/planning-artifacts/.hook-signals"
  local msg=$'We decided and chose X.\nRecurring pattern again.\nLesson learned: root cause found.\nCRITICAL error in parser.\nMAJOR vulnerability noted.'
  run_hook extract-knowledge "$(stop reviewer "$msg")"; [ "$RC" -eq 0 ] || return 1
  grep -q 'EXTRACT_KNOWLEDGE_SIGNAL: agent_type=reviewer' "$T/planning-artifacts/.hook-signals" || return 1
  rm -f "$T/planning-artifacts/.hook-signals"
  run_hook extract-knowledge "$(stop researcher "$msg")"
  [ ! -e "$T/planning-artifacts/.hook-signals" ]
}
check H10 "extract-knowledge: signal written to planning-artifacts/.hook-signals (a file, since SubagentStop stdout is debug-log only); researcher skipped" h_extract_signal

h_empty_stdin() {
  for h in enforce-paths enforce-sequencing warn-dor-dod extract-knowledge; do
    run_hook "$h" ""; [ "$RC" -eq 0 ] || return 1
  done
}
check H11 "all hooks exit 0 on empty stdin (never block on a malformed call)" h_empty_stdin

h_subagentstop_matchers() { jq -e '.hooks.SubagentStop | length > 0 and all(.[]; (.matcher // "") | test("implementer"))' .claude/settings.json >/dev/null; }
check H12 "SubagentStop groups use a per-agent matcher (supported by current Claude Code)" h_subagentstop_matchers

h_live_proof() {
  local f; f="$(ls evidence/hook-block-live-*.log 2>/dev/null | head -1)"
  [ -n "$f" ] && grep -q 'hook_event=PreToolUse' "$f" && grep -q 'BLOCK: Write to' "$f" && grep -q 'file_absent=yes' "$f"
}
check H13 "recorded live run: real 'claude -p' session was blocked by enforce-paths and the file was not created (evidence/hook-block-live-*.log)" h_live_proof

# ================= E: config =================
check E1 "enforcement-config.json is valid JSON" jq -e . .claude/enforcement-config.json
e_no_bmad() { ! grep -q '_bmad-output' .claude/enforcement-config.json; }
check E2 "enforcement-config.json no longer allowlists _bmad-output/" e_no_bmad

# ================= S: skills in SKILL.md format =================
s_layout() {
  local bad=0 d
  for d in .claude/skills/*/; do
    n="$(basename "$d")"; f="$d/SKILL.md"
    [ -f "$f" ] || { echo "no SKILL.md in $n"; bad=1; continue; }
    [ "$(sed -n 1p "$f")" = "---" ] || { echo "$n: no frontmatter"; bad=1; continue; }
    fm="$(awk 'NR>1&&/^---$/{exit} NR>1{print}' "$f")"
    echo "$fm" | grep -qE "^name: *\"?$n\"?\s*$" || { echo "$n: name != dir"; bad=1; }
    desc="$(echo "$fm" | sed -n 's/^description: *//p' | tr -d '"')"
    [ "${#desc}" -ge 40 ] && [ "${#desc}" -le 1536 ] || { echo "$n: description length ${#desc}"; bad=1; }
    echo "$desc" | grep -qiE 'use when' || { echo "$n: description lacks 'Use when'"; bad=1; }
  done
  ls .claude/skills/*.md >/dev/null 2>&1 && { echo "flat .md files remain in .claude/skills/"; bad=1; }
  [ "$(ls -d .claude/skills/*/ | wc -l)" -eq 10 ] || { echo "expected 10 skill dirs"; bad=1; }
  return $bad
}
check S1 "10 skills are .claude/skills/<name>/SKILL.md with matching name + a 'Use when' description (<=1536 chars)" s_layout

s_agents_resolve() {
  local bad=0 a s
  for a in .claude/agents/*.md; do
    case "$a" in *_agent-template.md) continue;; esac
    for s in $(sed -n '/^---$/,/^---$/p' "$a" | sed -n 's/^skills: *\[\(.*\)\].*/\1/p' | tr ',' ' ' | tr -d '"'); do
      [ -f ".claude/skills/$s/SKILL.md" ] || { echo "$a -> skill '$s' does not resolve"; bad=1; }
    done
  done
  return $bad
}
check S2 "every skill named in an agent's skills: list resolves to .claude/skills/<name>/SKILL.md" s_agents_resolve

s_agents_have_skills() { [ "$(grep -l '^skills: \["' .claude/agents/*.md | wc -l)" -ge 5 ]; }
check S3 "agents still declare skills (guards against S2 passing vacuously)" s_agents_have_skills

s_claims() {
  ! grep -qE 'catching 80%' .claude/skills/spec-protocol/SKILL.md || { echo "spec-protocol: unmeasured 80%/5% claim"; return 1; }
  grep -qiE 'not measured' .claude/skills/observation-masking/SKILL.md || { echo "observation-masking: 40-60% not labelled as unmeasured"; return 1; }
  grep -qiE 'not measured' .claude/skills/agent-compression-guide/SKILL.md || { echo "agent-compression-guide: target not labelled"; return 1; }
}
check S4 "unmeasured percentages in skills are removed or labelled 'not measured'" s_claims

# ================= V: coding-standards sources pinned / vendored =================
V=.claude/skills/coding-standards/vendored
v_yaml() { ! grep -nE '^\s*-?\s*url:' coding-standards-sources.yaml; }
check V1 "coding-standards-sources.yaml has no remote url: entries" v_yaml

v_manifest() {
  jq -e '.upstream and (.commit|test("^[0-9a-f]{40}$")) and .license=="CC0-1.0" and (.files|length>=3)' "$V/MANIFEST.json" >/dev/null || return 1
  local bad=0 f want got
  while IFS=$'\t' read -r f want; do
    got="$(shasum -a 256 "$V/$f" 2>/dev/null | cut -d' ' -f1)"
    [ "$got" = "$want" ] || { echo "$f sha256 mismatch"; bad=1; }
  done < <(jq -r '.files[]|[.path,.sha256]|@tsv' "$V/MANIFEST.json")
  return $bad
}
check V2 "vendored rules: MANIFEST pins a 40-hex upstream commit + CC0 licence; every file's sha256 matches" v_manifest

v_yaml_local() {
  local p bad=0
  for p in $(sed -n 's/^ *- local: *"\(.*\)"/\1/p' coding-standards-sources.yaml); do
    case "$p" in stories/*) continue;; esac   # matlab entry points at a project-supplied file
    [ -f "$p" ] || { echo "missing: $p"; bad=1; }
  done
  return $bad
}
check V3 "every local: path in coding-standards-sources.yaml exists (except the project-supplied stories/ one)" v_yaml_local

v_skill_text() { [ -f .claude/skills/coding-standards/SKILL.md ] && ! grep -q 'standards-cache' .claude/skills/coding-standards/SKILL.md; }
check V4 "coding-standards skill no longer depends on an externally populated standards-cache" v_skill_text

# ================= B: scenario comparison restored with real numbers =================
B=benchmarks/scenario-comparison
b_verbatim() {
  local pairs="SCENARIOA-vs-SCENARIOB-REPORT-2026-02-13.md comparison.md SCENARIOD-execution-estimate.md" f
  for f in $pairs; do
    git show "48f565e^:tests/$f" | cmp -s - "$B/$f" || { echo "$f differs from 48f565e^:tests/$f"; return 1; }
  done
}
check B1 "report, comparison.md and SCENARIOD estimate restored byte-identical to the pre-deletion commit (48f565e^)" b_verbatim

b_readme() {
  local f="$B/README.md"
  [ -f "$f" ] || return 1
  grep -q '613,670' "$f" && grep -qiE 'session-token-usage\.md.*(not|no longer).*(repo|preserved|available)|not (preserved|in this repo)' "$f" \
    && grep -qiE 'scenario ?B.*unknown|baseline.*unknown|no (measured )?baseline' "$f" \
    && grep -qiE 'estimate' "$f" && grep -qE '47,000|58,000' "$f"
}
check B2 "benchmarks README states the real numbers AND their limits (613,670 logged, source file not preserved, B unmeasured, C/D are estimates)" b_readme

# ================= R: README honesty =================
r_banned() {
  ! grep -nE 'fixes that|60.?80 ?%|why it works|_bmad-output|GitHub Actions|robertsfeir-atelier-pipeline' README.md
}
check R1 "README: no 'fixes that', no '60-80%', no 'why it works', no GitHub Actions, no _bmad-output, no dead docs/ link" r_banned

r_links() {
  local bad=0 l p
  while read -r l; do
    p="${l%%#*}"; [ -z "$p" ] && continue
    case "$p" in http*|mailto:*) continue;; esac
    [ -e "${p#/}" ] || { echo "dead link: $p"; bad=1; }
  done < <(grep -oE '\]\([^)]+\)' README.md | sed 's/^](//;s/)$//')
  return $bad
}
check R2 "README: every relative link resolves to a tracked path" r_links

r_dates_lineage() {
  grep -q '^## Status and lineage' README.md || return 1
  local sec; sec="$(awk '/^## Status and lineage/{f=1;next} /^## /{f=0} f' README.md)"
  echo "$sec" | grep -q '2026-02-06' && echo "$sec" | grep -q '2026-04-07' \
    && echo "$sec" | grep -q 'https://github.com/robertsfeir/atelier-pipeline' \
    && echo "$sec" | grep -qE 'extract-knowledge\.sh' && echo "$sec" | grep -qE 'observation-masking' && echo "$sec" | grep -qE 'agent-compression-guide' \
    && echo "$sec" | grep -qE 'awesome-cursorrules'
}
check R3 "README: 'Status and lineage' section with dates, Atelier link, and the files adapted from it" r_dates_lineage

r_hooks_claim() { ! grep -nE '6 hooks|secret leak, branch protection|82 assertions|test-runner\.sh' README.md; }
check R4 "README: removed claims the repo can't back (6 hooks, 82 assertions, tests/test-runner.sh)" r_hooks_claim

r_runner() { grep -q 'checks/run.sh' README.md && grep -q 'evidence/' README.md; }
check R5 "README points to checks/run.sh and evidence/" r_runner

r_stability() { grep -qiE 'not (a )?(current|maintained)|frozen|last (commit|updated)' README.md; }
check R6 "README states plainly that the repo is a dated build, not an actively maintained tool" r_stability

# ================= summary =================
printf '\n%d passed, %d failed\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ]
