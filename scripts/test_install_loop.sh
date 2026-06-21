#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"

tmpdir="$(mktemp -d)"
plan_out=""
once_out=""
auto_out=""
trap 'rm -rf "$tmpdir" "${plan_out:-}" "${once_out:-}" "${auto_out:-}"' EXIT

node bin/wsd-method.js install \
  --directory "$tmpdir" \
  --init-git \
  --yes \
  --github skip \
  --tools codex \
  --profile generic_node_frontend >/dev/null

test -f "$tmpdir/+wsd/loop/PROMPT_plan.md"
test -f "$tmpdir/+wsd/loop/PROMPT_build.md"
node "$tmpdir/+wsd/bin/wsd-validate-context.cjs" "$tmpdir/+context.json" >/dev/null

node -e '
const c = require(process.argv[1]);
if (!c.automation || !c.automation.loop || c.automation.loop.enabled !== true) process.exit(1);
if (!c.automation.loop.allowed_risks.includes("L1")) process.exit(2);
if (c.automation.loop.auto_use !== false) process.exit(3);
' "$tmpdir/+context.json"

mkdir -p "$tmpdir/+specs/features/sample-loop"
cat > "$tmpdir/+specs/features/sample-loop/spec.md" <<'EOF'
---
title: Sample Loop
status: approved
risk: L1
---
# Sample Loop

## Acceptance Criteria

- WHEN the loop prepares a prompt THEN it SHALL keep execution gated.
EOF

cat > "$tmpdir/+specs/features/sample-loop/tasks.md" <<'EOF'
# Tasks

- [ ] T1 -- sample task
EOF

git -C "$tmpdir" config user.email wsd@example.invalid
git -C "$tmpdir" config user.name "WSD Test"
git -C "$tmpdir" add -A
git -C "$tmpdir" commit -m "chore: base" >/dev/null

plan_out="$(mktemp)"
once_out="$(mktemp)"
auto_out="$(mktemp)"

"$tmpdir/+wsd/bin/wsd" loop status >/dev/null
"$tmpdir/+wsd/bin/wsd" loop auto status >"$auto_out"
grep -q "automation.loop.auto_use=false" "$auto_out"
"$tmpdir/+wsd/bin/wsd" loop auto on >/dev/null
node -e 'const c=require(process.argv[1]); if(c.automation.loop.auto_use !== true) process.exit(1)' "$tmpdir/+context.json"
"$tmpdir/+wsd/bin/wsd" loop auto status >"$auto_out"
grep -q "automation.loop.auto_use=true" "$auto_out"
"$tmpdir/+wsd/bin/wsd" loop auto off >/dev/null
node -e 'const c=require(process.argv[1]); if(c.automation.loop.auto_use !== false) process.exit(1)' "$tmpdir/+context.json"
git -C "$tmpdir" add +context.json
git -C "$tmpdir" commit -m "chore: toggle loop auto use" >/dev/null

"$tmpdir/+wsd/bin/wsd" loop plan --feature sample-loop >"$plan_out"
grep -q "PASS: WSD loop plan prompt ready" "$plan_out"
test -f "$tmpdir/+wsd/loop/state.json"

"$tmpdir/+wsd/bin/wsd" loop once --feature sample-loop --skip-ci >"$once_out"
grep -q "PASS: WSD loop build prompt ready" "$once_out"

if "$tmpdir/+wsd/bin/wsd" loop run --feature sample-loop --max-iterations 1 >/dev/null 2>&1; then
  echo "FAIL: loop run without --agent-cmd should fail" >&2
  exit 1
fi
