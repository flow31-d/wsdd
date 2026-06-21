#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"

tmpdir="$(mktemp -d)"
logfile="$(mktemp)"
trap 'rm -rf "$tmpdir" "$logfile"' EXIT

node bin/wsd-method.js install \
  --directory "$tmpdir" \
  --init-git \
  --yes \
  --github skip \
  --tools codex \
  --profile generic_node_frontend >/dev/null

git -C "$tmpdir" config user.email wsd@example.invalid
git -C "$tmpdir" config user.name "WSD Test"
git -C "$tmpdir" add -A
git -C "$tmpdir" commit -m "chore: initial wsd" >/dev/null

rm -rf "$tmpdir/docs"
cat > "$tmpdir/scripts/wsd_docs_check.sh" <<'SH'
#!/usr/bin/env bash
set -euo pipefail
echo "docs check ran" > .docs-check-ran
SH
chmod +x "$tmpdir/scripts/wsd_docs_check.sh"

printf "finish clean close\n" > "$tmpdir/demo.txt"

"$tmpdir/+wsd/bin/wsd" finish >"$logfile"

status="$(git -C "$tmpdir" status --short --untracked-files=all)"
if [[ -n "$status" ]]; then
  echo "FAIL: wsd finish left dirty worktree" >&2
  printf "%s\n" "$status" >&2
  cat "$logfile" >&2
  exit 1
fi

git -C "$tmpdir" log -1 --format=%s | grep -q '^chore(wsd): finish session$'
test -f "$tmpdir/+specs/HANDOFF.md"
grep -q 'Estado final esperado: limpo apos commit automatico do wsd finish' "$tmpdir/+specs/HANDOFF.md"
grep -q 'WSD docs check: PASS' "$tmpdir/+specs/HANDOFF.md"
grep -q 'docs check ran' "$tmpdir/.docs-check-ran"
grep -q 'ok: WSD docs check' "$logfile"
! grep -q 'Estado: sujo' "$tmpdir/+specs/HANDOFF.md"
grep -q 'PASS: WSD Finish completo - worktree limpo e gates aprovados' "$logfile"
