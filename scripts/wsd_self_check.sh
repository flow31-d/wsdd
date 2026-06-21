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

required_files=(
  "README.md"
  "package.json"
  "install.sh"
  "wsd.md"
  "AGENTS.md"
  "docs/00_planejamento_instalacao_wsd.md"
  "docs/01_constituicao.md"
  "docs/02_matriz_risco.md"
  "docs/03_ciclo_operacional.md"
  "docs/04_playbook_implantacao.md"
  "docs/05_contrato_artefatos.md"
  "docs/06_personalizacao_por_projeto.md"
  "docs/07_git_governance.md"
  "docs/08_rotinas_sessao.md"
  "docs/09_publicacao_github_privado.md"
  "docs/10_matriz_sincronizacao_notas.md"
  "docs/11_modulo_git_governance.md"
  "docs/14_qualidade_desenvolvimento.md"
  "docs/19_wsd_loop_automacao_inteligente.md"
  "schemas/context.schema.json"
  "templates/repo/AGENTS.md.template"
  "templates/repo/+context.json.template"
  "templates/repo/+specs/project/PROJECT.md.template"
  "templates/repo/+specs/project/STATE.md.template"
  "templates/repo/+specs/project/CONCERNS.md.template"
  "templates/repo/+specs/project/CONCERNS_PIPELINE.md.template"
  "templates/repo/+specs/codebase/TESTING.md.template"
  "templates/repo/+specs/TASK-001-wsd-bootstrap.spec.yaml.template"
  "templates/specs/feature-spec.md.template"
  "templates/specs/feature-tasks.md.template"
  "templates/repo/scripts/wsd_check.sh"
  "templates/local-wsd/bin/wsd"
  "templates/local-wsd/loop/PROMPT_plan.md"
  "templates/local-wsd/loop/PROMPT_build.md"
  "templates/local-wsd/bin/wsd-validate-context.cjs"
  "templates/codex-prompts/loop.md"
  "templates/codex-skills/wsd-specify/SKILL.md"
  "templates/codex-skills/wsd-design/SKILL.md"
  "templates/codex-skills/wsd-tasks/SKILL.md"
  "templates/codex-skills/wsd-idea/SKILL.md"
  "templates/codex-skills/wsd-concern/SKILL.md"
  "templates/codex-skills/wsd-loop/SKILL.md"
  "templates/claude-commands/commands/wsd-specify.md"
  "templates/claude-commands/commands/wsd-design.md"
  "templates/claude-commands/commands/wsd-tasks.md"
  "templates/claude-commands/commands/wsd-concern.md"
  "templates/claude-commands/commands/loop.md"
  "templates/git-hooks/pre-commit"
  "templates/git-hooks/commit-msg"
  "templates/git-hooks/pre-push"
  "templates/modules/git-governance/.github/PULL_REQUEST_TEMPLATE.md"
  "templates/modules/git-governance/.github/ISSUE_TEMPLATE/task.md"
  "templates/modules/git-governance/.github/ISSUE_TEMPLATE/bug.md"
  "templates/modules/git-governance/.github/ISSUE_TEMPLATE/decision.md"
  "bin/wsd-method.js"
  "scripts/wsd_bootstrap_repo.sh"
  "scripts/wsd_docs_check.sh"
  "scripts/wsd_check.sh"
  "scripts/test_install_codex_adherence.sh"
  "scripts/test_install_finish_clean.sh"
  "scripts/test_install_relatorio.sh"
)

for file in "${required_files[@]}"; do
  [[ -f "$file" ]] || fail "missing required file: $file"
done
ok "required files present"

