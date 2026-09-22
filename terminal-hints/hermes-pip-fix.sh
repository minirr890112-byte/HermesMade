#!/bin/sh
# hermes-pip-fix.sh — install Python packages safely, avoiding "SyntaxError: invalid syntax"
# Usage: ./hermes-pip-fix.sh <package-name>
# Safe for beginners • POSIX-compliant • Idempotent
set -e

PKG="${1:-}"
if [ -z "$PKG" ]; then
  echo "Usage: ./hermes-pip-fix.sh <package-name>"
  echo "Example: ./hermes-pip-fix.sh requests"
  exit 1
fi

echo "==> Installing '$PKG' the safe way"

# Detect a working Python 3 interpreter
if command -v python3 >/dev/null 2>&1; then
  PY=python3
elif command -v python >/dev/null 2>&1; then
  PY=python
else
  echo "✗ No Python found. Install Python 3 from https://python.org and tick 'Add to PATH'."
  exit 1
fi

echo "→ Using interpreter: $PY ($($PY --version 2>&1))"

# The fix: always use 'python -m pip', never the bare 'pip' command.
# This guarantees the package installs into the same Python you actually run.
if [ "$(uname)" = "Darwin" ]; then
  echo "→ Detected macOS. Installing for the current user..."
  command -p "$PY" -m pip install --user "$PKG"
else
  echo "→ Installing for the current user..."
  "$PY" -m pip install --user "$PKG"
fi

echo ""
echo "✓ Done. '$PKG' installed."
echo ""
echo "💡 If you saw 'SyntaxError: invalid syntax' before:"
echo "   you likely typed 'pip install ...' into the Python REPL (the >>> prompt)"
echo "   instead of your normal terminal/shell."
echo "   Type  exit()  to leave the REPL, then run:"
echo "     $PY -m pip install $PKG"
