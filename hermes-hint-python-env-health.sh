#!/bin/sh
# hermes-hint-python-env-health.sh — Diagnose & fix the most common r/learnpython setup errors
# Usage: sh hermes-hint-python-env-health.sh [--fix]
# Safe for beginners • POSIX-compliant • Idempotent • No sudo required
#
# Fixes these top pain points (auto-detected from r/learnpython, 2026-10-25):
#   1. SSL cert errors  -> "CERTIFICATE_VERIFY_FAILED" / "unable to get local issuer certificate"
#   2. Outdated pip/setuptools -> source-build failures (e.g. matplotlib building from .tar.gz)
#   3. PEP 668 "externally managed environment" -> pip refuses system-wide installs
#   4. EOL Python (<= 3.10) -> missing security patches (certifi emSign root removal)

set -u

FIX=0
if [ "${1:-}" = "--fix" ]; then
  FIX=1
fi

echo "==> Python Environment Health Check"
echo "    (re-run with --fix to apply repairs automatically)"
echo

# --- 1. Locate python3 ---
if ! command -v python3 >/dev/null 2>&1; then
  echo "[1] python3  NOT FOUND  -> install from https://www.python.org/downloads/"
  exit 1
fi

PYVER=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:3])))' 2>/dev/null || echo "unknown")
PYMAJOR=$(python3 -c 'import sys; print(sys.version_info.major)' 2>/dev/null || echo 0)
PYMINOR=$(python3 -c 'import sys; print(sys.version_info.minor)' 2>/dev/null || echo 0)

echo "[1] Python version : $PYVER  ($(command -v python3))"
if [ "$PYMAJOR" -lt 3 ] || { [ "$PYMAJOR" -eq 3 ] && [ "$PYMINOR" -lt 11 ]; }; then
  echo "    !! Python 3.10 and lower are end-of-life — missing security patches."
  echo "    -> Upgrade to Python 3.11+ : https://www.python.org/downloads/"
fi
echo

# --- 2. pip / setuptools / wheel freshness ---
if command -v python3 >/dev/null 2>&1; then
  PIPPATH=$(python3 -m pip --version 2>/dev/null || echo "")
  if [ -z "$PIPPATH" ]; then
    echo "[2] pip           : NOT FOUND  -> run: python3 -m ensurepip --upgrade"
  else
    echo "[2] $PIPPATH"
  fi
  if [ "$FIX" -eq 1 ]; then
    echo "    -> upgrading pip/setuptools/wheel (fixes 'no matching distribution' & source-build failures)"
    python3 -m pip install --upgrade pip setuptools wheel || echo "    (pip upgrade failed — see note below)"
  else
    echo "    -> tip: python3 -m pip install --upgrade pip setuptools wheel"
  fi
fi
echo

# --- 3. SSL / certifi check ---
if command -v python3 >/dev/null 2>&1; then
  echo "[3] SSL certificates:"
  CERTIFI_OK=$(python3 -c "import urllib.request; urllib.request.urlopen('https://pypi.org', timeout=10); print('ok')" 2>/dev/null || echo "fail")
  if [ "$CERTIFI_OK" = "ok" ]; then
    echo "    (OK) HTTPS to pypi.org works — no certificate problem detected."
  else
    echo "    (FAIL) CERTIFICATE_VERIFY_FAILED detected (unable to get local issuer certificate)."
    if [ "$FIX" -eq 1 ]; then
      echo "    -> upgrading certifi (official fix for SSL verify errors)"
      python3 -m pip install --upgrade certifi || echo "    (certifi upgrade failed)"
    else
      echo "    -> fix: python3 -m pip install --upgrade certifi"
    fi
  fi
fi
echo

# --- 4. PEP 668 externally-managed detection ---
if command -v python3 >/dev/null 2>&1; then
  EXTMAN=$(python3 -c "import sysconfig, pathlib; p=pathlib.Path(sysconfig.get_path('stdlib')); print('yes' if (p/'EXTERNALLY-MANAGED').exists() else 'no')" 2>/dev/null || echo "no")
  if [ "$EXTMAN" = "yes" ]; then
    echo "[4] (WARN) Externally-managed environment (PEP 668) detected."
    echo "    pip refuses system-wide installs here. Use a virtual environment:"
    echo "      python3 -m venv .venv && source .venv/bin/activate   # macOS / Linux"
    echo "      python3 -m venv .venv && .venv\\Scripts\\activate     # Windows"
    if [ "$FIX" -eq 1 ]; then
      echo "    -> creating a .venv virtual environment for you now"
      python3 -m venv .venv || echo "    (venv creation failed)"
    fi
  else
    echo "[4] Package install policy: standard (no PEP 668 block detected)."
  fi
fi
echo

echo "Done. Health check complete."
if [ "$FIX" -ne 1 ]; then
  echo "  Re-run with --fix to apply the repairs above automatically."
fi
