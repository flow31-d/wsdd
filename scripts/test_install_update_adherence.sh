#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"

tmpdir="$(mktemp -d)"
help_out="$(mktemp)"
update_out="$(mktemp)"
trap 'rm -rf "$tmpdir" "$help_out" "$update_out"' EXIT

node bin/wsd-method.js install \
  --directory "$tmpdir" \
  --init-git \
  --yes \
  --github skip \
  --tools both \
  --profile generic_node_frontend >/dev/null

rm -rf "$tmpdir/.agents/skills/wsd-relatorio"
rm -f "$tmpdir/.claude/commands/wsd-relatorio.md"
printf "custom loop skill\n" > "$tmpdir/.agents/skills/wsd-loop/SKILL.md"

node -e "const fs=require('fs'); const p=process.argv[1]; const c=require(p); c.version='0.4.9'; fs.writeFileSync(p, JSON.stringify(c, null, 2)+'\n')" "$tmpdir/+wsd/config.json"

"$tmpdir/+wsd/bin/wsd" update --help >"$help_out"
grep -q '^Usage: ./+wsd/bin/wsd update' "$help_out"
node -e "const c=require(process.argv[1]); if(c.version!=='0.4.9') process.exit(1)" "$tmpdir/+wsd/config.json"

"$tmpdir/+wsd/bin/wsd" update >"$update_out"
grep -q 'WSD updated: 0.4.9 ->' "$update_out"
grep -q 'Ensured: .agents/skills, .claude/commands, +wsd/hooks (new files only)' "$update_out"

test -f "$tmpdir/.agents/skills/wsd-relatorio/SKILL.md"
test -f "$tmpdir/.claude/commands/wsd-relatorio.md"
test -f "$tmpdir/+wsd/guides/git.md"
test -x "$tmpdir/+wsd/bin/wsd-report.cjs"
grep -q '^custom loop skill$' "$tmpdir/.agents/skills/wsd-loop/SKILL.md"

(cd "$tmpdir" && ./+wsd/bin/wsd version --json) | node -e "let s=''; process.stdin.on('data', d=>s+=d); process.stdin.on('end',()=>{const r=JSON.parse(s); if(r.status!=='aligned'||r.installed_version!==r.source_version) process.exit(1);})"
