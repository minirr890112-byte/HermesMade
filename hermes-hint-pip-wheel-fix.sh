#!/bin/sh
# hermes-hint-pip-wheel-fix.sh — recover from pip "error: failed building wheel for <pkg>"
# Usage: ./hermes-hint-pip-wheel-fix.sh [package-name]   (default: pygame)
# Safe for beginners • POSIX-compliant • Idempotent • No sudo required

PKG="${1:-pygame}"

echo "==> pip wheel build fixer — installing '${PKG}' without compiling from source"
echo

# 1. Confirm python3 exists before doing anything
if ! command -v python3 >/dev/null 2>&1; then
  echo "✗ python3 not found. Install Python 3 first: https://python.org/downloads/"
  exit 1
fi
echo "→ Python: $(command -p python3 --version)"

# 2. Refresh the build toolchain (harmless and idempotent to re-run)
echo "→ Upgrading pip / setuptools / wheel..."
command -p python3 -m pip install --user --upgrade pip setuptools wheel 2>/dev/null   || command -p python3 -m pip install --upgrade pip setuptools wheel

# 3. Force a PREBUILT wheel — this skips the C-source build that normally fails
echo "→ Installing '${PKG}' from a prebuilt wheel (no C compiler needed)..."
if command -p python3 -m pip install --only-binary :all: "${PKG}"; then
  echo "✓ '${PKG}' installed from a prebuilt wheel."
else
  echo "✗ No prebuilt wheel available for '${PKG}' on this Python version."
  echo "  Try a newer Python (3.11+), or run:"
  echo "    python3 -m pip install --upgrade pip setuptools wheel"
  echo "    python3 -m pip install ${PKG}"
fi

echo
echo "✓ Done. If '${PKG}' still won't install, paste the full error to r/learnpython."
