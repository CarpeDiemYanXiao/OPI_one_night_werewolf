#!/usr/bin/env bash
# Install only missing system and Python dependencies for Orange Pi
# Usage:
#   chmod +x scripts/install_missing_deps.sh
#   ./scripts/install_missing_deps.sh [--test-audio] [--venv]
# Options:
#   --test-audio   : after installing, run a short audio test (speaker-test or play sample)
#   --venv         : create and populate .venv with Python deps if missing

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_DIR"

TEST_AUDIO=false
DO_VENV=false
for arg in "$@"; do
  case "$arg" in
    --test-audio) TEST_AUDIO=true ;; 
    --venv) DO_VENV=true ;; 
    *) echo "[i] Unknown arg: $arg" ;; 
  esac
done

# Determine sudo
SUDO=""
if [ "$(id -u)" -ne 0 ]; then
  if command -v sudo >/dev/null 2>&1; then
    SUDO="sudo"
  else
    echo "[!] Please run as root or install sudo." >&2
    exit 1
  fi
fi

echo "[i] Checking required system packages..."

PKGS=(
  python3 python3-venv python3-pip python3-tk git
  libsdl2-2.0-0 libsdl2-image-2.0-0 libsdl2-mixer-2.0-0 libsdl2-ttf-2.0-0
  libasound2 libasound2-data libmpg123-0 ffmpeg alsa-utils
  pulseaudio pavucontrol fonts-noto-cjk
)

MISSING_APT=()
for p in "${PKGS[@]}"; do
  if ! dpkg -s "$p" >/dev/null 2>&1; then
    MISSING_APT+=("$p")
  fi
done

if [ ${#MISSING_APT[@]} -eq 0 ]; then
  echo "[i] All required apt packages already installed."
else
  echo "[i] Missing apt packages: ${MISSING_APT[*]}"
  $SUDO apt update -y
  $SUDO apt install -y "${MISSING_APT[@]}"
fi

if [ "$DO_VENV" = true ]; then
  echo "[i] Ensuring .venv exists and Python deps are installed..."
  if [ ! -d .venv ]; then
    python3 -m venv .venv
  fi
  # shellcheck disable=SC1091
  source .venv/bin/activate
  python -m pip install --upgrade pip wheel
  PIP_PKGS=(pillow pygame 'playsound==1.2.2')
  for pkg in "${PIP_PKGS[@]}"; do
    if ! python -c "import importlib,sys; sys.exit(0 if importlib.util.find_spec('${pkg%%=*}') else 1)" >/dev/null 2>&1; then
      echo "[i] Installing Python package: $pkg"
      python -m pip install -q "$pkg" || echo "[!] Failed to install $pkg"
    else
      echo "[i] Python package present: ${pkg%%=*}"
    fi
  done
fi

echo "[i] Ensuring user is in 'audio' group (may need logout/login)"
ORIG_USER="${SUDO_USER:-$(whoami)}"
$SUDO usermod -aG audio "$ORIG_USER" || true

if [ "$TEST_AUDIO" = true ]; then
  echo
  echo "[i] Running audio diagnostics"
  echo "[i] aplay -l output:"
  aplay -l || true
  if [ -f /usr/share/sounds/alsa/Front_Center.wav ]; then
    echo "[i] Playing system sample..."
    aplay /usr/share/sounds/alsa/Front_Center.wav || true
  else
    echo "[i] No sample found; running short speaker-test"
    speaker-test -c2 -t sine -f 440 -l 1 || true
  fi
  echo "[i] Audio test finished. If you couldn't hear anything, check 'alsamixer' and output device."
fi

echo "[✓] install_missing_deps.sh completed"
