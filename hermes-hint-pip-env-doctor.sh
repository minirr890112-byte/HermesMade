#!/bin/sh
# hermes-hint-pip-env-doctor.sh — diagnose & fix common Python/pip install problems
# Usage: sh hermes-hint-pip-env-doctor.sh
# Safe for beginners • POSIX-compliant • Idempotent • No sudo required
set -u

echo "==> Python & pip environment doctor"
echo "    fixes: 'pip not on PATH', 'failed to connect to pypi.org', 'wrong Python target'"
echo

# 1. Locate interpreters on PATH
echo "[1/5] Locating Python interpreters..."
command -v python3 >/dev/null 2>&1 && echo "  python3 -> $(command -v python3)"
command -v python  >/dev/null 2>&1 && echo "  python  -> $(command -v python)"
command -v pip3    >/dev/null 2>&1 && echo "  pip3    -> $(command -v pip3)"
command -v pip     >/dev/null 2>&1 && echo "  pip     -> $(command -v pip)"
echo

# 2. Version check
echo "[2/5] Python version:"
if command -v python3 >/dev/null 2>&1; then
  python3 --version 2>/dev/null || echo "  ! python3 present but not runnable"
elif command -v python >/dev/null 2>&1; then
  python --version 2>/dev/null || echo "  ! python present but not runnable"
else
  echo "  ! No Python found on PATH"
fi
echo

# 3. Virtual environment check
echo "[3/5] Virtual environment check:"
if [ -n "${VIRTUAL_ENV:-}" ]; then
  echo "  OK  inside venv: $VIRTUAL_ENV"
else
  echo "  !   not inside a venv (pip may target system Python)"
  echo "      tip: create one with  python3 -m venv .venv"
  echo "           then activate with  . .venv/bin/activate"
fi
echo

# 4. pip module check
echo "[4/5] pip module check:"
if command -v python3 >/dev/null 2>&1 && python3 -m pip --version >/dev/null 2>&1; then
  echo "  OK  'python3 -m pip' works -> $(python3 -m pip --version 2>/dev/null | cut -d' ' -f1-2)"
elif command -v python >/dev/null 2>&1 && python -m pip --version >/dev/null 2>&1; then
  echo "  OK  'python -m pip' works -> $(python -m pip --version 2>/dev/null | cut -d' ' -f1-2)"
else
  echo "  !   'python -m pip' failed (pip missing or broken)"
fi
echo

# 5. Recommended fixes
echo "[5/5] Recommended fixes (copy-paste):"
echo
echo "  # Always use the module form so pip targets the SAME Python you run:"
echo "  python3 -m pip install <package>"
echo
echo "  # If you see 'CERTIFICATE_VERIFY_FAILED', upgrade certifi:"
echo "  python3 -m pip install --upgrade certifi"
echo
echo "  # If 'pip: command not found', use the module form instead:"
echo "  python3 -m pip --version"
echo
echo "  # Install only for your user (no admin needed):"
echo "  python3 -m pip install --user <package>"
echo

echo "Done. If a package still won't install, run:"
echo "  python3 -m pip install <package> -v"
echo "  (the -v flag reveals the real error behind 'failed to connect to pypi.org')"
