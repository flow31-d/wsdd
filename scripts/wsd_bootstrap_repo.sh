#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
target=""
force="false"

usage() {
  cat <<'USAGE'
Usage:
  wsd_bootstrap_repo.sh --target /path/to/repo [--force]

Copies WSD repo templates into a target repository and removes ".template"
suffixes. It does not replace placeholders. Customize generated files before
committing.
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target)
      target="${2:-}"
      shift 2
      ;;
    --force)
      force="true"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 1
      ;;
  esac
done

[[ -n "$target" ]] || { usage; exit 1; }
[[ -d "$target/.git" ]] || { echo "Target is not a Git repository: $target" >&2; exit 1; }

copy_template() {
  local src="$1"
  local rel="${src#"$root/templates/repo/"}"
  local dest="$target/${rel%.template}"
  mkdir -p "$(dirname "$dest")"
  if [[ -e "$dest" && "$force" != "true" ]]; then
    echo "skip existing: ${dest#$target/}"
    return
  fi
  cp "$src" "$dest"
  echo "write: ${dest#$target/}"
}

while IFS= read -r -d '' src; do
  copy_template "$src"
done < <(find "$root/templates/repo" -type f -print0)

chmod +x "$target/scripts/wsd_check.sh" 2>/dev/null || true

echo
echo "WSD templates copied to: $target"
echo "Next steps:"
echo "  1. Replace placeholders {{...}}."
echo "  2. Run: python3 -m json.tool +context.json"
echo "  3. Run: cat +specs/project/STATE.md"
echo "  4. Run: bash scripts/wsd_check.sh --risk L0 ."

