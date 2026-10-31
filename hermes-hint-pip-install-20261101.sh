#!/bin/sh
# hermes-hint.sh — Fix "ERROR: Failed building wheel for <pkg>" (pip install)
# Usage: ./hermes-hint.sh [package-name]
# Safe for beginners • POSIX-compliant • Idempotent • No sudo
set -e

PKG="${1:-}"
echo "==> pip wheel-build doctor — fixes 'failed building wheel'"

PY=""
for cand in python3 python; do
  if command -v "$cand" >/dev/null 2>&1; then PY="$cand"; break; fi
done
[ -z "$PY" ] && { echo "✗ Python 3 not found."; exit 1; }

echo "→ Python:  $($PY --version 2>&1)"
echo "→ pip:     $("$PY" -m pip --version 2>/dev/null || echo 'missing')"

# 1. A wheel build usually fails because setuptools/wheel are outdated
echo "→ Upgrading build tools (setuptools, wheel, pip)..."
"$PY" -m pip install --upgrade --user pip setuptools wheel 2>/dev/null || "$PY" -m pip install --upgrade pip setuptools wheel

# 2. Most popular packages (pillow, pygame, numpy, pandas) ship PREBUILT wheels.
#    A source build means either an old Python or missing binary wheel. Prefer the binary:
if [ -n "$PKG" ]; then
  echo "→ Trying prebuilt (binary) wheel for '$PKG' first:"
  "$PY" -m pip install --only-binary :all: "$PKG"     && echo "✓ Installed '$PKG' from a prebuilt wheel."     || echo "⚠ No binary wheel for '$PKG' on this Python/platform — see below."
fi

# 3. If it still needs a source build, check platform compilers
if [ "$(uname)" = "Darwin" ]; then
  echo "→ macOS: ensure Xcode CLT is present (provides the C compiler):"
  echo "      xcode-select --install"
else
  echo "→ Linux: ensure build-essential is present:"
  echo "      sudo apt install build-essential python3-dev  # (Debian/Ubuntu)"
fi

echo "✓ Done. Retry: $PY -m pip install ${PKG:-<package>}"
