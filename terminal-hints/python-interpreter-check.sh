#!/bin/sh
# hermes-python-interpreter-check.sh — Diagnose which Python interpreter you're actually running
# Usage: ./python-interpreter-check.sh
# Safe for beginners • POSIX-compliant • Idempotent • Read-only (no sudo, no writes)

echo "==> Python Interpreter Check — which 'python' is real?"
echo

# 1. What commands exist on PATH, and which version do they run?
for cmd in python python3 python2 pip pip3; do
  if command -v "$cmd" >/dev/null 2>&1; then
    loc=$(command -v "$cmd")
    ver=$("$cmd" --version 2>&1 | head -n1)
    printf "  %-8s -> %s  (%s)\n" "$cmd" "$loc" "$ver"
  else
    printf "  %-8s -> (not found)\n" "$cmd"
  fi
done
echo

# 2. Resolve the symlink chain for python3 (portable: readlink -f is GNU/Linux-only)
if command -v python3 >/dev/null 2>&1; then
  echo "==> Symlink chain for 'python3':"
  target=$(command -v python3)
  i=0
  while [ -L "$target" ] && [ "$i" -lt 10 ]; do
    link=$(ls -l "$target" 2>/dev/null | sed 's/.* -> //')
    printf "  %s -> %s\n" "$target" "$link"
    case "$link" in
      /*) target="$link" ;;
      *) target="$(dirname "$target")/$link" ;;
    esac
    i=$((i+1))
  done
  printf "  (final target) %s\n" "$target"
fi
echo

# 3. Why 'python' vs 'python3' vs a version number? Plain-English explanation.
cat <<'EOF'
==> Why does 'python' point to 'python3' (and that to a version number)?

  This is normal on macOS and Linux. The convention is:
    python      -> the system default (usually an alias for python3)
    python3     -> the current "3.x" symlink (always safe to call)
    python3.14  -> a specific installed version

  Scripts can safely call 'python3' and always get some 3.x, while tools
  pinned to an exact version call 'python3.14' directly. On Windows there is
  only 'python' (the py.exe launcher picks the version).

EOF

# 4. Catch the classic "invalid syntax" cause: Python 2 vs Python 3.
echo "==> Quick sanity checks:"
if command -v python2 >/dev/null 2>&1; then
  echo "  !! Python 2 detected. Python 3 code throws 'invalid syntax' on Python 2."
  echo "     -> Always use 'python3' (never 'python'/'python2') for Python 3 code."
else
  echo "  OK  No Python 2 detected — 'python3' is your safest command."
fi

if command -v python3 >/dev/null 2>&1; then
  major=$(python3 -c 'import sys; print(sys.version_info[0])' 2>/dev/null)
  if [ "$major" = "3" ]; then
    echo "  OK  'python3' runs Python 3 — good."
  fi
fi

echo
echo "Done. Rule of thumb: use 'python3 -m pip install <pkg>' and 'python3 script.py'."
echo "If 'invalid syntax' appears, you may be running Python 2 code on Python 3"
echo "(or vice versa) — check with 'python3 --version'."
