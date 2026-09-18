#!/bin/sh
# hermes-hint-shell-args.sh — Diagnose shell metacharacters eating your Python CLI args
# Usage: ./hermes-hint-shell-args.sh [args...]
#   e.g.  ./hermes-hint-shell-args.sh A.csv + B.csv = C.csv
# Safe for beginners • POSIX-compliant • Idempotent • No sudo
#
# WHY THIS EXISTS
#   When you run:   python csv-math.py A.csv + B.csv = C.csv
#   the shell rewrites "+", "=", "*", "/", "-" BEFORE Python ever sees them.
#   Result: your script gets the wrong arguments (or none), glob expansion
#   explodes, and you get baffling errors. The fix is to quote the symbols.
#
# WHAT THIS DOES
#   Prints every argument your shell actually handed over, numbered, so you
#   can SEE what got mangled — then shows the corrected, quoted invocation.

echo "==> Shell Argument Inspector"
echo "    (Bare symbols like + - * / = are rewritten by the shell before"
echo "     your script ever runs. This shows you exactly what survived.)"
echo

if [ "$#" -eq 0 ]; then
  echo "No arguments received. Pass some to see how the shell treats them."
  echo
  echo "Usage: $0 [args...]"
  echo "Example (try it unquoted, then quoted):"
  echo "  $0 A.csv + B.csv = C.csv"
  echo "  $0 \"A.csv\" \"+\" \"B.csv\" \"=\" \"C.csv\""
  exit 0
fi

i=1
for arg in "$@"; do
  printf '  arg %s: <%s>\n' "$i" "$arg"
  i=$((i + 1))
done

echo
echo "→ If any symbol vanished (or you got a glob/redirect error), re-run"
echo "  quoting each symbol:  \"+\" \"=\" \"*\" \"/\" \"-\"  (or use a single quoted arg)."
echo "→ For your own Python CLI, prefer named flags via argparse:"
echo "    python csv-math.py --left A.csv --op + --right B.csv --out C.csv"
echo
echo "✓ Tip: quote any argument containing + - * / = ( ) & ; < > | \` \$"
