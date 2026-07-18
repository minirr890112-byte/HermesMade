#!/bin/sh
# hermes-pip-install-fix.sh — Fix "pip install: illegal option -- r" on macOS
# Usage: ./hermes-pip-install-fix.sh [requirements-file]
# Safe for beginners • POSIX-compliant • Idempotent
# Auto-detects pip vs system install collision and applies correct fix
set -e

echo "==> Hermes Pip Install Fix — resolves 'install: illegal option -- r'"
echo ""

REQ_FILE="${1:-requirements.txt}"

# --- Platform Detection ---
if [ "$(uname)" = "Darwin" ]; then
    echo "→ Detected macOS"
    OS="macos"
elif [ "$(uname)" = "Linux" ]; then
    echo "→ Detected Linux"
    OS="linux"
else
    echo "→ Detected $(uname)"
    OS="other"
fi

# --- Diagnose: is 'pip' really pip, or is it aliased to /usr/bin/install? ---
echo "→ Checking pip command..."
PIP_REAL=$(command -v pip 2>/dev/null || echo "")
PIP3_REAL=$(command -v pip3 2>/dev/null || echo "")

if [ -z "$PIP_REAL" ] && [ -z "$PIP3_REAL" ]; then
    echo "✗ pip is not installed. Install it first:"
    echo "   python3 -m ensurepip --user"
    exit 1
fi

# --- Check for requirements file ---
if [ ! -f "$REQ_FILE" ]; then
    echo "! Warning: '$REQ_FILE' not found in current directory."
    echo "  Usage: $0 <path-to-requirements.txt>"
    echo ""
    echo "  If you're just getting started, create one with:"
    echo "    pip freeze > requirements.txt"
    exit 1
fi

echo "→ Found $REQ_FILE"
echo ""

# --- THE FIX: Use python3 -m pip (bypasses aliases) ---
echo "→ Installing dependencies from $REQ_FILE using python3 -m pip..."
echo ""

if command -v python3 >/dev/null 2>&1; then
    # Use python3 -m pip to avoid alias collision
    python3 -m pip install -r "$REQ_FILE"
else
    echo "✗ python3 not found. Trying python..."
    command -p python -m pip install -r "$REQ_FILE"
fi

echo ""
echo "✓ Dependencies installed successfully!"
echo ""
echo "Pro tip: Always use 'python3 -m pip' instead of 'pip' on macOS to avoid"
echo "collisions with the system /usr/bin/install command."
echo ""
echo "To make this permanent, add to your ~/.zshrc or ~/.bashrc:"
echo "  alias pip='python3 -m pip'"
