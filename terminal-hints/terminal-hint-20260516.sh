#!/bin/bash
# ============================================================
# Hermes Terminal Hint — Auto-generated 2026-05-16 07:13 UTC
# Pain: What’s the simplest way to distribute a Python app to normal users?
# Source: https://reddit.com/r/learnpython/comments/1t7y5m7/whats_the_simplest_way_to_distribute_a_python_app/
# Category: UX | Priority: HIGH
# ============================================================

# ── Hint 1: PyInstaller one-liner (most common solution) ──
_pyinstaller_hint() {
    local last_cmd="$1"
    if [[ "$last_cmd" =~ (python|python3)\ .*\.py$ ]]; then
        echo ""
        echo "💡  Tired of asking users to install Python first?"
        echo "    Package it into a single executable:"
        echo ""
        echo "    pip install pyinstaller"
        echo "    pyinstaller --onefile --windowed your_script.py"
        echo ""
        echo "    Your users get a double-clickable app. No Python required."
        echo ""
        # Auto-copy to clipboard
        if command -v pbcopy &>/dev/null; then
            echo "pip install pyinstaller && pyinstaller --onefile your_script.py" | pbcopy
            echo "    📋 Command copied to clipboard! Press Cmd+V to paste."
        elif command -v xclip &>/dev/null; then
            echo "pip install pyinstaller && pyinstaller --onefile your_script.py" | xclip -sel clip
            echo "    📋 Command copied to clipboard! Press Ctrl+Shift+V to paste."
        fi
        echo ""
    fi
}

# ── Hint 2: Nuitka alternative (better performance, smaller binary) ──
_nuitka_hint() {
    if echo "$1" | grep -q "pyinstaller"; then
        echo ""
        echo "💡  Want a faster, smaller binary? Try Nuitka instead:"
        echo ""
        echo "    pip install nuitka"
        echo "    nuitka --standalone --onefile your_script.py"
        echo ""
        echo "    🚀 Nuitka compiles to C first, producing faster executables."
        echo ""
    fi
}

# ── Hint 3: ModuleNotFoundError fix ──
_module_not_found_hint() {
    if echo "$1" | grep -qi "modulenotfounderror"; then
        echo ""
        echo "💡  Module not found? Quick triage:"
        echo ""
        echo "    1. Is it installed?     → pip list | grep <module>"
        echo "    2. Is venv active?      → which python"
        echo "    3. Right Python version? → python --version"
        echo ""
        echo "    Fix: pip install <module>  (in the right environment!)"
        echo ""
    fi
}

# ── Hint 4: Running another .py from within Python ──
_run_py_hint() {
    if echo "$1" | grep -qE "(exec|subprocess|import).*\.py"; then
        echo ""
        echo "💡  Need to run another .py from within Python?"
        echo ""
        echo "    import subprocess"
        echo "    subprocess.run(['python3', 'other_script.py', '--arg', 'value'])"
        echo ""
        echo "    Or for direct access to its functions:"
        echo "    import other_script  # if it's structured as a module"
        echo ""
    fi
}

# ── Register hooks ──
# For zsh users: add this line to ~/.zshrc
#   preexec_functions+=(_pyinstaller_hint _nuitka_hint _module_not_found_hint _run_py_hint)
#
# For bash users: add this to ~/.bashrc
#   trap 'cmd=$(history 1); _pyinstaller_hint "$cmd"' DEBUG
#   trap 'cmd=$(history 1); _module_not_found_hint "$cmd"' DEBUG

echo "✅ Hermes terminal hints installed for zsh/bash."
echo "   Source this file or add to your ~/.zshrc / ~/.bashrc"
