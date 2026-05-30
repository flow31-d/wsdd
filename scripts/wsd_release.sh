#!/usr/bin/env bash
# scripts/wsd_release.sh — automação de release WSD privado + wsdd público.
#
# Uso: scripts/wsd_release.sh <patch|minor|major> [flags]
#
# Flags:
#   --dry-run             # não modifica nada — só mostra o que seria feito
#   --skip-wsdd           # pula sync e publish no wsdd público
#   --wsdd-clone <path>   # path para clone fresh do wsdd (default /tmp/wsdd-release)
#   --auto-merge          # auto-merge da PR após push (sem espera de review)
#   --yes                 # pula confirmações interativas (use com --auto-merge para CI)
#   --skip-tag            # não cria tag git (útil em hotfixes intermediários)
#   --skip-gh-release     # não cria GitHub Release no wsdd
#
# Pré-requisitos antes de rodar:
#   - branch atual: main; working tree limpa (sem trackeados modificados); main sync com origin
#   - CHANGELOG.md, README.md, ROADMAP.md e +specs/project/STATE.md já atualizados
#     manualmente para incluir a nova versão (script verifica presença, não escreve conteúdo)
#   - env vars opcionais WSD_GIT_NAME e WSD_GIT_EMAIL (defaults: Rodrigo Wolff)
#   - autenticação gh CLI funcional (HOME=/home/lpo nesta VPS)
#
# O que o script faz:
#   1. Pré-flight (branch/worktree/sync)
#   2. Calcula próxima versão a partir de package.json
#   3. Verifica que CHANGELOG/README/ROADMAP já mencionam a nova versão
#   4. Bumpa package.json
#   5. Roda gates (npm test, docs-check, self-check)
#   6. Cria branch release/vX.Y.Z, commita, push e abre PR
#   7. Auto-merge ou espera merge manual (com --auto-merge)
#   8. Após merge: fetch + tag vX.Y.Z + push tag
#   9. Sync wsdd: clone fresh, aplica whitelist, roda gates, commita, push, tag, GitHub Release
#      O sync público sanitiza presets internos antes de commitar no wsdd.

set -euo pipefail

WSD_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$WSD_ROOT"

# ----- Defaults -----
BUMP_TYPE=""
DRY_RUN=false
SKIP_WSDD=false
WSDD_CLONE="/tmp/wsdd-release"
AUTO_MERGE=false
ASSUME_YES=false
SKIP_TAG=false
SKIP_GH_RELEASE=false
GIT_NAME="${WSD_GIT_NAME:-Rodrigo Wolff}"
GIT_EMAIL="${WSD_GIT_EMAIL:-rodrigowolff31@gmail.com}"

# Whitelist de paths sincronizados WSD → wsdd
# (.github/, examples/, +wsd/, +specs/, +context.json, .agents/, REVIEW_PRE_V1.md,
#  xmodelos/, +imbox/, +logs/, PRIVATE_USE_NOTICE.md, profiles privados ficam de fora)
SYNC_DIRS=(
  "bin"
  "templates"
  "scripts"
  "schemas"
  "docs"
  "party-mode"
)
SYNC_FILES=(
  "README.md"
  "wsd.md"
  "AGENTS.md"
  "CHANGELOG.md"
  "ROADMAP.md"
  "CONTRIBUTING.md"
  "RELEASING.md"
  "package.json"
  "install.sh"
)
# profiles/: sync seletivo (excluir privados)
PROFILES_PRIVATE=(
  "koomplet_office.profile.yaml"
  "prescreve_mais.profile.yaml"
)
PUBLIC_PRIVATE_REF_PATTERN='koomplet|prescreve|flow31-d/koomplet|GitKoomplet/prescreve'

# ----- Parse args -----
while [[ $# -gt 0 ]]; do
  case "$1" in
    patch|minor|major) BUMP_TYPE="$1"; shift ;;
    --dry-run) DRY_RUN=true; shift ;;
    --skip-wsdd) SKIP_WSDD=true; shift ;;
    --wsdd-clone) WSDD_CLONE="$2"; shift 2 ;;
    --auto-merge) AUTO_MERGE=true; shift ;;
    --yes) ASSUME_YES=true; shift ;;
    --skip-tag) SKIP_TAG=true; shift ;;
    --skip-gh-release) SKIP_GH_RELEASE=true; shift ;;
    -h|--help) sed -n '2,30p' "$0" | sed 's/^# \?//'; exit 0 ;;
    *) echo "ERROR: unknown arg: $1" >&2; exit 1 ;;
  esac
