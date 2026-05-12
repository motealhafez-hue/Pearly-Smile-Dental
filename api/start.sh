#!/usr/bin/env sh
set -e

# Render provides $PORT
exec python -m uvicorn main:app --host 0.0.0.0 --port "${PORT:-8000}"
