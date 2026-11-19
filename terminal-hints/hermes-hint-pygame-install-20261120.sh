#!/bin/sh
# hermes-hint-pygame-install.sh — fix "pygame won't install" on Python 3.13+
# Usage: ./hermes-hint-pygame-install.sh
# Safe for beginners • POSIX-compliant • Idempotent • No sudo, no destructive ops
set -e

echo "==> pygame install fixer — Python 3.13+ has no prebuilt pygame wheel"

PY="python3"
if ! command -v python3 >/dev/null 2>&1; then
  PY="python"
fi
if ! command -v "$PY" >/dev/null 2>&1; then
  echo "✗ No Python interpreter found. Install Python first: https://python.org"
  exit 1
fi

echo "→ Detected interpreter: $PY ($($PY --version 2>&1))"

# Already installed? Verify import and exit early.
if $PY -c "import pygame" >/dev/null 2>&1; then
  echo "✓ pygame is already importable. You're good to go."
  exit 0
fi

echo "→ Trying pygame-ce (community edition — drop-in replacement with wheels for new Python)..."

if $PY -m pip install --user pygame-ce 2>/dev/null; then
  if $PY -c "import pygame; print('pygame', pygame.version.ver, 'OK')" 2>/dev/null; then
    echo "✓ Done. pygame-ce installed. Your existing 'import pygame' code works unchanged."
    exit 0
  fi
fi

echo "→ pygame-ce failed. Trying pre-release wheel (pip install pygame --pre)..."
if $PY -m pip install --user pygame --pre 2>/dev/null; then
  if $PY -c "import pygame" >/dev/null 2>&1; then
    echo "✓ Done. pygame (pre-release) installed."
    exit 0
  fi
fi

echo ""
echo "⚠ Still failing? Your Python is too new for pygame's stable wheel."
echo "   Safest fix: use a Python version pygame supports (3.12 or lower)."
echo "   macOS/Linux:   brew install python@3.12   (or use pyenv)"
echo "   Windows:       download 3.12 from https://www.python.org/downloads/"
echo "   Then re-run:   python3.12 -m pip install pygame"
exit 1
