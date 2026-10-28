#!/bin/sh
# hermes-hint-pg-config-executable-not-found.sh — Fix "pg_config executable not found" (psycopg2 install)
# Usage: ./hermes-hint-pg-config-executable-not-found.sh
# Safe for beginners • POSIX-compliant • Idempotent
set -e

echo "==> Installing PostgreSQL dev headers so psycopg2 can build"

if [ "$(uname)" = "Darwin" ]; then
  # macOS — install via Homebrew
  if command -v brew >/dev/null 2>&1; then
    brew install postgresql
  else
    echo "Install Homebrew first: https://brew.sh"; exit 1
  fi
elif command -v apt-get >/dev/null 2>&1; then
  # Debian / Ubuntu
  sudo apt-get update && sudo apt-get install -y libpq-dev
elif command -v dnf >/dev/null 2>&1; then
  # Fedora / RHEL
  sudo dnf install -y libpq-devel
else
  echo "Install libpq-dev (Debian) / libpq-devel (Fedora) / postgresql (brew)"; exit 1
fi

# Easiest path: the prebuilt binary wheel avoids the compile step entirely
python3 -m pip install psycopg2-binary

echo "✓ Done. Use 'psycopg2-binary' to skip the build step in future installs."
