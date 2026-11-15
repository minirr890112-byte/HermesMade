#!/bin/sh
# hermes-hint-numpy-build-fix.sh — Fix "numpy build fails" (missing atomic.h / ostream.h / cstddef.h)
# Usage: ./hermes-hint-numpy-build-fix.sh
# Safe for beginners • POSIX-compliant • Idempotent • No sudo, nothing destructive
#
# Root cause: when a package (numpy/scipy/pandas) has NO prebuilt wheel for your
# Python version, `uv`/`pip` falls back to compiling C++ from source, which needs
# the C++ standard-library headers (atomic.h, ostream.h, cstddef.h) on your
# include path. On a bleeding-edge Python (e.g. 3.15) those wheels often don't
# exist yet, so the build fails with exactly that "not finding <header>" error.
#
# The fix in order of preference:
#   1. Use a stable Python version that ships prebuilt wheels (3.12 / 3.13).
#   2. If you must keep the new Python, make sure the C++ toolchain headers exist.

echo "==> numpy-build-fix — diagnosing 'missing atomic.h / ostream.h / cstddef.h'"

# --- 1. Platform sanity check ------------------------------------------------
if [ "$(uname)" = "Darwin" ]; then
  OS="macOS"
else
  OS="$(uname)"
fi
echo "→ Detected OS: $OS"

# --- 2. Find the active Python + version -------------------------------------
PY=""
if command -v uv >/dev/null 2>&1; then
  PY="$(command -v uv)"
  echo "→ Found uv at: $PY"
fi

python_bin=""
for cand in python3 python; do
  if command -v "$cand" >/dev/null 2>&1; then
    python_bin="$(command -v "$cand")"
    break
  fi
done

if [ -z "$python_bin" ]; then
  echo "✗ No python3/python found on PATH."
  echo "  Install Python via https://python.org or:  brew install python@3.12"
  exit 1
fi

ver="$("$python_bin" -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")' 2>/dev/null)"
echo "→ Active Python: $python_bin  (version ${ver:-unknown})"

# --- 3. The actual diagnosis ------------------------------------------------
# Prebuilt wheels exist for stable releases. Bleeding-edge versions (>=3.14) are
# the #1 cause of "source build -> missing C++ headers" failures.
major="$(printf '%s' "$ver" | cut -d. -f1)"
minor="$(printf '%s' "$ver" | cut -d. -f2)"

new_python=0
if [ -n "$major" ] && [ -n "$minor" ] 2>/dev/null; then
  if [ "$major" -ge 3 ] && [ "$minor" -ge 14 ] 2>/dev/null; then
    new_python=1
  fi
fi

if [ "$new_python" -eq 1 ]; then
  echo "⚠ Your Python ($ver) is very new — prebuilt numpy/scipy wheels may not exist yet."
  echo "  That forces a from-source C++ build, which is what's failing."
  echo
  echo "  ✅ FIX (recommended): pin a stable Python and re-sync."
  if command -v uv >/dev/null 2>&1; then
    echo "     uv python install 3.12"
    echo "     uv python pin 3.12"
    echo "     uv sync"
  else
    echo "     brew install python@3.12"
    echo "     python3.12 -m venv .venv && source .venv/bin/activate"
    echo "     python3.12 -m pip install -r requirements.txt"
  fi
else
  echo "✓ Python $ver is a stable release (wheels should exist). The build error then"
  echo "  points to a missing C++ toolchain. Verify it below."
fi

# --- 4. Toolchain check (macOS) ----------------------------------------------
if [ "$OS" = "macOS" ]; then
  echo
  echo "→ Checking C++ standard-library headers (libc++)..."
  found=0
  for sdk in \
    "$(xcrun --show-sdk-path 2>/dev/null)/usr/include/c++/v1" \
    "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/c++/v1" \
    "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include/c++/v1"; do
    if [ -f "$sdk/atomic.h" ] && [ -f "$sdk/cstddef.h" ]; then
      echo "  ✓ Headers found: $sdk"
      found=1
      break
    fi
  done
  if [ "$found" -eq 0 ]; then
    echo "  ✗ C++ headers NOT found. Install the Xcode Command Line Tools:"
    echo "    xcode-select --install"
    echo "  (Then re-run: sudo xcode-select --reset — but only if the install still isn't picked up.)"
  fi
fi

# --- 5. Summary --------------------------------------------------------------
echo
echo "✓ Done. Quick checklist:"
echo "  1. Prefer a stable Python (3.12/3.13) so prebuilt wheels are used — no C++ build at all."
echo "  2. If you stay on a new Python, run: xcode-select --install  (macOS) to get the C++ headers."
echo "  3. Re-run your build/install. If numpy still fails, try forcing a wheel:"
echo "     uv pip install 'numpy<2.5'"
echo
echo "Tip: never edit system Python or pip by hand — always work inside a venv or let uv manage it."
