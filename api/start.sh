#!/usr/bin/env sh
set -e
# Always run from the directory that contains main.py (works from repo root or api/).
HERE="$(CDPATH= cd -- "$(dirname "$0")" && pwd)"
cd "$HERE"

# Render sets PORT; local fallback for dev.
exec python -m uvicorn main:app --host 0.0.0.0 --port "${PORT:-8000}"
