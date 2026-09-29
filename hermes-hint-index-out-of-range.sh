#!/bin/sh
# hermes-hint-index-out-of-range.sh — diagnose & fix Python "index out of range" errors
# Usage:  python3 your_script.py 2>&1 | ./hermes-hint-index-out-of-range.sh
#         ./hermes-hint-index-out-of-range.sh ./traceback.txt
# Safe for beginners • POSIX-compliant • Idempotent
set -e

SCRIPT_NAME="hermes-hint-index-out-of-range.sh"

usage() {
  echo "Usage:"
  echo "  python3 script.py 2>&1 | ./$SCRIPT_NAME   # pipe a live traceback"
  echo "  ./$SCRIPT_NAME ./traceback.txt            # or pass a saved traceback"
  echo "  ./$SCRIPT_NAME install-hook               # auto-detect in zsh/bash"
}

explain() {
  echo ""
  echo "==> IndexError: 'index out of range' — what's really happening"
  echo ""
  echo "Python lets you index a sequence (str/list/tuple) from the END using"
  echo "negative numbers: fruit[-1] is the last character, fruit[-2] the one"
  echo "before it, and so on. This is handy but has a trap:"
  echo ""
  echo "  fruit = \"apple\""
  echo "  index = -1"
  echo "  while index < len(fruit):      # <-- this is ALWAYS true for negatives"
  echo "      letter = fruit[index]      # <-- keeps going -1, -2, ... past -5"
  echo "      index = index - 1"
  echo ""
  echo "The loop condition 'index < len(fruit)' never becomes False, so index"
  echo "walks off the left edge of the string and Python raises:"
  echo "  IndexError: string index out of range"
  echo ""
  echo "==> The fix (pick one)"
  echo ""
  echo "1) Iterate directly — no index bookkeeping at all (Pythonic, safest):"
  echo "       for letter in fruit:"
  echo "           print(letter)"
  echo ""
  echo "2) If you MUST use an index, keep it non-negative:"
  echo "       for index in range(len(fruit)):"
  echo "           print(fruit[index])"
  echo ""
  echo "3) If you really want a backward loop, bound it with len():"
  echo "       for index in range(len(fruit) - 1, -1, -1):"
  echo "           print(fruit[index])"
  echo ""
  echo "✓ Done. Rule of thumb: 'while index < len(seq)' only works when index"
  echo "starts at 0 or higher. Negative indices need 'index >= -len(seq)'."
  echo ""
}

install_hook() {
  echo "==> Installing a shell hook to auto-detect 'index out of range' errors"
  echo ""
  hook_line='preexec_functions+=(_hermes_index_hint)'

  if [ -n "${ZSH_VERSION:-}" ]; then
    echo "→ Detected zsh."
    cat >> "$HOME/.zshrc" <<'EOF'

# hermes: auto-explain Python "index out of range" errors
_hermes_index_hint() {
  local last_cmd="$1"
  case "$last_cmd" in
    python*|python3*)
      : ;;
    *) return ;;
  esac
  echo "💡 If you see 'IndexError: ... index out of range', try:"
  echo "   for item in your_sequence:   # iterate directly, no manual index"
  echo "   Run: ./hermes-hint-index-out-of-range.sh for the full explanation."
}
preexec_functions+=(_hermes_index_hint)
EOF
    echo "✓ Added hook to ~/.zshrc. Restart your shell or run: source ~/.zshrc"
  elif [ -n "${BASH_VERSION:-}" ]; then
    echo "→ Detected bash."
    cat >> "$HOME/.bashrc" <<'EOF'

# hermes: auto-explain Python "index out of range" errors
_hermes_index_hint() {
  local last_cmd="$BASH_COMMAND"
  case "$last_cmd" in
    python*|python3*) : ;;
    *) return ;;
  esac
  echo "💡 If you see 'IndexError: ... index out of range', try:"
  echo "   for item in your_sequence:   # iterate directly, no manual index"
  echo "   Run: ./hermes-hint-index-out-of-range.sh for the full explanation."
}
trap '_hermes_index_hint' DEBUG
EOF
    echo "✓ Added hook to ~/.bashrc. Restart your shell or run: source ~/.bashrc"
  else
    echo "→ Unknown shell. The hook only supports zsh and bash."
  fi
  echo ""
}

main() {
  if [ "$1" = "install-hook" ]; then
    install_hook
    return
  fi

  input=""
  if [ -n "$1" ] && [ -f "$1" ]; then
    input="$(command -p cat "$1")"
  elif [ -n "$1" ] && [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    usage
    return
  elif [ -n "$1" ]; then
    echo "⚠ File not found: $1"
    usage
    return
  else
    # Read piped stdin (traceback). Detect if stdin is a TTY.
    if [ -t 0 ]; then
      echo "No input. Pipe a traceback or pass a file."
      usage
      return
    fi
    input="$(command -p cat)"
  fi

  if printf '%s' "$input" | command -p grep -qi "index out of range"; then
    explain
  else
    echo "No 'index out of range' error found in input."
    echo "Tip: capture stderr too — use '2>&1' when piping:"
    echo "  python3 script.py 2>&1 | ./$SCRIPT_NAME"
  fi
}

main "$@"
