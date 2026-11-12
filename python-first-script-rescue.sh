#!/bin/sh
# hermes-hint: python-first-script-rescue.sh — get a brand-new Python user's first script running
# Usage: sh python-first-script-rescue.sh [path/to/your_script.py]
# Fixes: "cd" into a .py file (directory invalid), missing deps (numpy/pillow), python vs py confusion
# Safe for beginners • POSIX-compliant • Idempotent • No sudo
set -u

echo "==> Python First-Script Rescue — fix the 3 most common 'my script won't run' blockers"

# 1) Locate a working Python interpreter (python3 > python > py launcher)
PY=""
for cand in python3 python py; do
    if command -v "$cand" >/dev/null 2>&1; then
        PY="$cand"
        break
    fi
done

if [ -z "$PY" ]; then
    echo "✗ No Python found on PATH."
    echo "→ Install it from https://www.python.org/downloads/ and tick 'Add Python to PATH'."
    exit 1
fi

echo "→ Using interpreter: $PY ($("$PY" --version 2>&1))"

# 2) Warn on the #1 beginner mistake: cd-ing into a FILE instead of a FOLDER
echo ""
echo "→ THE 'directory is invalid' FIX:"
echo "    'cd' takes a FOLDER, not a file. You cannot cd into script.py."
echo "    Correct pattern (run each line separately):"
if [ "$(uname)" = "Darwin" ] || [ "$(uname)" = "Linux" ]; then
    echo "      cd \"\$(dirname \"$1\")\"    # move into the folder that contains your script"
    echo "      $PY \"$(basename "$1")\"     # then run the script from inside that folder"
else
    echo "      cd /d \"C:\\path\\to\\folder\"     # move into the FOLDER (note: no .py at the end)"
    echo "      $PY your_script.py                 # then run the script by name"
fi

# 3) Install common missing dependencies (numpy + pillow) safely, no sudo, user-level
echo ""
echo "→ Installing common dependencies (numpy, pillow) with --user (no admin needed):"
"$PY" -m pip --version >/dev/null 2>&1 || "$PY" -m ensurepip --user >/dev/null 2>&1 || true
if "$PY" -m pip --version >/dev/null 2>&1; then
    "$PY" -m pip install --user numpy pillow
else
    echo "⚠ pip unavailable. On Windows try:  py -m ensurepip --upgrade"
fi

# 4) Optionally run the target script now
if [ -n "${1:-}" ] && [ -f "$1" ]; then
    echo ""
    echo "→ Attempting to run: $1"
    "$PY" "$1"
fi

echo ""
echo "✓ Done. Still stuck? Check: (1) script lives in a real folder, (2) cd into that FOLDER first,"
echo "  (3) use '$PY -m pip install --user <package>' for any other missing module."