done

[[ -n "$BUMP_TYPE" ]] || { echo "ERROR: missing bump type (patch|minor|major). Use --help." >&2; exit 1; }

# ----- Helpers -----
step()  { echo ""; echo "═══ $* ═══"; }
info()  { echo "  ✓ $*"; }
warn()  { echo "  ⚠ $*" >&2; }
err()   { echo "  ✗ $*" >&2; exit 1; }
debug() { [[ "${WSD_RELEASE_DEBUG:-0}" == "1" ]] && echo "    [debug] $*" >&2; return 0; }

confirm() {
  local prompt="${1:-Confirmar?}"
  if [[ "$ASSUME_YES" == "true" ]]; then echo "    [--yes] $prompt: SIM"; return 0; fi
  read -r -p "    $prompt [y/N]: " resp
  [[ "$resp" =~ ^[YySs](es|im)?$ ]] || { echo "    Cancelado."; exit 1; }
}

run() {
  # Executa comando; em dry-run, só mostra.
  if [[ "$DRY_RUN" == "true" ]]; then
    echo "    [dry-run] $*"
  else
    eval "$@"
  fi
}

sanitize_wsdd_public_clone() {
  local clone="$1"
  local method_file="$clone/bin/wsd-method.js"
  [[ -f "$method_file" ]] || err "bin/wsd-method.js não encontrado no clone público"

  node - "$method_file" <<'NODE'
const fs = require('fs');
const file = process.argv[2];
const privateProfiles = new Set(['koomplet_office', 'prescreve_mais']);
const lines = fs.readFileSync(file, 'utf8').split(/\n/);
const out = [];
let skipping = false;
let depth = 0;

function delta(line) {
  const opens = (line.match(/\{/g) || []).length;
  const closes = (line.match(/\}/g) || []).length;
  return opens - closes;
}

for (const line of lines) {
  if (!skipping) {
    const entry = line.match(/^  ([A-Za-z0-9_]+): \{$/);
    if (entry && privateProfiles.has(entry[1])) {
      skipping = true;
      depth = delta(line);
      continue;
    }
    out.push(line);
    continue;
  }

  depth += delta(line);
  if (depth <= 0) {
    skipping = false;
  }
}

let result = out.join('\n');
result = result.replace(/\n  \},\n\};\n\nmain\(\)\.catch/, '\n  }\n};\n\nmain().catch');
fs.writeFileSync(file, result);
NODE
}

validate_wsdd_public_payload() {
  local clone="$1"
  if (cd "$clone" && rg -n "$PUBLIC_PRIVATE_REF_PATTERN" bin profiles templates); then
    err "Payload público contém referência privada em bin/profiles/templates"
  fi
  info "Gate público PASS: sem referências privadas em bin/profiles/templates"
}

# ----- STEP 1: Pré-flight -----
step "1. Pré-flight checks"

current_branch=$(git rev-parse --abbrev-ref HEAD)
[[ "$current_branch" == "main" ]] || err "Branch atual é '$current_branch', precisa ser 'main'"
info "Branch: main"

dirty=$(git status --porcelain --untracked-files=no)
if [[ -n "$dirty" ]]; then
  git status --short
  err "Working tree tem arquivos trackeados modificados — commit ou stash antes"
fi
info "Working tree limpa (untracked OK)"

info "Fetching origin..."
HOME=/home/lpo git fetch origin main >/dev/null 2>&1 || warn "git fetch falhou (sem rede?)"
local_head=$(git rev-parse HEAD)
remote_head=$(git rev-parse origin/main 2>/dev/null || echo "")
if [[ -z "$remote_head" ]]; then
  warn "origin/main não conhecido — pulando check de sync"
elif [[ "$local_head" != "$remote_head" ]]; then
  err "main local ($local_head) não está sync com origin/main ($remote_head). Faça pull --ff-only antes."
fi
info "main sync com origin"

# ----- STEP 2: Calcula próxima versão -----
step "2. Calculando próxima versão"

current_version=$(node -e "console.log(require('./package.json').version)" 2>/dev/null) || err "Não foi possível ler package.json"
info "Versão atual: $current_version"

IFS='.' read -r maj min pat <<< "$current_version"
case "$BUMP_TYPE" in
  patch) pat=$((pat + 1)) ;;
  minor) min=$((min + 1)); pat=0 ;;
  major) maj=$((maj + 1)); min=0; pat=0 ;;
