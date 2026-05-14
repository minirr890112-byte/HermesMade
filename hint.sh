#!/bin/sh
# ============================================================
# Hermes Terminal Hints — Auto-generated from r/learnpython
# Generated: 2026-05-15
# Source: https://reddit.com/r/learnpython
# ============================================================
# To use:
#   For zsh:  source hint.sh && _hermes_hint_install
#   For bash: source hint.sh && _hermes_hint_install
#   Then:     hermes-hint          (check status)
#             hermes-hint run      (run diagnostics)
# ============================================================

set -e

HERMES_HINT_VERSION="2026.05.15-01"
HERMES_HINT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/hermes-hint"
mkdir -p "$HERMES_HINT_HOME"

# ---- Color helpers ----
if [ -t 1 ]; then
    _hint_red='\033[0;31m'; _hint_green='\033[0;32m'
    _hint_yellow='\033[1;33m'; _hint_blue='\033[0;34m'
    _hint_cyan='\033[0;36m'; _hint_bold='\033[1m'
    _hint_reset='\033[0m'
else
    _hint_red=''; _hint_green=''; _hint_yellow=''
    _hint_blue=''; _hint_cyan=''; _hint_bold=''; _hint_reset=''
fi

# ---- Shell detection ----
_hermes_detect_shell() {
    case "$SHELL" in
        */zsh)  echo "zsh" ;;
        */bash) echo "bash" ;;
        *)      echo "unknown" ;;
    esac
}

# ---- Clipboard helper ----
_hermes_clipboard() {
    case "$(uname -s)" in
        Darwin) pbcopy ;;
        Linux)
            if command -v xclip >/dev/null 2>&1; then
                xclip -selection clipboard
            elif command -v wl-copy >/dev/null 2>&1; then
                wl-copy
            else
                cat
            fi
            ;;
        *) cat ;;
    esac
}

# ---- Hint database ----
_hermes_hints() {
    cat <<'HINTS_EOF'
pyenv-multiple-versions|No module named|Multiple Python versions detected. Use pyenv to manage them cleanly.|brew install pyenv && pyenv install 3.12 && pyenv global 3.12
pip-stuck|pip.*hang|pip.*freeze|pip.*forever|Pip stuck or hanging? Clear its cache and reinstall.|python3 -m pip cache purge && python3 -m pip install --upgrade --force-reinstall pip
zsh-killed-oom|zsh: killed|Killed:|zsh: killed usually means out-of-memory. Process large files in chunks.|pd.read_csv('file.csv', chunksize=10000)
circular-import|ImportError.*circular|cannot import name|Circular import detected. Move shared code to common module or import inside function body.|# Refactor: create base.py for shared code
init-return|TypeError.*__init__.*return|__init__ cannot return values — Python returns the new object automatically. Use __str__ for string display.|# Correct: class Foo:\n#     def __str__(self): return f'Foo({self.x})'
indent-error|IndentationError|SyntaxError.*indent|unexpected indent|Indentation errors? Let Black auto-format your code.|pip install black && black *.py
typeerror-args|TypeError.*takes.*arguments.*but.*given|Argument count mismatch. Use inspect.signature() to debug your function signature.|import inspect; print(inspect.signature(my_func))
pandas-rowwise|KeyError|SettingWithCopyWarning|Pandas: use df.apply(..., axis=1) for row-wise operations, or np.select() for multi-condition columns.|df['new_col'] = df.apply(lambda row: categorize(row['A'], row['B']), axis=1)
oop-dataclass|||OOP: Use @dataclass when data and behavior belong together. For plain data passing, use dicts or namedtuples.|from dataclasses import dataclass\n@dataclass\nclass Student:\n    name: str\n    grade: float
decorator-real|||Decorators: @lru_cache auto-memoizes, @app.route maps URLs, @retry handles transient failures.|from functools import lru_cache\n@lru_cache\ndef heavy(x): ...
tkinter-macos|||Tkinter on macOS? PyQt6/PySide6 gives a more native look. Or try ttkbootstrap for improved tkinter theming.|pip install PyQt6
learn-blank-page|||Stuck on a blank page? Start with pseudocode — write comments for each step, then fill in code under each comment. Use pdb to step through.|import pdb; pdb.set_trace()
HINTS_EOF
}

