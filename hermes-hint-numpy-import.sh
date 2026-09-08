#!/bin/sh
# hermes-hint-numpy-import.sh — Fix "can't import numpy" / "pip is not recognized"
# Usage: ./hermes-hint-numpy-import.sh
# Safe for beginners • POSIX-compliant • Idempotent

set -e

echo "==> numpy import fixer — resolves ModuleNotFoundError: No module named 'numpy'"

# --- 1. Find a working Python interpreter ---
PY=""
if command -v python3 >/dev/null 2>&1; then
  PY="python3"
elif command -v python >/dev/null 2>&1; then
  PY="python"
elif [ "$(uname -s)" = "MINGW" ] || [ "$(uname -s)" = "MSYS" ] || [ "$(uname -s)" = "CYGWIN" ]; then
  # Windows fallback: the "py" launcher ships with python.org installers
  if command -v py >/dev/null 2>&1; then
    PY="py"
  fi
fi

if [ -z "$PY" ]; then
  echo "✗ No Python interpreter found."
  echo "  → Windows: install from https://www.python.org/downloads/ and tick"
  echo "    'Add Python to PATH' during setup."
  echo "  → macOS:   brew install python"
  echo "  → Linux:   sudo apt install python3 python3-pip"
  exit 1
fi

echo "→ Found Python: $PY"

# --- 2. Check if numpy already imports (idempotent — no-op if fixed) ---
if "$PY" -c "import numpy" >/dev/null 2>&1; then
  echo "✓ numpy is already importable. Nothing to do."
  echo "  If your script still fails, make sure it runs with: $PY your_script.py"
  exit 0
fi

# --- 3. Install numpy using the module form (bypasses PATH/alias issues) ---
echo "→ numpy missing. Installing via '$PY -m pip' (bypasses PATH & aliases)..."

if [ "$(uname -s)" = "Darwin" ]; then
  # macOS: Homebrew Pythons are externally-managed — prefer a user install
  "$PY" -m pip install --user numpy
elif [ "$(uname -s)" = "MINGW" ] || [ "$(uname -s)" = "MSYS" ] || [ "$(uname -s)" = "CYGWIN" ]; then
  # Windows: use the py launcher or python -m pip (never bare `pip` on PATH)
  "$PY" -m pip install numpy
else
  "$PY" -m pip install --user numpy
fi

# --- 4. Verify ---
if "$PY" -c "import numpy; print('numpy', numpy.__version__)" >/dev/null 2>&1; then
  VER=$("$PY" -c "import numpy; print(numpy.__version__)")
  echo "✓ Done! numpy $VER installed and importable."
  echo "  Run your script with: $PY your_script.py"
else
  echo "⚠ Installed, but import still fails. Common fixes:"
  echo "  1. Ensure your editor/terminal uses the same Python: $PY"
  echo "  2. Windows PATH issue → run:  py -m pip install numpy"
  echo "  3. Multiple Pythons → check: $PY -c 'import sys; print(sys.executable)'"
fi

echo "---"
echo "Tip: never type bare 'pip'. Always use '$PY -m pip' to avoid"
echo "     \"'pip' is not recognized\" errors on Windows."
