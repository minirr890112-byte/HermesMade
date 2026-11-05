#!/bin/sh
# fix-pip-wheel-build.sh — Fix "can't build wheel" / "Getting requirements to build wheel" errors during pip install
# Usage: ./fix-pip-wheel-build.sh [package]    (default: pygame)
# Safe for beginners • POSIX-compliant • Idempotent • No sudo required
set -eu

PKG="${1:-pygame}"

echo "=============================================="
echo "  pip wheel-build fixer"
echo "=============================================="
echo ""

# Warn about root (pip as root is unnecessary and risky)
if [ "$(id -u)" -eq 0 ]; then
    echo "⚠ Running as root — this is unnecessary. Re-run as your normal user."
fi

# Locate a working Python interpreter
if command -v python3 >/dev/null 2>&1; then
    PY=python3
elif command -v python >/dev/null 2>&1; then
    PY=python
else
    echo "✗ No Python found. Install it first: https://www.python.org/downloads/"
    exit 1
fi

echo "→ Interpreter: $PY ($("$PY" --version 2>&1))"
echo ""

# 1) Upgrade the build toolchain first. An outdated pip often can't find
#    modern prebuilt wheels, so it falls back to a slow/failing source build.
echo "→ [1/3] Upgrading pip, setuptools, wheel..."
"$PY" -m pip install --upgrade pip setuptools wheel
echo ""

# 2) Install the requested package (prefer a prebuilt wheel).
echo "→ [2/3] Installing '$PKG'..."
if "$PY" -m pip install "$PKG"; then
    echo ""
    echo "✓ [3/3] Done! '$PKG' is installed."
    exit 0
fi

# 3) Friendly, targeted guidance on failure.
echo ""
echo "⚠ '$PKG' still failed to build a wheel. Common fixes:"
echo ""
if [ "$PKG" = "pygame" ]; then
    echo "  • Your Python may be too new for pygame (it supports 3.9–3.13)."
    echo "    Try the community edition, which ships newer wheels:"
    echo "        $PY -m pip install pygame-ce"
    echo ""
fi
echo "  • Windows: install the free C++ build tools needed to compile wheels:"
echo "        https://visualstudio.microsoft.com/visual-cpp-build-tools/"
echo ""
echo "  • Or force a prebuilt wheel only (no source build):"
echo "        $PY -m pip install \"$PKG\" --only-binary :all:"
echo ""
exit 1
