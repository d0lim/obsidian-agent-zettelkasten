#!/usr/bin/env bash
set -euo pipefail

LANG_CODE="${1:?Usage: switch-lang.sh <en|ko>}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

[[ "$LANG_CODE" =~ ^(en|ko)$ ]] || { echo "Error: use 'en' or 'ko'"; exit 1; }

I18N_DIR="$ROOT/.i18n/$LANG_CODE"
[[ -d "$I18N_DIR" ]] || { echo "Error: $I18N_DIR not found"; exit 1; }

count=0
while IFS= read -r src; do
  rel="${src#$I18N_DIR/}"
  dest="$ROOT/$rel"
  mkdir -p "$(dirname "$dest")"
  cp "$src" "$dest"
  echo "  $rel"
  ((count++))
done < <(find "$I18N_DIR" -name "*.md" -type f | sort)

echo "$LANG_CODE" > "$ROOT/.language"
echo "Switched to '$LANG_CODE' ($count files)"
