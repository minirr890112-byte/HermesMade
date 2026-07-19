#!/bin/sh
# hermes-hint.sh — Fix pip install failures from macOS 'install' alias conflict
# Pain source: r/learnpython — "pip install -r requirements.txt" fails with "install: illegal option -- r"
# Usage: ./hermes-hint.sh [requirements-file]
# Safe for beginners • POSIX-compliant • Idempotent
set -e

REQ_FILE="${1:-requirements.txt}"

echo "==> Hermes Hint — pip install alias fix"
echo "    Fixes: 'install: illegal option -- r' on macOS"
echo ""

# --- Prerequisite checks ---
if ! command -v python3 >/dev/null 2>&1; then
  echo "✗ python3 not found. Install Python from https://python.org"
  exit 1
fi

if [ ! -f "$REQ_FILE" ]; then
  echo "✗ '$REQ_FILE' not found in current directory."
  echo "  Usage: ./hermes-hint.sh [requirements-file]"
  echo "  Default: requirements.txt"
  exit 1
fi

# --- Platform detection ---
if [ "$(uname)" = "Darwin" ]; then
  echo "→ macOS detected. Using 'python3 -m pip' to bypass shell alias conflicts."
  echo "  (Your shell may have 'install' aliased — this is a common macOS issue)"
  echo ""
  python3 -m pip install -r "$REQ_FILE"
elif [ "$(uname)" = "Linux" ]; then
  echo "→ Linux detected. Installing packages..."
  python3 -m pip install --user -r "$REQ_FILE"
else
  echo "→ Non-macOS/Linux detected. Attempting standard install..."
  python3 -m pip install -r "$REQ_FILE"
fi

echo ""
echo "✓ Done! Packages from '$REQ_FILE' installed successfully."
echo ""
echo "💡 Pro tip: Always use 'python3 -m pip' instead of bare 'pip' to avoid alias conflicts."
echo "   On macOS, add this to your ~/.zshrc:"
echo "     alias pip='python3 -m pip'"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "   Still stuck? Common fixes:"
echo "   • Use a virtual environment: python3 -m venv .venv && source .venv/bin/activate"
echo "   • Install single package: python3 -m pip install --user <package-name>"
echo "   • Check Python version: python3 --version (need 3.7+)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
