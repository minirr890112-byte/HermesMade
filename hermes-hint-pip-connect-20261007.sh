#!/bin/sh
# hermes-hint-pip-connect.sh — Diagnose & fix "pip install / pipenv fails to reach PyPI"
# Usage: ./hermes-hint-pip-connect.sh
# Safe for beginners • POSIX-compliant • Idempotent • No sudo
set -u

echo "==> pip/PyPI connection doctor"
echo "    Fixes: 'failed to connect to pypi.org', SSL cert errors, proxy issues"

# Locate Python
if command -v python3 >/dev/null 2>&1; then
  PY=python3
elif command -v python >/dev/null 2>&1; then
  PY=python
else
  echo "✗ Python not found — install it from https://python.org/downloads"
  exit 1
fi

echo ""
echo "→ Python : $($PY --version 2>&1)"
echo "→ pip    : $($PY -m pip --version 2>&1)"

echo ""
echo "→ Testing PyPI reachability ..."
if $PY -c "import urllib.request; urllib.request.urlopen('https://pypi.org/simple/', timeout=10)" >/dev/null 2>/tmp/pypi_probe.log; then
  echo "  ✓ PyPI reachable — network & TLS are fine."
else
  echo "  ✗ Could not reach PyPI. Possible cause:"
  grep -iE "SSL|CERTIFICATE|certificate|proxy|resolve|timeout|refused|Connection|Name" /tmp/pypi_probe.log 2>/dev/null | head -5
fi

echo ""
echo "→ Active pip proxy / index config:"
$PY -m pip config list 2>/dev/null | grep -iE "index-url|trusted-host|proxy" || echo "  (none)"

echo ""
echo "==> Most likely fixes (run ONE, then retry your install):"
echo "  1) Refresh TLS certificates  (fixes CERTIFICATE_VERIFY_FAILED):"
echo "       $PY -m pip install --upgrade certifi"
echo "  2) Upgrade pip itself:"
echo "       $PY -m pip install --upgrade pip"
echo "  3) Bypass a broken mirror — use the official index:"
echo "       $PY -m pip install <package> --index-url https://pypi.org/simple"
echo "  4) Behind a corporate proxy? Export it, then retry:"
echo "       export HTTPS_PROXY=http://proxy.example:8080"
echo "  5) See 'externally managed environment' (PEP 668) instead? Then:"
echo "       $PY -m pip install --user <package>    # or create a venv"
echo ""
echo "✓ Done. Re-run your original install command after applying a fix."
rm -f /tmp/pypi_probe.log
