#!/usr/bin/env bash
# ============================================================================
# Hermes Terminal Hint: Fix uv/conda Shell Conflicts
# Generated: 2026-05-22
# Source: r/learnpython pain scan
# Target: zsh/bash users whose shell config was corrupted by `uv`
# ============================================================================
# PAIN: uv tool overwrites shell aliases and breaks conda PATH entries
# ROOT CAUSE: uv modifies ~/.zshrc, ~/.bashrc, and PATH order
# FIX: Detect uv PATH injection and restore conda priority
#
# INSTALL: Source this in your ~/.zshrc or ~/.bashrc:
#   source ~/.hermes/hints/fix-uv-conda-conflict.sh
# ============================================================================

# ---- Helper: Detect if pbcopy (macOS) or xclip (Linux) is available ----
_copy_to_clipboard() {
    if command -v pbcopy &>/dev/null; then
        printf "%s" "$1" | pbcopy
        return 0
    elif command -v xclip &>/dev/null; then
        printf "%s" "$1" | xclip -selection clipboard
        return 0
    elif command -v wl-copy &>/dev/null; then
        printf "%s" "$1" | wl-copy
        return 0
    else
        return 1
    fi
}

# ---- Fix 1: uv PATH collision with conda ----
_fix_uv_conda_path() {
    # Check if uv is installed but conda is broken
    if command -v uv &>/dev/null && ! command -v conda &>/dev/null; then
        # conda was likely removed from PATH by uv's installer
        # Find conda and restore it
        local conda_paths=(
            "$HOME/miniconda3/bin"
            "$HOME/anaconda3/bin"
            "$HOME/miniforge3/bin"
            "/opt/homebrew/Caskroom/miniconda/base/bin"
            "/opt/homebrew/Caskroom/miniforge/base/bin"
            "/usr/local/Caskroom/miniconda/base/bin"
        )
        for cp in "${conda_paths[@]}"; do
            if [[ -f "$cp/conda" ]]; then
                export PATH="$cp:$PATH"
                break
            fi
        done
    fi
}

# ---- Fix 2: Detect uv-modified shell aliases ----
_fix_uv_aliases() {
    # uv may have overridden common aliases
    # Check if 'python' or 'python3' aliases still work
    local broken_aliases=()
    
    if alias python &>/dev/null && ! python -c "print('ok')" &>/dev/null 2>&1; then
        broken_aliases+=("python")
    fi
    
    if [[ ${#broken_aliases[@]} -gt 0 ]]; then
        printf "\n💡 Hermes detected broken aliases: %s\n" "${broken_aliases[*]}"
        printf "   uv may have overwritten your shell aliases.\n"
        
        local fix_cmd="unalias ${broken_aliases[*]} && hash -r"
        if _copy_to_clipboard "$fix_cmd"; then
            printf "\n   📋 Fix copied to clipboard! Press %s to restore:\n"                 "$( [[ "$OSTYPE" == "darwin"* ]] && echo "Cmd+V" || echo "Ctrl+Shift+V" )"
            printf "   ┌─────────────────────────────────────────────┐\n"
            printf "   │ %-45s │\n" "$fix_cmd"
            printf "   └─────────────────────────────────────────────┘\n"
        else
            printf "\n   Run: %s\n" "$fix_cmd"
        fi
    fi
}

# ---- Fix 3: Detect conda init broken after uv ----
_fix_conda_init() {
    # If conda exists but shell integration is broken
    if command -v conda &>/dev/null; then
        if ! type conda &>/dev/null 2>&1; then
            # conda shell function not loaded — uv may have removed the init block
            printf "\n💡 Hermes detected: conda is installed but shell init is broken.\n"
            local shell_name="${SHELL##*/}"
            local fix_cmd="conda init $shell_name && source ~/.${shell_name}rc"
            if _copy_to_clipboard "$fix_cmd"; then
                printf "   📋 Fix copied! Press %s and Enter to restore conda shell integration.\n"                     "$( [[ "$OSTYPE" == "darwin"* ]] && echo "Cmd+V" || echo "Ctrl+Shift+V" )"
                printf "   ┌─────────────────────────────────────────────┐\n"
                printf "   │ %-45s │\n" "$fix_cmd"
                printf "   └─────────────────────────────────────────────┘\n"
            fi
        fi
    fi
}

# ---- Fix 4: Generic ImportError hint (scipy, numpy, pandas) ----
_fix_import_error() {
    # Inspect stderr from the last command (zsh preexec-compatible pattern)
    # This is a simplified version — full preexec integration needs zsh hooks
    local last_stderr="$1"
    
    if [[ "$last_stderr" == *"ModuleNotFoundError"* ]] || [[ "$last_stderr" == *"ImportError"* ]]; then
        # Extract the module name
        local module
        module=$(echo "$last_stderr" | grep -oP "No module named '\K[^']+")
        
        if [[ -n "$module" ]]; then
            # Detect active environment
            local installer="pip install"
            if [[ -n "$CONDA_DEFAULT_ENV" ]]; then
                installer="conda install -c conda-forge"
            elif command -v uv &>/dev/null && [[ -n "$VIRTUAL_ENV" ]]; then
                installer="uv pip install"
            fi
            
            local fix_cmd="$installer $module"
            printf "\n💡 Hermes: Missing module '%s' detected!\n" "$module"
            if _copy_to_clipboard "$fix_cmd"; then
                printf "   📋 Fix copied! Press %s and Enter to install.\n"                     "$( [[ "$OSTYPE" == "darwin"* ]] && echo "Cmd+V" || echo "Ctrl+Shift+V" )"
                printf "   ┌─────────────────────────────────────────────┐\n"
                printf "   │ %-45s │\n" "$fix_cmd"
                printf "   └─────────────────────────────────────────────┘\n"
            fi
        fi
    fi
}

# ---- Run checks on shell startup ----
_fix_uv_conda_path
_fix_uv_aliases
_fix_conda_init

printf "\n🔧 Hermes Terminal Hints loaded — watching for uv/conda conflicts and import errors.\n"
