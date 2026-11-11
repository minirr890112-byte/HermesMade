#!/bin/sh
# hermes-venv-hint.sh — Diagnose & fix Python virtual environment confusion
# Usage: ./hermes-venv-hint.sh [project-dir]
# Safe for beginners • POSIX-compliant • Idempotent
set -e

echo "==> Python venv hint — fixes 'No module named X', 'externally-managed', and interpreter-not-configured errors"

# 1. Are we already inside a virtual environment?
if [ -n "$VIRTUAL_ENV" ]; then
    echo "✓ Already inside a virtual environment: $VIRTUAL_ENV"
    echo "  If a module is still 'not found', install it HERE with:"
    echo "      python -m pip install <package-name>"
    exit 0
fi

# 2. Locate a Python interpreter (bypass aliases)
PY=""
if command -v python3 >/dev/null 2>&1; then
    PY="$(command -v python3)"
elif command -v python >/dev/null 2>&1; then
    PY="$(command -v python)"
else
    echo "✗ No Python interpreter found on PATH."
    echo "  Install Python first: https://python.org/downloads/"
    exit 1
fi

echo "→ Interpreter in use: $PY"
echo "→ Inside a venv? No (VIRTUAL_ENV is not set) — this is usually the root cause."

# 3. Project directory (default: current)
DIR="${1:-.}"

# 4. Create the venv if it doesn't already exist
if [ -d "$DIR/.venv" ]; then
    echo "→ Found existing virtual environment at $DIR/.venv"
else
    echo "→ Creating a virtual environment at $DIR/.venv ..."
    "$PY" -m venv "$DIR/.venv" || {
        echo "⚠ Could not create the venv. On Debian/Ubuntu you may need:"
        echo "    sudo apt install python3-venv"
        echo "  (on macOS/Windows, reinstall Python from python.org and tick 'Add to PATH')"
        exit 1
    }
fi

# 5. Show the correct activation command per platform
case "$(uname -s)" in
    Darwin|Linux)
        echo ""
        echo "✓ venv is ready. Activate it with:"
        echo "    source \"$DIR/.venv/bin/activate\""
        ;;
    MINGW*|MSYS*|CYGWIN*)
        echo ""
        echo "✓ venv is ready. Activate it with:"
        echo "    \"$DIR\\.venv\\Scripts\\activate\""
        ;;
    *)
        echo ""
        echo "✓ venv created. Activate with the activate script under:"
        echo "    $DIR/.venv/bin/  (Unix)  or  $DIR/.venv/Scripts/  (Windows)"
        ;;
esac

# 6. Next steps (zero-jargon onboarding)
echo ""
echo "After activation your prompt should show (.venv). Then install packages:"
echo "    python -m pip install <package-name>"
echo ""
echo "✓ Done. Re-run this script any time to re-check your environment."
