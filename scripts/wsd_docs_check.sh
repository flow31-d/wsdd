#!/usr/bin/env bash
set -euo pipefail

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

required_files=(
  "README.md"
  "wsd.md"
  "ROADMAP.md"
  "CHANGELOG.md"
  "AGENTS.md"
  "docs/10_matriz_sincronizacao_notas.md"
  "docs/11_modulo_git_governance.md"
  "scripts/wsd_docs_check.sh"
)

for file in "${required_files[@]}"; do
  [[ -f "$file" ]] || fail "missing sync file: $file"
done
ok "sync files present"

for file in README.md wsd.md ROADMAP.md CHANGELOG.md docs/09_publicacao_github_privado.md; do
  grep -qE "$version|$tag" "$file" || fail "current version $version is not referenced in $file"
done
ok "current version referenced in central notes"

for file in README.md wsd.md ROADMAP.md AGENTS.md; do
  grep -qE "docs/10_matriz_sincronizacao_notas|Matriz de Sincronização" "$file" || fail "sync matrix not referenced in $file"
done
ok "sync matrix referenced by central notes"

for file in wsd.md ROADMAP.md docs/00_planejamento_instalacao_wsd.md docs/07_git_governance.md docs/10_matriz_sincronizacao_notas.md; do
  grep -qE "docs/11_modulo_git_governance|git-governance" "$file" || fail "git-governance module plan not referenced in $file"
done
ok "git-governance module plan referenced"

for file in README.md wsd.md docs/04_playbook_implantacao.md docs/08_rotinas_sessao.md; do
  grep -qE "wsd-method|install\\.sh|\\.wsd/bin/wsd" "$file" || fail "current installer/local CLI not documented in $file"
done
ok "installer and local CLI documented"

if grep -rnE "SKILL\.md\.template" README.md wsd.md ROADMAP.md AGENTS.md CHANGELOG.md docs >/tmp/wsd-stale-skill-links.$$ 2>/dev/null; then
  cat /tmp/wsd-stale-skill-links.$$
  rm -f /tmp/wsd-stale-skill-links.$$
  fail "stale skill template links found"
fi
rm -f /tmp/wsd-stale-skill-links.$$
ok "no stale skill template links"

if grep -rnE 'sendo publicado como repositório privado pessoal em versão `v0\.1\.0-alpha`' README.md wsd.md docs/09_publicacao_github_privado.md >/tmp/wsd-stale-version.$$ 2>/dev/null; then
  cat /tmp/wsd-stale-version.$$
  rm -f /tmp/wsd-stale-version.$$
  fail "stale alpha publication wording found"
fi
rm -f /tmp/wsd-stale-version.$$
ok "no stale publication wording"

# v0.1.4-alpha (TLC integration) checks
tlc_required=(
  "templates/repo/+specs/project/PROJECT.md.template"
  "templates/repo/+specs/project/STATE.md.template"
  "templates/repo/+specs/codebase/STACK.md.template"
  "templates/repo/+specs/codebase/ARCHITECTURE.md.template"
  "templates/repo/+specs/codebase/CONVENTIONS.md.template"
  "templates/repo/+specs/codebase/STRUCTURE.md.template"
  "templates/repo/+specs/codebase/INTEGRATIONS.md.template"
  "templates/repo/+specs/codebase/CONCERNS.md.template"
  "templates/repo/+specs/codebase/TESTING.md.template"
  "templates/specs/feature-spec.md.template"
  "templates/specs/feature-tasks.md.template"
  "templates/specs/quick-task.md.template"
  "templates/specs/quick-summary.md.template"
  "templates/codex-skills/wsd-specify/SKILL.md"
  "templates/codex-skills/wsd-design/SKILL.md"
  "templates/codex-skills/wsd-tasks/SKILL.md"
  "templates/claude-commands/commands/wsd-specify.md"
  "templates/claude-commands/commands/wsd-design.md"
  "templates/claude-commands/commands/wsd-tasks.md"
  "docs/14_qualidade_desenvolvimento.md"
)
for file in "${tlc_required[@]}"; do
  [[ -f "$file" ]] || fail "missing TLC integration artifact: $file"
