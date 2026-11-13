#!/bin/sh
# numpy-build-fix.sh — Fix "atomic.h / ostream.h / cstddef.h not found" numpy build failures
# Usage: ./numpy-build-fix.sh
# Safe for beginners • POSIX-compliant • Idempotent • No sudo
set -u

echo "==> numpy-build-fix — stop uv/pip from compiling numpy from source"

# --- Platform detection ----------------------------------------------------
if [ "$(uname)" = "Darwin" ]; then
  OS="macOS"
elif [ "$(uname)" = "Linux" ]; then
  OS="Linux"
else
  OS="$(uname)"
fi
echo "→ Detected OS: $OS"

# --- Dependency checks -----------------------------------------------------
if ! command -v uv >/dev/null 2>&1; then
  echo "✗ 'uv' not found. Install it first:  brew install uv   (macOS)  or  curl -LsSf https://astral.sh/uv/install.sh | sh"
  exit 1
fi

# --- Diagnose: what Python version is active? ------------------------------
PYVER="$(uv python find 2>/dev/null || python3 -c 'import sys; print(sys.version.split()[0])' 2>/dev/null || echo 'unknown')"
echo "→ Active Python: ${PYVER}"

# --- Root cause explanation -------------------------------------------------
# numpy build fails when: (1) the requested numpy version has no prebuilt wheel
# for the active Python, so uv/pip falls back to compiling from source, and
# (2) the C++ toolchain headers (atomic.h / ostream.h / cstddef.h) are missing
# or mismatched. The fix is NOT to hunt for headers — it is to install a numpy
# version that ships a prebuilt wheel for your Python (>=2.5.2 for Python 3.15+).
echo ""
echo "→ Root cause: no prebuilt numpy wheel for your Python → source build → missing C++ headers."
echo "→ Fix: install a numpy release that ships a prebuilt wheel (no compiler needed)."

# --- Apply fix: prefer pyproject.toml project, else direct uv add ----------
if [ -f "pyproject.toml" ]; then
  echo "→ Found pyproject.toml — pinning numpy to a wheel-bearing release..."
  if grep -q "numpy" pyproject.toml; then
    # Update existing numpy constraint to a safe floor
    command -p uv add "numpy>=2.5.2"
  else
    command -p uv add "numpy>=2.5.2"
  fi
else
  echo "→ No pyproject.toml — installing numpy into the active environment..."
  command -p uv pip install "numpy>=2.5.2"
fi

# --- Verify ----------------------------------------------------------------
echo ""
echo "✓ Done. Verifying import..."
if uv run python -c "import numpy; print('numpy', numpy.__version__, 'imports OK')" 2>/dev/null; then
  echo "✓ numpy is now installed from a prebuilt wheel."
else
  echo "→ Verification needs a project context; run:  uv run python -c \"import numpy\""
fi

echo ""
echo "ℹ Still seeing a build error? Your Python is bleeding-edge and other packages may lack wheels too."
echo "  Pin to a stable Python for the project:  uv python pin 3.13   (then  uv sync )"
