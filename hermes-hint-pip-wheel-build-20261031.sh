#!/bin/sh
# fix-pip-wheel-build.sh — Resolve "Failed building wheel for X" / "subprocess-exited-with-error" during pip install
# Usage: ./fix-pip-wheel-build.sh [package-name]
# Safe for beginners • POSIX-compliant • Idempotent • No sudo required
set -u

PKG="${1:-}"

echo "==> pip wheel-build fixer — resolves 'Failed building wheel' errors"
echo "    Root cause: pip fell back to building from source because no"
echo "    prebuilt wheel matched your Python version/OS, and the build"
echo "    toolchain (compiler or dev libraries) is missing."

# ---- Verify Python exists ----
if ! command -v python3 >/dev/null 2>&1; then
  echo "✗ python3 not found on PATH. Install Python first, then rerun."
  exit 1
fi

# ---- Step 1: upgrade build tools (fixes the majority of build failures) ----
echo ""
echo "→ Step 1/3: Upgrading pip, setuptools, and wheel..."
if command -p python3 -m pip install --upgrade pip setuptools wheel; then
  echo "  ✓ Build tools up to date."
else
  echo "  ⚠ Could not upgrade build tools (see above). Continuing anyway..."
fi

# ---- Step 2: prefer prebuilt binary wheels (no source compilation) ----
if [ -n "$PKG" ]; then
  echo ""
  echo "→ Step 2/3: Installing '$PKG' from prebuilt binary wheels only..."
  if command -p python3 -m pip install --only-binary :all: "$PKG"; then
    echo "  ✓ Done! '$PKG' installed from a prebuilt wheel."
    echo "  Verify with: python3 -m pip show $PKG"
    exit 0
  else
    echo "  ⚠ No prebuilt wheel available for '$PKG' on this Python version."
    echo "    (This is common with very new Python releases — see Step 3.)"
  fi
else
  echo ""
  echo "  Tip: rerun with a package name, e.g.: ./fix-pip-wheel-build.sh pillow"
fi

# ---- Step 3: platform-specific build prerequisites ----
echo ""
echo "→ Step 3/3: Building from source needs a C compiler + dev libraries."
if [ "$(uname)" = "Darwin" ]; then
  echo "  macOS detected. Install Xcode Command Line Tools, then retry:"
  echo "    xcode-select --install"
  echo "    python3 -m pip install ${PKG:-<package>}"
elif [ -f /etc/arch-release ]; then
  echo "  Arch Linux detected. Install base-devel, then retry:"
  echo "    sudo pacman -S --needed base-devel"
  echo "    python3 -m pip install ${PKG:-<package>}"
elif [ -f /etc/debian_version ]; then
  echo "  Debian/Ubuntu detected. Install build-essential + Python headers:"
  echo "    sudo apt install build-essential python3-dev"
  echo "    python3 -m pip install ${PKG:-<package>}"
else
  echo "  Install your distro's C compiler (e.g. gcc) and Python dev headers,"
  echo "  then retry: python3 -m pip install ${PKG:-<package>}"
fi

# ---- Bonus: a clean virtualenv sidesteps most wheel/source conflicts ----
echo ""
echo "→ Bonus: a fresh virtual environment avoids most wheel/source conflicts:"
echo "    python3 -m venv .venv && source .venv/bin/activate"
echo "    python3 -m pip install --upgrade pip"
if [ -n "$PKG" ]; then
  echo "    python3 -m pip install $PKG"
fi

echo ""
if [ -n "$PKG" ]; then
  echo "✓ If the above still fails, check https://pypi.org/project/$PKG/"
  echo "  for a wheel matching your Python version, or try an alternative."
else
  echo "✓ Rerun with your package name for a targeted fix."
fi
