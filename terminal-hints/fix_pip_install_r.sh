#!/usr/bin/env bash
#===========================================================================
# Hermes Terminal Hint — Auto-fix for Python environment issues
# Generated: 2026-06-09 23:09 UTC
# Source: r/learnpython scan
#===========================================================================
# Pain: pip install -r requirements.txt fails with 'install: illegal option -- r'
# Root Cause: macOS has a built-in /usr/bin/install command that shadows pip when 'pip' is not found or when the wrong Python is active
# Solution: python3 -m pip install -r requirements.txt
#===========================================================================

# --- macOS / Linux (zsh) ---
_fix_fix_pip_install_r() {
    # Capture both stdout and stderr from the last command
    local last_output
    last_output=$(fc -ln -1 2>/dev/null || true)

    if [[ "$last_output" == *"install: illegal option -- r"* ]]; then
        printf "\n💡  Fix tip: The command you ran tried to use macOS 'install' instead of pip.\n"
        printf "    We've copied the correct command to your clipboard. Just paste and run.\n\n"
        printf "    →  python3 -m pip install -r requirements.txt\n\n"

        # Copy to clipboard (cross-platform)
        if command -v pbcopy &>/dev/null; then
            printf "python3 -m pip install -r requirements.txt" | pbcopy
            printf "    ✅ Command copied! Press Cmd+V and Enter.\n"
        elif command -v xclip &>/dev/null; then
            printf "python3 -m pip install -r requirements.txt" | xclip -selection clipboard
            printf "    ✅ Command copied! Press Ctrl+Shift+V and Enter.\n"
        elif command -v wl-copy &>/dev/null; then
            printf "python3 -m pip install -r requirements.txt" | wl-copy
            printf "    ✅ Command copied! Press Ctrl+Shift+V and Enter.\n"
        else
            printf "    ℹ️  Copy the command above and run it manually.\n"
        fi
        printf "\n"
    fi
}

# --- Hook into zsh preexec ---
autoload -Uz add-zsh-hook 2>/dev/null
if [[ -n "$ZSH_VERSION" ]]; then
    add-zsh-hook preexec _fix_fix_pip_install_r 2>/dev/null || preexec_functions+=(_fix_fix_pip_install_r)
fi

# --- Hook into bash DEBUG trap ---
if [[ -n "$BASH_VERSION" ]]; then
    _bash_fix_pip_install_r_prev_cmd=""
    _bash_fix_pip_install_r_trap() {
        local last_cmd="$BASH_COMMAND"
        if [[ "$_bash_fix_pip_install_r_prev_cmd" == *"install: illegal option -- r"* ]]; then
            printf "\n💡  Fix tip: We've copied the correct command. Just paste and run.\n"
            printf "    →  python3 -m pip install -r requirements.txt\n\n"
            if command -v pbcopy &>/dev/null; then
                printf "python3 -m pip install -r requirements.txt" | pbcopy
            elif command -v xclip &>/dev/null; then
                printf "python3 -m pip install -r requirements.txt" | xclip -selection clipboard
            fi
        fi
        _bash_fix_pip_install_r_prev_cmd="$last_cmd"
    }
    trap '_bash_fix_pip_install_r_trap' DEBUG 2>/dev/null
fi

printf "🔧 Hermes pip-install fixer loaded. Watching for 'install: illegal option -- r'...\n"
