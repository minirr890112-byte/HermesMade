#!/bin/sh
# pyinstaller-path-fix.sh — Fix "pyinstaller is not recognised as an internal/external command"
# Usage: ./pyinstaller-path-fix.sh [your_script.py] [--onefile]
# Safe for beginners • POSIX-compliant • Idempotent • No sudo
set -e

echo "==> PyInstaller PATH Fix — bare 'pyinstaller' command not recognised"

# --- Detect the Python interpreter (python3 preferred, python as fallback) ---
if command -v python3 >/dev/null 2>&1; then
    PY="python3"
elif command -v python >/dev/null 2>&1; then
    PY="python"
else
    echo "✗ No Python interpreter found on your PATH."
    echo "  Install Python first, then re-run this script."
    exit 1
fi

echo "→ Using interpreter: $PY  ($(command -v "$PY"))"

# --- Is PyInstaller installed at the module level? ---
if "$PY" -m PyInstaller --version >/dev/null 2>&1; then
    VER=$("$PY" -m PyInstaller --version)
    echo "✓ PyInstaller $VER is installed (module-level)."
else
    echo "→ PyInstaller is not installed. Install it (no sudo needed):"
    echo "      $PY -m pip install --user pyinstaller"
    exit 0
fi

echo ""
echo "──────────────────────────────────────────────────────────"
echo " The problem"
echo "──────────────────────────────────────────────────────────"
echo "  The bare 'pyinstaller' command is NOT on your PATH."
echo "  • Windows:  PythonNN\\Scripts\\ is missing from PATH."
echo "  • macOS/Linux:  ~/.local/bin (the --user bin dir) is missing."
echo ""
echo " The fix (works on every OS, no PATH editing required)"
echo "──────────────────────────────────────────────────────────"
echo "  Always run PyInstaller as a Python module:"
echo ""
echo "      $PY -m PyInstaller ${1:-your_script.py}"
echo ""

# --- Optionally build now if a script argument was provided ---
if [ -n "${1:-}" ]; then
    echo "→ Building: $PY -m PyInstaller $*"
    "$PY" -m PyInstaller "$@"
    echo ""
    echo "✓ Done. Your packaged app is in the 'dist/' folder."
else
    echo "Tip: pass your script to build it now, e.g.:"
    echo "      ./pyinstaller-path-fix.sh my_script.py --onefile"
fi
