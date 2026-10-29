#!/bin/sh
# hermes-hint-runpy.sh — Run a Python script and keep the window open
# Usage: ./hermes-hint-runpy.sh path/to/script.py [args...]
# Fixes: "Python opens and closes instantly when I double-click a .py file"
# Safe for beginners • POSIX-compliant • Idempotent • No sudo
set -e

echo "==> runpy — keep your Python script window open"

if [ "$#" -lt 1 ]; then
  echo ""
  echo "Usage: ./hermes-hint-runpy.sh path/to/script.py [args...]"
  echo ""
  echo "Why this helps:"
  echo "  Double-clicking a .py file runs it in a window that closes the moment"
  echo "  the script finishes (or errors out). Running it from the terminal keeps"
  echo "  the window open so you can actually read the output or traceback."
  exit 1
fi

SCRIPT="$1"
shift

if [ ! -f "$SCRIPT" ]; then
  echo "✗ File not found: $SCRIPT"
  echo "  Tip: pass the full path, e.g. ./hermes-hint-runpy.sh ~/my_script.py"
  exit 1
fi

# Pick a Python interpreter (check with command -v first)
if command -v python3 >/dev/null 2>&1; then
  PY=python3
elif command -v python >/dev/null 2>&1; then
  PY=python
else
  echo "✗ Python not found on PATH."
  echo "  Install it from https://python.org (tick 'Add Python to PATH' on Windows)."
  exit 1
fi

echo "→ Interpreter: $(command -v "$PY")"
echo "→ Running:     $PY -i $SCRIPT $*"
echo "→ The window stays open (interactive mode)."
echo "  • If your script printed output or an error, you'll see it above."
echo "  • Type exit() and press Enter (or Ctrl+D) to close."
echo ""

# -i runs the script, then drops into an interactive REPL.
# On success you get a prompt; on error you still get the full traceback.
exec "$PY" -i "$SCRIPT" "$@"
