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
  "schemas/context.schema.json"
  "templates/repo/AGENTS.md.template"
  "templates/repo/.context.json.template"
  "templates/repo/+specs/project/PROJECT.md.template"
  "templates/repo/+specs/project/STATE.md.template"
  "templates/repo/+specs/codebase/TESTING.md.template"
  "templates/repo/+specs/TASK-001-wsd-bootstrap.spec.yaml.template"
  "templates/specs/feature-spec.md.template"
  "templates/specs/feature-tasks.md.template"
  "templates/repo/scripts/wsd_check.sh"
  "templates/local-wsd/bin/wsd"
  "templates/local-wsd/bin/wsd-validate-context.js"
  "templates/codex-skills/wsd-specify/SKILL.md"
  "templates/codex-skills/wsd-design/SKILL.md"
  "templates/codex-skills/wsd-tasks/SKILL.md"
  "templates/claude-commands/commands/wsd-specify.md"
  "templates/claude-commands/commands/wsd-design.md"
  "templates/claude-commands/commands/wsd-tasks.md"
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
)

for file in "${required_files[@]}"; do
  [[ -f "$file" ]] || fail "missing required file: $file"
done
ok "required files present"

for script in scripts/*.sh templates/repo/scripts/*.sh install.sh templates/local-wsd/bin/wsd templates/git-hooks/pre-commit templates/git-hooks/commit-msg templates/git-hooks/pre-push; do
  bash -n "$script" || fail "shell syntax failed: $script"
done
ok "shell scripts parse"

node --check bin/wsd-method.js >/dev/null || fail "node syntax failed: bin/wsd-method.js"
node --check templates/local-wsd/bin/wsd-validate-context.js >/dev/null || fail "node syntax failed: templates/local-wsd/bin/wsd-validate-context.js"
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
node templates/local-wsd/bin/wsd-validate-context.js "$tmpvalidator/valid.json" --schema schemas/context.schema.json >/dev/null \
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
if node templates/local-wsd/bin/wsd-validate-context.js "$tmpvalidator/missing.json" --schema schemas/context.schema.json >/dev/null 2>&1; then
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
if node templates/local-wsd/bin/wsd-validate-context.js "$tmpvalidator/badenum.json" --schema schemas/context.schema.json >/dev/null 2>&1; then
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
if node templates/local-wsd/bin/wsd-validate-context.js "$tmpvalidator/badtype.json" --schema schemas/context.schema.json >/dev/null 2>&1; then
  fail "validator self-test: wrong type accepted"
fi
rm -rf "$tmpvalidator"
trap - EXIT
ok "validator self-tests pass"

# WHEN/THEN/SHALL gate present in repo wsd_check.sh template (requires all three)
grep -q 'ghost spec' templates/repo/scripts/wsd_check.sh || fail "templates/repo/scripts/wsd_check.sh missing ghost spec gate"
grep -q '_spec_has_wts' templates/repo/scripts/wsd_check.sh || fail "templates/repo/scripts/wsd_check.sh missing _spec_has_wts (WHEN+THEN+SHALL triple check)"
ok "wsd_check.sh template has complete WHEN/THEN/SHALL gate"

# HANDOFF.md generation in finish case
grep -q 'HANDOFF.md' templates/local-wsd/bin/wsd || fail "templates/local-wsd/bin/wsd missing HANDOFF.md generation in finish"
ok "wsd CLI finish generates HANDOFF.md"

# STATE.md prompts in finish case
grep -q '_state_insert' templates/local-wsd/bin/wsd || fail "templates/local-wsd/bin/wsd missing STATE.md prompts in finish"
ok "wsd CLI finish has STATE.md prompts"

# git-hooks templates are executable
for hook in templates/git-hooks/pre-commit templates/git-hooks/commit-msg templates/git-hooks/pre-push; do
  [[ -x "$hook" ]] || fail "git hook template not executable: $hook"
done
ok "git hook templates are executable"

grep -q 'git-policy' bin/wsd-method.js || fail "bin/wsd-method.js missing --git-policy support"
grep -q 'git_governance' templates/repo/.context.json.template || fail ".context.json.template missing git_governance block"
grep -q 'git doctor' templates/local-wsd/bin/wsd || fail "templates/local-wsd/bin/wsd missing git namespace"
ok "git governance MVP artifacts present"

bash scripts/wsd_docs_check.sh
ok "documentation sync passed"

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
