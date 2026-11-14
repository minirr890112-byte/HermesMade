#!/bin/sh
# hermes-hint-numpy-macos-build.sh — Fix "atomic.h / ostream.h / cstddef.h not found" when numpy builds from source on macOS
# Usage: ./hermes-hint-numpy-macos-build.sh
# Safe for beginners • POSIX-compliant • Idempotent • No sudo, no destructive ops
set -u

echo "==> numpy source-build fixer — macOS C++ stdlib headers missing"

# This pain is macOS-specific (Xcode Command Line Tools + SDK headers)
if [ "$(uname)" != "Darwin" ]; then
  echo "→ This hint targets macOS. You're on $(uname) — nothing to do here."
  exit 0
fi

echo ""
echo "Symptom: uv (or pip) tries to build numpy from source and fails with:"
echo "  'atomic.h', 'ostream.h', 'cstddef.h' not found"
echo "Root cause: the C++ compiler can't find the macOS SDK's standard-library"
echo "            headers (usually an incomplete/broken Xcode Command Line Tools)."
echo ""

# 1. Locate Xcode Command Line Tools
echo "1) Xcode Command Line Tools"
if command -v xcode-select >/dev/null 2>&1; then
  CLT_PATH="$(xcode-select -p 2>/dev/null || echo '')"
  echo "   path: ${CLT_PATH:-<not set>}"
  if [ -z "$CLT_PATH" ] || [ ! -d "$CLT_PATH" ]; then
    echo "   ✗ CLT missing or broken → run:  xcode-select --install"
  else
    echo "   ✓ CLT present."
  fi
else
  echo "   ✗ xcode-select not found → run:  xcode-select --install"
fi

# 2. Resolve the active macOS SDK
echo ""
echo "2) macOS SDK root"
SDKROOT=""
if command -v xcrun >/dev/null 2>&1; then
  SDKROOT="$(xcrun --sdk macosx --show-sdk-path 2>/dev/null || echo '')"
  if [ -n "$SDKROOT" ]; then
    echo "   SDKROOT: $SDKROOT"
  else
    echo "   ✗ xcrun could not resolve the SDK (CLT incomplete)."
  fi
else
  echo "   ✗ xcrun not found (CLT not installed)."
fi

# 3. Verify the exact headers that failed
echo ""
echo "3) Checking the missing C++ headers"
if [ -n "$SDKROOT" ]; then
  for h in atomic.h ostream.h cstddef.h; do
    if [ -f "$SDKROOT/usr/include/c++/v1/$h" ]; then
      echo "   ✓ $h found"
    else
      echo "   ✗ $h NOT found under the SDK — this is your build failure."
    fi
  done
fi

# 4. The fix (guidance only — nothing destructive runs automatically)
echo ""
echo "4) Fix, in order:"
echo "   a. Repair CLT:            xcode-select --install"
echo "   b. Re-point to CLT:       xcode-select --reset"
echo "   c. Rebuild with the SDK visible:"
echo "        export SDKROOT=\"\$(xcrun --sdk macosx --show-sdk-path)\""
echo "        uv sync"
echo ""

echo "✓ Done. Still failing? Python 3.15 may not have a numpy wheel yet —"
echo "  pin an older numpy that ships a wheel:  uv pip install 'numpy<2.4'"
