#!/bin/sh
# hermes-hint.sh — Fix "pip install -r requirements.txt: illegal option -- r" on macOS
# Pain source: r/learnpython (Homebrew coreutils 'install' alias shadowing pip)
# Usage: ./hermes-hint-pip-mac-fix-20260727.sh [requirements_file]
# Safe for beginners • POSIX-compliant • Idempotent
set -e

echo "==> Hermes Hint — Fix pip 'install: illegal option -- r' on macOS"
echo "   Pain source: r/learnpython user on Mac couldn't install from requirements.txt"
echo "   Root cause: 'install' is aliased (Homebrew coreutils) — shadowing 'pip install'"
echo ""

# Platform check
if [ "$(uname)" != "Darwin" ]; then
  echo "→ This hint targets macOS. You're on $(uname)."
  echo "→ If you're on Linux with a similar issue, try: python3 -m pip install -r requirements.txt"
  exit 0
fi

echo "→ Detected macOS. Checking environment..."

# Check Python availability
if command -v python3 >/dev/null 2>&1; then
  echo "→ Found: $(command -v python3) ($(python3 --version 2>&1))"
else
  echo "✗ Python3 not found on PATH. Install from https://www.python.org/downloads/"
  exit 1
fi

# Check pip via python3 module
if python3 -m pip --version >/dev/null 2>&1; then
  echo "→ pip is available via python3 -m pip"
else
  echo "✗ pip module not available. Run: python3 -m ensurepip --upgrade"
  exit 1
fi

# Set requirements file (default or from argument)
REQ_FILE="${1:-requirements.txt}"
echo "→ Looking for: $REQ_FILE"

if [ ! -f "$REQ_FILE" ]; then
  echo "⚠ File '$REQ_FILE' not found in current directory."
  echo "  Usage: ./hermes-hint-pip-mac-fix-20260727.sh [path/to/requirements.txt]"
  echo ""
  echo "If you don't have a requirements.txt yet, this hint still helps:"
  echo "  ALWAYS use 'python3 -m pip' instead of bare 'pip' on macOS"
  echo ""
  exit 0
fi

# THE FIX: Use python3 -m pip instead of bare pip
# This bypasses the Homebrew 'install' alias that shadows pip
echo ""
echo "→ Installing from $REQ_FILE using python3 -m pip..."
python3 -m pip install -r "$REQ_FILE"

echo ""
echo "✓ Done! Packages installed successfully."
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "💡 WHY THIS HAPPENS:"
echo "   Homebrew's coreutils package installs an 'install' command"
echo "   that shadows 'pip install'. 'python3 -m pip' always works"
echo "   because it bypasses shell aliases and PATH shadowing."
echo ""
echo "🔧 PERMANENT FIX (choose one):"
echo "   Option A: Alias pip in your shell config:"
echo "     echo 'alias pip=\"python3 -m pip\"' >> ~/.zshrc"
echo ""
echo "   Option B: Use 'command -p pip' to force standard PATH:"
echo "     command -p pip install -r requirements.txt"
echo ""
echo "   Option C: Just always type 'python3 -m pip install ...'"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
