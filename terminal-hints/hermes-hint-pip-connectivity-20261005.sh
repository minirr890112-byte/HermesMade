#!/bin/sh
# hermes-hint-pip-connectivity.sh — Diagnose & fix "failed to connect with pypi.org" (pip/pipenv)
# Usage: ./hermes-hint-pip-connectivity.sh
# Safe for beginners • POSIX-compliant • Idempotent • No sudo, no destructive ops

echo "==> pip connectivity doctor — fixes 'failed to connect with pypi.org'"

# Locate a Python interpreter
PY=""
if command -v python3 >/dev/null 2>&1; then PY="python3"; elif command -v python >/dev/null 2>&1; then PY="python"; fi
if [ -z "$PY" ]; then
  echo "✗ Python not found on PATH. Install Python first, then re-run."
  exit 1
fi

# 1. Does DNS resolve pypi.org?
echo
echo "→ [1/4] Checking DNS for pypi.org ..."
if command -p getent hosts pypi.org >/dev/null 2>&1; then
  echo "  ✓ pypi.org resolves OK"
elif command -p nslookup pypi.org >/dev/null 2>&1; then
  echo "  ✓ pypi.org resolves OK (nslookup)"
else
  echo "  ✗ pypi.org does NOT resolve. This is a DNS / VPN / firewall problem, not Python."
  echo "  → Try: disconnect VPN, or check your DNS settings (e.g. 8.8.8.8)."
fi

# 2. Can we actually reach the PyPI index over HTTPS?
echo
echo "→ [2/4] Testing HTTPS connection to PyPI ..."
INDEX_URL="https://pypi.org/simple/"
if command -p python3 -c "import urllib.request,sys; urllib.request.urlopen('${INDEX_URL}', timeout=10)" >/dev/null 2>&1; then
  echo "  ✓ PyPI is reachable over HTTPS — network is fine"
elif command -p curl -s -m 10 -o /dev/null -w "%{http_code}" "${INDEX_URL}" 2>/dev/null | grep -q 200; then
  echo "  ✓ PyPI is reachable over HTTPS — network is fine"
else
  echo "  ✗ Cannot reach PyPI over HTTPS."
  echo "    Common causes: VPN, firewall, corporate proxy, or an outdated SSL bundle."
fi

# 3. Diagnose SSL certificate trust (the #1 culprit for 'CERTIFICATE_VERIFY_FAILED')
echo
echo "→ [3/4] Checking SSL certificate trust ..."
if command -p "$PY" -c "import ssl; ssl.create_default_context().load_default_certs()" >/dev/null 2>&1; then
  echo "  ✓ SSL certs load correctly"
else
  echo "  ✗ SSL cert bundle is broken/missing — this causes 'CERTIFICATE_VERIFY_FAILED'."
  echo "  → Fix: $PY -m pip install --upgrade certifi"
fi

# 4. If we got this far, test an actual pip operation (dry-run, no install)
echo
echo "→ [4/4] Verifying pip itself works ..."
if command -p "$PY" -m pip --version >/dev/null 2>&1; then
  echo "  ✓ pip is functional: $(command -p "$PY" -m pip --version 2>/dev/null | cut -d' ' -f1-2)"
else
  echo "  ✗ pip is broken or missing."
  echo "  → Fix: $PY -m ensurepip --upgrade"
fi

# --- Actionable fixes, in order of likelihood ---
echo
echo "==> If the error persists, try these IN ORDER:"
echo "  1) Fix SSL trust (most common fix):"
echo "     $PY -m pip install --upgrade certifi"
echo
echo "  2) Force a trusted host (bypasses SSL for a one-off install):"
echo "     $PY -m pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org <package>"
echo
echo "  3) Corporate proxy? Point pip at it:"
echo "     $PY -m pip config set global.proxy http://<proxy-host>:<port>"
echo
echo "  4) Behind a firewall/VPN? Disconnect and retry — many block pypi.org."
echo
echo "✓ Done. If you still see errors, paste the EXACT error text (not 'or something')."
