#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"

tmpdir="$(mktemp -d)"
codex_home="$(mktemp -d)"
prompt_out=""
dry_out=""
start_out=""
doctor_out=""
shortcuts_out=""
trap 'rm -rf "$tmpdir" "$codex_home" "${prompt_out:-}" "${dry_out:-}" "${start_out:-}" "${doctor_out:-}" "${shortcuts_out:-}"' EXIT

node bin/wsd-method.js install \
  --directory "$tmpdir" \
  --init-git \
  --yes \
  --github skip \
  --tools codex \
  --profile generic_node_frontend >/dev/null

test -x "$tmpdir/+wsd/bin/wsd"
test -f "$tmpdir/.agents/skills/wsd/SKILL.md"
test -f "$tmpdir/.agents/skills/wsd-loop/SKILL.md"
test -f "$tmpdir/.agents/skills/wsd-idea/SKILL.md"
grep -q "name: wsd-idea" "$tmpdir/.agents/skills/wsd-idea/SKILL.md"
test -f "$tmpdir/.agents/skills/wsd-concern/SKILL.md"
grep -q "name: wsd-concern" "$tmpdir/.agents/skills/wsd-concern/SKILL.md"
test -f "$tmpdir/.codex/skills/wsd-loop/SKILL.md"
test -f "$tmpdir/.codex/skills/wsd-idea/SKILL.md"
test -f "$tmpdir/.codex/skills/wsd-concern/SKILL.md"
test -f "$tmpdir/+wsd/templates/codex-prompts/loop.md"
grep -q "WSD Codex Bootstrap" "$tmpdir/AGENTS.md"
grep -q "codex-prompt" "$tmpdir/AGENTS.md"

start_out="$(mktemp)"
prompt_out="$(mktemp)"
dry_out="$(mktemp)"
doctor_out="$(mktemp)"
shortcuts_out="$(mktemp)"

"$tmpdir/+wsd/bin/wsd" start --brief >"$start_out"
grep -q "WSD Start Brief" "$start_out"
grep -q "context: present" "$start_out"
grep -q "state: present" "$start_out"

"$tmpdir/+wsd/bin/wsd" codex-prompt --task "implemente uma feature pequena" >"$prompt_out"
grep -q "Use WSDD neste repositorio" "$prompt_out"
grep -q "+context.json" "$prompt_out"
grep -q "Classifique a tarefa como L0, L1 ou L2" "$prompt_out"
grep -q "automation.loop.auto_use=false" "$prompt_out"

"$tmpdir/+wsd/bin/wsd" loop auto on >/dev/null
"$tmpdir/+wsd/bin/wsd" codex-prompt --task "implemente uma feature pequena" >"$prompt_out"
grep -q "automation.loop.auto_use=true" "$prompt_out"
grep -q "use WSD Loop automaticamente" "$prompt_out"

"$tmpdir/+wsd/bin/wsd" codex --dry-run --feature sample-feature --task "corrija um bug" >"$dry_out"
grep -q "Feature alvo: sample-feature" "$dry_out"
grep -q "corrija um bug" "$dry_out"

"$tmpdir/+wsd/bin/wsd" doctor >"$doctor_out"
grep -q "ok: AGENTS.md WSD Codex Bootstrap" "$doctor_out"

CODEX_HOME="$codex_home" "$tmpdir/+wsd/bin/wsd" codex-shortcuts status >"$shortcuts_out"
grep -q "missing: $codex_home/prompts/loop.md" "$shortcuts_out"
CODEX_HOME="$codex_home" "$tmpdir/+wsd/bin/wsd" codex-shortcuts install >"$shortcuts_out"
grep -q "PASS: Codex prompt instalado" "$shortcuts_out"
test -f "$codex_home/prompts/loop.md"
grep -q "WSD Codex Loop Shortcut" "$codex_home/prompts/loop.md"
"$tmpdir/+wsd/bin/wsd" codex-shortcuts print | grep -q "WSD Codex Loop Shortcut"
"$tmpdir/+wsd/bin/wsd" shortcuts shell | grep -q "wl()"

if "$tmpdir/+wsd/bin/wsd" codex-prompt --mode invalid >/dev/null 2>&1; then
  echo "FAIL: codex-prompt accepted invalid mode" >&2
  exit 1
fi
