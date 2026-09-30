#!/bin/sh
# python-env-doctor.sh — diagnose "pip installed it but Python can't find it"
# Usage: ./python-env-doctor.sh [package-name]
# Safe for beginners • POSIX-compliant • Idempotent • read-only (never installs anything)
#
# Fixes the #1 r/learnpython pain: you ran `pip install <pkg>`, it said "Success",
# but your script still dies with `ModuleNotFoundError`. Root cause is almost always
# one of three things: (1) multiple Pythons on PATH, (2) not inside a venv, or
# (3) using bare `pip` which points at a different interpreter than `python3`.
#
# No `set -e` on purpose — this is a diagnostic, so every check must run and report,
# even when earlier checks "fail".

echo "==> Python Environment Doctor — why can't Python find your package?"
echo ""

# [1] Which Python actually runs your code?
echo "[1] Which Python runs your code?"
if command -v python3 >/dev/null 2>&1; then
    echo "    python3 -> $(command -v python3)  ($(python3 --version 2>&1))"
else
    echo "    !! python3 not found on PATH"
fi
if command -v python >/dev/null 2>&1; then
    echo "    python  -> $(command -v python)  ($(python --version 2>&1))"
fi

# [2] Are you inside a virtual environment?
echo ""
echo "[2] Virtual environment status:"
if [ -n "$VIRTUAL_ENV" ]; then
    echo "    OK: inside a venv -> $VIRTUAL_ENV"
else
    echo "    !! NOT inside a venv (you are on the system Python)."
    echo "       Best practice — one venv per project:"
    echo "         python3 -m venv .venv && source .venv/bin/activate"
    echo "       (Windows Git Bash:  source .venv/Scripts/activate)"
fi

# [3] Does pip belong to the same Python you run with?
echo ""
echo "[3] pip <-> python match check:"
if command -v python3 >/dev/null 2>&1; then
    if python3 -m pip --version >/dev/null 2>&1; then
        echo "    OK: 'python3 -m pip' works (this is the recommended form)"
        python3 -m pip --version 2>&1 | sed 's/^/        /'
    else
        echo "    !! 'python3 -m pip' failed — pip may not be installed for this Python."
        echo "       Fix: python3 -m ensurepip --upgrade"
    fi
fi

# [4] If a package name was given, check whether THIS Python can import it
if [ -n "$1" ]; then
    echo ""
    echo "[4] Checking package '$1':"
    if python3 -c "import importlib, sys; importlib.import_module(sys.argv[1])" "$1" >/dev/null 2>&1; then
        python3 -c "import importlib, sys, os; m=importlib.import_module(sys.argv[1]); print('    OK: found at', getattr(m,'__file__','(built-in)'))" "$1"
        echo "    You are all set — this Python can import '$1'."
    else
        echo "    !! '$1' is NOT importable by $(command -v python3 2>/dev/null)"
        echo "       Fix — install with the SAME Python you run your code with:"
        echo "         python3 -m pip install $1"
        echo "       Or, if you meant a different Python (another venv, conda, VS Code's),"
        echo "       activate that environment first, then re-run this check."
    fi
fi

echo ""
echo "Done. Golden rule: always use 'python3 -m pip install <pkg>' — never bare 'pip'."
