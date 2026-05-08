#!/bin/bash
# WSD PreToolUse hook — reads .context.json and blocks forbidden_paths

TOOL_INPUT=$(cat)
FILE_PATH=$(echo "$TOOL_INPUT" | jq -r \
  '.tool_input.file_path // .tool_input.path // ""' 2>/dev/null)

# Release non-file tools immediately
[ -z "$FILE_PATH" ] && exit 0

# Release if no .context.json
[ ! -f ".context.json" ] && exit 0

# Check forbidden_paths
FORBIDDEN=$(jq -r '.permissions.forbidden_paths[]? // empty' .context.json 2>/dev/null)
while IFS= read -r fp; do
  [ -z "$fp" ] && continue
  if [[ "$FILE_PATH" == *"$fp"* ]]; then
    echo "WSD BLOCK: '$FILE_PATH' está em forbidden_paths ($fp). Verifique .context.json antes de prosseguir." >&2
    exit 2
  fi
done <<< "$FORBIDDEN"

exit 0
