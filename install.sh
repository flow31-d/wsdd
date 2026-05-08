#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v node >/dev/null 2>&1; then
  echo "FAIL: Node.js v20+ is required for WSD install." >&2
  exit 1
fi

node "$script_dir/bin/wsd-method.js" install "$@"
