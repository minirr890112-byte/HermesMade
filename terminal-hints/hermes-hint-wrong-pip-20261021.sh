#!/bin/sh
# hermes-hint — Python environment doctor (r/learnpython pain-point fixer)
# Usage: ./hermes-hint-wrong-pip-20261021.sh
# Safe for beginners • POSIX-compliant • Idempotent • No sudo, no destructive ops
# Fixes the top recurring r/learnpython pains: wrong Python/pip target,
# venv not activated, pip SSL CERTIFICATE_VERIFY_FAILED, and PEP 668 blocks.
set -u

echo "==> Python environment doctor — diagnosing your setup"

# 1) Which interpreters/pips are actually in scope?
PY=$(command -v python3 || true)
PIP=$(command -v pip3 || command -v pip || true)
echo ""
echo "[1/4] Interpreter & pip in PATH"
echo "  python3 -> ${PY:-NOT FOUND}"
echo "  pip     -> ${PIP:-NOT FOUND}"
[ -n "$PY" ] || { echo "  ! python3 not found. Install it first, then re-run."; exit 1; }

# 2) Are we inside an activated venv? (the #1 cause of ModuleNotFoundError)
echo ""
echo "[2/4] Virtual environment check"
if [ -n "${VIRTUAL_ENV:-}" ]; then
  echo "  ✓ Active venv: $VIRTUAL_ENV"
else
  echo "  ! No venv active. If you `pip install` a package and `import` still fails,"
  echo "    you are likely installing into a different Python than you are running."
fi

# 3) pip SSL check (macOS CERTIFICATE_VERIFY_FAILED)
echo ""
echo "[3/4] pip SSL check"
if "$PY" -c "import ssl" 2>/dev/null; then
  echo "  ✓ ssl module importable"
else
  echo "  ! ssl import failed — try: $PY -m pip install --upgrade certifi"
fi

# 4) PEP 668 / externally-managed detection
echo ""
echo "[4/4] PEP 668 externally-managed check"
"$PY" -m pip --version >/dev/null 2>&1 || echo "  ! pip unavailable for $PY"

echo ""
echo "==> Suggested fixes (run the one that matches your error):"
echo "  • ModuleNotFoundError after pip install  →  $PY -m pip install <pkg>"
echo "  • create a venv                           →  $PY -m venv .venv && . .venv/bin/activate"
echo "  • pip SSL CERTIFICATE_VERIFY_FAILED       →  $PY -m pip install --upgrade certifi"
echo "  • PEP 668 'externally managed'            →  use a venv (see above)"
echo ""
echo "✓ Done. Re-run any time; it only reads your environment."
