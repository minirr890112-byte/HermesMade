#!/bin/sh
# hermes-hint-numpy-macos-build.sh — Fix "numpy build fails on macOS (uv + homebrew): missing atomic.h / ostream.h / cstddef.h"
# Usage: ./hermes-hint-numpy-macos-build.sh
# Safe for beginners • POSIX-compliant • Idempotent • No sudo • No destructive ops
#
# Root cause: numpy has no prebuilt wheel for a very new Python (e.g. 3.14/3.15),
# so uv falls back to building it from source. That C++ build needs Apple's libc++
# headers, which live in the Xcode Command Line Tools SDK. When the SDK path is
# missing/empty, the compiler reports: atomic.h / ostream.h / cstddef.h not found.

echo "==> numpy-on-macOS build fix — diagnosing missing C++ headers"

if [ "$(uname)" != "Darwin" ]; then
  echo "→ This hint targets macOS (you are on: $(uname)). On Linux, install build tools instead:"
  echo "    sudo apt-get install build-essential python3-dev   # Debian/Ubuntu"
  exit 0
fi

echo "→ Detected macOS. Checking Xcode Command Line Tools (CLT) SDK..."

# 1) Is the Command Line Tools installation registered?
CLT_PATH="$(xcode-select -p 2>/dev/null || true)"
if [ -z "$CLT_PATH" ]; then
  echo "⚠  Xcode Command Line Tools not detected."
  echo "→  Fix: run  xcode-select --install"
  echo "   (opens a GUI installer — no sudo needed — then re-run this script)"
  exit 1
fi
echo "✓  CLT registered at: $CLT_PATH"

# 2) Does the SDK actually resolve to a real directory?
SDKROOT_VAL="$(xcrun --show-sdk-path 2>/dev/null || true)"
if [ -z "$SDKROOT_VAL" ] || [ ! -d "$SDKROOT_VAL" ]; then
  echo "⚠  SDK path is empty or missing — this is why the compiler can't find C++ headers."
  echo "→  Fix:  sudo xcode-select --reset"
  echo "         sudo xcode-select -s /Library/Developer/CommandLineTools"
  echo "   (then re-run this script)"
  exit 1
fi
echo "✓  SDK resolves to: $SDKROOT_VAL"

# 3) Are the three reported-missing libc++ headers present in this SDK?
MISSING=0
for h in atomic ostream cstddef; do
  if [ -f "$SDKROOT_VAL/usr/include/c++/v1/$h" ]; then
    echo "✓  Found header: $h"
  else
    echo "✗  Missing header: $h"
    MISSING=1
  fi
done

if [ "$MISSING" -eq 1 ]; then
  echo "→  libc++ headers are missing from this SDK. Reinstall CLT:"
  echo "    xcode-select --install"
  echo "   If that does not help, remove and reinstall CLT manually via System Settings,"
  echo "   then re-run this script."
  exit 1
fi

# 4) All headers present — export the SDK so the next build finds them.
export SDKROOT="$SDKROOT_VAL"
export CXXFLAGS="-isysroot $SDKROOT_VAL"
echo "✓  Exported SDKROOT + CXXFLAGS for this session."

# 5) Recommend the lower-friction fix: use a Python that has prebuilt numpy wheels.
PYVER="$(python3 --version 2>/dev/null | awk '{print $2}' || true)"
if [ -n "$PYVER" ]; then
  MAJOR="$(echo "$PYVER" | cut -d. -f1)"
  MINOR="$(echo "$PYVER" | cut -d. -f2)"
  if [ "$MAJOR" -ge 3 ] && [ "$MINOR" -ge 14 ]; then
    echo "⚠  You are on Python $PYVER — very new, so numpy may have no prebuilt wheel yet."
    echo "→  Easiest fix: pin an older Python with wheels, e.g."
    echo "      uv python pin 3.13"
    echo "      uv sync"
  fi
fi

echo ""
echo "→  Now retry your install, e.g."
echo "      uv sync                # or:  uv pip install numpy"
echo ""
echo "✓  Done. If the build still fails, share the full error from 'uv build' with your"
echo "   project maintainers — the header list in the error tells them exactly what's missing."
