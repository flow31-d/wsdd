#!/usr/bin/env bash
set -euo pipefail

# Gate de doc drift (warn-only): compara mudanças de código com docs-map.json.
# Uso: bash scripts/wsd_drift_check.sh [--range <git-range>]
# Default: mudanças não commitadas + staged; com --range, o range dado (ex.: HEAD~5..HEAD).

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"

range=""
if [[ "${1:-}" == "--range" ]]; then
  range="${2:-HEAD~1..HEAD}"
fi

[[ -f docs-map.json ]] || { echo "ok: docs-map.json ausente — drift check não aplicável"; exit 0; }
command -v node >/dev/null 2>&1 || { echo "warn: node ausente — drift check pulado"; exit 0; }
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "ok: fora de git — drift check não aplicável"; exit 0; }

if [[ -n "$range" ]]; then
  changed="$(git diff --name-only "$range" 2>/dev/null || true)"
else
  changed="$(git diff --name-only HEAD 2>/dev/null || true; git diff --name-only --cached 2>/dev/null || true)"
fi

[[ -n "$changed" ]] || { echo "ok: nenhuma mudança para checar drift"; exit 0; }

WSD_DRIFT_CHANGED="$changed" node - <<'NODE'
const fs = require('fs');
const map = JSON.parse(fs.readFileSync('docs-map.json', 'utf8')).map || {};
const changed = (process.env.WSD_DRIFT_CHANGED || '').split(/\r?\n/).filter(Boolean);
const changedSet = new Set(changed);
let warned = false;
for (const [codePath, docs] of Object.entries(map)) {
  const codeTouched = changed.some((f) =>
    codePath.endsWith('/') ? f.startsWith(codePath) : f === codePath);
  if (!codeTouched) continue;
  const docTouched = docs.some((d) => changedSet.has(d));
  if (!docTouched) {
    warned = true;
    console.log(`warn: ${codePath} mudou sem tocar doc mapeada (${docs.join(', ')}) — confirme se a documentação ainda descreve o comportamento`);
  }
}
if (!warned) console.log('ok: sem drift código→doc detectado');
NODE