# ---- Trigger check on command error (zsh preexec) ----
_hermes_hint_check_last_error() {
    local last_exit=$1
    local last_cmd="$2"

    # Only trigger on errors
    [ "$last_exit" -eq 0 ] && return

    _hermes_hints | while IFS='|' read -r name trigger hint cmd; do
        [ -z "$name" ] && continue
        [ "${name#\#}" != "$name" ] && continue

        _match=0
        IFS='|'
        for pat in $trigger; do
            if echo "$last_cmd" | grep -qiE "$pat" 2>/dev/null; then
                _match=1
                break
            fi
        done
        unset IFS

        if [ "$_match" -eq 1 ]; then
            printf "${_hint_bold}${_hint_yellow}\n" >&2
            printf "%s${_hint_reset}\n" "$hint" >&2
            printf "${_hint_cyan}  -> Command copied to clipboard:${_hint_reset} " >&2
            printf "%s\n" "$cmd" >&2
            echo "$cmd" | _hermes_clipboard
            printf "${_hint_green}  -> Paste with Cmd+V or Ctrl+Shift+V and press Enter${_hint_reset}\n" >&2
            printf "\n" >&2
        fi
    done
}

# ---- ZSH integration ----
_hermes_hint_preexec() {
    _hermes_last_cmd="$1"
}

_hermes_hint_precmd() {
    _hermes_hint_check_last_error "$?" "$_hermes_last_cmd"
}

# ---- BASH integration ----
_hermes_hint_bash_trap() {
    local last_exit=$?
    local last_cmd="$BASH_COMMAND"
    _hermes_hint_check_last_error "$last_exit" "$last_cmd"
    return $last_exit
}

# ---- Install ----
_hermes_hint_install() {
    local shell_name
    shell_name="$(_hermes_detect_shell)"

    case "$shell_name" in
        zsh)
            if grep -q "_hermes_hint_install" "$HOME/.zshrc" 2>/dev/null; then
                printf "${_hint_yellow}Already installed in ~/.zshrc${_hint_reset}\n"
                return 0
            fi
            cat >> "$HOME/.zshrc" <<'ZSHRC_EOF'

# === Hermes Terminal Hints ===
if [ -f "$HOME/.local/share/hermes-hint/hint.sh" ]; then
    source "$HOME/.local/share/hermes-hint/hint.sh"
    autoload -Uz add-zsh-hook
    add-zsh-hook preexec _hermes_hint_preexec
    add-zsh-hook precmd _hermes_hint_precmd
fi
ZSHRC_EOF
            printf "${_hint_green}Installed to ~/.zshrc${_hint_reset}\n"
            printf "${_hint_cyan}  Run: source ~/.zshrc${_hint_reset}\n"
            ;;
        bash)
            if grep -q "_hermes_hint_install" "$HOME/.bashrc" 2>/dev/null; then
                printf "${_hint_yellow}Already installed in ~/.bashrc${_hint_reset}\n"
                return 0
            fi
            cat >> "$HOME/.bashrc" <<'BASHRC_EOF'

# === Hermes Terminal Hints ===
if [ -f "$HOME/.local/share/hermes-hint/hint.sh" ]; then
    source "$HOME/.local/share/hermes-hint/hint.sh"
    trap '_hermes_hint_bash_trap' DEBUG
fi
BASHRC_EOF
            printf "${_hint_green}Installed to ~/.bashrc${_hint_reset}\n"
            printf "${_hint_cyan}  Run: source ~/.bashrc${_hint_reset}\n"
            ;;
        *)
            printf "${_hint_red}Shell not recognized. Supported: zsh, bash${_hint_reset}\n"
            printf "${_hint_yellow}  Manually add to your rc file:${_hint_reset}\n"
            printf "  source %s/hint.sh\n" "$HERMES_HINT_HOME"
            ;;
    esac
}

