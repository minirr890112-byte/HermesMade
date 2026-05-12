#!/usr/bin/env bash
# ==============================================================
# Hermes Terminal Hint — Auto-generated from r/learnpython scan
# Generated: $(date -u +"%Y-%m-%dT%H:%M:%SZ")
# Target pain: Python app distribution confusion
# Source: https://reddit.com/r/learnpython/comments/1t7y5m7/
# Score: 94 | Comments: 53 | Category: Tooling
# ==============================================================
#
# INSTALL: Add to ~/.zshrc or ~/.bashrc
#   source ~/.hermes/hints/python-distribution-hint.sh
#
# WHAT IT DOES:
#   Detects when you're trying to run a .py file that imports 
#   non-stdlib modules, and suggests packaging tools.
#

_fix_python_distribution() {
    local last_cmd="$1"
    local last_stderr="$2"
    
    # Pattern: ModuleNotFoundError suggesting missing dependencies
    if [[ "$last_stderr" == *"ModuleNotFoundError"* ]] || \
       [[ "$last_stderr" == *"No module named"* ]]; then
        
        # Check if this looks like a project (has multiple .py files)
        local py_count
        py_count=$(find . -maxdepth 1 -name "*.py" 2>/dev/null | wc -l | tr -d ' ')
        
        if [[ "$py_count" -gt 1 ]] || [[ -f "requirements.txt" ]]; then
            printf "\n"
            printf "╭─────────────────────────────────────────────────────────╮\n"
            printf "│  💡 Distribution Tip                                    │\n"
            printf "│                                                         │\n"
            printf "│  Want to share this app? Try these tools:               │\n"
            printf "│                                                         │\n"
            printf "│  📦 PyInstaller (single .exe):                          │\n"
            printf "│     pip install pyinstaller                             │\n"
            printf "│     pyinstaller --onefile your_main.py                  │\n"
            printf "│                                                         │\n"
            printf "│  🍎 macOS .app bundle:                                  │\n"
            printf "│     pip install briefcase                               │\n"
            printf "│     briefcase new && briefcase build                    │\n"
            printf "│                                                         │\n"
            printf "│  🪟 Windows installer:                                  │\n"
            printf "│     pip install pynsist                                 │\n"
            printf "│                                                         │\n"
            printf "│  Copied pyinstaller --onefile to clipboard — Cmd+V!     │\n"
            printf "╰─────────────────────────────────────────────────────────╯\n"
            printf "\n"
            
            # Copy to clipboard
            if command -v pbcopy &>/dev/null; then
                echo "pyinstaller --onefile your_main.py" | pbcopy
            elif command -v xclip &>/dev/null; then
                echo "pyinstaller --onefile your_main.py" | xclip -selection c
            fi
        fi
    fi
    
    # Pattern: Trying to share .py directly with non-technical person
    if [[ "$last_cmd" == *"python"* ]] && [[ "$last_stderr" == *"Traceback"* ]]; then
        if [[ -f "requirements.txt" ]] || [[ -f "setup.py" ]] || [[ -f "pyproject.toml" ]]; then
            printf "\n"
            printf "╭─────────────────────────────────────────────────────────╮\n"
            printf "│  💡 Sharing this with non-devs?                         │\n"
            printf "│                                                         │\n"
            printf "│  pip install pyinstaller && pyinstaller --onefile *.py  │\n"
            printf "│                                                         │\n"
            printf "│  → Creates a single distributable binary. No Python req.│\n"
            printf "╰─────────────────────────────────────────────────────────╯\n"
            printf "\n"
        fi
    fi
}

# Hook into preexec for zsh (inspect stderr after command runs)
if [[ -n "$ZSH_VERSION" ]]; then
    # Zsh: use precmd to check last exit status and error output
    _hermes_check_last_error() {
        if [[ $? -ne 0 ]]; then
            _fix_python_distribution "$(fc -ln -1 2>/dev/null)" "$(tail -20 /tmp/hermes_last_stderr 2>/dev/null)"
        fi
    }
    precmd_functions+=(_hermes_check_last_error)
elif [[ -n "$BASH_VERSION" ]]; then
    # Bash: use DEBUG trap
    _hermes_trap() {
        local cmd="$BASH_COMMAND"
        if [[ "$cmd" == *"python"* ]]; then
            # Capture stderr of the next command
            exec 2>/tmp/hermes_last_stderr
        fi
    }
    trap '_hermes_trap' DEBUG
    
    _hermes_check_error() {
        local exit_code=$?
        if [[ $exit_code -ne 0 ]]; then
            _fix_python_distribution "$(history 1 | sed 's/^[ ]*[0-9]*[ ]*//')" "$(cat /tmp/hermes_last_stderr 2>/dev/null)"
        fi
        exec 2>/dev/stderr  # Restore stderr
    }
    PROMPT_COMMAND="_hermes_check_error; $PROMPT_COMMAND"
fi

echo "✅ Python distribution hint loaded. Will trigger on ModuleNotFoundError or python tracebacks."
