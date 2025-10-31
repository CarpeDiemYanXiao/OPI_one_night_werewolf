#!/usr/bin/env bash
# Simple runner for Orange Pi
set -euo pipefail
REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_DIR"
source .venv/bin/activate
exec python wolf/main.py
