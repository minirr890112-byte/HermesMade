#!/bin/sh
# hermes-hint-pip-not-on-path.sh — Diagnose & fix "python/pip: command not found" after install
# Usage: ./hermes-hint-pip-not-on-path-20261004.sh
# Safe for beginners • POSIX-compliant • Idempotent • No sudo
# Pain source: r/learnpython — pip installs OK but the command is "not recognized / not on PATH"
set -e

echo "==> Hermes Terminal Hint — 'command not found' after pip install"
echo "    Pain: python/pip is not recognized, or a pip-installed tool isn't on PATH"
echo "    Source: r/learnpython (scan 2026-10-04)"
echo ""

# === Platform detection ===
UNAME="$(uname)"
if [ "$UNAME" = "Darwin" ]; then
    OS="macOS"
elif [ "$UNAME" = "Linux" ]; then
    OS="Linux"
else
    OS="Windows"
fi
echo "→ Detected: $OS"

# === Step 1: find a working Python ===
PYTHON=""
for cand in python3 python py; do
    if command -v "$cand" >/dev/null 2>&1; then
        PYTHON="$cand"
        break
    fi
done

if [ -z "$PYTHON" ]; then
    echo "✗ No Python found on PATH."
    if [ "$OS" = "macOS" ]; then
        echo "  → Install: brew install python3"
        echo "  → Or download from https://python.org/downloads/"
    elif [ "$OS" = "Linux" ]; then
        echo "  → Install: sudo apt install python3  (Debian/Ubuntu)"
        echo "  → Or download from https://python.org/downloads/"
    else
        echo "  → Install from https://python.org/downloads/"
        echo "  → IMPORTANT: tick 'Add Python to PATH' in the installer!"
    fi
    exit 1
fi
echo "→ Python found: $PYTHON ($($PYTHON --version 2>&1))"

# === Step 2: check pip ===
if ! "$PYTHON" -m pip --version >/dev/null 2>&1; then
    echo "✗ pip not available for $PYTHON."
    echo "  → Run: $PYTHON -m ensurepip --upgrade"
    echo "  → Or:  curl -sS https://bootstrap.pypa.io/get-pip.py | $PYTHON"
    exit 1
fi
echo "→ pip OK: $($PYTHON -m pip --version 2>&1 | head -1)"

# === Step 3: the key insight ===
echo ""
echo "The #1 cause of 'command not found' is that pip installs tools into a"
echo "'Scripts'/'bin' folder that is NOT on your PATH."
echo ""

if [ "$OS" = "Windows" ]; then
    echo "→ On Windows, use the 'py' launcher or 'python -m <module>' instead:"
    echo "    py -m pip install <package>"
    echo "    py -m <module>"
    echo "  If you must run a bare command (e.g. 'pytest'), add this to PATH:"
    echo "    %LOCALAPPDATA%\\Programs\\Python\\Python3xx\\Scripts"
    echo "  (replace Python3xx with your actual version, e.g. Python314)"
else
    echo "→ On macOS/Linux, prefer:"
    echo "    $PYTHON -m pip install <package>"
    echo "    $PYTHON -m <module>"
    echo "  This avoids PATH/alias problems entirely."
fi

echo ""
echo "✓ Done. Quick reference:"
echo "    $PYTHON -m pip install <package>   # install a package"
echo "    $PYTHON -m <module>                # run a pip-installed tool"
