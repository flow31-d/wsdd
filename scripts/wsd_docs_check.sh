#!/usr/bin/env bash
set -euo pipefail

# Checker documental WSD (v0.5.0 lean-core).
# Valida COERÊNCIA, não duplicação: a versão vive em package.json + CHANGELOG
# (+ linha de versão em README/wsd.md/ROADMAP); histórico vive no git.

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

ok() {
  echo "ok: $*"
}

version="$(node -p "require('./package.json').version")"
tag="v${version}"

# 1. Arquivos centrais presentes
# NOTA (adaptação para o repo público wsdd): "archive/README.md" foi removido
# desta lista. archive/ é pesquisa interna do WSD privado e nunca é
# sincronizada para o público por política (docs/15, secao 5.2) — este
# checker roda também no wsdd, onde a pasta archive/ não existe por design.
required_files=(
  "README.md"
  "wsd.md"
  "ROADMAP.md"
  "CHANGELOG.md"
  "CHANGELOG_ARCHIVE.md"
  "AGENTS.md"
  "docs-map.json"
  "docs/10_matriz_sincronizacao_notas.md"
  "scripts/wsd_docs_check.sh"
  "scripts/wsd_drift_check.sh"
)
for file in "${required_files[@]}"; do
  [[ -f "$file" ]] || fail "missing sync file: $file"
done
ok "sync files present"

# 2. Versão atual em exatamente as fontes declaradas (CHANGELOG + linhas de versão)
grep -qE "$version|$tag" CHANGELOG.md || fail "current version $version missing in CHANGELOG.md"
for file in README.md wsd.md ROADMAP.md; do
  grep -qE "Versão atual.*\`?v?${version}\`?" "$file" || fail "version line for $version missing in $file"
done
ok "current version referenced in canonical sources"

# 3. Guarda de regressão: histórico duplicado não pode voltar às notas
if grep -rln '🕒 Registro de Alterações por Agentes' README.md wsd.md AGENTS.md ROADMAP.md CHANGELOG.md docs/ 2>/dev/null | head -1 | grep -q .; then
  fail "manual history table (🕒 Registro) reappeared in operational notes — history lives in git/CHANGELOG"
fi
if grep -qE '^## v?0\.[0-9]' README.md; then
  fail "README.md has per-version history sections — keep history only in CHANGELOG.md"
fi
ok "no duplicated history in operational notes"

# 4. Comandos aposentados não podem reaparecer no contrato operacional
# (docs/ pode mencioná-los historicamente com a nota de depreciação)
if grep -rln 'codex-shortcuts\|/prompts:loop\|wsd codex-prompt\|\.codex/skills' \
    README.md wsd.md AGENTS.md ROADMAP.md templates/ bin/ 2>/dev/null | head -1 | grep -q .; then
  grep -rln 'codex-shortcuts\|/prompts:loop\|wsd codex-prompt\|\.codex/skills' README.md wsd.md AGENTS.md ROADMAP.md templates/ bin/ 2>/dev/null >&2
  fail "retired command surface referenced in operational contract (codex-shortcuts, /prompts:loop, codex-prompt, .codex/skills)"
fi
ok "no retired command references in operational contract"

# 5. Referências estruturais mínimas
for file in README.md wsd.md AGENTS.md; do
  grep -qE "docs/10_matriz_sincronizacao_notas|Matriz de Sincronização|matriz" "$file" || fail "sync matrix not referenced in $file"
done
grep -q 'CHANGELOG_ARCHIVE' CHANGELOG.md || fail "CHANGELOG.md must link CHANGELOG_ARCHIVE.md"
grep -q 'full_auto' templates/repo/+context.json.template || fail "+context.json.template missing full_auto default"
grep -q 'full_auto' schemas/context.schema.json || fail "context schema missing full_auto enum"
grep -q 'WSD Bootstrap' templates/repo/AGENTS.md.template || fail "AGENTS.md.template missing WSD Bootstrap section"
grep -q 'Intenção → Ação' templates/repo/AGENTS.md.template || fail "AGENTS.md.template missing Intenção → Ação table"
grep -q '+wsd/guides/' templates/repo/AGENTS.md.template || fail "AGENTS.md.template missing on-demand guides references"
for guide in git loop party sessao lovable; do
  [[ -f "templates/local-wsd/guides/${guide}.md" ]] || fail "missing guide: templates/local-wsd/guides/${guide}.md"
done
ok "structural references present"

# 6. Orçamento de contexto: AGENTS.md.template deve permanecer lean (≤150 linhas)
agents_lines="$(wc -l < templates/repo/AGENTS.md.template)"
[[ "$agents_lines" -le 150 ]] || fail "AGENTS.md.template has ${agents_lines} lines (limit 150) — move detail to +wsd/guides/"
ok "AGENTS.md.template within lean budget (${agents_lines} lines)"

# 7. Janela ativa do CHANGELOG (≤ ~8 versões; resto no archive)
changelog_versions="$(grep -c '^## 0\.' CHANGELOG.md || true)"
[[ "$changelog_versions" -le 8 ]] || fail "CHANGELOG.md has ${changelog_versions} version sections — move older ones to CHANGELOG_ARCHIVE.md"
ok "CHANGELOG active window ok (${changelog_versions} versions)"

# 8. Drift código→doc (warn-only)
bash scripts/wsd_drift_check.sh || true

echo "PASS: WSD docs sync check completed"
