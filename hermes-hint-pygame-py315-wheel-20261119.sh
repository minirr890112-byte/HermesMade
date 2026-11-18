#!/bin/sh
# hermes-hint-pygame-py315-wheel.sh — Fix "pip install pygame" on Python 3.15 failing with 'No module named setuptools._distutils.msvccompiler'
# Usage: ./hermes-hint-pygame-py315-wheel-20261119.sh
# Safe for beginners • POSIX-compliant • Idempotent • No sudo, nothing destructive
#
# Recurring pain (r/learnpython, 2026-11-17 / 2026-11-18):
#   pip install pygame  on Python 3.15.x fails with:
#     ModuleNotFoundError: No module named 'setuptools._distutils.msvccompiler'
#
# Root cause: pygame does not ship a prebuilt wheel for Python 3.15 (or 3.14), so
# pip falls back to building pygame from source. On Windows the source build needs
# the MSVC compiler, and modern setuptools (>= 81) no longer bundles the
# `setuptools._distutils.msvccompiler` helper module — so the build dies before it
# even compiles anything.
#
# Fix, in order of preference:
#   1. (Best)  Use Python 3.12 or 3.13, where pygame ships prebuilt wheels.
#   2.         Install `pygame-ce` (community edition) — ships wheels for newer Pythons.
#   3. (Last)  Stay on 3.15 but install MSVC Build Tools (Windows) or force wheel-only.
#
# Source: https://www.reddit.com/r/learnpython/comments/1xyzisj/
set -u

echo "==> pygame Py3.15 wheel fixer — 'setuptools._distutils.msvccompiler' error"
echo ""

# Locate a Python interpreter
PY=""
for c in python3 python py; do
  if command -v "$c" >/dev/null 2>&1; then PY="$c"; break; fi
done
if [ -z "$PY" ]; then
  echo "✗ No Python found. Install it from https://www.python.org/downloads/"
  exit 1
fi

VER="$("$PY" -c 'import sys;print(f"{sys.version_info.major}.{sys.version_info.minor}")' 2>/dev/null || echo unknown)"
echo "→ Interpreter: $PY (Python $VER)"

# Warn about root (pip as root is unnecessary and risky)
if [ "$(id -u)" -eq 0 ]; then
  echo "⚠ Running as root — this is unnecessary. Re-run as your normal user."
fi

# Confirm pip is functional
if "$PY" -m pip --version >/dev/null 2>&1; then
  echo "→ pip is working."
else
  echo "⚠ pip not working — try: $PY -m ensurepip --upgrade"
fi

echo ""
case "$VER" in
  3.14|3.15|3.16)
    echo "⚠ Python $VER detected — pygame does NOT ship a prebuilt wheel for it yet,"
    echo "  so pip tries a source build, which fails on the missing MSVC compiler."
    echo ""
    echo "  ── Fix 1 (BEST) ── pin to a stable Python that has pygame wheels:"
    echo "      python3.13 -m venv .venv && . .venv/bin/activate"
    echo "      python -m pip install pygame"
    echo ""
    echo "  ── Fix 2 (no reinstall) ── community edition ships newer wheels:"
    echo "      $PY -m pip install pygame-ce"
    echo ""
    echo "  ── Fix 3 (must stay on $VER) ── Windows: install MSVC Build Tools:"
    echo "      https://visualstudio.microsoft.com/visual-cpp-build-tools/"
    echo "      # then retry, or force a wheel-only install (fails cleanly, no source build):"
    echo "      $PY -m pip install pygame --only-binary :all:"
    echo ""
    echo "  Why: 'setuptools._distutils.msvccompiler' was removed in setuptools 81+. A"
    echo "  source build on Windows imports it, so the build dies immediately."
    ;;
  *)
    echo "→ Python $VER should have a pygame wheel. Try a clean install:"
    echo "      $PY -m pip install --upgrade pip setuptools wheel"
    echo "      $PY -m pip install pygame"
    ;;
esac

echo ""
echo "✓ Guidance complete. Re-run any time — it only prints, never changes your system."
