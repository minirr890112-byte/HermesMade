#!/bin/sh
# hermes-hint-subprocess-block.sh — Detect & fix Python subprocess.run() blocking your input() loop
# Usage: ./hermes-hint-subprocess-block.sh [your_script.py]
# Safe for beginners • POSIX-compliant • Idempotent • No sudo • No destructive ops
#
# Pain point (r/learnpython, Nov 2026): a script launches an app via subprocess.run()
# but then never re-prompts for input — because run() BLOCKS until the child exits.
#
#   import subprocess
#   while True:
#       u = input("press q to quit: ")
#       if u == "q": break
#       subprocess.run("/path/to/LocalSend.AppImage", shell=True)  # <- blocks here
#
# Fix: launch in the background with subprocess.Popen (non-blocking) and keep a handle
# so you can poll or terminate it later.

set -e

TARGET="${1:-}"

echo "==> subprocess-block hint — fix 'my script won't read input / terminate'"

# ---------- Mode A: scan a script for blocking calls ----------
if [ -n "$TARGET" ]; then
  if [ ! -f "$TARGET" ]; then
    echo "✗ File not found: $TARGET"
    exit 1
  fi
  echo "→ Scanning $TARGET for blocking subprocess calls..."

  if grep -Eq 'subprocess\.(run|call|check_output|check_call)|os\.system' "$TARGET"; then
    echo "⚠ Found blocking call(s). subprocess.run()/call()/check_output() and os.system()"
    echo "  all WAIT for the child to finish before the next line runs — that's why your"
    echo "  input() loop freezes after the first launch."
    echo
    echo "  Matches:"
    grep -nE 'subprocess\.(run|call|check_output|check_call)|os\.system' "$TARGET" || true
  else
    echo "✓ No blocking subprocess calls found. If the loop still hangs, check for"
    echo "  time.sleep(), a tight while loop, or input() buffering instead."
  fi
fi

# ---------- Mode B: print the ready-to-paste fix ----------
echo
echo "── The fix (non-blocking) ─────────────────────────────────────────────"
cat <<'EOF'
import subprocess

proc = None
while True:
    user_input = input("press q to quit: ").strip()
    if user_input == "q":
        if proc is not None and proc.poll() is None:
            proc.terminate()          # stop the app before we exit
        break
    # Launch WITHOUT blocking, keep a handle to control it later:
    proc = subprocess.Popen(
        ["/path/to/LocalSend.AppImage"],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )
EOF
echo "──────────────────────────────────────────────────────────────────────"
echo "Key change: Popen(...) returns immediately; poll() checks if it's alive;"
echo "terminate() stops it cleanly. run() == start + wait; Popen == start only."

# ---------- Clipboard convenience (platform-aware, safe) ----------
if [ -n "$TARGET" ]; then
  if [ "$(uname)" = "Darwin" ]; then
    command -p pbcopy < "$TARGET" >/dev/null 2>&1 && echo "✓ Copied $TARGET to clipboard (macOS)."
  elif command -v xclip >/dev/null 2>&1; then
    xclip -selection clipboard < "$TARGET" 2>/dev/null && echo "✓ Copied $TARGET to clipboard (xclip)."
  else
    echo "ℹ Install xclip (Linux) for clipboard copy, or just edit the file directly."
  fi
fi

echo "✓ Done. Replace subprocess.run() with subprocess.Popen() to un-block your loop."
