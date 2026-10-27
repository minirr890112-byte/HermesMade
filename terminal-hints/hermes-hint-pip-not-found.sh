#!/bin/sh
# hermes-hint-pip-not-found.sh — fix "pip installed it, but Python can't find it"
# Usage: ./hermes-hint-pip-not-found.sh [package-name]
# Safe for beginners • POSIX-compliant • Idempotent • No sudo
set -e

echo "==> pip-not-found fix — 'install said OK, but import fails'"

# 1. Locate the interpreter your scripts actually run with
if ! command -v python3 >/dev/null 2>&1; then
    echo "✗ python3 not found on PATH. Install Python first: https://www.python.org/downloads/"
    exit 1
fi

PY_EXE="$(python3 -c 'import sys; print(sys.executable)' 2>/dev/null || echo "python3")"
RUN_VER="$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:2])))' 2>/dev/null || echo "?")"
echo "→ Your scripts run with:   $PY_EXE  (Python $RUN_VER)"

# 2. Locate the interpreter that 'python3 -m pip' installs into
if python3 -m pip --version >/dev/null 2>&1; then
    PIP_VER="$(python3 -m pip --version | sed -n 's/.*(python \([0-9.]*\)).*/\1/p')"
    echo "→ python3 -m pip targets:  Python ${PIP_VER:-unknown}"
else
    echo "✗ python3 -m pip is broken or missing. Bootstrap it with:  python3 -m ensurepip --user"
    exit 1
fi

# 3. Warn if the two interpreters differ (the root cause of this pain)
if [ -n "$PIP_VER" ] && [ "$RUN_VER" != "$PIP_VER" ]; then
    echo ""
    echo "⚠  MISMATCH: scripts run on Python $RUN_VER, but pip installs into Python $PIP_VER."
    echo "   That is why installs 'succeed' yet import fails."
    echo "   Fix: always install with the SAME interpreter that runs your script."
fi

# 4. Optional: install a specific package correctly, then verify it imports
if [ -n "${1:-}" ]; then
    echo ""
    echo "→ Installing '$1' into the interpreter your scripts use..."
    python3 -m pip install --user "$1"
    MODULE="${1%%[<>=!~]*}"
    echo "→ Verifying import of '$MODULE'..."
    if python3 -c "import $MODULE" 2>/dev/null; then
        echo "✓ '$1' imports successfully. You're good to go!"
    else
        echo "✗ Import still fails. The import name may differ from the package name"
        echo "  (e.g. package 'beautifulsoup4' imports as 'bs4'). Check the docs."
        echo "  Confirm the interpreter: python3 -c 'import sys; print(sys.executable)'"
    fi
else
    echo ""
    echo "── Golden rule ─────────────────────────────────────────────────"
    echo "  ALWAYS:  python3 -m pip install <package>"
    echo "  NEVER:   pip install <package>     # may target a different Python"
    echo "  CHECK:   python3 -c 'import sys; print(sys.executable)'"
    echo "           python3 -m pip --version"
    echo "────────────────────────────────────────────────────────────────"
fi

echo "✓ Done."
