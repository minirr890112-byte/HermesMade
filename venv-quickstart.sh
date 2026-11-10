#!/bin/sh
# venv-quickstart.sh — one-command Python virtual environment setup
# Usage: ./venv-quickstart.sh [project-dir]
# Safe for beginners • POSIX-compliant • Idempotent
set -e

echo "==> venv-quickstart — create a virtual environment & install dependencies"

# Detect Python 3
if command -v python3 >/dev/null 2>&1; then
    PY=python3
elif command -v python >/dev/null 2>&1; then
    PY=python
else
    echo "✗ Python 3 not found. Install it from python.org or your package manager."
    exit 1
fi

# Resolve target project directory (default: current dir)
DIR="${1:-.}"
cd "$DIR"
VENV=".venv"

# Pick venv layout by platform
case "$(uname)" in
    Darwin|Linux)
        VENV_PY="$VENV/bin/python"
        ACTIVATE="$VENV/bin/activate"
        ;;
    *)
        # Windows (Git Bash / MSYS)
        VENV_PY="$VENV/Scripts/python.exe"
        ACTIVATE="$VENV/Scripts/activate"
        ;;
esac

# Create venv (idempotent)
if [ -d "$VENV" ]; then
    echo "→ Reusing existing virtual environment at $VENV"
else
    echo "→ Creating virtual environment in $VENV ..."
    "$PY" -m venv "$VENV"
fi

# Install dependencies if present
if [ -f "requirements.txt" ]; then
    echo "→ Installing dependencies from requirements.txt ..."
    "$VENV_PY" -m pip install -r requirements.txt
else
    echo "→ No requirements.txt found — skipping dependency install."
fi

echo ""
echo "✓ Done! Activate your environment with:"
echo "      source $ACTIVATE"
echo "  (Windows PowerShell:  .\\$VENV\\Scripts\\Activate.ps1)"
