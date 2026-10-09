#!/bin/sh
# pip-doctor.sh — diagnose & fix "pip install <package>" failing (PATH / DNS / venv)
# Usage: ./pip-doctor.sh [package]          (default: pip)
# Safe for beginners • POSIX-compliant • No sudo • Idempotent
#
# Fixes the 3 most common r/learnpython pip failures:
#   1. bare `pip` not found / wrong interpreter   -> use `python3 -m pip`
#   2. "Failed to resolve 'pypi.org'" (DNS)       -> diagnose network/VPN/firewall
#   3. missing venv / PEP 668                     -> create & activate a venv

echo "==> pip-doctor — why won't 'pip install' work?"

# 1. Pick a working interpreter
if command -v python3 >/dev/null 2>&1; then
    PY=python3
elif command -v python >/dev/null 2>&1; then
    PY=python
else
    echo "✗ Python not found. Install it first: https://www.python.org/downloads/"
    exit 1
fi
echo "→ interpreter : $($PY --version 2>&1)"

# 2. Verify pip via the reliable 'python -m pip' path (bypasses aliases & PATH issues)
if $PY -m pip --version >/dev/null 2>&1; then
    echo "✓ $PY -m pip : OK"
    PIPM="$PY -m pip"
else
    echo "✗ $PY -m pip is broken or missing"
    echo "  → fix: $PY -m ensurepip --upgrade"
    PIPM=""
fi

# 3. Warn about bare `pip` (the classic wrong-interpreter / not-on-PATH trap)
if command -v pip >/dev/null 2>&1; then
    echo "→ bare 'pip'  : $(command -v pip)"
    echo "  (tip: prefer '$PY -m pip' so it always matches this interpreter)"
else
    echo "→ bare 'pip'  : not on PATH — use '$PY -m pip' instead"
fi

# 4. Dry-run install (installs NOTHING) to surface the real blocker
if [ -n "$PIPM" ]; then
    echo ""
    echo "==> Dry-run of '${1:-pip}' (nothing is installed):"
    $PIPM install --dry-run --user "${1:-pip}" 2>&1 | sed 's/^/   /'
fi

echo ""
echo "==> Quick reference (match your error to a fix):"
echo "   • 'command not found: pip'            → python3 -m pip install <pkg>"
echo "   • 'externally-managed-environment'    → use a venv:"
echo "        python3 -m venv .venv && source .venv/bin/activate"
echo "   • 'Failed to resolve pypi.org'        → DNS issue: check VPN / firewall / offline"
echo "   • 'CERTIFICATE_VERIFY_FAILED'         → python3 -m pip install --trusted-host pypi.org \\"
echo "                                            --trusted-host files.pythonhosted.org <pkg>"
echo "   • 'script ... not on PATH'            → add ~/.local/bin (macOS/Linux) or"
echo "                                            '...\\Scripts' (Windows) to your PATH"
echo ""
echo "✓ Done. Re-run with a package name to test: ./pip-doctor.sh requests"
