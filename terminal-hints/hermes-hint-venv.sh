#!/bin/sh
# hermes-hint-venv.sh — Diagnose "pip installed to the wrong Python" (venv/global confusion)
# Usage: ./hermes-hint-venv.sh
# Safe for beginners • POSIX-compliant • Idempotent • No sudo
set -e

echo "==> Which Python is my pip really using? — venv vs. global confusion fix"

# 1. Find the active Python
PY="$(command -v python3 || command -v python || true)"
if [ -z "$PY" ]; then
  echo "✗ Python not found on PATH. Install it first: https://python.org/downloads"
  exit 1
fi

echo "→ Active python:  $PY"
echo "→ pip on PATH:    $(command -v pip3 || command -v pip || echo 'pip not found')"

# 2. Is a virtualenv active?
if [ -n "$VIRTUAL_ENV" ]; then
  echo "✓ venv ACTIVE: $VIRTUAL_ENV"
else
  echo "⚠ No venv active — 'pip install' will target the system site-packages."
  echo "  Create + activate a project venv:"
  echo "      python3 -m venv .venv"
  echo "      source .venv/bin/activate        # macOS/Linux"
  echo "      .venv\\Scripts\\activate           # Windows (cmd)"
fi

# 3. Show where packages actually land for the active interpreter
echo "→ This interpreter resolves packages from:"
"$PY" -c 'import sysconfig, sys; print("    prefix:      ", sys.prefix); print("    site-packages:", sysconfig.get_paths()["purelib"])'

# 4. The reliable, always-correct install command
echo ""
echo "💡 Install with 'python3 -m pip' so the package always lands in the"
echo "   SAME Python you run scripts with:"
echo "      python3 -m pip install <package>"
echo ""
echo "   Avoid bare 'pip install' when you have more than one Python."

echo "✓ Done. Re-run after activating a venv to confirm the path changed."
