#!/bin/sh
# hermes-hint-pip-wheel-fix.sh — Fix "pip install <pkg>" failing on a source build
# Usage: ./hermes-hint-pip-wheel-fix.sh [package]
# Safe for beginners • POSIX-compliant • Idempotent • No sudo
#
# Fixes errors like:
#   "Using cached <pkg>-X.Y.Z.tar.gz"
#   "Preparing metadata (pyproject.toml) ... error"
#   "error: subprocess-exited-with-error"
#   "WARNING: Failed to activate VS environment ... vswhere.exe"
#
# Root cause: pip can't find a prebuilt wheel for your Python version, so it
# falls back to compiling from source — which fails without a C/C++ compiler.

set -u

PKG="${1:-matplotlib}"
BASE="${PKG%%[=<>!~ ]*}"

echo "==> Python wheel installer — install '$PKG' without compiling from source"

# --- Locate Python ---
PY=""
for c in python3 python py; do
    if command -v "$c" >/dev/null 2>&1; then
        PY="$c"; break
    fi
done
if [ -z "$PY" ]; then
    echo "!! No Python found on PATH. Install from https://python.org/downloads/"
    exit 1
fi
echo "-> Python: $($PY --version 2>&1)"

# --- Platform note ---
case "$(uname -s)" in
    Darwin) echo "-> OS: macOS" ;;
    Linux)  echo "-> OS: Linux" ;;
    *)      echo "-> OS: $(uname -s) (Windows users: run this in Git Bash or WSL)" ;;
esac

# --- 1. Upgrade pip so it can see the latest wheels ---
echo "-> Upgrading pip (old pip can't see recently-published wheels)..."
"$PY" -m pip install --upgrade pip || true

# --- 2. Install from a prebuilt wheel only (never compile from source) ---
echo "-> Installing '$PKG' (binary-only, no source build)..."
if "$PY" -m pip install --only-binary :all: "$PKG"; then
    echo ""
    echo "OK. '$PKG' installed from a prebuilt wheel."
    echo "Verify it works: $PY -c \"import $BASE; print($BASE.__version__)\"" 
    exit 0
fi

# --- 3. If no wheel exists, here's why and how to fix it ---
echo ""
echo "No prebuilt wheel found for your Python version. Try in this order:"
echo "  1. Your Python may be too new (wheels can lag releases by weeks)."
echo "     Check https://pypi.org/project/$PKG/#files for a wheel matching"
echo "     your Python (e.g. cp312, cp313). Use a Python version that has"
echo "     wheels, or wait for one to be published."
echo "  2. conda/miniconda users:  conda install $PKG"
echo "  3. Confirm your terminal uses the same Python as your editor/IDE:"
echo "       $PY -c 'import sys; print(sys.executable)'"
echo "  4. Download a matching .whl from the files page above, then:"
echo "       $PY -m pip install /path/to/downloaded.whl"
exit 1
