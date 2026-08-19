#!/bin/sh
# hermes-hint-python-setup.sh — Detect & guide a working Python 3 environment
# Usage: ./hermes-hint-python-setup.sh
# Safe for beginners • POSIX-compliant • Idempotent • No sudo required
set -e

echo "==> Python Environment Check — fixes 'how do I install Python?' / 'command not found: python'"

os="$(uname)"
echo "→ Detected OS: $os"

# 1. Locate a usable Python 3 interpreter
py=""
for cand in python3 python; do
  if command -v "$cand" >/dev/null 2>&1; then
    ver="$("$cand" --version 2>&1 || true)"
    case "$ver" in
      *"Python 3"*) py="$cand"; break ;;
    esac
  fi
done

if [ -n "$py" ]; then
  loc="$(command -v "$py")"
  echo "✓ Found Python 3: $py → $loc"
  echo "  Version: $("$py" --version 2>&1)"
  echo ""
  echo "  Tips:"
  echo "  • Always run '$py' (not bare 'python' — on some systems 'python' is Python 2 or missing)."
  echo "  • Use '$py -m pip install <pkg>' to install packages into the right interpreter."
  echo "  • Create isolated projects with: $py -m venv .venv && . .venv/bin/activate"
else
  echo "✗ No Python 3 found on PATH."
  echo ""
  echo "  How to install:"
  if [ "$os" = "Darwin" ]; then
    echo "  macOS options (pick ONE):"
    echo "    1. Official installer: https://www.python.org/downloads/macos/"
    echo "    2. Homebrew (if installed): brew install python"
    echo "    3. Xcode CLT (for system python3): xcode-select --install"
  elif [ "$os" = "Linux" ]; then
    echo "  Linux (Debian/Ubuntu):  sudo apt update && sudo apt install python3"
    echo "  Linux (Fedora/RHEL):    sudo dnf install python3"
    echo "  Linux (Arch):           sudo pacman -S python"
  else
    echo "  Windows: use winget →  winget install Python.Python.3.14  (or python.org installer)"
  fi
  echo ""
  echo "  After installing, re-run this script."
fi

# 2. Warn about the classic 'python' vs 'python3' gotcha
if command -v python >/dev/null 2>&1; then
  pyver="$(python --version 2>&1 || true)"
  case "$pyver" in
    *"Python 2"*) echo ""; echo "⚠ Note: bare 'python' resolves to $pyver. Use 'python3' instead." ;;
  esac
fi

# 3. Warn if pip is missing
if [ -n "$py" ] && ! "$py" -m pip --version >/dev/null 2>&1; then
  echo ""
  echo "⚠ pip not available for $py. Try: $py -m ensurepip --upgrade"
fi

[ "$(id -u)" -eq 0 ] && echo "⚠ Running as root — this is unnecessary for this check."

echo ""
echo "✓ Check complete."
