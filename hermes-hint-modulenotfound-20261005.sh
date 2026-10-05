#!/bin/sh
# hermes-hint-modulenotfound-20261005.sh — Fix common r/learnpython pip / SSL / venv / interpreter issues
# Usage:  ./hermes-hint-modulenotfound-20261005.sh            # auto-detect and fix (safe, no sudo)
#         ./hermes-hint-modulenotfound-20261005.sh diagnose   # check only, change nothing
# Safe for beginners • POSIX-compliant • Idempotent • No sudo
set -u

MODE="${1:-fix}"
echo "==> r/learnpython pain fixer — pip SSL / venv / ModuleNotFoundError / interpreter"
echo ""

# --- Locate Python ---
PY=$(command -v python3 2>/dev/null || true)
if [ -z "$PY" ]; then
    echo "[!] python3 not found. Install from https://www.python.org/downloads/"
    exit 1
fi
echo "-> python3:  $PY"
echo "-> version:  $($PY --version 2>&1)"
echo "-> pip:      $($PY -m pip --version 2>&1 | head -n1)"
if [ "$(uname)" = "Darwin" ]; then echo "-> platform: macOS"; else echo "-> platform: Linux/other"; fi
echo ""

# --- 1) SSL / certifi ---
echo "== [1/4] SSL certificate check =="
if $PY -c "import ssl; ssl.create_default_context()" >/dev/null 2>&1; then
    echo "-> SSL context OK."
else
    echo "-> SSL broken (CERTIFICATE_VERIFY_FAILED). Installing certifi..."
    $PY -m pip install --user --upgrade certifi 2>/dev/null || $PY -m pip install --upgrade certifi
    echo "   If still failing, append to pip: --trusted-host pypi.org --trusted-host files.pythonhosted.org"
fi
echo ""

# --- 2) venv ---
echo "== [2/4] Virtual environment =="
if [ -n "$VIRTUAL_ENV" ]; then
    echo "-> Already inside a venv: $VIRTUAL_ENV"
elif [ -d ".venv" ]; then
    echo "-> Found .venv/. Run: source .venv/bin/activate"
elif [ -d "venv" ]; then
    echo "-> Found ./venv. Run: source venv/bin/activate"
else
    echo "-> No venv detected. Create one to avoid 'installed but import fails':"
    echo "     $PY -m venv .venv && source .venv/bin/activate"
fi
echo ""

# --- 3) pip / interpreter mismatch ---
echo "== [3/4] pip / interpreter mismatch =="
PIPPY=$($PY -m pip --version 2>/dev/null | sed 's/.*(python //; s/)//')
echo "-> pip runs with python: $PIPPY"
if $PY -m pip --version >/dev/null 2>&1; then
    echo "-> pip is healthy. To check where a package landed:"
    echo "     $PY -c \"import sys; print(sys.executable)\""
else
    echo "-> pip broken. Reinstall via ensurepip:  $PY -m ensurepip --upgrade"
fi
echo ""

# --- 4) ModuleNotFoundError ---
echo "== [4/4] ModuleNotFoundError =="
echo "-> If 'No module named X' but you installed it, you likely installed to a"
echo "   different Python. Verify:  $PY -m pip show <pkg>"
echo "   Fix: install with the SAME interpreter you run with:  $PY -m pip install <pkg>"
echo ""

echo "==> Done. Re-run with 'diagnose' to check without changes."
