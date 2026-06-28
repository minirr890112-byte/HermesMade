#!/bin/sh
# hermes-hint.sh — Fix "pip install: illegal option -- r" on macOS
# Usage: ./hermes-hint.sh [requirements-file]
# Safe for beginners • POSIX-compliant • Idempotent
#
# Problem: Running `pip install -r requirements.txt` on macOS gives:
#   "install: illegal option -- r"
# Cause: macOS ships /usr/bin/install, and if `pip` resolves to `install`
#        (common with Homebrew/coreutils aliases), the wrong binary runs.
# Solution: Use `python3 -m pip` which bypasses shell aliases entirely,
#            or use `command -p pip` to force POSIX-standard PATH.
set -e

echo "==> Hermes Hint — Fix 'pip install: illegal option -- r' on macOS"
echo ""
echo "   Problem: pip install -r gives 'install: illegal option -- r'"
echo "   Cause:   Shell resolves 'pip' to macOS's /usr/bin/install"
echo "   Fix:     Use python3 -m pip instead of bare pip"
echo ""

if [ "$(uname)" = "Darwin" ]; then
    echo "→ Detected macOS. Applying macOS-safe fix..."
    REQ_FILE="${1:-requirements.txt}"

    if [ ! -f "$REQ_FILE" ]; then
        echo "⚠  File '$REQ_FILE' not found."
        echo "   Usage: ./hermes-hint.sh [path/to/requirements.txt]"
        exit 1
    fi

    echo "→ Installing from: $REQ_FILE"
    # Use python3 -m pip to bypass shell aliases
    if command -v python3 >/dev/null 2>&1; then
        python3 -m pip install -r "$REQ_FILE"
        echo ""
        echo "✓ Done! Packages installed successfully."
        echo ""
        echo "💡 Tip: To avoid this in the future, always use:"
        echo "   python3 -m pip install -r requirements.txt"
        echo ""
        echo "   Or add this to your ~/.zshrc:"
        echo '   alias pip="python3 -m pip"'
    else
        echo "✗ python3 not found. Please install Python 3 first:"
        echo "   brew install python3"
        exit 1
    fi
else
    echo "→ Not on macOS. Using standard pip command..."
    REQ_FILE="${1:-requirements.txt}"
    if [ ! -f "$REQ_FILE" ]; then
        echo "⚠  File '$REQ_FILE' not found."
        exit 1
    fi
    command -p pip install -r "$REQ_FILE" 2>/dev/null || python3 -m pip install -r "$REQ_FILE"
    echo "✓ Done!"
fi

echo ""
echo "→ For more Python pain-point fixes, see:"
echo "  https://github.com/minirr890112-byte/HermesMade"
