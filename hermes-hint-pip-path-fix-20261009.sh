#!/bin/sh
# pip-path-fix.sh — explain & fix the "pip install ... not on PATH" warning
# Usage: sh pip-path-fix.sh
# Safe for beginners • POSIX-compliant • Idempotent • Read-only (prints fix commands)

echo "==> pip PATH helper — what the yellow 'not on PATH' warning means, and how to fix it"

# 1. Locate a working Python interpreter (alias-proof, no sudo)
PY=""
for cand in python3 python py; do
  if command -v "$cand" >/dev/null 2>&1; then
    PY="$cand"
    break
  fi
done

if [ -z "$PY" ]; then
  echo "✗ No Python found on this system."
  echo "  Install it from https://www.python.org/downloads/ and tick 'Add Python to PATH'."
  exit 1
fi

echo "→ Using Python: $PY"

# 2. Ask Python where its console scripts are installed (the dir the warning names)
SCRIPTS_DIR="$($PY -c "import sysconfig; print(sysconfig.get_path('scripts'))" 2>/dev/null)"

if [ -z "$SCRIPTS_DIR" ]; then
  echo "✗ Could not determine the scripts directory."
  exit 1
fi

echo "→ pip installs command-line tools into: $SCRIPTS_DIR"

# 3. Check whether that directory is already on PATH
case ":$PATH:" in
  *":$SCRIPTS_DIR:"*) ON_PATH=1 ;;
  *)                  ON_PATH=0 ;;
esac

if [ "$ON_PATH" -eq 1 ]; then
  echo "✓ $SCRIPTS_DIR is already on your PATH — the warning is safe to ignore."
else
  echo "⚠ $SCRIPTS_DIR is NOT on your PATH."
  echo ""
  echo "   What this means: 'pip install <package>' succeeded, but the command-line"
  echo "   tools it installed (the ones ending in .exe on Windows) can't be run from"
  echo "   the terminal until their folder is added to PATH."
  echo ""
  echo "   Fix it — pick one:"
  echo ""
  echo "   Windows (PowerShell, permanent):"
  echo "     setx PATH \"\$env:PATH;$SCRIPTS_DIR\""
  echo ""
  echo "   macOS / Linux — add this line to ~/.zshrc or ~/.bashrc, then reopen terminal:"
  echo "     export PATH=\"$SCRIPTS_DIR:\$PATH\""
fi

echo ""
echo "==> Avoid the warning entirely next time:"
echo "   Use 'python -m pip' instead of bare 'pip':"
echo "     $PY -m pip install <package>"

echo ""
echo "==> Installed something by accident and want to undo it?"
echo "     $PY -m pip uninstall <package>"

echo ""
echo "✓ Done."
