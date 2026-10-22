#!/bin/sh
# python-pip-doctor.sh — diagnose & fix "pip installed it, but Python can't import it"
# Usage: ./python-pip-doctor.sh [module-name]
#
# Fixes the #1 r/learnpython pain: a package installs without error, then your
# script throws ModuleNotFoundError / ImportError. Root causes it detects:
#   1. bare `pip` points at a DIFFERENT Python than `python3`  (the classic bug)
#   2. PEP 668 "externally-managed-environment" blocks pip on Linux
#   3. no prebuilt wheel for your Python -> pip builds from source and fails
#   4. the package was installed into a venv you've since deactivated
set -u

MOD="${1:-}"
PY=$(command -v python3 2>/dev/null || command -v python 2>/dev/null)

echo ""
echo "==> Python Environment Doctor"
echo "    Diagnosing: 'pip install worked, but my script can't import it'"
echo ""

if [ -z "$PY" ]; then
    echo "[1/5] ✗ No Python found on PATH."
    echo "      Install it: https://www.python.org/downloads/"
    echo "      (Debian/Ubuntu:  sudo apt install python3 python3-pip)"
    exit 1
fi

echo "[1/5] Interpreter"
echo "      python3 path : $PY"
"$PY" --version 2>&1 | sed 's/^/      version      : /'
if [ -n "${VIRTUAL_ENV:-}" ]; then
    echo "      active venv  : $VIRTUAL_ENV"
else
    echo "      active venv  : (none — system Python)"
fi

echo ""
echo "[2/5] pip vs 'python3 -m pip'  (a mismatch is the classic bug)"
PIP_BIN=$(command -v pip 2>/dev/null || true)
[ -n "$PIP_BIN" ] && echo "      bare pip     : $PIP_BIN"
echo "      python3 -m pip: $("$PY" -m pip --version 2>&1 | head -n1)"

# Heuristic: does bare `pip` shebang point at a non-python3 interpreter?
if [ -n "$PIP_BIN" ] && [ -f "$PIP_BIN" ]; then
    PIP_PY=$(head -n1 "$PIP_BIN" 2>/dev/null | sed 's/^#!//')
    if [ -n "$PIP_PY" ] && ! echo "$PIP_PY" | grep -q 'python3'; then
        echo "      ⚠  MISMATCH: bare 'pip' uses '$PIP_PY' — not your 'python3'."
        echo "         Always install with: $PY -m pip install <pkg>"
    else
        echo "      ✓ No obvious mismatch (still prefer: $PY -m pip install <pkg>)"
    fi
fi

echo ""
echo "[3/5] PEP 668 'externally-managed-environment' check"
STDLIB=$("$PY" -c 'import sysconfig; print(sysconfig.get_path("stdlib"))' 2>/dev/null)
if [ -n "$STDLIB" ] && [ -f "$STDLIB/EXTERNALLY-MANAGED" ]; then
    echo "      ⚠  Detected: your system Python refuses 'pip install'."
    echo "         Fix with a virtual environment:"
    echo "           $PY -m venv .venv && . .venv/bin/activate"
    echo "           $PY -m pip install <pkg>"
else
    echo "      ✓ No externally-managed block detected."
fi

echo ""
echo "[4/5] Import check"
if [ -n "$MOD" ]; then
    if "$PY" -c "import $MOD" >/dev/null 2>&1; then
        echo "      ✓ '$MOD' imports fine in $("$PY" --version 2>&1)"
    else
        echo "      ✗ '$MOD' NOT importable in $("$PY" --version 2>&1)"
        echo "         Install into THIS interpreter:"
        echo "           $PY -m pip install $MOD"
        echo "         If you already did, it went to a DIFFERENT Python. Reinstall"
        echo "         into the interpreter you actually run your script with."
    fi
else
    echo "      (tip) pass a module name to test importability, e.g.:"
    echo "          ./python-pip-doctor.sh numpy"
fi

echo ""
echo "[5/5] Source-build / wheel check"
PY_MINOR=$("$PY" -c 'import sys; print(str(sys.version_info.major)+"."+str(sys.version_info.minor))' 2>/dev/null)
if [ -n "$PY_MINOR" ]; then
    case "$PY_MINOR" in
        3.1[4-9]|3.[2-9][0-9])
            echo "      ⚠  You're on Python $PY_MINOR — a very new release."
            echo "         Many packages (matplotlib, numpy, pandas) ship no prebuilt"
            echo "         wheel yet, so pip falls back to BUILDING FROM SOURCE and"
            echo "         fails on a missing C compiler / 'vswhere.exe'."
            echo "         Fix: use a stable Python (3.11-3.12) via pyenv/conda, or:"
            echo "           $PY -m pip install <pkg> --only-binary :all:"
            ;;
        *)
            echo "      ✓ Python $PY_MINOR is stable; most packages ship prebuilt wheels."
            ;;
    esac
fi

echo ""
echo "--- Quick reference ---"
echo "  Always install : $PY -m pip install <pkg>      (never bare 'pip')"
echo "  Wrong Python   : see [2/5] — reinstall into the interpreter you run"
echo "  PEP 668 blocked: $PY -m venv .venv && . .venv/bin/activate"
echo "  No wheel/build : use a stable Python (3.11-3.12) or --only-binary :all:"
echo "  Missing tkinter: sudo apt install python3-tk  (Debian/Ubuntu)"
echo ""
echo "✓ Done."
