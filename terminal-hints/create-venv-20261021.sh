#!/bin/sh
# hermes-hint.sh — create & activate a Python virtual environment (venv)
# Usage: ./create-venv.sh [env_name]
# Safe for beginners • POSIX-compliant • Idempotent
set -e

NAME="${1:-venv}"
echo "==> Creating virtual environment: $NAME"

command -p python3 -m venv "$NAME" || {
  echo "-> python3-venv missing? Installing..."
  if [ "$(uname)" = "Linux" ] && command -v apt-get >/dev/null 2>&1; then
    sudo apt-get install -y python3-venv
  fi
  command -p python3 -m venv "$NAME"
}

echo "✓ Created. Activate with:"
echo "   source $NAME/bin/activate      (macOS/Linux)"
echo "   $NAME\\Scripts\\activate        (Windows)"
echo "Then install packages: pip install <pkg>"
echo "To leave: deactivate"
