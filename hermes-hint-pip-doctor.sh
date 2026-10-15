#!/bin/sh
# hermes-hint-pip-doctor.sh — diagnose & fix common `pip install` failures
# Usage: ./hermes-hint-pip-doctor.sh [package ...]
# Fixes: "no matching distribution", "Failed to build", "externally managed",
#        "CERTIFICATE_VERIFY_FAILED", "ModuleNotFoundError"
# Safe for beginners • POSIX-compliant • Idempotent • No sudo
set -u

PY="$(command -v python3 2>/dev/null || command -v python 2>/dev/null || echo python3)"

echo "==> pip-install-doctor — diagnosing why 'pip install' fails"
echo

if ! command -v "$PY" >/dev/null 2>&1; then
  echo "✗ Python not found on PATH. Install it first: https://www.python.org/downloads/"
  exit 1
fi

echo "→ Python: $("$PY" --version 2>&1)"
echo "→ pip:    $("$PY" -m pip --version 2>&1 | head -n1)"
echo

echo "→ 'pip' resolves to: $(command -v pip 2>/dev/null || echo '(not found — use python3 -m pip)')"
echo

if [ "$#" -eq 0 ]; then
  echo "Tip: pass package names to check them, e.g. ./hermes-hint-pip-doctor.sh numpy matplotlib"
  echo
fi

for PKG in "$@"; do
  echo "── Checking '$PKG' ──"
  "$PY" -m pip index versions "$PKG" 2>&1 | head -n3
  echo
done

echo "==> Common fixes by error message =="
echo
echo "1) 'No matching distribution found for X'"
echo "   → Your Python version is too new; no prebuilt wheel exists yet."
echo "   → Fix: install an older Python and use it:"
echo "        uv python install 3.12          # or 3.11"
echo "        uv venv --python 3.12 .venv && source .venv/bin/activate"
echo "        python -m pip install <package>"
echo
echo "2) 'Failed to build X when installing build dependencies'"
echo "   → pip tried to compile from source (no wheel) and failed."
echo "   → Fix: force a prebuilt wheel only:"
echo "        $PY -m pip install --only-binary :all: <package>"
echo "   → Or switch to an older Python (see #1)."
echo
echo "3) 'error: externally-managed-environment' (PEP 668)"
echo "   → Your system Python is protected. Never sudo pip install."
echo "   → Fix: create a virtual environment:"
echo "        $PY -m venv .venv && source .venv/bin/activate"
echo "        python -m pip install <package>"
echo
echo "4) 'CERTIFICATE_VERIFY_FAILED' / SSL errors"
echo "   → Outdated CA certificates. Fix:"
echo "        $PY -m pip install --upgrade certifi"
echo
echo "5) 'ModuleNotFoundError: No module named X'"
echo "   → The package isn't installed in this interpreter. Fix:"
echo "        $PY -m pip install X"
echo
echo "✓ Done. Re-run with: ./hermes-hint-pip-doctor.sh <package>"