esac
next_version="${maj}.${min}.${pat}"
release_tag="v${next_version}"
release_branch="release/${release_tag}"
info "Próxima versão: $next_version"
info "Tag: $release_tag"
info "Branch de release: $release_branch"

# ----- STEP 3: Verifica preparação -----
step "3. Verificando preparação manual"

if grep -qE "^## .*${next_version}" CHANGELOG.md; then
  info "CHANGELOG.md menciona seção para $next_version"
else
  err "CHANGELOG.md NÃO tem seção '## ... $next_version'. Atualize antes de rodar."
fi

if grep -qE "v?${next_version}" README.md; then
  info "README.md menciona $next_version"
else
  warn "README.md não menciona $next_version"
  confirm "Continuar mesmo assim?"
fi

if grep -qE "v?${next_version}" ROADMAP.md; then
  info "ROADMAP.md menciona $next_version"
else
  warn "ROADMAP.md não menciona $next_version"
  confirm "Continuar mesmo assim?"
fi

# ----- STEP 4: Bump package.json -----
step "4. Bump package.json"

if grep -q "\"version\": \"$current_version\"" package.json; then
  info "Vai mudar: $current_version → $next_version"
  if [[ "$DRY_RUN" == "false" ]]; then
    sed -i "s/\"version\": \"$current_version\"/\"version\": \"$next_version\"/" package.json
  fi
  info "package.json bumped"
else
  warn "package.json já não está em $current_version — assumindo já bumped"
fi

# ----- STEP 5: Run local gates -----
step "5. Rodando gates locais"

if [[ "$DRY_RUN" == "true" ]]; then
  echo "    [dry-run] npm test"
  echo "    [dry-run] bash scripts/wsd_docs_check.sh"
  echo "    [dry-run] bash scripts/wsd_self_check.sh"
else
  info "npm test (pode levar 1-2 min)..."
  npm test >/tmp/wsd_release_npm_test.log 2>&1 || { tail -30 /tmp/wsd_release_npm_test.log; err "npm test falhou"; }
  info "npm test PASS"

  info "wsd_docs_check.sh..."
  bash scripts/wsd_docs_check.sh >/tmp/wsd_release_docs_check.log 2>&1 || { tail -20 /tmp/wsd_release_docs_check.log; err "docs_check falhou"; }
  info "docs_check PASS"

  info "wsd_self_check.sh..."
  bash scripts/wsd_self_check.sh >/tmp/wsd_release_self_check.log 2>&1 || { tail -20 /tmp/wsd_release_self_check.log; err "self_check falhou"; }
  info "self_check PASS"
fi

# ----- STEP 6: Branch + commit + push + PR -----
step "6. Commit + branch + PR no WSD privado"

# Detectar mudanças staged/unstaged que precisam entrar no commit
modified=$(git status --porcelain --untracked-files=no | awk '{print $2}')
if [[ -z "$modified" ]]; then
  warn "Nenhum arquivo modificado para commit (talvez package.json já estava bumped e tudo já está em main?)"
  confirm "Continuar (criar branch e merge mesmo sem mudanças locais)?"
fi

run "git checkout -b \"$release_branch\""
info "Branch: $release_branch"

if [[ -n "$modified" ]]; then
  for f in $modified; do
    run "git add \"$f\""
  done

  echo ""
  echo "    Diff staged:"
  if [[ "$DRY_RUN" == "false" ]]; then
    git diff --cached --stat | sed 's/^/    /'
  fi
  echo ""

  confirm "Commit dessas mudanças?"

  commit_msg_file=$(mktemp)
  cat > "$commit_msg_file" <<EOF
chore(release): ${release_tag}

$(awk "/^## .*${next_version}/,/^## [0-9]/" CHANGELOG.md | sed '$d' | head -50)

Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>
EOF
  if [[ "$DRY_RUN" == "true" ]]; then
    echo "    [dry-run] git commit (mensagem em $commit_msg_file)"
    cat "$commit_msg_file" | head -10 | sed 's/^/      /'
  else
    git -c "user.name=$GIT_NAME" -c "user.email=$GIT_EMAIL" commit -F "$commit_msg_file"
    rm -f "$commit_msg_file"
  fi
  info "Commit criado"
fi

