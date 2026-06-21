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
  "docs/19_wsd_loop_automacao_inteligente.md"
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

grep -qE "$version|$tag" docs/19_wsd_loop_automacao_inteligente.md || fail "current version $version is not referenced in docs/19_wsd_loop_automacao_inteligente.md"
ok "current version referenced in WSD Loop doc"

for file in README.md wsd.md ROADMAP.md AGENTS.md; do
  grep -qE "docs/10_matriz_sincronizacao_notas|Matriz de Sincronização" "$file" || fail "sync matrix not referenced in $file"
done
ok "sync matrix referenced by central notes"

for file in wsd.md ROADMAP.md docs/00_planejamento_instalacao_wsd.md docs/07_git_governance.md docs/10_matriz_sincronizacao_notas.md; do
  grep -qE "docs/11_modulo_git_governance|git-governance" "$file" || fail "git-governance module plan not referenced in $file"
done
ok "git-governance module plan referenced"

for file in README.md wsd.md docs/04_playbook_implantacao.md docs/08_rotinas_sessao.md; do
  grep -qE "wsd-method|install\\.sh|\\+wsd/bin/wsd" "$file" || fail "current installer/local CLI not documented in $file"
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
  "templates/repo/+specs/project/CONCERNS.md.template"
  "templates/repo/+specs/project/CONCERNS_PIPELINE.md.template"
  "templates/repo/+specs/codebase/TESTING.md.template"
  "templates/specs/feature-spec.md.template"
  "templates/specs/feature-tasks.md.template"
  "templates/specs/quick-task.md.template"
  "templates/specs/quick-summary.md.template"
  "templates/codex-prompts/loop.md"
  "templates/codex-skills/wsd-specify/SKILL.md"
  "templates/codex-skills/wsd-design/SKILL.md"
  "templates/codex-skills/wsd-tasks/SKILL.md"
  "templates/codex-skills/wsd-idea/SKILL.md"
  "templates/codex-skills/wsd-finish/SKILL.md"
  "templates/codex-skills/wsd-relatorio/SKILL.md"
  "templates/codex-skills/wsd-concern/SKILL.md"
  "templates/codex-skills/wsd-loop/SKILL.md"
  "templates/claude-commands/commands/wsd-relatorio.md"
  "templates/claude-commands/commands/wsd-finish.md"
  "templates/claude-commands/commands/wsd-specify.md"
  "templates/claude-commands/commands/wsd-design.md"
  "templates/claude-commands/commands/wsd-tasks.md"
  "templates/claude-commands/commands/wsd-concern.md"
  "templates/claude-commands/commands/loop.md"
  "docs/14_qualidade_desenvolvimento.md"
)
for file in "${tlc_required[@]}"; do
  [[ -f "$file" ]] || fail "missing TLC integration artifact: $file"
done
ok "TLC integration artifacts present"

grep -q '_wsd_finish' templates/local-wsd/bin/wsd || fail "templates/local-wsd/bin/wsd missing _wsd_finish"
grep -q '_finish_docs_check' templates/local-wsd/bin/wsd || fail "wsd finish missing docs audit hook"
grep -Fq 'if [[ -f scripts/wsd_docs_check.sh ]]; then' templates/local-wsd/bin/wsd || fail "wsd finish docs audit must run when scripts/wsd_docs_check.sh exists"
grep -Fq 'rm -rf "$tmpdir/docs"' scripts/test_install_finish_clean.sh || fail "finish clean regression test must cover repo without root docs directory"
grep -q 'chore(wsd): finish session' templates/local-wsd/bin/wsd || fail "wsd finish missing default closing commit message"
grep -q 'test:install-finish-clean' package.json || fail "package.json missing finish clean regression test"
grep -q 'finish limpo' docs/10_matriz_sincronizacao_notas.md || fail "sync matrix missing finish clean contract"
grep -q 'worktree limpo' docs/08_rotinas_sessao.md || fail "docs/08 missing clean finish contract"
ok "WSD finish clean-close artifacts documented"

