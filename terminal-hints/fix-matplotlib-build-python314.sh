#!/bin/sh
# fix-matplotlib-build-python314.sh — fix "Failed to build 'matplotlib' when installing build dependencies"
# Usage: sh fix-matplotlib-build-python314.sh
# Safe for beginners • POSIX-compliant • Idempotent • No sudo, no destructive ops
#
# Root cause: Python 3.14 is new enough that matplotlib has not yet shipped a
# prebuilt wheel for it. pip falls back to compiling matplotlib from source,
# which fails unless you have a full C build toolchain installed.
set -u

echo "==> matplotlib build-failure helper — checks your Python version and shows the safe fix"

# Locate a Python interpreter
PY=""
if command -v python3 >/dev/null 2>&1; then
  PY="python3"
elif command -v python >/dev/null 2>&1; then
  PY="python"
fi

if [ -z "$PY" ]; then
  echo "✗ No Python interpreter found on PATH."
  echo "→ Install Python 3.12 or 3.13 from https://www.python.org/downloads/"
  echo "  (matplotlib ships prebuilt wheels for both — no compiler needed)."
  exit 1
fi

# Read the major.minor version in a POSIX-safe way
VERSION=$("$PY" -c 'import sys; print("%d.%d" % sys.version_info[:2])' 2>/dev/null) || VERSION=""
if [ -z "$VERSION" ]; then
  echo "✗ Could not read Python version from '$PY'."
  exit 1
fi

MAJOR=$(printf '%s' "$VERSION" | cut -d. -f1)
MINOR=$(printf '%s' "$VERSION" | cut -d. -f2)

echo "→ Detected Python $VERSION"

# Python 3.14+ : no stable matplotlib wheels yet -> source build fails
if [ "$MAJOR" -ge 3 ] && [ "$MINOR" -ge 14 ]; then
  echo "⚠ Python $VERSION is too new for matplotlib's prebuilt wheels right now."
  echo ""
  echo "→ Recommended fix (zero compiler setup):"
  echo "  1. Install Python 3.12 or 3.13: https://www.python.org/downloads/"
  echo "  2. Re-run your install with that interpreter:"
  echo "     python3.13 -m pip install matplotlib"
  echo ""
  echo "→ If you must stay on $VERSION, try a wheel-only install (will tell you if no wheel exists):"
  echo "     $PY -m pip install --only-binary :all: matplotlib"
  echo ""
  echo "  Note: if that errors with 'no matching distribution', no wheel exists yet for $VERSION."
else
  echo "✓ Python $VERSION is recent enough — the failure is likely a missing compiler."
  echo "→ Try a wheel-only install (avoids compiling from source entirely):"
  echo "     $PY -m pip install --only-binary :all: matplotlib"
  echo ""
  echo "→ If that still fails, upgrade pip and retry:"
  echo "     $PY -m pip install --upgrade pip"
  echo "     $PY -m pip install matplotlib"
fi

echo ""
echo "✓ Done. If you still see 'Failed to build matplotlib', the fastest path is Python 3.13."
