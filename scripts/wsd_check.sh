#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  wsd_check.sh [--risk L0|L1|L2] [--spec path/to/spec.yaml] [repo_path]

Checks a repository using the Wolff Spec Driven minimum contract.
USAGE
}

risk="L0"
spec=""
repo="."

while [[ $# -gt 0 ]]; do
  case "$1" in
    --risk)
      risk="${2:-}"
      shift 2
      ;;
    --spec)
      spec="${2:-}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      repo="$1"
      shift
      ;;
  esac
done

cd "$repo"

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

pass_step() {
  echo "ok: $*"
}

case "$risk" in
  L0|L1|L2) ;;
  *) fail "invalid risk '$risk'; expected L0, L1 or L2" ;;
esac

git rev-parse --is-inside-work-tree >/dev/null 2>&1 || fail "not inside a Git repository"
pass_step "git repository detected"

[[ -f "+context.json" ]] || fail "+context.json missing"
python3 -m json.tool +context.json >/dev/null || fail "+context.json is invalid JSON"
pass_step "+context.json valid JSON"

_context_validator=""
if [[ -x "+wsd/bin/wsd-validate-context.cjs" ]]; then
  _context_validator="+wsd/bin/wsd-validate-context.cjs"
elif [[ -x "templates/local-wsd/bin/wsd-validate-context.cjs" ]]; then
  _context_validator="templates/local-wsd/bin/wsd-validate-context.cjs"
fi

