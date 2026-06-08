#!/usr/bin/env bash
# =============================================================================
# Hermes Terminal Hint — Auto-fix for pip/requirements.txt issues
# Generated: 2025-06-09
# Pain source: r/learnpython — "Need help with installing requirements.txt"
# Category: Environment
# Issue: Users type "install -r requirements.txt" instead of "pip install -r requirements.txt"
# =============================================================================
# Add to your ~/.zshrc or ~/.bashrc to get automatic hints when things go wrong.
# Usage: source ~/hermes_terminal_hint_pip_fix.sh

_hermes_fix_pip_requirements() {
    local last_cmd="$1"

    # Pattern 1: user typed "install -r requirements.txt" (missing "pip")
    if [[ "$last_cmd" == install* ]] && [[ "$last_cmd" == *"-r"* ]]; then
        local fix="pip install -r requirements.txt"
        if command -v pbcopy &>/dev/null; then
            echo -n "$fix" | pbcopy
            printf '\n💡  Hermes: Did you mean "pip install -r requirements.txt"?\n'
            printf '   We copied it to your clipboard. Press Cmd+V and Enter.\n\n'
        elif command -v xclip &>/dev/null; then
            echo -n "$fix" | xclip -selection clipboard
            printf '\n💡  Hermes: Did you mean "pip install -r requirements.txt"?\n'
            printf '   We copied it to your clipboard. Press Ctrl+Shift+V and Enter.\n\n'
        elif command -v clip.exe &>/dev/null; then
            echo -n "$fix" | clip.exe
            printf '\n💡  Hermes: Did you mean "pip install -r requirements.txt"?\n'
            printf '   We copied it to your clipboard. Right-click and Paste.\n\n'
        else
            printf '\n💡  Hermes: Did you mean "pip install -r requirements.txt"?\n'
            printf '   Run that instead.\n\n'
        fi
    fi

    # Pattern 2: ModuleNotFoundError
    if [[ "$last_cmd" == *"ModuleNotFoundError"* ]] || [[ "$last_cmd" == *"No module named"* ]]; then
        printf '\n💡  Hermes: It looks like a module is missing.\n'
        printf '   Make sure the module name is correct, or install it with: pip install <module-name>\n'
        printf '   Common gotchas:\n'
        printf '   - Did you install into the right venv/conda env?\n'
        printf '   - On macOS: try python3 -m pip install <module>\n'
        printf '   - Module name != import name? (e.g., pip install beautifulsoup4, import bs4)\n\n'
    fi

    # Pattern 3: pip command not found
    if [[ "$last_cmd" == *"pip: command not found"* ]] || [[ "$last_cmd" == *"pip3: command not found"* ]]; then
        printf '\n💡  Hermes: pip not found. Try one of these:\n'
        printf '   python3 -m pip install <package>\n'
        printf '   python -m pip install <package>\n'
        printf '   Or install pip: https://pip.pypa.io/en/stable/installation/\n\n'
    fi

    # Pattern 4: import error / cannot import
    if [[ "$last_cmd" == *"ImportError"* ]] || [[ "$last_cmd" == *"cannot import"* ]]; then
        printf '\n💡  Hermes: Import error detected. Check:\n'
        printf '   - Is the module installed? (pip list | grep <name>)\n'
        printf '   - Are you in the right virtual environment?\n'
        printf '   - Is there a name conflict with your own file?\n'
        printf '   - Circular import? Check your import chain.\n\n'
    fi
}

# ---- ZSH integration ----
if [[ -n "$ZSH_VERSION" ]]; then
    autoload -Uz add-zsh-hook
    _hermes_last_cmd=""
    _hermes_preexec() { _hermes_last_cmd="$1"; }
    _hermes_precmd() {
        local e=$?
        if [[ $e -ne 0 && -n "$_hermes_last_cmd" ]]; then
            _hermes_fix_pip_requirements "$_hermes_last_cmd"
        fi
    }
    add-zsh-hook preexec _hermes_preexec
    add-zsh-hook precmd _hermes_precmd
fi

# ---- BASH integration ----
if [[ -n "$BASH_VERSION" ]]; then
    _hermes_last_bash_cmd=""
    trap '_hermes_last_bash_cmd="$BASH_COMMAND"' DEBUG
    _hermes_bash_prompt() {
        local e=$?
        if [[ $e -ne 0 && -n "$_hermes_last_bash_cmd" ]]; then
            _hermes_fix_pip_requirements "$_hermes_last_bash_cmd"
        fi
    }
    if [[ -n "$PROMPT_COMMAND" ]]; then
        PROMPT_COMMAND="_hermes_bash_prompt;$PROMPT_COMMAND"
    else
        PROMPT_COMMAND="_hermes_bash_prompt"
    fi
fi

echo "🧠 Hermes terminal hints loaded — I'll help with pip/import issues."
