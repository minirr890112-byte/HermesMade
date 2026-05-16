#!/usr/bin/env bash
# ============================================================================
# Hermes Terminal Hints — r/learnpython Pain Points
# Generated: 2026-05-16 23:12:10 UTC
# Source: Reddit r/learnpython scan + pain-classifier + pain-value-judgment
# ============================================================================
# Drop-in: source this in ~/.zshrc or ~/.bashrc to get automatic hints
# when you hit common Python beginner errors.
# ============================================================================

# ─── Helper: cross-platform clipboard ───
_copy_to_clipboard() {
    if command -v pbcopy &>/dev/null; then
        echo "$1" | pbcopy
    elif command -v xclip &>/dev/null; then
        echo "$1" | xclip -selection clipboard
    elif command -v clip.exe &>/dev/null; then
        echo "$1" | clip.exe
    fi
}

# ─── Hint 1: ModuleNotFoundError — venv mismatch ───
# Pain: pip installs module but Python can't find it
# Trigger: ModuleNotFoundError: No module named 'X'
# Reddit: Multiple posts (pygame, pyodbc, numpy)
_fix_module_not_found() {
    local err="$1"
    if [[ "$err" == *"ModuleNotFoundError"* ]] || [[ "$err" == *"No module named"* ]]; then
        local mod=$(echo "$err" | sed -n "s/.*No module named '\''\([^'\'']*\)'\''.*/\1/p")
        [[ -z "$mod" ]] && mod="unknown"
        local py_path=$(which python3 2>/dev/null || which python 2>/dev/null)
        local pip_path=$(which pip3 2>/dev/null || which pip 2>/dev/null)

        echo ""
        echo "💡 Hermes Hint: Module '$mod' not found"
        echo "   Your Python:  $py_path"
        echo "   Your pip:     $pip_path"
        echo "   ─────────────────────────────────────────"
        if [[ -n "$VIRTUAL_ENV" ]]; then
            echo "   ✓ You ARE in a virtual env: $VIRTUAL_ENV"
            echo "   → Fix: pip install $mod"
            _copy_to_clipboard "pip install $mod"
        else
            echo "   ⚠ You are NOT in a virtual env"
            echo "   → Fix: python3 -m pip install $mod"
            _copy_to_clipboard "python3 -m pip install $mod"
        fi
        echo "   📋 Command copied to clipboard — Cmd+V / Ctrl+Shift+V to paste"
        echo ""
    fi
}

# ─── Hint 2: Zsh: killed / Killed: 9 — OOM ───
# Pain: Python process killed by OOM on macOS when processing large files
# Trigger: "zsh: killed" or "Killed: 9" in stderr
# Reddit: Merging large CSV on 8GB Mac, process killed silently
_fix_oom_killed() {
    local err="$1"
    if [[ "$err" == *"zsh: killed"* ]] || [[ "$err" == *"Killed: 9"* ]]; then
        echo ""
        echo "💡 Hermes Hint: Process killed — likely out of memory"
        echo "   ─────────────────────────────────────────"
        echo "   Check memory:  vm_stat  # macOS  |  free -h  # Linux"
        echo "   Check ulimit:  ulimit -a | grep 'max memory'"
        echo ""
        echo "   🛠  Quick fixes for large data:"
        echo "   1. Process in chunks with csv.reader + itertools.islice"
        echo "   2. Use dask:  pip install dask"
        echo "   3. Use polars (zero-copy): pip install polars"
        echo ""
        _copy_to_clipboard "pip install dask[dataframe] polars"
        echo "   📋 'pip install dask polars' copied to clipboard"
        echo ""
    fi
}

# ─── Hint 3: pip SSL / CERTIFICATE_VERIFY_FAILED ───
# Pain: pip install fails with SSL certificate errors
# Trigger: "CERTIFICATE_VERIFY_FAILED" or "SSL" error
_fix_pip_ssl() {
    local err="$1"
    if [[ "$err" == *"CERTIFICATE_VERIFY_FAILED"* ]] || [[ "$err" == *"SSL: CERTIFICATE"* ]]; then
        echo ""
        echo "💡 Hermes Hint: pip SSL certificate error"
        echo "   ─────────────────────────────────────────"
        echo "   Fix: python3 -m pip install --upgrade certifi"
        _copy_to_clipboard "python3 -m pip install --upgrade certifi"
        echo "   📋 Command copied — Cmd+V / Ctrl+Shift+V to paste"
        echo ""
    fi
}

# ─── Hint 4: Multiple Python versions conflict ───
# Pain: which python shows wrong version, packages go to wrong site-packages
# Reddit: 5+ Python versions conflicting on macOS, can't tell which is which
_fix_python_conflict() {
    local cmd="$1"
    if [[ "$cmd" == *"which python"* ]] || [[ "$cmd" == *"python --version"* ]] || \
       [[ "$cmd" == *"python3 --version"* ]]; then
        echo ""
        echo "💡 Hermes Hint: Python version management"
        echo "   ─────────────────────────────────────────"
        echo "   All Python installations:"
        ls -1 /usr/local/bin/python* /usr/bin/python* /opt/homebrew/bin/python* 2>/dev/null | head -10
        echo ""
        echo "   🛠  Clean slate options:"
        echo "   • pyenv:    pyenv versions && pyenv global 3.12"
        echo "   • Homebrew: brew unlink python@3.9 && brew link python@3.12"
        echo "   • venv:     python3 -m venv .venv && source .venv/bin/activate"
        echo ""
    fi
}

