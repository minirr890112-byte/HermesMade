#!/bin/sh
# hermes-hint.sh — Fix "install: illegal option -- r" when pip is shadowed by macOS /usr/bin/install
# Usage: ./learnpython_20260629_2310.sh
# This happens when Homebrew or coreutils places /usr/bin before pip in PATH.
# The alias 'install' shadows 'pip install'. Use python3 -m pip to bypass.
# HERMES-UUID: 754a7bd5-16f8-457a-ae3f-c4b360b1c699
# Safe for beginners • POSIX-compliant • Idempotent
set -e

echo "==> Hermes Terminal Fix — pip install illegal option -- r"

if [ "$(uname)" = "Darwin" ]; then
  echo "==> Detected macOS. Checking for pip alias conflict..."
  if command -p pip install 2>&1 | grep -q "illegal option"; then
    echo "-> Fix: Using python3 -m pip instead of bare pip (bypasses install alias)"
    echo "-> Running: python3 -m pip install --user -r requirements.txt"
    command -p python3 -m pip install --user -r requirements.txt
  else
    echo "-> No alias conflict detected. Installing normally..."
    command -p python3 -m pip install --user -r requirements.txt
  fi
else
  echo "==> Detected Linux. Installing normally..."
  command -p python3 -m pip install --user -r requirements.txt
fi

echo "✓ Done. If you still see 'illegal option -- r', this means 'pip' is being shadowed."
echo "→ Permanent fix: Add to your ~/.zshrc or ~/.bashrc:"
echo "    alias pip='python3 -m pip'"
