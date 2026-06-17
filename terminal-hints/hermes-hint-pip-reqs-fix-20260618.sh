#!/bin/sh
# hermes-hint-pip-reqs-fix.sh — Safely install Python requirements.txt on any OS
# Usage: ./hermes-hint-pip-reqs-fix.sh [path/to/requirements.txt]
# Auto-detected from r/learnpython pain point (June 2026)
# Safe for beginners • POSIX-compliant • Idempotent • No sudo
set -e

REQS_FILE="${1:-requirements.txt}"

echo "==> Hermes Pain Fix: Installing Python requirements"
echo "→ Fixes: 'pip install -r requirements.txt' failing on macOS/Linux"
echo "→ Pain source: r/learnpython — new users hitting pip install errors"
echo ""

# ── Check Python exists ──
if ! command -v python3 >/dev/null 2>&1; then
    echo "✗ Python 3 not found. Please install Python first:"
    if [ "$(uname)" = "Darwin" ]; then
        echo "  brew install python3"
    else
        echo "  sudo apt install python3 python3-pip  # Debian/Ubuntu"
        echo "  sudo dnf install python3 python3-pip  # Fedora"
    fi
    exit 1
fi

echo "→ Python found: $(command -v python3)"
echo "→ Python version: $(python3 --version 2>&1)"

# ── Check requirements.txt exists ──
if [ ! -f "$REQS_FILE" ]; then
    echo "✗ File '${REQS_FILE}' not found in current directory."
    echo "  Usage: $0 [path/to/requirements.txt]"
    echo "  Example: $0 ./my-project/requirements.txt"
    exit 1
fi

echo "→ Requirements file: ${REQS_FILE}"
echo ""

# ── Detect platform ──
if [ "$(uname)" = "Darwin" ]; then
    echo "→ Detected macOS. Checking pip availability..."
    
    # Ensure pip is available (some macOS Python installs miss it)
    if ! python3 -m pip --version >/dev/null 2>&1; then
        echo "→ pip not found via python3 -m pip."
        if command -v brew >/dev/null 2>&1; then
            echo "→ Installing pip via Homebrew..."
            brew install python3 2>/dev/null || true
        fi
        # Try again
        if ! python3 -m pip --version >/dev/null 2>&1; then
            echo "→ Running ensurepip..."
            python3 -m ensurepip --user 2>/dev/null || true
        fi
    fi
    
    echo "→ Using: python3 -m pip install --user -r ${REQS_FILE}"
    python3 -m pip install --user -r "$REQS_FILE"
else
    echo "→ Detected Linux. Using standard pip..."
    echo "→ Using: python3 -m pip install -r ${REQS_FILE}"
    python3 -m pip install -r "$REQS_FILE"
fi

echo ""
echo "✓ Done! All packages from ${REQS_FILE} installed successfully."
echo ""
echo "── Tips ──"
echo "• Always use 'python3 -m pip' instead of bare 'pip' to avoid alias issues"
echo "• If you still see errors, try: python3 -m pip install --user -r ${REQS_FILE}"
echo "• To create a virtual environment instead: python3 -m venv venv && source venv/bin/activate"