# ─── Hint 5: Loop overwriting variable (missing .append) ───
# Pain: User assigns inside loop instead of appending to list
# Reddit: "Why does my Python loop keep overwriting the variable?"
_fix_loop_overwrite() {
    local err="$1"
    if [[ "$err" == *"NameError"* ]] || [[ "$err" == *"AttributeError"*"append"* ]]; then
        echo ""
        echo "💡 Hermes Hint: Loop overwrite pattern detected"
        echo "   ─────────────────────────────────────────"
        echo "   ❌ BAD:   result = result + [x]   # O(n²)"
        echo "   ❌ BAD:   for x in items: result = process(x)  # overwrites!"
        echo "   ✅ GOOD:  result = []"
        echo "             for x in items:"
        echo "                 result.append(process(x))"
        echo "   ✅ BEST:  result = [process(x) for x in items]  # list comprehension"
        echo ""
        echo "   🔗 More: python -c 'help(\"LISTCOMP\")'"
        echo ""
    fi
}

# ─── Hint 6: Return in __init__ ───
# Pain: Using return in __init__ (Python forbids non-None return from __init__)
# Trigger: TypeError: __init__() should return None
_fix_init_return() {
    local err="$1"
    if [[ "$err" == *"__init__"*"should return None"* ]] || \
       [[ "$err" == *"TypeError"*"__init__"* ]]; then
        echo ""
        echo "💡 Hermes Hint: __init__ must return None"
        echo "   ─────────────────────────────────────────"
        echo "   ❌ WRONG:  def __init__(self): return something"
        echo "   ✅ RIGHT:  def __init__(self): self.attr = something"
        echo ""
        echo "   💡 For custom construction, use __new__ or a @classmethod:"
        echo "      @classmethod"
        echo "      def from_config(cls, path):"
        echo "          obj = cls.__new__(cls)"
        echo "          # ... setup ..."
        echo "          return obj"
        echo ""
    fi
}

# ─── Hint 7: PyInstaller not found / packaging confusion ───
# Pain: User wants to turn .py into .exe/.app but doesn't know PyInstaller
# Reddit: "What do people use to turn Python script into desktop app?"
_fix_packaging() {
    local cmd="$1"
    if [[ "$cmd" == *"pyinstaller"* ]] && command -v pyinstaller &>/dev/null; then
        :
    elif [[ "$cmd" == *"pyinstaller"* ]]; then
        echo ""
        echo "💡 Hermes Hint: PyInstaller not installed"
        echo "   ─────────────────────────────────────────"
        echo "   Install:    pip install pyinstaller"
        echo "   Simple:     pyinstaller --onefile script.py"
        echo "   GUI app:    pyinstaller --onefile --windowed app.py"
        echo "   With icon:  pyinstaller --onefile --windowed --icon=app.icns app.py"
        echo ""
        _copy_to_clipboard "pip install pyinstaller"
        echo "   📋 Command copied — Cmd+V / Ctrl+Shift+V to paste"
        echo ""
    fi
}

# ═══════════════════════════════════════════════════════════════
# HOOK REGISTRATION — auto-detect shell (zsh vs bash)
# ═══════════════════════════════════════════════════════════════

# Zsh preexec — captures the command line before execution
if [[ -n "$ZSH_VERSION" ]]; then
    _hermes_preexec() {
        _hermes_last_cmd="$1"
    }
    autoload -Uz add-zsh-hook
    add-zsh-hook preexec _hermes_preexec
fi

# Zsh precmd — runs before each prompt
if [[ -n "$ZSH_VERSION" ]]; then
    _hermes_precmd() {
        local last_exit=$?
        if [[ $last_exit -eq 137 ]]; then
            _fix_oom_killed "Killed: 9"
        fi
        if [[ "$_hermes_last_cmd" == *"which python"* ]] || \
           [[ "$_hermes_last_cmd" == *"python"*"--version"* ]]; then
            _fix_python_conflict "$_hermes_last_cmd"
        fi
        _hermes_last_cmd=""
    }
    autoload -Uz add-zsh-hook
    add-zsh-hook precmd _hermes_precmd
fi

# Bash DEBUG trap — runs before every command
if [[ -n "$BASH_VERSION" ]]; then
    _hermes_debug_trap() {
        _hermes_last_cmd="$BASH_COMMAND"
    }
    trap '_hermes_debug_trap' DEBUG

    _hermes_prompt_cmd() {
        local last_exit=$?
        if [[ $last_exit -eq 137 ]]; then
            _fix_oom_killed "Killed: 9"
        fi
        if [[ "$_hermes_last_cmd" == *"which python"* ]] || \
           [[ "$_hermes_last_cmd" == *"python"*"--version"* ]]; then
            _fix_python_conflict "$_hermes_last_cmd"
        fi
        _hermes_last_cmd=""
    }
    PROMPT_COMMAND="_hermes_prompt_cmd${PROMPT_COMMAND:+;$PROMPT_COMMAND}"
fi

# ─── Optional: pipe stderr through hint detection ───
# Usage: python script.py 2> >(hermes_hint_filter)
hermes_hint_filter() {
    while IFS= read -r line; do
        echo "$line" >&2
        _fix_module_not_found "$line"
        _fix_oom_killed "$line"
        _fix_pip_ssl "$line"
        _fix_loop_overwrite "$line"
        _fix_init_return "$line"
    done
}

echo "🧠 Hermes Terminal Hints loaded — 7 pain-point detectors active"
echo "   ModuleNotFound | OOM Kill | pip SSL | Python Conflict | Loop Overwrite | __init__ Return | PyInstaller"