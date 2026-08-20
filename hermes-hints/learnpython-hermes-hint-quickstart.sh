#!/bin/sh
# hermes-hint — Print a beginner-friendly Python quick-start path
# Usage: ./hermes-hint-quickstart.sh
# Safe for beginners • POSIX-compliant • Idempotent
set -e

echo "==> Python quick-start (beginner path)"

if [ "$(uname)" = "Darwin" ]; then
  echo "→ Detected macOS."
  command -p python3 --version
  echo "  → Next: python3 -m pip install --user jupyter"
else
  echo "→ Detected Linux/other."
  python3 --version
  echo "  → Next: python3 -m pip install --user jupyter"
fi

echo "✓ Done. Open a tutorial and type-along. Consistency beats speed."