confirm "Push branch $release_branch e abrir PR?"
run "HOME=/home/lpo git push -u origin \"$release_branch\""
info "Branch pushed"

repo_slug=$(git config --get remote.origin.url | sed -E 's|.*github\.com[:/]([^/]+/[^/.]+)(\.git)?$|\1|')

if [[ "$DRY_RUN" == "true" ]]; then
  echo "    [dry-run] gh pr create --repo $repo_slug --base main --title 'chore(release): $release_tag' ..."
  pr_number="<dry-run>"
else
  pr_url=$(HOME=/home/lpo gh pr create --repo "$repo_slug" --base main \
    --title "chore(release): $release_tag" \
    --body "Automated release $release_tag via scripts/wsd_release.sh. See CHANGELOG.md section $next_version for details.")
  pr_number=$(echo "$pr_url" | grep -oE '[0-9]+$')
  info "PR aberta: $pr_url"
fi

# ----- STEP 7: Merge PR -----
step "7. Merge PR"

if [[ "$AUTO_MERGE" == "true" ]]; then
  confirm "Auto-merge agora?"
  run "HOME=/home/lpo gh pr merge \"$pr_number\" --repo \"$repo_slug\" --merge"
  info "PR mergeada"
else
  warn "Auto-merge desabilitado. PR aberta em #$pr_number."
  warn "Faça merge manualmente (gh pr merge $pr_number --repo $repo_slug --merge) e depois re-rode o script com:"
  warn "  scripts/wsd_release.sh $BUMP_TYPE --skip-prep --resume-from-tag"
  warn "OU passe --auto-merge agora se preferir."
  confirm "Já mergeou? Continuar para tag/push?"
fi

# ----- STEP 8: Tag + push tag -----
step "8. Tag e push da tag"

if [[ "$SKIP_TAG" == "true" ]]; then
  info "Tag pulado (--skip-tag)"
else
  run "git checkout main"
  run "HOME=/home/lpo git pull --ff-only"

  if git tag -l "$release_tag" | grep -q "$release_tag"; then
    warn "Tag $release_tag já existe localmente"
  else
    if [[ "$DRY_RUN" == "true" ]]; then
      echo "    [dry-run] git tag -a $release_tag -m 'Release $release_tag'"
    else
      git -c "user.name=$GIT_NAME" -c "user.email=$GIT_EMAIL" tag -a "$release_tag" -m "Release $release_tag

$(awk "/^## .*${next_version}/,/^## [0-9]/" CHANGELOG.md | sed '$d' | head -40)
"
    fi
    info "Tag $release_tag criada"
  fi

  run "HOME=/home/lpo git push origin \"$release_tag\""
  info "Tag $release_tag publicada em origin"
fi

# ----- STEP 9: Sync wsdd -----
if [[ "$SKIP_WSDD" == "true" ]]; then
  step "9. Sync wsdd PULADO (--skip-wsdd)"
  echo ""
  info "Release $release_tag concluído no WSD privado. Para publicar no wsdd, re-rode sem --skip-wsdd ou faça sync manual."
  exit 0
fi

step "9. Sync para wsdd público"

if [[ -d "$WSDD_CLONE" ]]; then
  warn "$WSDD_CLONE já existe — vai ser removido para clone fresh"
  confirm "OK remover $WSDD_CLONE?"
  run "rm -rf \"$WSDD_CLONE\""
fi

info "Clonando wsdd em $WSDD_CLONE..."
run "HOME=/home/lpo gh repo clone flow31-d/wsdd \"$WSDD_CLONE\""

if [[ "$DRY_RUN" == "true" ]]; then
  echo "    [dry-run] Aplicaria whitelist sync (${#SYNC_DIRS[@]} diretórios + ${#SYNC_FILES[@]} arquivos)"
