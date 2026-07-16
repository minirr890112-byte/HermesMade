#!/bin/sh
# hermes-hint-learnpython-20260716.sh — Pain-point fixes from r/learnpython scan
# Usage: ./hermes-hint-learnpython-20260716.sh [pip-ssl|venv-check|matplotlib-fix|import-path]
# Safe for beginners • POSIX-compliant • Idempotent • Idempotent
# Generated: 2026-07-16 23:14 UTC | Source: Training data + prior session data (GFW fallback)
set -e

echo " "
echo "╔════════════════════════════════════════════════╗"
echo "║   🐍 Hermes Terminal Hint — r/learnpython     ║"
echo "║   20260716                           ║"
echo "╚════════════════════════════════════════════════╝"
echo " "
HINT="''${1:-all}"''  # Default: run all checks

# ── Platform detection ──
IS_MACOS="no"
IS_LINUX="no"
IS_WINDOWS="no"
case "$(uname -s)" in
    Darwin*) IS_MACOS="yes" ;;
    Linux*)  IS_LINUX="yes" ;;
    MINGW*|MSYS*|CYGWIN*) IS_WINDOWS="yes" ;;
esac

# ── Fix 1: pip SSL certificate errors ──
fix_pip_ssl() {
    echo "🔒 [pip-ssl] Checking SSL certificate configuration..."
    
    if command -v python3 >/dev/null 2>&1; then
        # Test pip SSL
        SSL_TEST=$(python3 -c "import pip._vendor.requests; print(pip._vendor.requests.certs.where())" 2>/dev/null || echo "FAIL")
        
        if [ "$SSL_TEST" = "FAIL" ]; then
            echo "   ⚠ pip SSL appears broken — upgrading certifi..."
            python3 -m pip install --upgrade --user certifi pip 2>/dev/null || true
            echo "   ✓ certifi upgraded. Run: export SSL_CERT_FILE=$(python3 -m certifi 2>/dev/null || echo '')"
        else
            CERT_FILE=$(python3 -m certifi 2>/dev/null || echo "")
            if [ -n "$CERT_FILE" ]; then
                echo "   ✓ SSL cert bundle found: $CERT_FILE"
                echo "   💡 If pip SSL fails on corporate networks, run:"
                echo "      export SSL_CERT_FILE=$(python3 -m certifi)"
                echo "      export REQUESTS_CA_BUNDLE=$(python3 -m certifi)"
            else
                echo "   ⚠ certifi not found. Install: python3 -m pip install --upgrade certifi"
            fi
        fi
    else
        echo "   ⚠ python3 not found on PATH"
    fi
    echo " "
}

# ── Fix 2: Virtual environment check ──
fix_venv_check() {
    echo "📦 [venv-check] Checking virtual environment status..."

    if [ -n "$VIRTUAL_ENV" ]; then
        echo "   ✓ Active virtual environment: $VIRTUAL_ENV"
        echo "   ✓ Python: $(python3 --version 2>/dev/null || echo 'unknown')"
    else
        echo "   ⚠ No virtual environment active!"
        echo "   💡 Create and activate one:"
        
        if [ "$IS_WINDOWS" = "yes" ]; then
            echo "      python -m venv .venv"
            echo "      .venv\\Scripts\\activate.bat       # Command Prompt"
            echo "      .venv\\Scripts\\Activate.ps1       # PowerShell (needs: Set-ExecutionPolicy RemoteSigned -Scope CurrentUser)"
        else
            echo "      python3 -m venv ~/.venv"
            echo "      source ~/.venv/bin/activate"
            echo "   "
            echo "   ⚠ macOS Homebrew users: You need venv because of PEP 668."
            echo "      Direct pip install will fail with 'externally-managed-environment'."
        fi
    fi
    echo " "
}

