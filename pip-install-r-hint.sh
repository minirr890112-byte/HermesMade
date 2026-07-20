#!/usr/bin/env bash
# Terminal Hint: pip install -r requirements.txt fails on macOS
# Auto-generated from r/learnpython pain point scan
# Generated: 2025-07-21
# Source: reddit.com/r/learnpython/comments/1kphir9/need_help_with_installing_requirementstxt/
# Category: Environment | Pain Score: 2 | Comments: 28

# ─────────────────────────────────────────────────────────
# PAIN: "pip install -r requirements.txt" -> "install: illegal option -- r"
# ─────────────────────────────────────────────────────────
# This error happens on macOS when /usr/bin/install (system copy tool)
# is invoked instead of pip. Causes:
#   - pip not installed (Python not in PATH)
#   - Shell alias masking 'pip'
#   - python3 -m pip is the reliable workaround

DETECT_PATTERN="pip[3]? install .*-r"
FIX_COMMAND="python3 -m pip install -r requirements.txt"

# Override pip with a wrapper that detects the macOS conflict
pip() {
  if [[ "$*" == *"install"* && "$*" == *"-r"* ]]; then
    echo "TERMINAL HINT: pip install -r conflict on macOS"
    echo "   The error 'install: illegal option -- r' means macOS /usr/bin/install ran instead of pip."
    echo ""
    echo "   Quick fix: python3 -m pip install -r requirements.txt"
    echo ""
    echo "   Debug: which pip && pip --version"
    echo "   Ensure pip: python3 -m ensurepip --upgrade"
    echo "   Alias (add to ~/.zshrc): alias pip='python3 -m pip'"
    echo ""
    command python3 -m pip "$@"
  else
    command pip "$@"
  fi
}

fix_pip_on_macos() {
  echo "Fixing pip on macOS..."
  if ! command -v python3 &>/dev/null; then
    echo "python3 not found. Install: brew install python@3.12"
    return 1
  fi
  python3 -m ensurepip --upgrade 2>/dev/null || true
  echo "Use: python3 -m pip install -r requirements.txt"
  echo "Add alias: echo "alias pip='python3 -m pip'" >> ~/.zshrc"
}

show_help() {
  cat << 'EOF'
pip-install-r Hint - macOS pip install -r fix
==============================================
Problem: "install: illegal option -- r" on 'pip install -r requirements.txt'
Cause: macOS /usr/bin/install runs instead of pip

Solutions:
  1. python3 -m pip install -r requirements.txt  (always safe)
  2. source ./pip-install-r-hint.sh               (auto-detect wrapper)
  3. bash ./pip-install-r-hint.sh fix             (one-shot fix)
EOF
}

case "${1:-}" in
  fix) fix_pip_on_macos ;;
  help|--help|-h) show_help ;;
  *) [[ "${BASH_SOURCE[0]}" == "${0}" ]] && show_help ;;
esac
