#!/usr/bin/env bash
# Orange Pi (Ubuntu Jammy) setup script for One Night Werewolf Dealer
# - Installs system packages (Python, Tk, SDL/ALSA, fonts)
# - Creates local venv and installs Python deps (Pillow + optional audio backends)
# - Prints a quick sanity summary
# Usage on Orange Pi:
#   chmod +x scripts/setup_orangepi.sh
#   ./scripts/setup_orangepi.sh

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_DIR"

# Determine sudo if not root
SUDO=""
if [ "$(id -u)" -ne 0 ]; then
  if command -v sudo >/dev/null 2>&1; then
    SUDO="sudo"
  else
    echo "[!] Please run as root or install sudo."
    exit 1
  fi
fi

# 1) System packages
$SUDO apt update -y
$SUDO apt install -y \
  python3 python3-venv python3-pip python3-tk git \
  libsdl2-2.0-0 libsdl2-image-2.0-0 libsdl2-mixer-2.0-0 libsdl2-ttf-2.0-0 \
  libasound2 libasound2-data libmpg123-0 ffmpeg alsa-utils \
  fonts-noto-cjk

# 2) Python venv
if [ ! -d .venv ]; then
  python3 -m venv .venv
fi
# shellcheck disable=SC1091
source .venv/bin/activate
python -m pip install --upgrade pip wheel

# 3) Python deps: Pillow (required) + pygame / playsound (optional)
python -m pip install -q pillow
# Try pygame first (preferred). If it fails, continue.
python -m pip install -q pygame || echo "[!] pygame install failed, continuing without it"
# playsound fallback (blocking, no fade). If it fails, continue.
python -m pip install -q 'playsound==1.2.2' || echo "[!] playsound install failed, continuing without it"

# 4) Quick sanity check
python - <<'PY'
import sys
ok = True
try:
    import tkinter  # noqa: F401
except Exception as e:
    ok = False
    print('[X] tkinter import failed:', e)
try:
    from PIL import Image  # noqa: F401
except Exception as e:
    ok = False
    print('[X] Pillow import failed:', e)
try:
    import pygame  # noqa: F401
    print('[i] pygame available')
except Exception:
    print('[i] pygame not available (optional)')
print('[i] Python:', sys.version)
print('[i] Setup OK' if ok else '[!] Setup has issues (see above)')
PY

cat <<TIP

[✓] Environment prepared.

To run the app on Orange Pi (with a graphical desktop):
  cd "$REPO_DIR"
  source .venv/bin/activate
  python wolf/main.py

Notes:
- Ensure you're on a desktop/X session (not pure SSH) to show Tk window.
- Sounds are optional. Put MP3 files under ./sounds (BGM recommended name: "Mysterious Light.mp3").
- Role images should be in ./images/roles (already included in repo).
TIP
