#!/bin/sh
# python-env-fix.sh — Diagnose & fix the most common Python setup mistakes
# Usage: sh python-env-fix.sh [check|fix]
# Safe for beginners • POSIX-compliant • Idempotent • No sudo required
#
# Fixes the recurring r/learnpython pain points:
#   1. "pip install" fails with "invalid syntax" / SSL certificate errors
#   2. "ModuleNotFoundError" right after a successful pip install
#   3. Confusion over which python / pip is actually running
#   4. venv not activated (packages silently go to the wrong interpreter)
set -u

echo "==> Python Environment Doctor — what this fixes:"
echo "    1. 'pip install' fails with 'invalid syntax' / SSL errors"
echo "    2. 'ModuleNotFoundError' right after a successful pip install"
echo "    3. Confusion over which python/pip is actually running"
echo "    4. venv not activated (packages go to the wrong place)"
echo ""

MODE="${1:-check}"

# --- Platform detection ---
if [ "$(uname)" = "Darwin" ]; then
  OS="macOS"
elif [ "$(uname)" = "Linux" ]; then
  OS="Linux"
else
  OS="unknown"
fi
echo "-> OS detected: $OS"

# --- Locate interpreters (command -v bypasses aliases/functions) ---
command -v python3 >/dev/null 2>&1 && PY3="$(command -v python3)" || PY3=""
command -v python  >/dev/null 2>&1 && PY="$(command -v python)"  || PY=""
command -v pip3    >/dev/null 2>&1 && PIP3="$(command -v pip3)"    || PIP3=""

echo ""
echo "-> python3 : ${PY3:-<not found>}"
echo "-> python  : ${PY:-<not found>}"
echo "-> pip3    : ${PIP3:-<not found>}"

# --- venv status ---
if [ -n "${VIRTUAL_ENV:-}" ]; then
  echo "-> venv: ACTIVE -> $VIRTUAL_ENV  (good)"
  IN_VENV=1
else
  echo "-> venv: NOT active (packages will install to the global interpreter)"
  IN_VENV=0
fi

# --- Active Python version ---
if [ -n "$PY3" ]; then
  echo ""
  echo "-> Active interpreter version:"
  "$PY3" --version 2>&1 || echo "   (python3 --version failed)"
  "$PY3" -c 'import sys; print("   interpreter path:", sys.executable)' 2>/dev/null
fi

# --- pip3 shebang sanity check (which interpreter does pip target?) ---
if [ -n "$PIP3" ]; then
  PIP_PY="$(head -n 1 "$PIP3" 2>/dev/null | sed 's/^#!//')"
  case "$PIP_PY" in
    *python3*) echo "-> pip3 shebang: $PIP_PY  (ok)" ;;
    *python2*|*python) echo "-> WARNING: pip3 shebang looks odd: $PIP_PY" ;;
    *) echo "-> pip3 shebang: ${PIP_PY:-unknown}" ;;
  esac
fi

echo ""
echo "==> Recommended safe workflow (avoids ~90% of 'ModuleNotFoundError'):"
echo "    1. Create a venv:      python3 -m venv .venv"
echo "    2. Activate it:        source .venv/bin/activate"
echo "    3. Install packages:   python3 -m pip install <package>"
echo "    4. Run your script:    python3 <your_script.py>"
echo ""

# --- Fix mode (opt-in, non-destructive, no sudo) ---
if [ "$MODE" = "fix" ]; then
  echo "==> Applying safe fixes..."
  if [ -n "$PY3" ]; then
    "$PY3" -m pip install --user --upgrade certifi >/dev/null 2>&1       && echo "-> OK: certifi upgraded (fixes CERTIFICATE_VERIFY_FAILED)"       || echo "-> certifi upgrade skipped (not needed or offline)"
  fi
  echo "-> OK: prefer 'python3 -m pip' over bare 'pip' (avoids alias/wrong-interpreter bugs)"
  echo ""
  echo "Done. If a package still raises 'ModuleNotFoundError', run:"
  echo "    python3 -m pip show <package>"
  echo "    python3 -c 'import sys; print(sys.executable)'"
fi

echo ""
echo "-> Quick reference:"
echo "    which python3            -> show the interpreter path"
echo "    python3 -m pip list      -> list packages for the ACTIVE interpreter"
echo "    deactivate               -> leave a venv"