# ---- Uninstall ----
_hermes_hint_uninstall() {
    local shell_name
    shell_name="$(_hermes_detect_shell)"
    local rc_file

    case "$shell_name" in
        zsh)  rc_file="$HOME/.zshrc" ;;
        bash) rc_file="$HOME/.bashrc" ;;
        *)    printf "${_hint_red}Unknown shell${_hint_reset}\n"; return 1 ;;
    esac

    if [ -f "$rc_file" ]; then
        if command -v gsed >/dev/null 2>&1; then
            gsed -i '/# === Hermes Terminal Hints ===/,/fi/d' "$rc_file"
        else
            sed -i '' '/# === Hermes Terminal Hints ===/,/fi/d' "$rc_file" 2>/dev/null || \
            sed -i '/# === Hermes Terminal Hints ===/,/fi/d' "$rc_file"
        fi
        printf "${_hint_green}Removed from %s${_hint_reset}\n" "$rc_file"
    fi
}

# ---- Status ----
_hermes_hint_status() {
    printf "${_hint_bold}Hermes Terminal Hints v%s${_hint_reset}\n" "$HERMES_HINT_VERSION"
    printf "Shell: %s\n" "$(_hermes_detect_shell)"
    printf "Home: %s\n" "$HERMES_HINT_HOME"
    printf "\n"
    printf "${_hint_bold}Available hints:${_hint_reset}\n"
    _hermes_hints | while IFS='|' read -r name trigger hint cmd; do
        [ -z "$name" ] && continue
        [ "${name#\#}" != "$name" ] && continue
        printf "  ${_hint_cyan}%-25s${_hint_reset} %s\n" "$name" "${hint:0:80}"
    done
}

# ---- Run diagnostics ----
_hermes_hint_run() {
    printf "${_hint_bold}Running Python environment diagnostics...${_hint_reset}\n\n"

    printf "${_hint_blue}[1/5] Python version${_hint_reset}\n"
    if command -v python3 >/dev/null 2>&1; then
        printf "  python3: %s\n" "$(python3 --version 2>&1)"
    else
        printf "${_hint_red}  python3 not found in PATH${_hint_reset}\n"
    fi

    printf "${_hint_blue}[2/5] pip status${_hint_reset}\n"
    if command -v pip3 >/dev/null 2>&1; then
        printf "  pip3: %s\n" "$(pip3 --version 2>&1 | head -1)"
    else
        printf "${_hint_red}  pip not found${_hint_reset}\n"
    fi

    printf "${_hint_blue}[3/5] pyenv${_hint_reset}\n"
    if command -v pyenv >/dev/null 2>&1; then
        printf "  pyenv: %s\n" "$(pyenv --version)"
    else
        printf "  pyenv not installed (recommended for version management)\n"
    fi

    printf "${_hint_blue}[4/5] Virtual environment${_hint_reset}\n"
    if [ -n "$VIRTUAL_ENV" ]; then
        printf "  Active venv: %s\n" "$VIRTUAL_ENV"
    else
        printf "  No virtual environment active\n"
    fi

    printf "${_hint_blue}[5/5] Common pitfalls${_hint_reset}\n"
    if command -v brew >/dev/null 2>&1; then
        _brew_count=$(brew list --formula 2>/dev/null | grep -c 'python@' || echo 0)
        if [ "$_brew_count" -gt 1 ]; then
            printf "${_hint_yellow}  Multiple Homebrew Python versions (%d)${_hint_reset}\n" "$_brew_count"
        fi
    fi

    printf "\n${_hint_green}Diagnostics complete.${_hint_reset}\n"
}

# ---- CLI entry point ----
hermes-hint() {
    case "${1:-status}" in
        install)   _hermes_hint_install ;;
        uninstall) _hermes_hint_uninstall ;;
        run)       _hermes_hint_run ;;
        status|*)  _hermes_hint_status ;;
    esac
}
