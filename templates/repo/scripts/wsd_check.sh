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

if command -v node >/dev/null 2>&1 && [[ -x "+wsd/bin/wsd-validate-context.cjs" ]]; then
  node +wsd/bin/wsd-validate-context.cjs +context.json >/dev/null || fail "+context.json schema validation failed"
  pass_step "+context.json schema valid"
else
  echo "warn: node missing or +wsd/bin/wsd-validate-context.cjs absent — schema validation skipped"
fi

[[ -f "+specs/project/STATE.md" ]] || fail "+specs/project/STATE.md missing"
pass_step "STATE.md present"

[[ -f "AGENTS.md" ]] || fail "AGENTS.md missing"
[[ -d "+specs" ]] || fail "+specs directory missing"
[[ -d "+specs/project" ]] || fail "+specs/project directory missing"
pass_step "WSD directories present"

if grep -R "{{[A-Z0-9_][A-Z0-9_]*}}" AGENTS.md +context.json +specs +logs scripts 2>/dev/null; then
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

echo "PASS: WSD check completed"

# Write health cache for wsd snapshot
if [[ -d +wsd ]]; then
  printf '{"passed":true,"ghost_specs":0,"checked_at":"%s"}\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" > +wsd/.last-check.json 2>/dev/null || true
fi
