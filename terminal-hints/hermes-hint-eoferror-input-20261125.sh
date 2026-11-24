#!/bin/sh
# hermes-hint-eoferror-input-20261125.sh — fix "EOFError: EOF when reading a line"
# Usage: ./hermes-hint-eoferror-input-20261125.sh [your_script.py]
# Source: r/learnpython post 1y4msgt ("EOF when writing code for list")
# Safe for beginners • POSIX-compliant • Idempotent
set -u

SCRIPT="${1:-}"

echo "==> EOFError: EOF when reading a line — what it means and how to fix it"
echo
echo "  input() (or sys.stdin.readline()) hit the end of its input stream before"
echo "  you supplied a line. Python raises EOFError because there is literally"
echo "  nothing left to read."
echo
echo "  The 3 most common triggers:"
echo "    1. A loop calls input() one time too many (off-by-one)."
echo "    2. The IDE 'Run' button isn't attached to a console that can send input."
echo "    3. The script is run with no stdin (online judge / < /dev/null / closed pipe)."
echo

if [ -n "$SCRIPT" ]; then
  if [ -f "$SCRIPT" ]; then
    echo "── Scanning $SCRIPT for input() calls ──"
    if command -v grep >/dev/null 2>&1; then
      grep -n 'input(' "$SCRIPT" 2>/dev/null || echo "  (no input() calls found)"
    fi
    echo
  else
    echo "⚠ '$SCRIPT' not found — skipping scan."
    echo
  fi
fi

echo "── Fix 1: supply the input via stdin ──"
echo
echo "  printf '3\\nAlice\\nBob\\nCarol\\n' | python3 ${SCRIPT:-your_script.py}"
echo "  # or feed a file:  python3 ${SCRIPT:-your_script.py} < input.txt"
echo

echo "── Fix 2: read ALL input at once, then loop ──"
echo "  # instead of:  for _ in range(n): x = input()"
echo
cat <<'EOF'
import sys
lines = sys.stdin.read().splitlines()   # safe even if input is short/empty
for line in lines:
    print("got:", line)
EOF
echo

echo "── Fix 3: guard against missing input ──"
cat <<'EOF'
try:
    line = input()
except EOFError:
    line = None   # no more input — handle gracefully
EOF
echo

echo "── Fix 4 (IDE users): run in the Integrated Terminal, not 'Run Python File' ──"
echo "  VS Code: open Terminal > New Terminal, then run 'python3 your_script.py'"
echo "  so the process inherits a real console that can accept your keystrokes."
echo

echo "✓ Done. If the error persists, check that your loop reads exactly one line"
echo "  per line you actually provide."
