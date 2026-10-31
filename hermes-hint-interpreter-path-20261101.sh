#!/bin/sh
# hermes-hint.sh — Find the Python your shell actually uses (and fix PATH)
# Usage: ./hermes-hint.sh
# Safe for beginners • POSIX-compliant • Idempotent • No sudo
set -e

echo "==> Python PATH detective"

echo "→ 'python'  resolves to: $(command -v python  || echo '(not found)')"
echo "→ 'python3' resolves to: $(command -v python3 || echo '(not found)')"
echo "→ Version in use:        $(python3 --version 2>&1 || echo n/a)"

if [ "$(uname)" = "Darwin" ]; then
  echo ""
  echo "→ macOS Homebrew Pythons found:"
  ls -1 /opt/homebrew/bin/python3* 2>/dev/null || echo "   (none under /opt/homebrew — check /usr/local)"
  echo "→ Hint: if pip installs but the interpreter can't see it, run:"
  echo "      $(command -v python3 || echo python3) -m pip install --user <package>"
fi
echo ""
echo "→ Every Python knows its own home:"
python3 -c "import sys; print('   sys.executable =', sys.executable)"
echo "✓ Done. Use 'python3 -m pip install' so pip always targets the right interpreter."
