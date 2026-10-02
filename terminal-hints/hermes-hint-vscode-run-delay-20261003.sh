#!/bin/sh
# vscode-python-run-speedup.sh — Fix the ~5s "Run Python File" delay in VS Code
# Usage: ./vscode-python-run-speedup.sh [your_script.py]
# Safe for beginners • POSIX-compliant • Idempotent (diagnostic only — changes nothing)

echo "==> VS Code 'Run Python File' speedup — why the button is slow & how to fix it"
echo

# --- Platform & prerequisites ---
OS="$(uname)"
PY=""
for c in python3 python; do
  if command -v "$c" >/dev/null 2>&1; then PY="$c"; break; fi
done

if [ -z "$PY" ]; then
  echo "✗ Python 3 not found on PATH. Install it first: https://python.org"
  exit 1
fi
PY_VERSION="$("$PY" --version 2>&1)"
echo "→ Detected $OS — using $PY ($PY_VERSION)"

if command -v code >/dev/null 2>&1; then
  echo "→ Found VS Code CLI (code) — you can apply the settings snippet below."
else
  echo "→ VS Code CLI (code) not on PATH — skip straight to the fixes below."
fi
echo

# --- The cause, in plain language ---
echo "Why is the ▶ Run button slow?"
echo "  The 'Run Python File' button launches a fresh Python process, activates"
echo "  your environment, and waits on the language server on every run."
echo "  Running the file directly in the terminal skips all of that — it's instant."
echo

# --- Benchmark: prove the direct run is fast ---
echo "Proof — benchmark a direct run (should be ~0-1s, not 5s):"
TMP="$(mktemp /tmp/pybench.XXXXXX)" || TMP="/tmp/pybench.$$"
printf 'print("hello")\n' > "$TMP"
START="$(command -p date +%s)"
"$PY" "$TMP" >/dev/null 2>&1
END="$(command -p date +%s)"
ELAPSED=$((END - START))
rm -f "$TMP"
echo "  → direct '$PY file.py' finished in ${ELAPSED}s (the ▶ button often takes ~5s)"
echo

# --- The fixes (copy/paste, no system changes) ---
echo "Fixes (pick one):"
echo
echo "  1) Run the file directly instead of the ▶ button:"
echo "       $PY your_script.py"
echo
echo "  2) Skip the slow env-activation step — add to VS Code settings.json:"
echo '       "python.terminal.activateEnvironment": false'
echo
echo "  3) Add a fast 'py' alias to your shell profile:"
echo "       alias py='$PY'"
echo
echo "  4) Use the integrated terminal: Ctrl+\` then '$PY your_script.py'"
echo

# --- Optional: run the user's own script on the fast path ---
if [ -n "${1:-}" ]; then
  if [ -f "$1" ]; then
    echo "==> Running '$1' directly (the fast path):"
    "$PY" "$1"
  else
    echo "✗ '$1' not found. Pass a real .py file, e.g.:"
    echo "    ./vscode-python-run-speedup.sh my_script.py"
    exit 1
  fi
fi

echo
echo "✓ Done. The ▶ button isn't broken — it's doing extra setup. Run directly and it's instant."