grep -q '_wsd_relatorio' templates/local-wsd/bin/wsd || fail "templates/local-wsd/bin/wsd missing _wsd_relatorio"
grep -q 'test:install-relatorio' package.json || fail "package.json missing relatorio regression test"
grep -q 'wsd relatorio' README.md wsd.md docs/08_rotinas_sessao.md docs/18_manual_leigo_comandos_wsdd.md || fail "wsd relatorio not documented in central docs"
grep -q 'Relatorio WSD' templates/codex-skills/wsd-relatorio/SKILL.md templates/claude-commands/commands/wsd-relatorio.md || fail "agent report command artifacts missing Relatorio WSD"
ok "WSD relatorio artifacts documented"

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

# v0.1.5-alpha: JSON Schema for +context.json
[[ -f schemas/context.schema.json ]] || fail "schemas/context.schema.json missing"
[[ -f templates/local-wsd/bin/wsd-validate-context.cjs ]] || fail "templates/local-wsd/bin/wsd-validate-context.cjs missing"
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
grep -q 'git_governance' templates/repo/+context.json.template || fail "+context.json.template missing git_governance"
grep -q 'wsd git doctor' README.md docs/00_planejamento_instalacao_wsd.md docs/11_modulo_git_governance.md || fail "wsd git commands not documented"
ok "Git/GitHub Governance MVP artifacts present and documented"

# v0.4.0: WSD Loop automation
[[ -f templates/local-wsd/loop/PROMPT_plan.md ]] || fail "WSD Loop plan prompt missing"
[[ -f templates/local-wsd/loop/PROMPT_build.md ]] || fail "WSD Loop build prompt missing"
grep -q 'automation' templates/repo/+context.json.template || fail "+context.json.template missing automation block"
grep -q 'automation' schemas/context.schema.json || fail "context schema missing automation block"
grep -q 'loop)' templates/local-wsd/bin/wsd || fail "wsd CLI missing loop command"
grep -q 'test:install-loop' package.json || fail "package.json missing test:install-loop"
grep -q 'auto_use' templates/repo/+context.json.template schemas/context.schema.json || fail "automation.loop.auto_use not wired in template/schema"
grep -q 'wsd loop' README.md wsd.md docs/08_rotinas_sessao.md docs/19_wsd_loop_automacao_inteligente.md || fail "WSD Loop commands not documented"
grep -q 'loop auto' README.md docs/08_rotinas_sessao.md docs/18_manual_leigo_comandos_wsdd.md docs/19_wsd_loop_automacao_inteligente.md || fail "loop auto toggle not documented"
grep -q 'automation.loop' docs/05_contrato_artefatos.md docs/10_matriz_sincronizacao_notas.md docs/19_wsd_loop_automacao_inteligente.md || fail "automation.loop contract not documented"
ok "WSD Loop artifacts present and documented"

grep -q 'test:install-codex-adherence' package.json || fail "package.json missing test:install-codex-adherence"
grep -q 'WSD Codex Bootstrap' AGENTS.md templates/repo/AGENTS.md.template || fail "WSD Codex Bootstrap not documented in AGENTS files"
grep -q 'codex-prompt' README.md wsd.md docs/08_rotinas_sessao.md docs/18_manual_leigo_comandos_wsdd.md docs/19_wsd_loop_automacao_inteligente.md || fail "codex-prompt not documented"
grep -q '.agents/skills' README.md docs/08_rotinas_sessao.md docs/13_compatibilidade_claude_code.md || fail "current Codex .agents/skills path not documented"
grep -q 'codex-shortcuts' README.md docs/18_manual_leigo_comandos_wsdd.md docs/19_wsd_loop_automacao_inteligente.md || fail "codex-shortcuts not documented"
grep -q '/prompts:loop' README.md docs/18_manual_leigo_comandos_wsdd.md docs/19_wsd_loop_automacao_inteligente.md || fail "Codex prompt shortcut not documented"
grep -q '/loop status' README.md docs/13_compatibilidade_claude_code.md docs/18_manual_leigo_comandos_wsdd.md || fail "Claude /loop shortcut not documented"
grep -q 'Codex Adherence Pack' README.md wsd.md CHANGELOG.md docs/10_matriz_sincronizacao_notas.md docs/19_wsd_loop_automacao_inteligente.md || fail "Codex Adherence Pack not documented in central docs"
ok "Codex Adherence Pack artifacts present and documented"

echo "PASS: WSD docs sync check completed"
