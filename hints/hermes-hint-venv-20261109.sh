#!/bin/sh
# hermes-hint-venv.sh -- create & use a clean virtual environment
# Usage: ./hermes-hint-venv.sh [venv-name]
# Safe for beginners * POSIX-compliant * Idempotent * No sudo
set -u

echo "==> venv setup -- isolate your project dependencies"

PY=""
if command -v python3 >/dev/null 2>&1; then PY="python3"
elif command -v python >/dev/null 2>&1; then PY="python"
else echo "! Python not found."; exit 1; fi

VENV="${1:-venv}"
echo "-> Using $PY -> $(command -v $PY)"

if [ ! -d "$VENV" ]; then
  $PY -m venv "$VENV"
  echo "-> Created '$VENV'"
else
  echo "-> '$VENV' already exists"
fi

echo "-> Activate with:"
if [ "$(uname)" = "Darwin" ] || [ "$(uname)" = "Linux" ]; then
  echo "   source $VENV/bin/activate"
else
  echo "   $VENV\\Scripts\\activate"
fi
echo "-> Then: $PY -m pip install <package>"
