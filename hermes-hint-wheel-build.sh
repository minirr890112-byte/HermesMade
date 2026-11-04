#!/bin/sh
# hermes-hint-wheel-build.sh — Fix "Failed building wheel" / "can't build the wheel" on pip install
# Usage: ./hermes-hint-wheel-build.sh
# Safe for beginners • POSIX-compliant • Idempotent • No sudo
set -e

echo "==> pygame install fix — 'can't build the wheel' / 'Failed building wheel for pygame'"

if command -v python3 >/dev/null 2>&1; then
  PY=python3
elif command -v python >/dev/null 2>&1; then
  PY=python
else
  echo "✗ No Python found. Install Python 3 from https://python.org first."
  exit 1
fi

echo "→ Python: $($PY --version 2>&1)"

# Root cause: pip downloaded pygame-*.tar.gz (source) because no prebuilt
# wheel exists for your Python version, then stalled trying to compile it.
echo "→ Step 1/2 — upgrading pip + setuptools + wheel..."
"$PY" -m pip install --upgrade pip setuptools wheel

echo "→ Step 2/2 — installing pygame-ce (maintained fork with prebuilt wheels)..."
"$PY" -m pip install pygame-ce

echo ""
echo "✓ Done. pygame-ce installs as the 'pygame' module — just 'import pygame'."
echo "  If you specifically need classic pygame: $PY -m pip install pygame==2.1.3"