done
ok "TLC integration artifacts present"

# legacy paths must not appear in new templates / installer / scripts
if grep -rnE '\.specs/|\.logs/error_vault' bin/ scripts/ templates/repo/+specs/ templates/repo/+logs/ templates/local-wsd/ templates/codex-skills/ templates/claude-commands/ profiles/ 2>/dev/null \
   | grep -vE 'CHANGELOG|examples/|wsd_docs_check\.sh' >/tmp/wsd-legacy-paths.$$ 2>/dev/null; then
  if [[ -s /tmp/wsd-legacy-paths.$$ ]]; then
    cat /tmp/wsd-legacy-paths.$$
    rm -f /tmp/wsd-legacy-paths.$$
    fail "legacy .specs or .logs/error_vault paths found in new artifacts"
  fi
fi
rm -f /tmp/wsd-legacy-paths.$$
ok "no legacy .specs / .logs/error_vault paths in new artifacts"

# WHEN/THEN/SHALL contract present in feature-spec template
grep -qE 'SHALL' templates/specs/feature-spec.md.template || fail "feature-spec template missing WHEN/THEN/SHALL"
ok "feature-spec template uses WHEN/THEN/SHALL"

# Conventional Commits standard documented
grep -qE 'Conventional Commits' docs/07_git_governance.md || fail "Conventional Commits not documented in 07_git_governance.md"
ok "Conventional Commits documented"

# v0.1.5-alpha: JSON Schema for .context.json
[[ -f schemas/context.schema.json ]] || fail "schemas/context.schema.json missing"
[[ -f templates/local-wsd/bin/wsd-validate-context.js ]] || fail "templates/local-wsd/bin/wsd-validate-context.js missing"
grep -qE 'context\.schema\.json|wsd-validate-context' docs/05_contrato_artefatos.md || fail "context schema not documented in 05_contrato_artefatos.md"
grep -qE 'context\.schema\.json|wsd-validate-context' docs/10_matriz_sincronizacao_notas.md || fail "context schema not referenced in 10_matriz_sincronizacao_notas.md"
ok "context JSON Schema artifacts present and documented"

# v0.1.6-alpha: git hooks and WHEN/THEN/SHALL checker
[[ -f templates/git-hooks/pre-commit ]] || fail "templates/git-hooks/pre-commit missing"
[[ -f templates/git-hooks/commit-msg ]] || fail "templates/git-hooks/commit-msg missing"
[[ -f templates/git-hooks/pre-push ]] || fail "templates/git-hooks/pre-push missing"
grep -qE 'git.hooks|git-hooks|pre-commit|commit-msg' docs/07_git_governance.md || fail "git hooks not documented in 07_git_governance.md"
grep -q 'ghost spec\|WHEN/THEN/SHALL' templates/repo/scripts/wsd_check.sh || fail "wsd_check.sh template missing ghost spec / WHEN/THEN/SHALL check"
ok "git hooks templates present and WHEN/THEN/SHALL gate in wsd_check.sh"

# v0.1.10-alpha: Git/GitHub Governance MVP
[[ -f templates/modules/git-governance/.github/PULL_REQUEST_TEMPLATE.md ]] || fail "Git Governance PR template missing"
[[ -f templates/modules/git-governance/.github/ISSUE_TEMPLATE/task.md ]] || fail "Git Governance task issue template missing"
[[ -f templates/modules/git-governance/.github/ISSUE_TEMPLATE/bug.md ]] || fail "Git Governance bug issue template missing"
[[ -f templates/modules/git-governance/.github/ISSUE_TEMPLATE/decision.md ]] || fail "Git Governance decision issue template missing"
grep -q -- '--git-policy' bin/wsd-method.js || fail "bin/wsd-method.js missing --git-policy"
grep -q 'git_governance' templates/repo/.context.json.template || fail ".context.json.template missing git_governance"
grep -q 'wsd git doctor' README.md docs/00_planejamento_instalacao_wsd.md docs/11_modulo_git_governance.md || fail "wsd git commands not documented"
ok "Git/GitHub Governance MVP artifacts present and documented"

echo "PASS: WSD docs sync check completed"