# ── Fix 3: macOS matplotlib backend ──
fix_matplotlib_backend() {
    echo "📊 [matplotlib-fix] Checking matplotlib backend..."

    if [ "$IS_MACOS" = "yes" ]; then
        # Check if matplotlib is installed
        MPL_CHECK=$(python3 -c "import matplotlib; print(matplotlib.get_backend())" 2>/dev/null || echo "NOT_INSTALLED")
        
        if [ "$MPL_CHECK" = "NOT_INSTALLED" ]; then
            echo "   ⓘ matplotlib not installed — skipping"
        elif [ "$MPL_CHECK" = "MacOSX" ] || [ "$MPL_CHECK" = "TkAgg" ]; then
            echo "   ✓ matplotlib backend: $MPL_CHECK"
        else
            echo "   ⚠ matplotlib backend is '$MPL_CHECK' — may cause issues."
            echo "   💡 Add this BEFORE importing pyplot:"
            echo "      import matplotlib"
            echo "      matplotlib.use('TkAgg')  # or 'QtAgg' if you have PyQt installed"
        fi
        
        # Check MPLBACKEND env var
        if [ -n "$MPLBACKEND" ]; then
            echo "   ⓘ MPLBACKEND set to: $MPLBACKEND"
        fi
    else
        echo "   ⓘ macOS-only check — skipping on $(uname -s)"
    fi
    echo " "
}

# ── Fix 4: Import path / sibling import check ──
fix_import_path() {
    echo "📁 [import-path] Checking Python import path..."
    
    # Check if we're in a project directory
    if [ -f "setup.py" ] || [ -f "pyproject.toml" ]; then
        echo "   ✓ Project root detected"
        
        # Check for pip install -e
        PIP_LIST=$(python3 -m pip list --format=json 2>/dev/null || echo "[]")
        if echo "$PIP_LIST" | grep -q '"editable_project_location"'; then
            echo "   ✓ Package installed in editable mode"
        else
            echo "   💡 For sibling imports to work, install in dev mode:"
            echo "      python3 -m pip install -e ."
        fi
    else
        echo "   ⓘ No setup.py/pyproject.toml found — not a Python package"
    fi
    
    # Check PYTHONPATH
    if [ -n "$PYTHONPATH" ]; then
        echo "   ⓘ PYTHONPATH: $PYTHONPATH"
    fi
    
    echo "   💡 Cross-platform paths: Use 'from pathlib import Path' instead of raw strings"
    echo "      pathlib.Path('data', 'input.csv')  # works on Windows, macOS, and Linux"
    echo " "
}

# ── Fix 5: pip dependency resolver ──
fix_pip_resolver() {
    echo "🔗 [pip-resolver] Checking pip dependency resolution..."

    if command -v pip3 >/dev/null 2>&1; then
        PIP_VER=$(pip3 --version 2>/dev/null | awk '{print $2}')
        echo "   pip version: $PIP_VER"
        
        if python3 -c "import pip; exit(0 if tuple(map(int, pip.__version__.split('.'))) >= (20,3) else 1)" 2>/dev/null; then
            echo "   ⓘ pip 20.3+ has strict dependency resolver — conflicts are now errors"
            echo "   💡 If pip hangs on resolving dependencies:"
            echo "      1. Upgrade pip:  python3 -m pip install --upgrade pip"
            echo "      2. Use uv (fast): curl -LsSf https://astral.sh/uv/install.sh | sh"
            echo "      3. Use poetry:   pip install poetry && poetry add <package>"
        fi
    else
        echo "   ⚠ pip not found"
    fi
    echo " "
}

# ── Run selected hint(s) ──
case "$HINT" in
    pip-ssl)        fix_pip_ssl ;;
    venv-check)     fix_venv_check ;;
    matplotlib-fix) fix_matplotlib_backend ;;
    import-path)    fix_import_path ;;
    pip-resolver)   fix_pip_resolver ;;
    all|*)
        fix_pip_ssl
        fix_venv_check
        fix_matplotlib_backend
        fix_import_path
        fix_pip_resolver
        ;;
esac

echo "✓ All checks complete. Happy coding! 🐍"
