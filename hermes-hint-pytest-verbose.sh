#!/bin/sh
# hermes-hint-pytest-verbose.sh — Make pytest print live output while tests run
# Usage: sh hermes-hint-pytest-verbose.sh [test-file-or-dir]
# Safe for beginners • POSIX-compliant • Idempotent • No sudo
set -e

echo "==> pytest-verbose — show live print() output instead of captured dots"

# pytest captures stdout/stderr by default, so print() calls are hidden
# (and only shown for failing tests). To see them live, disable capture.
#   -s  ==  --capture=no

# Detect interpreter for `python -m pytest` (alias-safe).
PY="python3"
if [ "$(uname)" = "Darwin" ]; then
  if command -p python3 >/dev/null 2>&1; then PY="python3"; else PY="python"; fi
else
  if command -p python >/dev/null 2>&1; then PY="python"; else PY="python3"; fi
fi

# Verify pytest is installed; give a friendly error if not.
if ! "$PY" -m pytest --version >/dev/null 2>&1; then
  echo "⚠ pytest not found. Install it first:"
  echo "    $PY -m pip install pytest"
  exit 1
fi

TARGET="${1:-.}"
echo "→ Running pytest on: $TARGET"
echo "→ Using: $PY -m pytest -s -v (live output + verbose)"

"$PY" -m pytest -s -v "$TARGET"

echo ""
echo "✓ Done. Flags used:"
echo "  -s            : disable output capture (show print() live)"
echo "  -v            : verbose (one line per test)"
echo "  --tb=short    : shorter tracebacks (add if tracebacks are too long)"
