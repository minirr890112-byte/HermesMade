#!/bin/sh
# hermes-hint-hatchling-src-layout.sh — fix "ModuleNotFoundError" after `pip install -e .`
#   when pyproject.toml uses the Hatchling build backend with a src/ layout.
# Usage: ./hermes-hint-hatchling-src-layout.sh [project-dir]
# Safe for beginners • POSIX-compliant • Idempotent • No sudo
#
# SYMPTOM
#   `pip install -e .` (or `uv pip install -e .`) succeeds and `pip show` lists your
#   package, but `import <pkg>` still fails with:
#       ModuleNotFoundError: No module named '<pkg>'
#
# ROOT CAUSE (distinct from the setuptools src-layout case)
#   Your pyproject.toml declares a non-setuptools build backend:
#       [build-system]
#       requires = ["hatchling"]
#       build-backend = "hatchling.build"
#   When build-backend is NOT setuptools, your setup.py is COMPLETELY IGNORED —
#   every `package_dir` / `find_packages(where='src')` line you wrote there is dead.
#   Hatchling does NOT auto-detect a src/ layout; you must point it at the package:
#       [tool.hatch.build.targets.wheel]
#       packages = ["src/<pkg>"]
#   Without this, the built wheel contains no packages, so nothing is importable.

set -e

PROJ="${1:-.}"
cd "$PROJ" 2>/dev/null || { echo "⚠ Could not enter directory: $PROJ"; exit 1; }

echo "==> Editable-install ModuleNotFoundError doctor (Hatchling + src/ layout)"
echo "→ Scanning project in: $(command -p pwd)"
echo ""

IS_HATCH=0
SRC_LAYOUT=0
PKG_DIR=""

# --- 1) Detect build backend ---
if [ -f pyproject.toml ]; then
  echo "→ pyproject.toml found"
  if grep -qi 'hatch' pyproject.toml; then
    IS_HATCH=1
    echo "  • Hatchling build backend detected"
  elif grep -qi 'build-backend' pyproject.toml; then
    echo "  • A build-backend is set (not setuptools) — see note at end"
  else
    echo "  • No custom build-backend (setuptools default)"
  fi
fi

# --- 2) Detect src layout ---
if [ -d src ]; then
  SRC_LAYOUT=1
  PKG_DIR=$(command -p ls src 2>/dev/null | head -n1)
  echo "  • src/ layout detected (package dir: src/${PKG_DIR:-?})"
fi

# --- 3) The ignored setup.py trap ---
if [ "$IS_HATCH" -eq 1 ] && [ -f setup.py ]; then
  echo ""
  echo "  ⚠ LIKELY BUG: Hatchling backend + a setup.py in the repo."
  echo "    Hatchling IGNORES setup.py — package_dir / find_packages there are dead code."
fi

# --- 4) Missing hatch packages declaration ---
if [ "$IS_HATCH" -eq 1 ] && [ "$SRC_LAYOUT" -eq 1 ]; then
  HAS_PKGS=0
  if grep -qE 'tool\.hatch\.build' pyproject.toml && grep -qE 'packages[[:space:]]*=' pyproject.toml; then
    HAS_PKGS=1
  fi
  if [ "$HAS_PKGS" -eq 0 ]; then
    echo ""
    echo "  ⚠ No [tool.hatch.build.targets.wheel] packages declaration found."
    echo "    Hatchling builds an EMPTY wheel by default with a src/ layout."
    echo ""
    echo "  → Add to pyproject.toml (use YOUR real package dir name):"
    echo ""
    echo "      [tool.hatch.build.targets.wheel]"
    echo "      packages = [\"src/${PKG_DIR:-yourpkg}\"]"
  else
    echo "  ✓ Hatch packages config present — confirm it points at src/${PKG_DIR:-yourpkg}."
  fi
fi

# --- 5) Reinstall + verify ---
echo ""
echo "→ Reinstall after fixing:"
if command -v uv >/dev/null 2>&1; then
  echo "    uv pip install -e . --force-reinstall --no-cache"
else
  echo "    python3 -m pip install -e . --force-reinstall --no-cache-dir"
fi
echo ""
echo "→ Verify the import resolves:"
if [ -n "$PKG_DIR" ]; then
  echo "    python3 -c \"import $PKG_DIR; print('OK')\""
else
  echo "    python3 -c \"import yourpkg; print('OK')\""
fi
echo ""
echo "✓ Done. Prefer setuptools? Swap the [build-system] block to:"
echo "    requires = [\"setuptools>=61.0\"]"
echo "    build-backend = \"setuptools.build_meta\""
echo "  and set package_dir={'': 'src'} (see hermes-hint-editable-src-layout-20261123.sh)."
