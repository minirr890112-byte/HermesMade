#!/bin/sh
# hermes-hint.sh — Fix pip install -r requirements.txt failures on macOS/Linux/Windows
# Usage: ./hermes-hint-pip-install-requirements-20250716.sh [path/to/requirements.txt]
# Safe for beginners • POSIX-compliant • Idempotent
# Pain source: r/learnpython — "Need help with installing requirements.txt" (28 comments)
set -e

REQUIREMENTS="${1:-requirements.txt}"

echo "==> Hermes Terminal Hint — Installing Python Requirements"
echo "    Pain: pip install -r requirements.txt fails on macOS/Linux"
echo "    Source: r/learnpython"
echo ""

# === Platform Detection ===
if [ "$(uname)" = "Darwin" ]; then
    echo "→ Detected macOS."
    PYTHON="python3"
elif [ "$(uname)" = "Linux" ]; then
    echo "→ Detected Linux."
    PYTHON="python3"
else
    # Windows (MSYS2/Git Bash/Cygwin)
    echo "→ Detected Windows (or unknown OS)."
    PYTHON="python"
fi

# === Prerequisite Checks ===
if ! command -v "$PYTHON" >/dev/null 2>&1; then
    echo "✗ ERROR: $PYTHON is not installed or not in PATH."
    echo "  → macOS: brew install python3"
    echo "  → Linux: sudo apt install python3  (or use your package manager)"
    echo "  → Windows: Install from https://python.org/downloads/"
    exit 1
fi

if ! [ -f "$REQUIREMENTS" ]; then
    echo "✗ ERROR: '$REQUIREMENTS' not found in current directory."
    echo "  → Make sure you're in the right folder (use 'cd' to navigate)"
    echo "  → Or pass the path: $0 /path/to/requirements.txt"
    exit 1
fi

echo "→ Found $PYTHON: $($PYTHON --version 2>&1)"
echo "→ Found requirements file: $REQUIREMENTS"
echo ""

# === PIP Check ===
# Use python3 -m pip (not bare pip) to avoid shell alias conflicts
if ! "$PYTHON" -m pip --version >/dev/null 2>&1; then
    echo "✗ ERROR: pip is not available for $PYTHON."
    echo "  → Run: $PYTHON -m ensurepip --upgrade"
    echo "  → Or: curl -sS https://bootstrap.pypa.io/get-pip.py | $PYTHON"
    exit 1
fi

# === The Fix ===
echo "→ Installing packages from $REQUIREMENTS..."

# Try user-level install first (safest, no sudo needed)
if "$PYTHON" -m pip install --user -r "$REQUIREMENTS" 2>/tmp/pip_error.log; then
    echo ""
    echo "✓ SUCCESS! All packages installed."
else
    PIP_EXIT=$?
    echo ""
    echo "⚠ User-level install failed (exit code: $PIP_EXIT)."
    echo "  Common fixes:"
    echo ""

    # Diagnose common errors
    if grep -qi "certificate\|SSL\|CERTIFICATE_VERIFY" /tmp/pip_error.log; then
        echo "  → SSL Certificate Error detected."
        echo "    Fix: $PYTHON -m pip install --upgrade certifi"
        echo "    Or add --trusted-host: pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org -r $REQUIREMENTS"
    elif grep -qi "ModuleNotFound\|No module named" /tmp/pip_error.log; then
        echo "  → Missing module dependency detected."
        echo "    Fix: $PYTHON -m pip install --upgrade pip setuptools wheel"
        echo "    Then retry: $0 $REQUIREMENTS"
    elif grep -qi "permission denied\|access denied" /tmp/pip_error.log; then
        echo "  → Permission denied. Try with sudo (if you trust the packages):"
        echo "    sudo $PYTHON -m pip install -r $REQUIREMENTS"
        echo "  → Or use a virtual environment (recommended):"
        echo "    $PYTHON -m venv .venv && source .venv/bin/activate && pip install -r $REQUIREMENTS"
    elif grep -qi "externally-managed-environment\|PEP 668" /tmp/pip_error.log; then
        echo "  → Externally-managed Python (PEP 668) detected (common on macOS Homebrew, Debian/Ubuntu)."
        echo "    Best fix: Use a virtual environment:"
        echo "      $PYTHON -m venv .venv"
        echo "      source .venv/bin/activate"
        echo "      pip install -r $REQUIREMENTS"
        echo "    Or override (not recommended): pip install --break-system-packages -r $REQUIREMENTS"
    else
        echo "  → Unknown error. Full output saved to /tmp/pip_error.log"
        echo "  → Try with verbose output: $PYTHON -m pip install -v -r $REQUIREMENTS"
    fi
    echo ""
    echo "  ═════════════════════════════════════════"
    echo "  🔧 The 'Always Works' Solution:"
    echo "  ═════════════════════════════════════════"
    echo "  $PYTHON -m venv .venv"
    echo "  source .venv/bin/activate"
    echo "  pip install -r $REQUIREMENTS"
    echo ""
    exit $PIP_EXIT
fi

# Cleanup
rm -f /tmp/pip_error.log
