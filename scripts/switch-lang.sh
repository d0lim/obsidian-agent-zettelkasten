#!/usr/bin/env bash
set -euo pipefail

LANG_CODE="${1:?Usage: switch-lang.sh <en|ko>}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

# Validate
[[ "$LANG_CODE" =~ ^(en|ko)$ ]] || { echo "Error: use 'en' or 'ko'"; exit 1; }

# Find all source files for the target language
count=0
while IFS= read -r src; do
  dest="${src%.${LANG_CODE}.md}.md"
  cp "$src" "$dest"
  echo "  $src → $dest"
  ((count++))
done < <(find "$ROOT" -name "*.${LANG_CODE}.md" \
  -not -path "*/.obsidian/*" \
  -not -path "*/node_modules/*" \
  -not -path "*/scripts/*" | sort)

echo "$LANG_CODE" > "$ROOT/.language"
echo "Switched to '$LANG_CODE' ($count files)"
