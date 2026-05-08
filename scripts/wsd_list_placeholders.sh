#!/usr/bin/env bash
set -euo pipefail

target="${1:-.}"

cd "$target"
rg -n "\{\{[A-Z0-9_][A-Z0-9_]*\}\}" . || true