else
  # Sync diretórios via rsync (preserva diffs intencionais como .github/)
  for d in "${SYNC_DIRS[@]}"; do
    if [[ -d "$WSD_ROOT/$d" ]]; then
      info "Sync dir: $d/"
      rsync -a --delete \
        --exclude='.git/' \
        "$WSD_ROOT/$d/" "$WSDD_CLONE/$d/"
    fi
  done

  # Sync arquivos
  for f in "${SYNC_FILES[@]}"; do
    if [[ -f "$WSD_ROOT/$f" ]]; then
      info "Sync file: $f"
      cp "$WSD_ROOT/$f" "$WSDD_CLONE/$f"
    fi
  done

  # profiles/: sync seletivo (excluir privados)
  info "Sync dir: profiles/ (excluindo privados)"
  rm -rf "$WSDD_CLONE/profiles"
  mkdir -p "$WSDD_CLONE/profiles"
  for f in "$WSD_ROOT/profiles"/*.yaml; do
    base=$(basename "$f")
    is_private=false
    for priv in "${PROFILES_PRIVATE[@]}"; do
      [[ "$base" == "$priv" ]] && { is_private=true; break; }
    done
    if [[ "$is_private" == "false" ]]; then
      cp "$f" "$WSDD_CLONE/profiles/$base"
    fi
  done

  info "Sanitizando bin/wsd-method.js para payload público"
  sanitize_wsdd_public_clone "$WSDD_CLONE"
fi

# Validar wsdd após sync
step "9.1 Validando wsdd após sync"

if [[ "$DRY_RUN" == "true" ]]; then
  echo "    [dry-run] cd $WSDD_CLONE && npm test"
else
  ( cd "$WSDD_CLONE" && npm test >/tmp/wsdd_release_npm_test.log 2>&1 ) || { tail -30 /tmp/wsdd_release_npm_test.log; err "npm test falhou no wsdd"; }
  info "npm test no wsdd PASS"
  validate_wsdd_public_payload "$WSDD_CLONE"
fi

# Mostra diff e pede confirmação
step "9.2 Diff WSD → wsdd"

if [[ "$DRY_RUN" == "false" ]]; then
  ( cd "$WSDD_CLONE" && git status --short )
  echo ""
fi

confirm "Commit + push as mudanças no wsdd?"

# Commit no wsdd
if [[ "$DRY_RUN" == "false" ]]; then
  cd "$WSDD_CLONE"
  git add -- "${SYNC_DIRS[@]}" profiles "${SYNC_FILES[@]}"
  git -c "user.name=$GIT_NAME" -c "user.email=$GIT_EMAIL" commit -m "chore(release): $release_tag — sync from WSD privado

Sincronização da release $release_tag a partir do flow31-d/WSD privado.

$(awk "/^## .*${next_version}/,/^## [0-9]/" CHANGELOG.md | sed '$d' | head -40)

Refs: flow31-d/WSD release $release_tag

Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>"
  cd "$WSD_ROOT"
fi
info "Commit wsdd criado"

confirm "Push direto em wsdd main?"
run "( cd \"$WSDD_CLONE\" && HOME=/home/lpo git push origin main )"
info "wsdd main atualizado"

if [[ "$SKIP_TAG" == "true" ]]; then
  info "Tag pulado no wsdd (--skip-tag)"
else
  if [[ "$DRY_RUN" == "true" ]]; then
    echo "    [dry-run] tag $release_tag no wsdd"
  else
    cd "$WSDD_CLONE"
    git -c "user.name=$GIT_NAME" -c "user.email=$GIT_EMAIL" tag -a "$release_tag" -m "Release $release_tag — sync from WSD privado"
    HOME=/home/lpo git push origin "$release_tag"
    cd "$WSD_ROOT"
  fi
  info "Tag $release_tag publicada no wsdd"
fi

# GitHub Release no wsdd
if [[ "$SKIP_GH_RELEASE" == "true" ]]; then
  info "GitHub Release pulado (--skip-gh-release)"
else
  if [[ "$DRY_RUN" == "true" ]]; then
    echo "    [dry-run] gh release create $release_tag --repo flow31-d/wsdd"
  else
    notes_file=$(mktemp)
    awk "/^## .*${next_version}/,/^## [0-9]/" CHANGELOG.md | sed '$d' | head -60 > "$notes_file"
    HOME=/home/lpo gh release create "$release_tag" --repo flow31-d/wsdd \
      --title "$release_tag" \
      --notes-file "$notes_file" || warn "gh release create falhou — pode já existir"
    rm -f "$notes_file"
  fi
  info "GitHub Release $release_tag publicado no wsdd"
fi

step "Release $release_tag CONCLUÍDO"
echo ""
echo "  WSD privado: tag $release_tag publicada em main"
echo "  wsdd público: tag $release_tag publicada em main + GitHub Release"
echo ""
echo "  Próximos passos:"
echo "    - Atualizar projetos cliente: ./+wsd/bin/wsd update"
echo "    - Verificar release: https://github.com/flow31-d/wsdd/releases/tag/$release_tag"
echo ""
