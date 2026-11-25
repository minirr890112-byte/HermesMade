#!/bin/sh
# hermes-hint-unicode-escape-fix-20261125.sh — Convert literal \n / \t / \r escapes to real characters WITHOUT garbling UTF-8 accents (ü, é, ñ, ...)
# Usage: ./hermes-hint-unicode-escape-fix-20261125.sh <file> [output-file]
# Problem it fixes: printed output shows "New York\nParis\nNürnberg" instead of real newlines,
#   and the common .encode().decode('unicode-escape') workaround corrupts accented characters.
# Safe for beginners • POSIX-compliant • Idempotent (re-running is a no-op on already-fixed files)
set -eu

echo "==> unicode-escape fix — turn literal \\n/\\t escapes into real chars, keep UTF-8 intact"

# Friendly dependency check: find a working Python (macOS users sometimes have a
# broken /usr/bin/python3 stub blocked by the Xcode license — so we try a few names).
PY=""
for cand in python3 python3.12 python3.11 python3.10 python; do
  if command -v "$cand" >/dev/null 2>&1 && "$cand" -c 'pass' 2>/dev/null; then
    PY="$cand"; break
  fi
done
if [ -z "$PY" ]; then
  echo "✗ No working Python found on PATH. Install Python 3 first (https://www.python.org/downloads/)" >&2
  exit 1
fi

INPUT="${1:-}"
if [ -z "$INPUT" ] || [ ! -f "$INPUT" ]; then
  echo "Usage: $0 <file> [output-file]" >&2
  echo "  Reads <file>, converts literal \\n \\t \\r \\\\ sequences, writes to <output-file> (or stdout if omitted)." >&2
  exit 1
fi

OUTPUT="${2:-}"

# The correct fix is a *targeted* replacement of backslash escapes — NOT unicode-escape,
# which decodes the whole string as latin-1 and corrupts multibyte UTF-8 (ü, é, ñ, ...).
if [ -n "$OUTPUT" ]; then
  "$PY" - "$INPUT" "$OUTPUT" <<'PY'
import sys
src, dst = sys.argv[1], sys.argv[2]
with open(src, encoding="utf-8") as f:
    text = f.read()
fixed = (
    text.replace("\\\\", "\x00")   # protect existing literal double-backslash
        .replace("\\n", "\n")       # literal backslash-n  -> real newline
        .replace("\\t", "\t")       # literal backslash-t  -> real tab
        .replace("\\r", "\r")       # literal backslash-r  -> real carriage return
        .replace("\x00", "\\\\")    # restore the protected backslashes
)
with open(dst, "w", encoding="utf-8") as f:
    f.write(fixed)
print("✓ Wrote fixed output to", dst)
PY
else
  "$PY" - "$INPUT" <<'PY'
import sys
src = sys.argv[1]
with open(src, encoding="utf-8") as f:
    text = f.read()
fixed = (
    text.replace("\\\\", "\x00")
        .replace("\\n", "\n")
        .replace("\\t", "\t")
        .replace("\\r", "\r")
        .replace("\x00", "\\\\")
)
sys.stdout.write(fixed)
PY
fi

echo "✓ Done. If accents are STILL garbled, your file isn't really UTF-8 — try: \"$PY\" -c \"print(open('$INPUT', encoding='utf-8', errors='replace').read())\""
