#!/bin/sh
# hermes-hint.sh — Fix Python Environment & Dependency Issues
# Generated: 2026-07-28 07:08 UTC
# Source: r/learnpython pain point analysis via Pullpush API
# Usage: ./hermes-hint.sh
# Safe for beginners • POSIX-compliant • Idempotent
set -e

echo "==> Hermes Terminal Hint — Python Environment Fixer"
echo "    Based on r/learnpython pain points (top signals detected)"
echo ""

# ── Platform detection ──
if [ "$(uname)" = "Darwin" ]; then
    IS_MACOS=1
    echo "→ Detected macOS"
else
    IS_MACOS=0
    echo "→ Detected Linux"
fi
echo ""

# ── Hint 1: pip install fails with SSL/CERT errors ──
echo "── Hint 1: Fix pip SSL/Certificate Errors ──"
if command -v python3 >/dev/null 2>&1; then
    echo "  ✓ python3 found: $(command -v python3)"
    echo "  → If 'pip install' fails with SSL errors, run:"
    echo ""
    echo "    python3 -m pip install --upgrade certifi"
    echo ""
    if [ "$IS_MACOS" -eq 1 ] && [ -f "/Applications/Python 3.*/Install Certificates.command" ]; then
        echo "  → macOS users can also run:"
        echo "    open '/Applications/Python 3.*/Install Certificates.command'"
        echo ""
    fi
else
    echo "  ⚠ python3 not found. Install Python first: https://python.org/downloads/"
fi

# ── Hint 2: requirements.txt installation fails ──
echo "── Hint 2: Fix requirements.txt Installation Issues ──"
if [ -f "requirements.txt" ]; then
    echo "  ✓ requirements.txt found in current directory"
    echo "  → Run: python3 -m pip install -r requirements.txt"
elif [ -f "../requirements.txt" ]; then
    echo "  ✓ requirements.txt found in parent directory"
    echo "  → Run: python3 -m pip install -r ../requirements.txt"
else
    echo "  ℹ No requirements.txt found. If your project has one, run:"
    echo "    python3 -m pip install -r requirements.txt"
fi

# ── Hint 3: Virtual environment best practice ──
echo ""
echo "── Hint 3: Create Isolated Environments ──"
if command -v python3 >/dev/null 2>&1; then
    echo "  → Never pollute your system Python. Always use a venv:"
    echo ""
    echo "    python3 -m venv .venv"
    echo "    source .venv/bin/activate  # macOS/Linux"
    echo "    python3 -m pip install -r requirements.txt"
    echo ""
fi

# ── Hint 4: ModuleNotFoundError quick fix ──
echo "── Hint 4: ModuleNotFoundError? Check these first ──"
echo "  → 1. Is your virtual environment activated? (source .venv/bin/activate)"
echo "  → 2. Did you install the package? (python3 -m pip install <module-name>)"
echo "  → 3. Is the package name correct? (Some use hyphens vs underscores)"
echo ""

# ── Hint 5: Environment diagnostic ──
echo "── Hint 5: Full Environment Diagnostic ──"
if command -v python3 >/dev/null 2>&1; then
    PY_VER=$(python3 --version 2>&1 || echo "unknown")
    PY_PATH=$(command -v python3)
    PIP_PATH=$(python3 -m pip --version 2>/dev/null || echo "pip not available")
    echo "  • Python version: $PY_VER"
    echo "  • Python path: $PY_PATH"
    echo "  • Pip info: $PIP_PATH"
else
    echo "  ⚠ python3 not found — install from https://python.org/downloads/"
fi

echo ""
echo "✓ Done. Run this script anytime you hit Python environment issues."
echo "  More help at: https://reddit.com/r/learnpython"
