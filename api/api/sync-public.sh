#!/usr/bin/env sh
# Sync static site from repo parent into api/public (run from api/).
set -e
API_DIR="$(CDPATH= cd -- "$(dirname "$0")" && pwd)"
SITE_ROOT="${1:-$(dirname "$API_DIR")}"
PUB="$API_DIR/public"
if [ ! -f "$SITE_ROOT/index.html" ]; then
  echo "No index.html at $SITE_ROOT" >&2
  exit 1
fi
rm -rf "$PUB"
mkdir -p "$PUB"
for ext in html css js txt xml; do
  find "$SITE_ROOT" -maxdepth 1 -type f -name "*.$ext" -exec cp -f {} "$PUB/" \;
done
if [ -d "$SITE_ROOT/Pictures" ]; then
  cp -R "$SITE_ROOT/Pictures" "$PUB/"
fi
echo "Synced $SITE_ROOT -> $PUB"
