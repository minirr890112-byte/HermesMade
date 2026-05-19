#!/usr/bin/env bash
# ============================================================
# Hermes Terminal Hints — r/learnpython Pain Points
# Generated: 2026-05-19 23:13 UTC
# Source: Reddit r/learnpython scan (15 pain posts, 12 hints)
# Drop into ~/.zshrc or ~/.bashrc
# ============================================================

_python_pain_precmd() {
    local last_stderr
    last_stderr="$(_hermes_last_stderr 2>/dev/null)"

    # _python_tip_1tfm72 (on-first-open)
    if [[ ! -f /tmp/.hermes_hint__python_tip_1tfm72 ]]; then
        _hermes_hint "💡" "Community wisdom at the Reddit thread (cmd+click)." "https://reddit.com/r/learnpython/comments/1tfm72l/i_made_this_15_hours_into_python/"
        touch /tmp/.hermes_hint__python_tip_1tfm72
    fi
    # _explain_for_loop (on-first-open)
    if [[ ! -f /tmp/.hermes_hint__explain_for_loop ]]; then
        _hermes_hint "💡" "For loops: the variable is just a label YOU create. Each iteration, Python assigns the next item." "names = ['bob','jim','bill']; for name in names:;     print(name); # 'name' is YOUR label -- Python assigns each item to it, one at a time."
        touch /tmp/.hermes_hint__explain_for_loop
    fi
    # _fix_packaging_confusion
    if echo "$last_stderr" | grep -qE "pyinstaller|py2app|cx_Freeze" 2>/dev/null; then
        _hermes_hint "💡" "Packaging Python? PyInstaller for quick EXEs, Flet for modern cross-platform GUI. Copied!" "pip install pyinstaller; pyinstaller --onefile --windowed your_script.py"
    fi
    # _python_tip_1th9rq (on-first-open)
    if [[ ! -f /tmp/.hermes_hint__python_tip_1th9rq ]]; then
        _hermes_hint "💡" "Community wisdom at the Reddit thread (cmd+click)." "https://reddit.com/r/learnpython/comments/1th9rqk/how_long_did_it_take_you_to_learn_python/"
        touch /tmp/.hermes_hint__python_tip_1th9rq
    fi
    # _check_package_safety
    if echo "$last_stderr" | grep -qE "pip install" 2>/dev/null; then
        _hermes_hint "💡" "Before installing unknown packages: pip-audit scans for known vulnerabilities. Copied!" "pip install pip-audit && pip-audit"
    fi
    # _python_tip_1thvxl (on-first-open)
    if [[ ! -f /tmp/.hermes_hint__python_tip_1thvxl ]]; then
        _hermes_hint "💡" "Community wisdom at the Reddit thread (cmd+click)." "https://reddit.com/r/learnpython/comments/1thvxlu/cant_understand_for_loops_after_an_hour/"
        touch /tmp/.hermes_hint__python_tip_1thvxl
    fi
    # _python_beginner_advice (on-first-open)
    if [[ ! -f /tmp/.hermes_hint__python_beginner_advice ]]; then
        _hermes_hint "💡" "Python progress isn't linear. Build things -- theory comes naturally through practice." "# Month 1-2: variables, loops, functions; # Month 3-4: small projects; # Month 5-6: libraries (pandas, flask); # Key: 20 min/day > 3 hours once a week"
        touch /tmp/.hermes_hint__python_beginner_advice
    fi
    # _python_tip_1te5gg (on-first-open)
    if [[ ! -f /tmp/.hermes_hint__python_tip_1te5gg ]]; then
        _hermes_hint "💡" "Community wisdom at the Reddit thread (cmd+click)." "https://reddit.com/r/learnpython/comments/1te5gg4/9th_grader_wants_to_code/"
        touch /tmp/.hermes_hint__python_tip_1te5gg
    fi
    # _python_tip_1te3nv (on-first-open)
    if [[ ! -f /tmp/.hermes_hint__python_tip_1te3nv ]]; then
        _hermes_hint "💡" "Community wisdom at the Reddit thread (cmd+click)." "https://reddit.com/r/learnpython/comments/1te3nvd/newbie_wanting_to_learn_python/"
        touch /tmp/.hermes_hint__python_tip_1te3nv
    fi
    # _fix_dependency_chaos
    if echo "$last_stderr" | grep -qE "ModuleNotFoundError|ImportError" 2>/dev/null; then
        _hermes_hint "💡" "Dependency drift? Lock and pin your dependencies with pip-tools. Copied to clipboard." "python -m pip freeze > requirements.txt; python -m pip install pip-tools && pip-compile"
    fi
    # _python_tip_1tevlc (on-first-open)
    if [[ ! -f /tmp/.hermes_hint__python_tip_1tevlc ]]; then
        _hermes_hint "💡" "Community wisdom at the Reddit thread (cmd+click)." "https://reddit.com/r/learnpython/comments/1tevlck/wheres_a_good_place_to_learn_python_i_dont_trust/"
        touch /tmp/.hermes_hint__python_tip_1tevlc
    fi
    # _learn_comprehensions (on-first-open)
    if [[ ! -f /tmp/.hermes_hint__learn_comprehensions ]]; then
        _hermes_hint "💡" "Comprehensions = loops in one line. Start: [f(x) for x in iterable]. Copied example." "squares = []; for x in range(10):;     squares.append(x**2); # Same as:; squares = [x**2 for x in range(10)]"
        touch /tmp/.hermes_hint__learn_comprehensions
    fi
}

# --- Helper: capture stderr (zsh) ---
if [[ -n "$ZSH_VERSION" ]]; then
    _hermes_last_stderr() {
        cat /tmp/hermes_last_stderr 2>/dev/null
    }
    exec 2> >(tee /tmp/hermes_last_stderr >&2)
fi

# --- Helper: cross-platform clipboard ---
_hermes_clipboard() {
    if command -v pbcopy &>/dev/null; then
        echo "$1" | pbcopy
    elif command -v xclip &>/dev/null; then
        echo "$1" | xclip -selection clipboard
    elif command -v clip.exe &>/dev/null; then
        echo "$1" | clip.exe
    fi
}

# --- Helper: print hint ---
_hermes_hint() {
    local emoji msg solution
    emoji="$1"; msg="$2"; solution="$3"
    printf "\n%s %s\n" "$emoji" "$msg"
    _hermes_clipboard "$solution"
    printf "   Solution copied to clipboard — Cmd+V / Ctrl+Shift+V to paste.\n"
}

echo "✅ Hermes Python hints loaded. 12 triggers active."
