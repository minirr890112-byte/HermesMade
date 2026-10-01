#!/bin/sh
# hermes-hint-file-not-found.sh — Fix "FileNotFoundError" from cwd vs script-folder confusion
# Usage: ./hermes-hint-file-not-found.sh [datafile]
# Safe for beginners • POSIX-compliant • Idempotent • No sudo
set -e

DATA="${1:-data.csv}"

echo "==> FileNotFoundError fix — Python opens relative paths from the current"
echo "    working directory (cwd), NOT from your script's folder."
echo ""

echo "-> Where Python is looking right now (your cwd):"
command -p pwd
echo ""

echo "-> Files Python can actually see here:"
command -p ls -1 2>/dev/null || echo "   (nothing — directory is empty)"
echo ""

echo "-> Is your data file visible from here?"
if [ -f "$DATA" ]; then
  echo "   Found '$DATA' here. Running 'python3 your_script.py' from this folder works."
else
  echo "   '$DATA' NOT found here. That is exactly why open('$DATA') raises FileNotFoundError."
  echo "   Two fixes:"
  echo "     1) cd into the folder that holds the file, then run your script."
  echo "     2) Anchor the path to the script's own folder (works from anywhere):"
  echo "          from pathlib import Path"
  echo "          here = Path(__file__).parent"
  echo "          with open(here / \"$DATA\") as f:"
fi
echo ""

if [ "$(uname)" = "Darwin" ]; then
  echo "-> macOS note: launching a script from Finder or an IDE does not change cwd,"
  echo "   so relative paths break — prefer Path(__file__).parent."
fi

echo ""
echo "[OK] Rule of thumb: relative paths resolve against where you RUN the script,"
echo "     not where it is saved."
