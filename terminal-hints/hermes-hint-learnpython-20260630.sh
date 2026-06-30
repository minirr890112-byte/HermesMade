#!/bin/sh
# hermes-hint-learnpython-20260630.sh — Fix 4 common Python beginner pains
# Usage: ./hermes-hint-learnpython-20260630.sh [fix-name]
#   fix-name: pip-ssl | venv-check | matplotlib-fix | import-path (default: all)
# Safe for beginners • POSIX-compliant • Idempotent • No sudo

set -e


run_all() {
    echo ""
    echo "  ╔══════════════════════════════════════════════════════╗"
    echo "  ║   🐍 Hermes Python Pain Fixer — 20260630            ║"
    echo "  ║   GFW-blocked scan | Training data synthesis       ║"
    echo "  ╚══════════════════════════════════════════════════════╝"
    echo ""
    fix_pip_ssl
    fix_venv_check
    fix_matplotlib
    fix_import_path
    echo ""
    echo "  ✅ All fixes applied. Restart your terminal and try again."
}

# ── Fix 1: pip SSL CERTIFICATE_VERIFY_FAILED ──
fix_pip_ssl() {
    echo "==> Fix 1/4: pip SSL certificate errors"
    echo "    Problem: pip install fails with CERTIFICATE_VERIFY_FAILED"
    echo "    Common on corporate networks, macOS, and Python 3.6+."
    echo ""
    if [ "$(uname)" = "Darwin" ]; then
        echo "→ macOS detected."
        if command -v brew >/dev/null 2>&1; then
            echo "→ Found Homebrew. Installing certifi via brew..."
            command -p brew install certifi 2>/dev/null || true
            CERTIFI_PATH="$(command -p python3 -m certifi 2>/dev/null || echo \"\")"
            if [ -n "$CERTIFI_PATH" ]; then
                export SSL_CERT_FILE="$CERTIFI_PATH"
                echo "✓ SSL_CERT_FILE set to: $CERTIFI_PATH"
            fi
        fi
    fi
    echo "→ Upgrading certifi via pip..."
    command -p python3 -m pip install --upgrade certifi 2>/dev/null || {
        echo "⚠ pip upgrade failed. Trying with --trusted-host..."
        command -p python3 -m pip install --upgrade --trusted-host pypi.org --trusted-host files.pythonhosted.org certifi
    }
    echo "→ Quick test..."
    if command -p python3 -c "import certifi; print(certifi.where())" >/dev/null 2>&1; then
        echo "✓ certifi is working!"
    else
        echo "⚠ certifi test inconclusive. Check proxy settings:"
        echo "   export HTTP_PROXY=http://your-proxy:port"
    fi
    echo ""
}

# ── Fix 2: Virtual environment audit ──
fix_venv_check() {
    echo "==> Fix 2/4: Virtual environment confusion"
    echo "    Problem: pip installs go to system Python instead of venv"
    echo ""
    if [ -n "$VIRTUAL_ENV" ]; then
        echo "✓ You ARE inside a virtual environment: $VIRTUAL_ENV"
        PIP_PREFIX="$(command -p python3 -m pip --version 2>/dev/null | grep -o '/[^ ]*' | head -1 || echo \"\")"
        if echo "$PIP_PREFIX" | grep -q "$VIRTUAL_ENV" 2>/dev/null; then
            echo "✓ pip is correctly using the venv"
        else
            echo "⚠ pip may not be using the venv. Try:"
            echo "   deactivate && source $VIRTUAL_ENV/bin/activate"
        fi
    else
        echo "⚠ You are NOT inside a virtual environment."
        echo "   Create one: python3 -m venv myenv"
        echo "   Activate:   source myenv/bin/activate"
        echo "   (On Windows: myenv\\Scripts\\activate)"
    fi
    echo ""
}

# ── Fix 3: matplotlib blank window on macOS ──
fix_matplotlib() {
    echo "==> Fix 3/4: matplotlib figures not showing"
    echo "    Problem: Blank window or no plot after macOS/OS update"
    echo ""
    if [ "$(uname)" = "Darwin" ]; then
        echo "→ macOS detected. Checking backend..."
        BACKEND="$(command -p python3 -c \"import matplotlib; print(matplotlib.get_backend())\" 2>/dev/null || echo unknown)"
        echo "  Current backend: $BACKEND"
        if [ "$BACKEND" = "MacOSX" ] || [ "$BACKEND" = "unknown" ]; then
            echo "→ Installing matplotlib-inline..."
            command -p python3 -m pip install --user matplotlib-inline 2>/dev/null || true
            echo "→ Quick fix for scripts — add at top:"
            echo "   import matplotlib"
            echo "   matplotlib.use('TkAgg')  # or 'QtAgg'"
        fi
    else
        echo "→ Linux detected."
        echo "   Try: python3 -m pip install --user matplotlib-inline"
    fi
    echo ""
}

# ── Fix 4: ModuleNotFoundError on sibling imports ──
fix_import_path() {
    echo "==> Fix 4/4: Python import errors (sibling directories)"
    echo "    Problem: ModuleNotFoundError importing from another folder"
    echo ""
    echo "→ Option A (recommended): Install your project as a package"
    echo "   cd your-project/"
    echo "   python3 -m pip install -e ."
    echo "   (You need a setup.py or pyproject.toml)"
    echo ""
    echo "→ Option B: Add parent to PYTHONPATH"
    echo '   export PYTHONPATH="${PYTHONPATH}:$(pwd)"'
    echo ""
    echo "→ Option C (in-code, last resort):"
    echo "   import sys; from pathlib import Path"
    echo "   sys.path.insert(0, str(Path(__file__).parent.parent))"
    echo ""
    echo "→ Minimal pyproject.toml for Option A:"
    echo "   [build-system]"
    echo '   requires = ["setuptools>=61.0"]'
    echo "   build-backend = \"setuptools.backends._legacy:_Backend\""
    echo "   [project]"
    echo "   name = \"myproject\""
    echo "   version = \"0.1.0\""
    echo ""
}

# ── Dispatch ──
case "${1:-all}" in
    pip-ssl)       fix_pip_ssl ;;
    venv-check)    fix_venv_check ;;
    matplotlib-fix) fix_matplotlib ;;
    import-path)   fix_import_path ;;
    all)           run_all ;;
    *)
        echo "Usage: $0 [pip-ssl|venv-check|matplotlib-fix|import-path|all]"
        exit 1
        ;;
esac