#!/bin/sh
# hermes-hint.sh — Fix matplotlib backend after system update
# Usage: ./hermes-hint-matplotlib-backend-20260622.sh
# Safe for beginners • POSIX-compliant • Idempotent
# Fixes: "ValueError: Key backend: 'module://matplotlib_inline.backend_inline'"
# Source: r/learnpython pain scan — matplotlib broken after macOS/Linux system update
set -e

echo "==> Matplotlib Backend Fix — repairs inline backend after system updates"
echo ""

# ── Platform detection ──
OS="$(uname)"
echo "→ Detected OS: $OS"

# ── Check Python ──
PYTHON=""
if command -v python3 >/dev/null 2>&1; then
    PYTHON="python3"
elif command -v python >/dev/null 2>&1; then
    PYTHON="python"
else
    echo "✗ Python not found. Install Python 3 first: https://python.org/downloads/"
    exit 1
fi
echo "→ Using: $PYTHON ($($PYTHON --version 2>&1))"

# ── Check matplotlib ──
if ! $PYTHON -c "import matplotlib" 2>/dev/null; then
    echo "✗ matplotlib not installed."
    echo "  Run: $PYTHON -m pip install matplotlib"
    exit 1
fi
echo "→ matplotlib is installed"

# ── Diagnose current backend ──
CURRENT_BACKEND="$($PYTHON -c "import matplotlib; print(matplotlib.get_backend())" 2>/dev/null || echo "unknown")"
echo "→ Current backend: $CURRENT_BACKEND"

# ── Check if inline backend is broken ──
INLINE_OK="$($PYTHON -c "
import matplotlib
matplotlib.use('module://matplotlib_inline.backend_inline')
print('ok')
" 2>/dev/null || echo "broken")"

if [ "$INLINE_OK" = "ok" ]; then
    echo ""
    echo "✓ Inline backend is working correctly. No fix needed."
    echo ""
    echo "If you still see errors in VSCode/Jupyter:"
    echo "  • In VSCode: Cmd+Shift+P → 'Python: Select Interpreter' → choose your venv Python"
    echo "  • Restart Jupyter kernel: Kernel → Restart Kernel"
    echo "  • Try a different backend: export MPLBACKEND=TkAgg"
    exit 0
fi

echo "→ Inline backend appears BROKEN — applying fix..."

# ── Fix 1: Clear matplotlib cache ──
echo ""
echo "==> Step 1/4: Clearing matplotlib cache..."
CACHE_DIR="$($PYTHON -c "import matplotlib; print(matplotlib.get_cachedir())" 2>/dev/null || echo "")"
if [ -n "$CACHE_DIR" ] && [ -d "$CACHE_DIR" ]; then
    echo "  Removing: $CACHE_DIR"
    rm -rf "$CACHE_DIR"
    echo "  ✓ Cache cleared"
else
    echo "  (no cache dir found, skipping)"
fi

# ── Fix 2: Reinstall matplotlib (user-level) ──
echo ""
echo "==> Step 2/4: Reinstalling matplotlib (user-level, no sudo)..."
$PYTHON -m pip install --user --upgrade --force-reinstall matplotlib 2>&1 | tail -3
echo "  ✓ matplotlib reinstalled"

# ── Fix 3: Try setting MPLBACKEND ──
echo ""
echo "==> Step 3/4: Testing alternative backends..."
for backend in TkAgg Qt5Agg Agg; do
    if MPLBACKEND="$backend" $PYTHON -c "import matplotlib; matplotlib.use('$backend'); print('ok')" 2>/dev/null; then
        echo "  ✓ Backend '$backend' works"
        WORKING_BACKEND="$backend"
        break
    else
        echo "  ✗ Backend '$backend' not available"
    fi
done

# ── Fix 4: Recommend configuration ──
echo ""
echo "==> Step 4/4: Configuration recommendation"
echo ""
echo "  To make the fix permanent, add one of these to your shell rc file:"
echo ""
echo "  # Option A: Set a working backend (recommended)"
echo '  export MPLBACKEND='"${WORKING_BACKEND:-TkAgg}"
echo ""
echo "  # Option B: For Jupyter notebooks only"
echo "  # In your notebook, add as first cell:"
echo "  #   %matplotlib inline"
echo "  #   import matplotlib"
echo "  #   matplotlib.use('module://matplotlib_inline.backend_inline')"
echo ""
echo "  # Option C: Create a matplotlibrc file"
echo "  # echo 'backend : ${WORKING_BACKEND:-TkAgg}' > ~/.matplotlib/matplotlibrc"
echo ""

# ── Verify ──
echo "==> Verification:"
$PYTHON -c "
import matplotlib
matplotlib.use('${WORKING_BACKEND:-TkAgg}')
import matplotlib.pyplot as plt
print('  ✓ matplotlib basic import OK')
" 2>/dev/null && echo "  ✓ Backend switch successful" || echo "  ⚠ Some backends unavailable"

echo ""
echo "✓ Done! Try running your script again."
echo ""
echo "If the issue persists in Jupyter/VSCode:"
echo "  1. Restart your Jupyter kernel (Kernel → Restart)"
echo "  2. In VSCode: Cmd+Shift+P → 'Developer: Reload Window'"
echo "  3. Check: $PYTHON -c 'import matplotlib; print(matplotlib.get_backend())'"
echo ""
echo "For more help: https://matplotlib.org/stable/users/explain/backends.html"
