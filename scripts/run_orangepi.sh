#!/usr/bin/env bash
# Simple runner for Orange Pi
set -euo pipefail
REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_DIR"

# Detect DISPLAY for Tk GUI
if [ -z "${DISPLAY-}" ]; then
	cat <<'MSG'
[X] No DISPLAY detected. Tk GUI cannot start in a pure SSH session.

Run one of the following:
1) Plug HDMI and run from a local desktop terminal; or
2) Use SSH with X11 forwarding (ssh -Y) and run a local X server (e.g. VcXsrv on Windows);
3) Use a remote desktop (xrdp) session and start from there.

Tips (server side):
	apt install -y xauth
	ensure /etc/ssh/sshd_config has: X11Forwarding yes
	systemctl restart ssh

Tips (Windows client):
	Install & start VcXsrv (XLaunch -> Multiple windows -> Disable access control),
	then in PowerShell: ssh -Y root@<IP>
MSG
	exit 1
fi

source .venv/bin/activate
exec python wolf/main.py