if command -v node >/dev/null 2>&1 && [[ -n "$_context_validator" ]]; then
  _validator_args=("+context.json")
  if [[ "$_context_validator" == templates/* && -f "schemas/context.schema.json" ]]; then
    _validator_args+=("--schema" "schemas/context.schema.json")
  fi
  node "$_context_validator" "${_validator_args[@]}" >/dev/null || fail "+context.json schema validation failed"
  pass_step "+context.json schema valid"
else
  echo "warn: node missing or wsd-validate-context.cjs absent — schema validation skipped"
fi

[[ -f "AGENTS.md" ]] || fail "AGENTS.md missing"
[[ -d "+specs" ]] || fail "+specs directory missing"
[[ -d "+specs/project" ]] || fail "+specs/project directory missing"
pass_step "WSD directories present"

# L0: presença das 6 notas obrigatórias de +specs/project/ (WSD-004)
# Antes só STATE.md era checada; WSD-001 escapou porque o gate não validava as outras.
_project_notes=(PROJECT.md STATE.md ROADMAP.md IDEAS.md IDEAS_PIPELINE.md CONCERNS.md)
for _note in "${_project_notes[@]}"; do
  [[ -f "+specs/project/$_note" ]] || fail "+specs/project/$_note missing (L0 required)"
done
pass_step "6 notas obrigatórias de +specs/project/ presentes (L0)"

grep -q '^## Features Ativas' +specs/project/ROADMAP.md || fail "ROADMAP.md missing 'Features Ativas' section"
grep -q '^## Backlog' +specs/project/ROADMAP.md || fail "ROADMAP.md missing 'Backlog' section"
grep -Eq '^## (Bloqueadores Ativos|Blockers)' +specs/project/STATE.md || fail "STATE.md missing blockers section"
pass_step "ROADMAP/STATE estruturados para snapshot"

# Lovable gate: se +context.json declara lovable_integration.enabled=true,
# repo é Bun-puro. package-lock.json proibido (causa raiz Preview travado),
# bun.lock obrigatório.
_lovable_enabled=""
if command -v python3 >/dev/null 2>&1; then
  _lovable_enabled="$(python3 - <<'PY' 2>/dev/null || true
import json
try:
    with open("+context.json", encoding="utf-8") as fh:
        data = json.load(fh)
    li = data.get("lovable_integration", {})
    print("true" if li.get("enabled") else "")
except Exception:
    pass
PY
)"
fi
if [[ "$_lovable_enabled" == "true" ]]; then
  [[ ! -f package-lock.json ]] || fail "package-lock.json presente — Lovable é Bun-puro (causa raiz Preview travado)"
  [[ -f bun.lock ]] || fail "bun.lock ausente — rode 'bun install' (Lovable é Bun-puro)"
  pass_step "Lovable invariantes (sem package-lock.json, bun.lock presente)"
fi

_placeholder_targets=(AGENTS.md +context.json +specs scripts)
[[ -d +logs ]] && _placeholder_targets+=(+logs)
if grep -R "{{[A-Z0-9_][A-Z0-9_]*}}" "${_placeholder_targets[@]}" 2>/dev/null; then
  fail "unrendered placeholders found"
fi
pass_step "no template placeholders found"

# Ghost spec detection: approved/implemented specs must have complete WHEN + THEN + SHALL
_spec_has_wts() {
  grep -q '\bWHEN\b' "$1" 2>/dev/null && \
  grep -q '\bTHEN\b' "$1" 2>/dev/null && \
  grep -q '\bSHALL\b' "$1" 2>/dev/null
}

if [[ -d "+specs/features" ]]; then
  ghost_specs=()
  while IFS= read -r specfile; do
    if grep -qE 'status:[[:space:]]*(approved|implemented|verified)' "$specfile" 2>/dev/null; then
      if ! _spec_has_wts "$specfile"; then
        ghost_specs+=("$specfile")
      fi
    fi
  done < <(find +specs/features -maxdepth 2 -name 'spec.md' 2>/dev/null | sort)
  if [[ ${#ghost_specs[@]} -gt 0 ]]; then
    echo "warn: ghost specs detectadas (approved/implemented sem WHEN+THEN+SHALL completos):"
    for s in "${ghost_specs[@]}"; do echo "  - $s"; done
    echo "  Todos os tres keywords sao obrigatorios em acceptance criteria."
  elif find +specs/features -maxdepth 2 -name 'spec.md' 2>/dev/null | grep -q .; then
    pass_step "feature specs have WHEN/THEN/SHALL"
  fi
fi

# L1: coerência ROADMAP ↔ spec — todas as referências `+specs/features/<slug>/spec.md`
# no ROADMAP.md devem apontar para arquivos existentes (WSD-004)
if [[ "$risk" == "L1" || "$risk" == "L2" ]] && [[ -f "+specs/project/ROADMAP.md" ]]; then
  _missing_specs=()
  while IFS= read -r _spec_ref; do
    # Normaliza: remove backticks, espaços, links markdown
    _spec_path=$(echo "$_spec_ref" | sed -E 's/.*(\+specs\/features\/[a-zA-Z0-9_-]+\/spec\.md).*/\1/')
    if [[ -n "$_spec_path" ]] && [[ ! -f "$_spec_path" ]]; then
      _missing_specs+=("$_spec_path")
    fi
  done < <(grep -oE '\+specs/features/[a-zA-Z0-9_-]+/spec\.md' "+specs/project/ROADMAP.md" 2>/dev/null | sort -u)
  if [[ ${#_missing_specs[@]} -gt 0 ]]; then
    echo "FAIL: ROADMAP.md referencia specs ausentes:" >&2
    for _s in "${_missing_specs[@]}"; do echo "  - $_s" >&2; done
    fail "spec coherence broken — adicione spec.md ou remova entry do ROADMAP"
  fi
  pass_step "ROADMAP referencia specs válidas (L1)"
fi

if [[ "$risk" == "L1" || "$risk" == "L2" ]]; then
  [[ -n "$spec" ]] || fail "--spec is required for $risk"
  [[ -f "$spec" ]] || fail "spec not found: $spec"
  grep -Eq 'severity:[[:space:]]*"'$risk'"|severity:[[:space:]]*'$risk "$spec" || fail "spec severity does not match $risk"
  grep -Eq 'status:[[:space:]]*"approved"|status:[[:space:]]*approved' "$spec" || fail "spec must be approved for $risk"
  pass_step "$risk spec approved"
  # Require all three: WHEN + THEN + SHALL (not just SHALL)
  _spec_has_wts "$spec" || fail "$risk spec missing complete WHEN/THEN/SHALL pattern — all three required (ghost spec blocked)"
  pass_step "$risk spec has complete WHEN/THEN/SHALL"
fi

if [[ "$risk" == "L2" ]]; then
  grep -Eq 'rollback_plan:' "$spec" || fail "L2 spec must include rollback_plan"
  grep -Eq 'risk_assessment:' "$spec" || fail "L2 spec must include risk_assessment"
  pass_step "L2 risk and rollback sections present"
fi

# Write health cache for wsd snapshot
if [[ -d +wsd ]]; then
  printf '{"passed":true,"ghost_specs":0,"checked_at":"%s"}\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" > +wsd/.last-check.json 2>/dev/null || true
fi

_snapshot_cmd=""
if [[ -f "+wsd/bin/wsd-snapshot.cjs" ]]; then
  _snapshot_cmd="+wsd/bin/wsd-snapshot.cjs"
elif [[ -f "templates/local-wsd/bin/wsd-snapshot.cjs" ]]; then
  _snapshot_cmd="templates/local-wsd/bin/wsd-snapshot.cjs"
fi

[[ -n "$_snapshot_cmd" ]] || fail "WSD snapshot generator missing"
command -v node >/dev/null 2>&1 || fail "node is required to generate WSD snapshot"
node "$_snapshot_cmd" >/dev/null || fail "WSD snapshot generation failed"
[[ -f "+wsd/snapshot.json" ]] || fail "+wsd/snapshot.json missing after generation"
python3 -m json.tool +wsd/snapshot.json >/dev/null || fail "+wsd/snapshot.json is invalid JSON"
grep -q '"schema": "wsd/project-snapshot/v1"' +wsd/snapshot.json || fail "+wsd/snapshot.json schema mismatch"
pass_step "+wsd/snapshot.json generated and valid"

echo "PASS: WSD check completed"
