#!/bin/sh
# hermes-hint-editable-src-layout.sh — fix "ModuleNotFoundError" after `pip install -e .` (src-layout projects)
# Usage: ./hermes-hint-editable-src-layout.sh [project-dir]
# Safe for beginners • POSIX-compliant • Idempotent • No sudo
#
# SYMPTOM
#   You run `pip install -e .` (or `uv pip install -e .`) on a local package, the
#   install reports success, but importing your module still fails with:
#       ModuleNotFoundError: No module named '<yourpkg>'
#   even though `pip show` / `importlib.metadata` lists the package as installed.
#
# ROOT CAUSE (most common with a src/ layout)
#   In setup.py / pyproject.toml, `package_dir` maps the package to the WRONG path:
#       package_dir={'mypkg': 'src/mypkg'}    # WRONG  -> setuptools looks for src/mypkg/mypkg/*.py
#   With a src/ layout you must map the project ROOT to src/:
#       package_dir={'': 'src'}               # CORRECT
#   A second common cause: the distribution name (pyproject `[project] name`) differs
#   from the import name (e.g. name = "my-pkg" but you `import mypkg`), or a stale
#   build cache from a previous install attempt.

set -e

PROJ="${1:-.}"
cd "$PROJ" 2>/dev/null || { echo "⚠ Could not enter directory: $PROJ"; exit 1; }

echo "==> Editable-install ModuleNotFoundError doctor"
echo "→ Scanning project in: $(command -p pwd)"
echo ""

# --- 1) Detect package manager ---
HAVE_UV=0; HAVE_PY=0
command -v uv >/dev/null 2>&1 && HAVE_UV=1
command -v python3 >/dev/null 2>&1 && HAVE_PY=1
echo "→ Package manager detected:"
[ "$HAVE_UV" -eq 1 ] && echo "  • uv:      $(command -v uv)"
[ "$HAVE_PY" -eq 1 ] && echo "  • python3: $(command -v python3)  (pip via 'python3 -m pip')"

# --- 2) Detect src layout ---
SRC_LAYOUT=0
if [ -d src ]; then
  SRC_LAYOUT=1
  echo "  • src/ layout detected"
fi

# --- 3) Read distribution name from pyproject.toml ---
DIST_NAME=""
if [ -f pyproject.toml ]; then
  echo "  • pyproject.toml found"
  NAME_LINE=$(grep -m1 -E '^[[:space:]]*name[[:space:]]*=' pyproject.toml || true)
  DIST_NAME=$(printf '%s' "$NAME_LINE" | sed -E 's/^.*=[[:space:]]*//; s/[[:space:]]*#.*$//' | tr -d '"'"'"'"')
  [ -n "$DIST_NAME" ] && echo "    → distribution name: $DIST_NAME"
fi
[ -f setup.py ] && echo "  • setup.py found"
[ -f setup.cfg ] && echo "  • setup.cfg found"

# --- 4) Flag the wrong package_dir pattern ---
if [ "$SRC_LAYOUT" -eq 1 ]; then
  WRONG=0
  if [ -f setup.py ] && grep -E "package_dir[[:space:]]*=" setup.py | grep -qE "['\"][^'\"]+['\"][[:space:]]*:[[:space:]]*['\"]src/"; then
    WRONG=1
  fi
  if [ -f pyproject.toml ] && grep -E "package-dir[[:space:]]*=" pyproject.toml | grep -qE "['\"][^'\"]+['\"][[:space:]]*=[[:space:]]*['\"]src/"; then
    WRONG=1
  fi

  if [ "$WRONG" -eq 1 ]; then
    echo ""
    echo "  ⚠ FOUND LIKELY BUG: package_dir maps a package to 'src/<pkg>'."
    echo "    This makes setuptools look one level too deep: src/<pkg>/<pkg>/*.py"
    echo ""
    echo "  → Fix it to map the project ROOT to src/:"
    echo ""
    echo "      # in setup.py"
    echo "      setup(..., packages=find_packages(where='src'), package_dir={'': 'src'})"
    echo ""
    echo "      # in pyproject.toml (setuptools backend)"
    echo "      [tool.setuptools]"
    echo "      package-dir = { \"\" = \"src\" }"
  else
    echo "  ✓ No obvious package_dir misconfiguration found."
  fi
fi

# --- 5) Name consistency check (hyphen vs underscore) ---
if [ "$SRC_LAYOUT" -eq 1 ]; then
  PKG_DIR=$(command -p ls src 2>/dev/null | head -n1)
  if [ -n "$DIST_NAME" ] && [ -n "$PKG_DIR" ]; then
    NORM_DIST=$(printf '%s' "$DIST_NAME" | tr '-' '_')
    if [ "$NORM_DIST" != "$PKG_DIR" ]; then
      echo ""
      echo "  ⚠ Name mismatch: distribution '$DIST_NAME' (normalized '$NORM_DIST')"
      echo "    vs actual package directory 'src/$PKG_DIR'."
      echo "  → The import name comes from the package dir, not the dist name."
      echo "    Make sure you 'import $PKG_DIR', or rename one of them to match."
    fi
  fi
fi

# --- 6) Suggested reinstall + verify ---
echo ""
echo "→ Suggested reinstall (editable, isolated):"
if [ "$HAVE_UV" -eq 1 ]; then
  echo "    uv pip install -e ."
else
  echo "    python3 -m pip install -e ."
fi

echo ""
echo "→ Verify the import resolves:"
if [ -n "${PKG_DIR:-}" ]; then
  echo "    python3 -c \"import $PKG_DIR; print('OK')\""
else
  echo "    python3 -c \"import yourpkg; print('OK')\""
fi

echo ""
echo "✓ Done. If it still fails, clear stale build artifacts and reinstall:"
echo "    rm -rf build dist *.egg-info   # build artifacts only — regenerated on next install"
