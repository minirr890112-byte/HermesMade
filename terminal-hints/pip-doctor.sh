#!/bin/sh
# pip-doctor.sh — Fix the most common `pip install` failures (SSL certs, PEP 668, stale pip/build tools)
# Usage: ./pip-doctor.sh [optional-package-to-install]
# Safe for beginners • POSIX-compliant • Idempotent • No sudo required
set -u

echo "==> pip-doctor — diagnosing & fixing common Python package install problems"

# Locate Python (python3 first, fall back to python)
PY="$(command -v python3 || command -v python || true)"
if [ -z "$PY" ]; then
  echo "✗ No Python found. Install it first: https://www.python.org/downloads/"
  exit 1
fi
echo "→ Python: $PY ($("$PY" --version 2>&1))"

# Verify pip module is available
if ! "$PY" -m pip --version >/dev/null 2>&1; then
  echo "✗ pip module is missing. Try: $PY -m ensurepip --upgrade"
  exit 1
fi
"$PY" -m pip --version

# 1) Upgrade core packaging tools — fixes "Installing build dependencies ... failed"
echo "→ Upgrading pip / setuptools / wheel..."
"$PY" -m pip install --upgrade pip setuptools wheel 2>/dev/null || \
  echo "  ⚠ Could not upgrade core tools (offline or read-only) — continuing anyway"

# 2) Fix SSL CERTIFICATE_VERIFY_FAILED (common on macOS/Windows and corporate networks)
if "$PY" -c "import ssl, urllib.request; urllib.request.urlopen('https://pypi.org/simple/', timeout=10)" 2>/dev/null; then
  echo "✓ HTTPS connection to PyPI works"
else
  echo "⚠ SSL certificate verification is failing — upgrading certifi..."
  "$PY" -m pip install --upgrade certifi 2>/dev/null || \
    echo "  → Fallback: $PY -m pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org <package>"
fi

# 3) Detect externally-managed environment (PEP 668 — Homebrew / Ubuntu / Debian)
if "$PY" -m pip install --dry-run pip 2>&1 | grep -qi "externally managed"; then
  echo "⚠ This Python is 'externally managed' (PEP 668) — creating a virtual environment instead"
  VENV="${VENV_DIR:-.venv}"
  "$PY" -m venv "$VENV"
  echo "✓ Created virtual environment at '$VENV'"
  echo "→ Activate it: source '$VENV/bin/activate'   (macOS/Linux)"
fi

# 4) Install the requested package (with --user fallback for permission errors)
if [ -n "${1:-}" ]; then
  echo "→ Installing '$1'..."
  "$PY" -m pip install "$1" || "$PY" -m pip install --user "$1"
fi

echo "✓ Done. If it still fails, use a clean virtual environment:"
echo "    $PY -m venv .venv && source .venv/bin/activate && $PY -m pip install ${1:-<package>}"
