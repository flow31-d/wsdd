#!/usr/bin/env bash
set -euo pipefail

# Testa aderência de agente pós-install (v0.5.0 lean-core):
# AGENTS.md lean com WSD Bootstrap + Intenção → Ação, skills em .agents/skills
# (sem espelho .codex), guias on-demand em +wsd/guides e brief via wsd-report.cjs.

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"

tmpdir="$(mktemp -d)"
start_out="$(mktemp)"
doctor_out="$(mktemp)"
trap 'rm -rf "$tmpdir" "$start_out" "$doctor_out"' EXIT

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
test ! -d "$tmpdir/.codex"

# AGENTS.md lean: bootstrap, intenção→ação, full-auto, guias, limite de linhas
grep -q "WSD Bootstrap" "$tmpdir/AGENTS.md"
grep -q "Intenção → Ação" "$tmpdir/AGENTS.md"
grep -q "full_auto" "$tmpdir/AGENTS.md"
grep -q "+wsd/guides/" "$tmpdir/AGENTS.md"
agents_lines="$(wc -l < "$tmpdir/AGENTS.md")"
if [[ "$agents_lines" -gt 150 ]]; then
  echo "FAIL: AGENTS.md gerado tem ${agents_lines} linhas (limite 150)" >&2
  exit 1
fi

# Guias on-demand vendorizados
for guide in git loop party sessao; do
  test -f "$tmpdir/+wsd/guides/${guide}.md"
done

# Contexto full_auto
node -e "const c=require(process.argv[1]); if(c.workflow.approval_mode!=='full_auto') process.exit(1)" "$tmpdir/+context.json"

# Brief via engine Node
"$tmpdir/+wsd/bin/wsd" start --brief >"$start_out"
grep -q "WSD Start Brief" "$start_out"
grep -q "context: present" "$start_out"
grep -q "state: present" "$start_out"
grep -q "concerns_active:" "$start_out"

# Doctor reconhece o bootstrap novo e o report engine
"$tmpdir/+wsd/bin/wsd" doctor >"$doctor_out"
grep -q "ok: AGENTS.md WSD Bootstrap" "$doctor_out"
grep -q "ok: +wsd/bin/wsd-report.cjs" "$doctor_out"
grep -q "ok: +wsd/guides" "$doctor_out"

# Comandos aposentados devem falhar
if "$tmpdir/+wsd/bin/wsd" codex-prompt --task "x" >/dev/null 2>&1; then
  echo "FAIL: codex-prompt ainda existe" >&2
  exit 1
fi
if "$tmpdir/+wsd/bin/wsd" codex-shortcuts status >/dev/null 2>&1; then
  echo "FAIL: codex-shortcuts ainda existe" >&2
  exit 1
fi

echo "PASS: agent adherence install test"
