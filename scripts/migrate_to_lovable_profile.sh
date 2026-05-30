#!/usr/bin/env bash
# Migra um repo WSD existente para o profile lovable_tanstack_start.
#
# - Faz wsd-method update (preserva +context.json, AGENTS.md, +specs/)
# - Injeta bloco lovable_integration em +context.json
# - Adiciona ./package-lock.json em permissions.forbidden_paths
# - Adiciona bun em permissions.tool_allowlist
# - Anexa package-lock.json ao .gitignore
# - Insere seção "Lovable Workflow" em AGENTS.md (entre "Paths Sensíveis" e "Validação")
# - Roda wsd lovable doctor para validar
#
# Idempotente: ré-executa sem efeito se já migrado.
#
# Uso:
#   bash migrate_to_lovable_profile.sh <caminho-do-repo>

set -euo pipefail

WSD_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

repo="${1:-}"
if [[ -z "$repo" ]]; then
  echo "Uso: $0 <caminho-do-repo>" >&2
  exit 1
fi
if [[ ! -d "$repo" ]]; then
  echo "FAIL: $repo não existe" >&2
  exit 1
fi
repo="$(cd "$repo" && pwd)"

echo "== Lovable profile migration: $repo =="

# Pré-condição: já tem WSD instalado
if [[ ! -f "$repo/+wsd/config.json" ]]; then
  echo "FAIL: $repo não tem +wsd/config.json. Use 'wsd-method install --profile lovable_tanstack_start' para install do zero." >&2
  exit 1
fi
if [[ ! -f "$repo/+context.json" ]]; then
  echo "FAIL: $repo/+context.json ausente" >&2
  exit 1
fi
if [[ ! -f "$repo/AGENTS.md" ]]; then
  echo "FAIL: $repo/AGENTS.md ausente" >&2
  exit 1
fi
command -v jq >/dev/null || { echo "FAIL: jq necessário" >&2; exit 1; }
command -v python3 >/dev/null || { echo "FAIL: python3 necessário" >&2; exit 1; }

# Passo 1: refresh +wsd/ (templates, schemas, profiles, scripts, CLI)
echo ""
echo "[1/5] wsd-method update"
node "$WSD_ROOT/bin/wsd-method.js" update --directory "$repo" >/dev/null
echo "  ok: +wsd/ atualizado"

# Passo 2: injetar lovable_integration em +context.json
echo ""
echo "[2/5] Injetar lovable_integration em +context.json"
python3 - "$repo/+context.json" <<'PY'
import json
import sys

path = sys.argv[1]
with open(path, encoding="utf-8") as fh:
    ctx = json.load(fh)

changed = False

if not ctx.get("lovable_integration", {}).get("enabled"):
    ctx["lovable_integration"] = {
        "enabled": True,
        "bot": "gpt-engineer-app[bot]",
        "package_manager": "bun",
        "forbidden_files": ["package-lock.json"],
        "fragile_paths": [
            "src/routes/index.tsx",
            "src/**/keyframes*.css",
            "src/**/*parallax*",
            "src/**/*tilt*",
        ],
        "auto_delete_branch_on_merge": False,
        "collaboration_model": "owner_plus_fork_pr",
    }
    changed = True

perms = ctx.setdefault("permissions", {})
fp = perms.setdefault("forbidden_paths", [])
if "./package-lock.json" not in fp:
    fp.append("./package-lock.json")
    changed = True

ta = perms.setdefault("tool_allowlist", [])
if "bun" not in ta:
    ta.append("bun")
    changed = True

if changed:
    with open(path, "w", encoding="utf-8") as fh:
        json.dump(ctx, fh, indent=2, ensure_ascii=False)
        fh.write("\n")
    print("  ok: +context.json atualizado")
else:
    print("  ok: +context.json já tem lovable_integration (no-op)")
PY

# Passo 3: validar contra schema
echo ""
echo "[3/5] Validar +context.json contra schema"
if [[ -x "$repo/+wsd/bin/wsd-validate-context.cjs" ]]; then
  node "$repo/+wsd/bin/wsd-validate-context.cjs" "$repo/+context.json" >/dev/null
  echo "  ok: +context.json valida contra schema"
else
  echo "  warn: validador ausente"
fi

# Passo 4: inserir seção Lovable Workflow em AGENTS.md
echo ""
echo "[4/5] Inserir seção Lovable Workflow em AGENTS.md"
if grep -q "^## Lovable Workflow" "$repo/AGENTS.md"; then
  echo "  ok: seção 'Lovable Workflow' já presente (no-op)"
else
  # Tira do template renderizado da fonte e injeta entre "Paths Sensíveis" e "Validação".
  # Faz isso passando settings.LOVABLE=true para o renderer do wsd-method.
  python3 - "$WSD_ROOT/templates/repo/AGENTS.md.template" "$repo/AGENTS.md" <<'PY'
import re
import sys

tmpl_path = sys.argv[1]
agents_path = sys.argv[2]

with open(tmpl_path, encoding="utf-8") as fh:
    tmpl = fh.read()

# Extrai o bloco {{#if LOVABLE}}...{{/if}} renderizado (sem o flag).
m = re.search(r"\{\{#if LOVABLE\}\}([\s\S]*?)\{\{/if\}\}", tmpl)
if not m:
    print("  FAIL: bloco Lovable não encontrado no template")
    sys.exit(1)
lovable_section = m.group(1).rstrip() + "\n"

with open(agents_path, encoding="utf-8") as fh:
    agents = fh.read()

# Insere entre "## Paths Sensíveis ... {{SENSITIVE_PATHS_MARKDOWN_LIST renderizado}}" e "## Validação".
# Ancora-se em "\n## Validação" como ponto de inserção (linha em branco antes).
pattern = re.compile(r"\n## Validação\b", re.M)
if not pattern.search(agents):
    print("  FAIL: não achei '## Validação' em AGENTS.md para ancorar a inserção")
    sys.exit(2)
new_agents = pattern.sub("\n" + lovable_section + "\n## Validação", agents, count=1)

with open(agents_path, "w", encoding="utf-8") as fh:
    fh.write(new_agents)
print("  ok: seção 'Lovable Workflow' inserida")
PY
fi

# Passo 5: .gitignore + doctor
echo ""
echo "[5/5] Anexar package-lock.json ao .gitignore + rodar lovable doctor"
gi="$repo/.gitignore"
if [[ -f "$gi" ]] && grep -qx "package-lock.json" "$gi"; then
  echo "  ok: .gitignore já lista package-lock.json"
else
  printf '\n# Lovable: package-lock.json proibido (scaffold é Bun-puro)\npackage-lock.json\n' >> "$gi"
  echo "  ok: package-lock.json anexado ao .gitignore"
fi

echo ""
echo "Rodando wsd lovable doctor..."
"$repo/+wsd/bin/wsd" lovable doctor

echo ""
echo "PASS: migração concluída em $repo"
echo "Próximo passo opcional: ./+wsd/bin/wsd lovable bootstrap (desliga auto-delete branch no GitHub)"
