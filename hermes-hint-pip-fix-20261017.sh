#!/bin/sh
# hermes-hint-pip-fix.sh — Diagnose & fix "pip install fails" on Python
#
# The single most common beginner pain on r/learnpython: `pip install <x>`
# errors out with "No module named …", "externally-managed-environment",
# "Failed to build …", or "No matching distribution found".
#
# Usage:
#   ./hermes-hint-pip-fix-20261017.sh <package> [package2 ...]
#   e.g.  ./hermes-hint-pip-fix-20261017.sh ipydatagrid matplotlib
#
# What it does (all safe, idempotent, no sudo):
#   1. Installs to user site-packages with `--user` (no root needed).
#   2. If your OS blocks that (PEP 668 "externally-managed"), it creates a
#      local `.venv` virtual environment and installs there instead.
#   3. Prints the exact activation command + extra fixes for build failures.
#
# POSIX-compliant (dash/ash/bash/zsh) • macOS + Linux • tested with `sh -n`.

set -u

say()  { printf '%s\n' "$*"; }
warn() { printf '⚠️  %s\n' "$*" >&2; }
ok()   { printf '✅ %s\n' "$*"; }

# ---- locate a Python interpreter ----
PY=python3
command -v "$PY" >/dev/null 2>&1 || PY=python
if ! command -v "$PY" >/dev/null 2>&1; then
    warn "No Python interpreter found. Install it first: https://python.org"
    exit 1
fi

say "==> hermes-hint — Fix 'pip install fails'"
say "    Interpreter: $PY ($("$PY" --version 2>&1))"
say "    OS: $(uname -s)"

if [ "$#" -eq 0 ]; then
    warn "No package given."
    say "Usage: $0 <package> [package2 ...]"
    exit 1
fi

# ---- case 0: already inside a virtualenv ----
if [ -n "${VIRTUAL_ENV:-}" ]; then
    say "→ Already inside a virtualenv ($VIRTUAL_ENV). Installing…"
    "$PY" -m pip install "$@"
    ok "Done."
    exit 0
fi

ERRFILE=$(mktemp 2>/dev/null || echo "/tmp/hermes_pip_err.$$")

# ---- attempt 1: user-level install (no sudo) ----
say "→ Attempt 1: user-level install (--user, no sudo) …"
if "$PY" -m pip install --user "$@" 2>"$ERRFILE"; then
    rm -f "$ERRFILE"
    ok "Installed to user site-packages."
    say "   If you then see 'command not found', add this dir to your PATH:"
    "$PY" -m site --user-base 2>/dev/null | sed 's#$#/bin#'
    exit 0
fi

ERR=$(cat "$ERRFILE" 2>/dev/null || true)
rm -f "$ERRFILE"

if printf '%s' "$ERR" | grep -qi 'externally-managed'; then
    warn "Detected PEP 668 'externally-managed-environment'."
    say "   Your OS blocks pip from writing to system Python (Debian/Ubuntu/Fedora)."
    say "   The safe, recommended fix is a virtual environment — continuing…"
fi

# ---- attempt 2: create a virtual environment ----
VENV=.venv
say "→ Attempt 2: creating virtualenv '$VENV' …"
if ! "$PY" -m venv "$VENV" 2>/dev/null; then
    warn "Could not create the venv."
    warn "  On Debian/Ubuntu run:  sudo apt install python3-venv"
    warn "  Then re-run:          $0 $*"
    exit 1
fi

say "→ Installing into '$VENV' …"
"$VENV/bin/python" -m pip install "$@"

ok "Installed into '$VENV'."
say ""
say "To use it, activate the venv first, then run your code:"
if [ "$(uname -s)" = "Darwin" ] || [ "$(uname -s)" = "Linux" ]; then
    say "    source $VENV/bin/activate"
else
    say "    $VENV\\Scripts\\activate    (Windows)"
fi

say ""
say "Still stuck? If you saw 'Failed to build …' or 'No matching distribution found':"
say "    • Your Python may be too new for that package (e.g. 3.13 / 3.14)."
say "    • Try a prebuilt wheel:  $VENV/bin/python -m pip install --only-binary :all: $*"
say "    • Or pin an older Python (3.11 / 3.12) for packages like tensorflow_text."
