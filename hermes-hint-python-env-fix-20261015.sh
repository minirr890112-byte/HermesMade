#!/bin/sh
# hermes-hint-python-env-fix.sh — diagnose & fix the most common Python "pip install fails" / broken-env pains
# Usage: ./hermes-hint-python-env-fix.sh [--tkinter]
# Safe for beginners • POSIX-compliant • Idempotent • No sudo
set -e

echo "==> Python Environment Fixer — pip install & interpreter health check"
echo ""

# ---- Platform detection ----
if [ "$(uname)" = "Darwin" ]; then
    OS="macOS"
else
    OS="Linux"
fi
echo "-> Detected OS: $OS"

# ---- Locate a working Python ----
PY=""
for cand in python3 python; do
    if command -v "$cand" >/dev/null 2>&1; then
        PY="$cand"
        break
    fi
done
if [ -z "$PY" ]; then
    echo "X No Python found. Install it first: https://python.org/downloads"
    exit 1
fi
echo "-> Using interpreter: $(command -v "$PY")"
echo "-> Version: $($PY --version 2>&1)"

# ---- Diagnostic 1: is pip available? ----
echo ""
echo "==> [1/3] Checking pip availability..."
if $PY -m pip --version >/dev/null 2>&1; then
    echo "OK pip is available via '$PY -m pip'"
else
    echo "! pip missing. Bootstrap it with:"
    echo "    $PY -m ensurepip --upgrade"
fi

# ---- Diagnostic 2: SSL certificates (CERTIFICATE_VERIFY_FAILED) ----
echo ""
echo "==> [2/3] Checking SSL certificates..."
if $PY -c "import ssl" >/dev/null 2>&1; then
    echo "OK ssl module imports cleanly"
else
    echo "! ssl module broken. Fix by installing certifi:"
    echo "    $PY -m pip install --upgrade certifi"
fi

# ---- Diagnostic 3: externally-managed environment (PEP 668) ----
echo ""
echo "==> [3/3] Checking 'externally-managed' environment (PEP 668)..."
EXTERN=$($PY -c "import sysconfig,os; p=os.path.join(sysconfig.get_path('stdlib'),'EXTERNALLY-MANAGED'); print('yes' if os.path.exists(p) else 'no')" 2>/dev/null || echo "unknown")
if [ "$EXTERN" = "yes" ]; then
    echo "! This Python is externally managed (Homebrew / Debian / Ubuntu system Python)."
    echo "  Fix: use a virtual environment or the --user flag:"
    echo "    $PY -m venv .venv && source .venv/bin/activate"
    echo "    # or: $PY -m pip install --user <package>"
else
    echo "OK Not externally managed"
fi

# ---- Optional tkinter check (init.tcl / _tkinter TclError) ----
if [ "${1:-}" = "--tkinter" ]; then
    echo ""
    echo "==> tkinter check (init.tcl / _tkinter errors)..."
    if $PY -c "import tkinter" >/dev/null 2>&1; then
        echo "OK tkinter imports cleanly"
    else
        echo "! tkinter broken. On macOS with Homebrew:"
        echo "    brew install python-tk"
        echo "  On Debian/Ubuntu:"
        echo "    sudo apt-get install python3-tk"
    fi
fi

echo ""
echo "==> Done. If you still see errors, try:"
echo "    $PY -m pip install --user --upgrade pip setuptools wheel"
