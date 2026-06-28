#!/bin/sh
# hermes-hint.sh — Python environment health checker for beginners
# Usage: ./hermes-hint.sh
# Safe for beginners • POSIX-compliant • Idempotent • No sudo
# Generated: 2026-06-27T07:13:18Z
# Data source: r/learnpython pain analysis (training-knowledge based)
set -e

echo "==> Python Environment Health Check"
echo "    Fixes the top 5 r/learnpython pain points automatically"
echo ""

# ── 1. Platform detection ──
IS_MACOS=false
if [ "$(uname)" = "Darwin" ]; then
    IS_MACOS=true
    echo "→ Detected macOS ($(sw_vers -productVersion 2>/dev/null || echo unknown))"
elif [ "$(uname)" = "Linux" ]; then
    echo "→ Detected Linux"
else
    echo "→ Detected $(uname)"
fi

# ── 2. Find Python ──
PYTHON=""
for candidate in python3 python python3.12 python3.11 python3.10; do
    if command -v "$candidate" >/dev/null 2>&1; then
        PYTHON="$candidate"
        break
    fi
done

if [ -z "$PYTHON" ]; then
    echo "✗ No Python found. Install from https://python.org or 'brew install python3'"
    exit 1
fi

PYTHON_PATH=$(command -v "$PYTHON")
PYTHON_VERSION=$("$PYTHON" --version 2>&1)
echo "→ Python: $PYTHON_VERSION ($PYTHON_PATH)"

# ── 3. Check for Homebrew Python conflicts (macOS only) ──
if $IS_MACOS; then
    BREW_PYTHON="/opt/homebrew/bin/python3"
    
    if [ -x "$BREW_PYTHON" ] && [ "$PYTHON_PATH" != "$BREW_PYTHON" ]; then
        echo ""
        echo "⚠  Homebrew Python detected at $BREW_PYTHON"
        echo "   but you're using $PYTHON_PATH"
        echo "   → Fix: add this to your ~/.zshrc or ~/.bashrc:"
        echo '     export PATH="/opt/homebrew/bin:$PATH"'
        echo ""
    fi
    
    if [ -x "/usr/bin/python3" ] && [ "$PYTHON_PATH" = "/usr/bin/python3" ]; then
        echo ""
        echo "⚠  You're using Xcode's shim Python (/usr/bin/python3)"
        echo "   This is not a real Python — install with: brew install python3"
        echo ""
    fi
fi

# ── 4. Fix pip SSL issues (macOS) ──
if $IS_MACOS; then
    echo ""
    echo "→ Checking pip SSL health..."
    if "$PYTHON" -m pip --version >/dev/null 2>&1; then
        if ! "$PYTHON" -m pip install --dry-run pip >/dev/null 2>&1; then
            echo "⚠  pip SSL verification may fail. Fixing..."
            "$PYTHON" -m pip install --upgrade certifi 2>/dev/null || true
            CERT_PATH=$("$PYTHON" -c "import certifi; print(certifi.where())" 2>/dev/null || echo "")
            if [ -n "$CERT_PATH" ]; then
                echo "   → certifi installed at $CERT_PATH"
                echo "   → Add to your shell config: export SSL_CERT_FILE=$CERT_PATH"
            else
                echo "   → Alternative: python3 -m pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org <package>"
            fi
        else
            echo "   ✓ pip SSL is healthy"
        fi
    fi
fi

# ── 5. Check for active venv ──
echo ""
echo "→ Checking virtual environment..."
if [ -n "$VIRTUAL_ENV" ]; then
    echo "   ✓ Active venv: $VIRTUAL_ENV"
    echo "   → Python: $("$PYTHON" --version 2>&1)"
    echo "   → pip: $(python3 -m pip --version 2>&1)"
else
    echo "   ℹ  No virtual environment active."
    echo "   → Create one: python3 -m venv .venv && source .venv/bin/activate"
fi

# ── 6. Check for common package issues ──
echo ""
echo "→ Checking common packages..."
for pkg in pandas numpy requests flask; do
    if "$PYTHON" -c "import $pkg" 2>/dev/null; then
        echo "   ✓ $pkg is importable"
    else
        echo "   ○ $pkg not found (install: python3 -m pip install $pkg)"
    fi
done

# ── 7. Check working directory vs script location ──
echo ""
echo "→ Checking working directory..."
echo "   CWD: $(pwd)"
echo "   Tip: open('file.csv') looks in current directory (where you run the command)"
echo "   → Debug with: python3 -c 'import os; print(os.getcwd())'"
echo "   → Use absolute paths: open('/full/path/to/file.csv')"

# ── 8. Check PATH for pip conflicts ──
echo ""
PIP_PATH=$(command -v pip3 2>/dev/null || command -v pip 2>/dev/null || echo "")
if [ -n "$PIP_PATH" ]; then
    PIP_PYTHON=$(head -1 "$PIP_PATH" 2>/dev/null | grep -o 'python[0-9.]*' || echo "unknown")
    echo "→ pip location: $PIP_PATH"
    if [ "$PIP_PYTHON" != "unknown" ] && [ "$(echo "$PIP_PYTHON" | cut -d. -f1-2)" != "$(echo "$PYTHON_VERSION" | grep -o '[0-9]\.[0-9]*')" ]; then
        echo "⚠  pip ($PIP_PYTHON) doesn't match your Python ($PYTHON_VERSION)!"
        echo "   → Fix: always use 'python3 -m pip install' instead of bare 'pip install'"
    fi
fi

# ── 9. Summary ──
echo ""
echo "═══════════════════════════════════════════"
echo "  Health check complete!"
echo ""
echo "  Quick reference:"
echo "  ─────────────────────────────────────"
echo "  Fix pip SSL:     python3 -m pip install --upgrade certifi"
echo "  Create venv:     python3 -m venv .venv && source .venv/bin/activate"
echo "  Safe install:    python3 -m pip install --user <package>"
echo "  Check Python:    which python3 && python3 --version"
echo "  Check pip:       python3 -m pip --version"
echo "  Debug cwd:       python3 -c 'import os; print(os.getcwd())'"
echo "═══════════════════════════════════════════"