for skill in templates/codex-skills/*/SKILL.md; do
  head -n 1 "$skill" | grep -qx -- '---' || fail "Codex skill missing YAML frontmatter: $skill"
  sed -n '1,12p' "$skill" | grep -q '^name:' || fail "Codex skill missing name: $skill"
  sed -n '1,12p' "$skill" | grep -q '^description:' || fail "Codex skill missing description: $skill"
done
ok "Codex skill frontmatter present"

for script in scripts/*.sh templates/repo/scripts/*.sh install.sh templates/local-wsd/bin/wsd templates/git-hooks/pre-commit templates/git-hooks/commit-msg templates/git-hooks/pre-push; do
  bash -n "$script" || fail "shell syntax failed: $script"
done
ok "shell scripts parse"

node --check bin/wsd-method.js >/dev/null || fail "node syntax failed: bin/wsd-method.js"
node --check templates/local-wsd/bin/wsd-validate-context.cjs >/dev/null || fail "node syntax failed: templates/local-wsd/bin/wsd-validate-context.cjs"
ok "node cli parses"

python3 -m json.tool schemas/context.schema.json >/dev/null || fail "schemas/context.schema.json is invalid JSON"
ok "context schema is valid JSON"

tmpvalidator=$(mktemp -d)
trap 'rm -rf "$tmpvalidator"' EXIT
cat >"$tmpvalidator/valid.json" <<'JSON'
{
  "$schema": "wsd/context/v1",
  "project": { "name": "x", "type": "y", "primary_language": "z" },
  "environment": { "canonical_host": "h", "canonical_path": "p" },
  "repository": { "default_branch": "main", "repo_type": "private" },
  "permissions": {
    "write_paths": ["./src"],
    "forbidden_paths": ["./.git"],
    "tool_allowlist": ["bash"],
    "secrets_policy": "read_only_env_vars"
  },
  "workflow": { "production_mutation_policy": "forbidden_for_agents" },
  "wsd": { "method": "Wolff Spec Driven", "context_documents": ["+specs/project/PROJECT.md"] }
}
JSON
node templates/local-wsd/bin/wsd-validate-context.cjs "$tmpvalidator/valid.json" --schema schemas/context.schema.json >/dev/null \
  || fail "validator self-test: minimal valid sample rejected"

cat >"$tmpvalidator/missing.json" <<'JSON'
{
  "$schema": "wsd/context/v1",
  "project": { "name": "x", "type": "y", "primary_language": "z" },
  "environment": { "canonical_host": "h", "canonical_path": "p" },
  "repository": { "default_branch": "main", "repo_type": "private" },
  "permissions": {
    "forbidden_paths": ["./.git"],
    "tool_allowlist": ["bash"],
    "secrets_policy": "read_only_env_vars"
  },
  "workflow": { "production_mutation_policy": "forbidden_for_agents" },
  "wsd": { "method": "WSD", "context_documents": [] }
}
JSON
if node templates/local-wsd/bin/wsd-validate-context.cjs "$tmpvalidator/missing.json" --schema schemas/context.schema.json >/dev/null 2>&1; then
  fail "validator self-test: missing required field accepted"
fi

cat >"$tmpvalidator/badenum.json" <<'JSON'
{
  "$schema": "wsd/context/v1",
  "project": { "name": "x", "type": "y", "primary_language": "z" },
  "environment": { "canonical_host": "h", "canonical_path": "p" },
  "repository": { "default_branch": "main", "repo_type": "private" },
  "permissions": {
    "write_paths": ["./src"],
    "forbidden_paths": ["./.git"],
    "tool_allowlist": ["bash"],
    "secrets_policy": "read_only_env_vars"
  },
  "workflow": { "production_mutation_policy": "yolo" },
  "wsd": { "method": "WSD", "context_documents": [] }
}
JSON
if node templates/local-wsd/bin/wsd-validate-context.cjs "$tmpvalidator/badenum.json" --schema schemas/context.schema.json >/dev/null 2>&1; then
  fail "validator self-test: invalid enum accepted"
fi

cat >"$tmpvalidator/badtype.json" <<'JSON'
{
  "$schema": "wsd/context/v1",
  "project": { "name": "x", "type": "y", "primary_language": "z" },
  "environment": { "canonical_host": "h", "canonical_path": "p" },
  "repository": { "default_branch": "main", "repo_type": "private" },
  "permissions": {
    "write_paths": ["./src"],
    "forbidden_paths": ["./.git"],
    "tool_allowlist": ["bash"],
    "secrets_policy": "read_only_env_vars",
    "max_runtime_seconds": "600"
  },
  "workflow": { "production_mutation_policy": "forbidden_for_agents" },
  "wsd": { "method": "WSD", "context_documents": [] }
}
JSON
if node templates/local-wsd/bin/wsd-validate-context.cjs "$tmpvalidator/badtype.json" --schema schemas/context.schema.json >/dev/null 2>&1; then
  fail "validator self-test: wrong type accepted"
fi
rm -rf "$tmpvalidator"
trap - EXIT
ok "validator self-tests pass"

# WHEN/THEN/SHALL gate present in repo wsd_check.sh template (requires all three)
grep -q 'ghost spec' templates/repo/scripts/wsd_check.sh || fail "templates/repo/scripts/wsd_check.sh missing ghost spec gate"
grep -q '_spec_has_wts' templates/repo/scripts/wsd_check.sh || fail "templates/repo/scripts/wsd_check.sh missing _spec_has_wts (WHEN+THEN+SHALL triple check)"
ok "wsd_check.sh template has complete WHEN/THEN/SHALL gate"

# WSD-009 regression: release script presente e executável
[ -f scripts/wsd_release.sh ] || fail "scripts/wsd_release.sh missing (WSD-009)"
[ -x scripts/wsd_release.sh ] || fail "scripts/wsd_release.sh not executable (WSD-009)"
bash -n scripts/wsd_release.sh || fail "scripts/wsd_release.sh has syntax error"
ok "wsd_release.sh present, executable, syntax-valid (WSD-009)"

# WSD-002 regression: render() suporta conditionals
grep -q '{{#if' bin/wsd-method.js || fail "bin/wsd-method.js render() missing {{#if}} conditional support (WSD-002)"
grep -q '{{#unless' bin/wsd-method.js || fail "bin/wsd-method.js render() missing {{#unless}} conditional support (WSD-002)"
ok "render() supports {{#if}}/{{#unless}} conditionals (WSD-002)"

# WSD-013 regression: fs.existsSync guards nos loops de cópia
existsync_count=$(grep -c 'fs.existsSync(srcPath)' bin/wsd-method.js || true)
if [[ "$existsync_count" -lt 2 ]]; then
  fail "bin/wsd-method.js missing fs.existsSync guards in copy loops (WSD-013): found $existsync_count, need 2"
fi
ok "bin/wsd-method.js has fs.existsSync guards in copy loops (WSD-013)"

# WSD-007 regression: módulos opcionais (D-001) — settings, prompts, config.modules
grep -q 'INSTALL_DOCS' bin/wsd-method.js || fail "bin/wsd-method.js missing INSTALL_DOCS setting (WSD-007)"
grep -q 'INSTALL_PARTY_MODE' bin/wsd-method.js || fail "bin/wsd-method.js missing INSTALL_PARTY_MODE setting (WSD-007)"
grep -q 'INSTALL_EXAMPLES' bin/wsd-method.js || fail "bin/wsd-method.js missing INSTALL_EXAMPLES setting (WSD-007)"
grep -q 'config.modules' bin/wsd-method.js || fail "bin/wsd-method.js missing config.modules (WSD-007)"
ok "WSD-007 install opt-out wired (settings + config.modules)"

# WSD-004/WSD concerns regression: wsd_check.sh template valida 7 notas project/ (L0) + ROADMAP coherence (L1)
grep -q '_project_notes' templates/repo/scripts/wsd_check.sh || fail "templates/repo/scripts/wsd_check.sh missing _project_notes L0 check (WSD-004)"
grep -q 'CONCERNS.md' templates/repo/scripts/wsd_check.sh || fail "templates/repo/scripts/wsd_check.sh missing CONCERNS.md in L0 manifest (WSD-004)"
grep -q 'CONCERNS_PIPELINE.md' templates/repo/scripts/wsd_check.sh || fail "templates/repo/scripts/wsd_check.sh missing CONCERNS_PIPELINE.md in L0 manifest"
grep -q 'ROADMAP referencia specs válidas' templates/repo/scripts/wsd_check.sh || fail "templates/repo/scripts/wsd_check.sh missing L1 ROADMAP coherence check (WSD-004)"
ok "WSD-004 L0+L1 gates present in wsd_check.sh template"

grep -q 'snapshot.json generated and valid' templates/repo/scripts/wsd_check.sh || fail "templates/repo/scripts/wsd_check.sh missing snapshot generation gate"
grep -q 'ROADMAP/STATE estruturados' templates/repo/scripts/wsd_check.sh || fail "templates/repo/scripts/wsd_check.sh missing ROADMAP/STATE structure gate"
ok "WSD snapshot operational contract present"

# HANDOFF.md generation in finish case
grep -q 'HANDOFF.md' templates/local-wsd/bin/wsd || fail "templates/local-wsd/bin/wsd missing HANDOFF.md generation in finish"
ok "wsd CLI finish generates HANDOFF.md"

# STATE.md prompts in finish case
grep -q '_state_insert' templates/local-wsd/bin/wsd || fail "templates/local-wsd/bin/wsd missing STATE.md prompts in finish"
ok "wsd CLI finish has STATE.md prompts"

grep -q '_wsd_finish' templates/local-wsd/bin/wsd || fail "templates/local-wsd/bin/wsd missing _wsd_finish clean-close function"
grep -q '_finish_docs_check' templates/local-wsd/bin/wsd || fail "templates/local-wsd/bin/wsd finish missing docs audit"
grep -q 'chore(wsd): finish session' templates/local-wsd/bin/wsd || fail "templates/local-wsd/bin/wsd finish missing default commit message"
grep -q 'git commit -m' templates/local-wsd/bin/wsd || fail "templates/local-wsd/bin/wsd finish missing closing commit"
grep -q 'test:install-finish-clean' package.json || fail "package.json missing test:install-finish-clean"
ok "wsd CLI finish clean-close contract present"

grep -q '_wsd_relatorio' templates/local-wsd/bin/wsd || fail "templates/local-wsd/bin/wsd missing _wsd_relatorio"
grep -q 'Relatorio WSD' templates/local-wsd/bin/wsd || fail "templates/local-wsd/bin/wsd missing report title"
grep -q 'Sugestão do agente' templates/local-wsd/bin/wsd || fail "templates/local-wsd/bin/wsd report missing agent suggestion"
grep -q 'test:install-relatorio' package.json || fail "package.json missing test:install-relatorio"
ok "wsd CLI relatorio contract present"

# git-hooks templates are executable
for hook in templates/git-hooks/pre-commit templates/git-hooks/commit-msg templates/git-hooks/pre-push; do
  [[ -x "$hook" ]] || fail "git hook template not executable: $hook"
done
ok "git hook templates are executable"

grep -q 'git-policy' bin/wsd-method.js || fail "bin/wsd-method.js missing --git-policy support"
grep -q 'git_governance' templates/repo/+context.json.template || fail "+context.json.template missing git_governance block"
grep -q 'git doctor' templates/local-wsd/bin/wsd || fail "templates/local-wsd/bin/wsd missing git namespace"
ok "git governance MVP artifacts present"

grep -q 'automation' schemas/context.schema.json || fail "schemas/context.schema.json missing automation block"
grep -q 'auto_use' schemas/context.schema.json || fail "schemas/context.schema.json missing automation.loop.auto_use"
grep -q 'automation' templates/repo/+context.json.template || fail "+context.json.template missing automation block"
grep -q 'auto_use' templates/repo/+context.json.template || fail "+context.json.template missing automation.loop.auto_use"
grep -q 'loop)' templates/local-wsd/bin/wsd || fail "templates/local-wsd/bin/wsd missing loop command"
grep -q '_wsd_loop' templates/local-wsd/bin/wsd || fail "templates/local-wsd/bin/wsd missing loop dispatcher"
grep -q 'loop auto' templates/local-wsd/bin/wsd || fail "templates/local-wsd/bin/wsd missing loop auto toggle"
grep -q 'test:install-loop' package.json || fail "package.json missing test:install-loop"
grep -q 'WSD Loop' docs/19_wsd_loop_automacao_inteligente.md || fail "docs/19 missing WSD Loop content"
ok "WSD Loop automation artifacts present"

grep -q 'WSD Codex Bootstrap' templates/repo/AGENTS.md.template || fail "AGENTS.md.template missing WSD Codex Bootstrap"
grep -q 'codex-prompt)' templates/local-wsd/bin/wsd || fail "templates/local-wsd/bin/wsd missing codex-prompt command"
grep -q '_wsd_codex' templates/local-wsd/bin/wsd || fail "templates/local-wsd/bin/wsd missing codex launcher"
grep -q 'start --brief' templates/local-wsd/bin/wsd || fail "templates/local-wsd/bin/wsd missing start --brief"
grep -q '.agents' bin/wsd-method.js || fail "bin/wsd-method.js missing .agents/skills install target"
grep -q 'codex-shortcuts)' templates/local-wsd/bin/wsd || fail "templates/local-wsd/bin/wsd missing codex-shortcuts command"
grep -q 'shortcuts)' templates/local-wsd/bin/wsd || fail "templates/local-wsd/bin/wsd missing shortcuts command"
grep -q 'WSD Codex Loop Shortcut' templates/codex-prompts/loop.md || fail "Codex loop prompt missing marker"
grep -q '/loop status' templates/claude-commands/commands/loop.md || fail "Claude /loop command missing status mapping"
grep -q 'test:install-codex-adherence' package.json || fail "package.json missing test:install-codex-adherence"
ok "Codex adherence artifacts present"

bash scripts/wsd_docs_check.sh
ok "documentation sync passed"

if [[ -f +specs/project/IDEAS.md && -f +specs/project/IDEAS_PIPELINE.md ]]; then
  if grep -q '^## IDEA-[0-9][0-9][0-9]' +specs/project/IDEAS.md \
    && grep -q '^| — | — | — | — | — | — |$' +specs/project/IDEAS_PIPELINE.md; then
    fail "+specs/project/IDEAS_PIPELINE.md still has placeholder row while IDEAS.md has ideas"
  fi
  ok "WSD ideas pipeline is populated when ideas exist"
else
  ok "WSD ideas pipeline check not applicable without project idea notes"
fi

if find . -type f \( -name "*.md" -o -name "*.md.template" \) -print0 | xargs -0 grep -L '^---$' >/tmp/wsd-md-without-frontmatter.$$ 2>/dev/null; then
  if [[ -s /tmp/wsd-md-without-frontmatter.$$ ]]; then
    echo "warn: markdown files without Obsidian frontmatter or intentionally template-only:"
    sed 's#^\./#  - #' /tmp/wsd-md-without-frontmatter.$$
  fi
fi
rm -f /tmp/wsd-md-without-frontmatter.$$

secret_pattern='API[_]KEY=[A-Za-z0-9]|SEC[R]ET=[A-Za-z0-9]|TOK[E]N=[A-Za-z0-9]|PASS[W]ORD=[A-Za-z0-9]|BEGI[N] (RSA |OPENSSH |EC |)PRIVA[T]E KEY|\bs[k]-[A-Za-z0-9]{20,}'
if grep -rnE "$secret_pattern" --include='*.md' --include='*.json' --include='*.yaml' --include='*.yml' --include='*.sh' --include='*.js' --include='*.template' --exclude-dir=.git --exclude-dir=node_modules --exclude-dir=xmodelos --exclude-dir=party-mode . >/tmp/wsd-secret-scan.$$ 2>/dev/null; then
  if [[ -s /tmp/wsd-secret-scan.$$ ]]; then
    cat /tmp/wsd-secret-scan.$$
    rm -f /tmp/wsd-secret-scan.$$
    fail "possible secret pattern found"
  fi
fi
rm -f /tmp/wsd-secret-scan.$$
ok "basic secret scan passed"

echo "PASS: WSD self check completed"
