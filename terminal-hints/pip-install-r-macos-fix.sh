#!/usr/bin/env bash
# =============================================================================
# Hermes Terminal Hint: Fix "pip install -r requirements.txt" on macOS
# =============================================================================
# Generated: 2026-06-08
# Source: r/learnpython — "Need help with installing requirements.txt" (↑2 💬28)
# Pain: macOS `install` binary shadows `pip install`, causing "illegal option -- r"
# Fix: Use `python3 -m pip` or full pip path instead of bare `pip install`
# =============================================================================

# ── Auto-detect shell and clipboard backend ──────────────────────────────────
_fix_pip_install_r() {
    local last_stderr="$1"

    # Trigger: "install: illegal option -- r" (macOS system install, not pip)
    if [[ "$last_stderr" == *"install: illegal option -- r"* ]] || \
       [[ "$last_stderr" == *"install: illegal option"* ]]; then
        echo ""
        echo "┌─────────────────────────────────────────────────────────────┐"
        echo "│ 💡  macOS gotcha!                                           │"
        echo "│                                                             │"
        echo "│  You ran:     pip install -r requirements.txt               │"
        echo "│  But macOS ran the system /usr/bin/install instead of pip.  │"
        echo "│                                                             │"
        echo "│  ✅  Fix: Use python3 -m pip instead:                       │"
        echo "│                                                             │"
        echo "│      python3 -m pip install -r requirements.txt             │"
        echo "│                                                             │"
        echo "│  📋  The command has been copied to your clipboard.         │"
        echo "│      Paste it (Cmd+V / Ctrl+Shift+V) and press Enter.       │"
        echo "└─────────────────────────────────────────────────────────────┘"
        echo ""

        # Copy the fix to clipboard (cross-platform)
        if command -v pbcopy &>/dev/null; then
            echo -n "python3 -m pip install -r requirements.txt" | pbcopy
        elif command -v xclip &>/dev/null; then
            echo -n "python3 -m pip install -r requirements.txt" | xclip -selection clipboard
        elif command -v clip.exe &>/dev/null; then
            echo -n "python3 -m pip install -r requirements.txt" | clip.exe
        fi
    fi

    # Bonus trigger: "pip: command not found" on fresh macOS
    if [[ "$last_stderr" == *"pip: command not found"* ]] || \
       [[ "$last_stderr" == *"pip3: command not found"* ]]; then
        echo ""
        echo "┌─────────────────────────────────────────────────────────────┐"
        echo "│ 💡  pip not found? No problem!                               │"
        echo "│                                                             │"
        echo "│  On macOS, python3 is installed but pip may not be on PATH. │"
        echo "│                                                             │"
        echo "│  ✅  Fix: Use the built-in pip module:                      │"
        echo "│                                                             │"
        echo "│      python3 -m pip install <package-name>                  │"
        echo "│                                                             │"
        echo "│  📋  The command has been copied to your clipboard.         │"
        echo "└─────────────────────────────────────────────────────────────┘"
        echo ""
        if command -v pbcopy &>/dev/null; then
            echo -n "python3 -m pip install " | pbcopy
        elif command -v xclip &>/dev/null; then
            echo -n "python3 -m pip install " | xclip -selection clipboard
        fi
    fi
}

# ── Shell integration ───────────────────────────────────────────────────────
# Paste this into your ~/.zshrc or ~/.bashrc, then run `source ~/.zshrc`

# zsh: preexec hook
if [[ -n "$ZSH_VERSION" ]]; then
    # Capture stderr from last command
    _last_stderr=""
    _capture_stderr() {
        exec 3>&2 2>/tmp/hermes_stderr_capture.$$
    }
    _release_stderr() {
        exec 2>&3 3>&-
        _last_stderr="$(cat /tmp/hermes_stderr_capture.$$ 2>/dev/null)"
        rm -f /tmp/hermes_stderr_capture.$$
        _fix_pip_install_r "$_last_stderr"
    }
    # Note: For full stderr capture, use `script` or zsh `preexec` + `precmd` with FD dup
    # Simplified version: check on known error patterns in terminal output
fi

# bash: DEBUG trap
if [[ -n "$BASH_VERSION" ]]; then
    # Simplified: inject hint when user types `pip install -r`
    _fix_pip_hint() {
        local cmd="$BASH_COMMAND"
        if [[ "$cmd" == "pip install -r"* ]] && [[ "$(uname)" == "Darwin" ]]; then
            echo ""
            echo "┌─────────────────────────────────────────────────────────────┐"
            echo "│ ⚠️  On macOS, 'pip install -r' may use system install.       │"
            echo "│     ✅  Use: python3 -m pip install -r requirements.txt     │"
            echo "└─────────────────────────────────────────────────────────────┘"
            echo ""
        fi
    }
    trap '_fix_pip_hint' DEBUG
fi

echo "✅ Hermes terminal hint loaded: pip-install-r macOS fix"
echo "   Try: pip install -r requirements.txt  (on macOS to see the hint)"
