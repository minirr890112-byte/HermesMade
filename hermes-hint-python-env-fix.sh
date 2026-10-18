#!/bin/sh
# hermes-hint-python-env-fix.sh — diagnose & fix common Python/pip environment errors
# Usage: ./hermes-hint-python-env-fix.sh [venv_dir]
# Fixes: pip SSL CERTIFICATE_VERIFY_FAILED, ModuleNotFoundError after install,
#        pip targeting the wrong Python, PEP 668 "externally managed" blocks.
# Safe for beginners • POSIX-compliant • Idempotent • No sudo

echo "==> Python environment doctor — fixing common pip/venv issues"

# --- Platform + Python discovery ---
OS=$(uname)
PY=python3
if ! command -v "$PY" >/dev/null 2>&1; then
  echo "✗ python3 not found. Install it from https://python.org first."
  exit 1
fi
PYBIN=$(command -v "$PY")
echo "→ OS: $OS"
echo "→ Python: $PYBIN ($($PY -c 'import sys;print(sys.version.split()[0])' 2>/dev/null))"

# --- 1. Fix pip SSL / CERTIFICATE_VERIFY_FAILED (common on macOS) ---
$PY -c 'import certifi' >/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "→ certifi missing — installing to fix SSL verification..."
  $PY -m pip install --upgrade certifi 2>/dev/null
  $PY -c 'import certifi; print("→ certifi OK:", certifi.where())'
else
  echo "→ certifi present: $($PY -c 'import certifi;print(certifi.where())')"
fi

# --- 2. Point pip at the right Python (avoid system/venv mismatch) ---
echo "→ pip resolved as: $($PY -m pip --version 2>/dev/null)"

# --- 3. Detect PEP 668 'externally managed' and suggest --user / venv ---
if $PY -m pip install --dry-run --quiet --upgrade pip 2>&1 | grep -q 'externally-managed-environment'; then
  echo "⚠ Detected PEP 668 externally-managed Python."
  echo "  → Use a venv: $PY -m venv ${1:-venv} && source ${1:-venv}/bin/activate"
  echo "  → Or install with: $PY -m pip install --user <pkg>"
fi

# --- 4. Quick module-install helper (fixes ModuleNotFoundError) ---
if [ -n "$2" ]; then
  echo "→ Installing requested package: $2"
  $PY -m pip install "$2" || $PY -m pip install --user "$2"
fi

echo ""
echo "✓ Done. Quick-reference fixes:"
echo "  • SSL error        → $PY -m pip install --upgrade certifi"
echo "  • Wrong Python     → always use: $PY -m pip install <pkg>  (not bare 'pip')"
echo "  • Module not found → $PY -m pip install --user <pkg>   then re-run your script"
echo "  • PEP 668 blocked  → $PY -m venv venv && source venv/bin/activate"
