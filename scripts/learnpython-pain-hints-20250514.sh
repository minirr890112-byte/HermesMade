#!/usr/bin/env bash
# ============================================================================
# Hermes Pain-Hint Terminal Assistant
# Auto-generated from r/learnpython pain point analysis
# Generated: 2025-05-18T07:14:00Z
# Source: r/learnpython — 30 posts classified, 20 terminal hints generated
# ============================================================================
# To use: source this file in your ~/.zshrc or ~/.bashrc
#   source ~/.hermes/scripts/learnpython-pain-hints.sh
# ============================================================================

HERMES_HINT_ENABLED="${HERMES_HINT_ENABLED:-1}"

# --------------- helper: clipboard (cross-platform) ---------------
_clipboard_copy() {
    if command -v pbcopy &>/dev/null; then
        printf '%s' "$1" | pbcopy
    elif command -v xclip &>/dev/null; then
        printf '%s' "$1" | xclip -selection clipboard
    elif command -v clip.exe &>/dev/null; then
        printf '%s' "$1" | clip.exe
    fi
}

# ===========================
# HINT #1 — ModuleNotFoundError: pyodbc
# Pain: Missing pyodbc but I see it installed
# Source: https://reddit.com/r/learnpython/comments/1tdqzea/
# Engagement: 20
# ===========================
_hint_missing_pyodbc() {
    if [[ "$1" == *"ModuleNotFoundError"* && "$1" == *"pyodbc"* ]]; then
        printf "\n💡 'pyodbc' not found? You may be in the wrong virtual environment."
        printf "\n   Try: source .venv/bin/activate && pip install pyodbc\n"
        _clipboard_copy "pip install pyodbc"
        printf "   (Cmd+V / Ctrl+Shift+V to paste)\n"
    fi
}

# ===========================
# HINT #2 — Loop Overwriting Variable
# Pain: Why does my Python loop keep overwriting the variable instead of storing all the values?
# Source: https://reddit.com/r/learnpython/comments/1tbamo4/
# Engagement: 60
# ===========================
_hint_loop_accumulator() {
    if [[ "$1" == *"NameError"* || "$1" == *"IndexError"* ]]; then
        # Heuristic: if user just ran a Python file and got an error, show hint
        local last_cmd="${2:-}"
        if [[ "$last_cmd" == *"python"* ]]; then
            printf "\n💡 Loops overwriting your variable? Use .append() on a list instead of = assignment.\n"
            printf "   Example:\n"
            printf "     result = []\n"
            printf "     for item in items:\n"
            printf '         result.append(item * 2)\n'
        fi
    fi
}

# ===========================
# HINT #3 — API Rate Limits
# Pain: Building an AI medical office chatbot with Flask + Groq API — hitting rate limits constantly
# Source: https://reddit.com/r/learnpython/comments/1tfsxzw/
# Engagement: 14
# ===========================
_hint_rate_limit() {
    if [[ "$1" == *"429"* || "$1" == *"RateLimitError"* || "$1" == *"rate limit"* ]]; then
        printf "\n💡 Hitting API rate limits? Add time.sleep() between calls:\n"
        printf "     import time, random\n"
        printf "     time.sleep(1 + random.random())  # between API calls\n"
        printf "   Or use exponential backoff: double wait after each 429.\n"
    fi
}

# ===========================
# HINT #4 — venv + Git Clone Best Practice
# Pain: venv and cloned git repositories - best practice?
# Source: https://reddit.com/r/learnpython/comments/1tepup4/
# Engagement: 31
# ===========================
_hint_venv_git() {
    if [[ "$1" == *"git clone"* ]]; then
        printf "\n💡 After cloning a repo, set up a virtual environment:\n"
        printf "     python -m venv .venv\n"
        printf "     source .venv/bin/activate\n"
        printf "     pip install -r requirements.txt\n"
        _clipboard_copy "python -m venv .venv && source .venv/bin/activate && pip install -r requirements.txt"
        printf "   (Cmd+V to paste)\n"
    fi
}

# ===========================
# HINT #5 — Type Warning / Expected Type Mismatch
# Pain: New to Python, error warning — Expected type 'collections.iterable', got 'list[Any]|int'
# Source: https://reddit.com/r/learnpython/comments/1tdei6p/
# Engagement: 19
# ===========================
_hint_type_mismatch() {
    if [[ "$1" == *"TypeError"* || "$1" == *"type"* && "$1" == *"warning"* ]]; then
        printf "\n💡 Type warning? Add a type hint: : list or try running mypy:\n"
        printf "     pip install mypy\n"
        printf "     mypy --strict your_file.py\n"
    fi
}

# ===========================
# HINT #6 — Packaging Python as Desktop App
# Pain: What do people usually use to turn a Python script into a desktop app?
# Source: https://reddit.com/r/learnpython/comments/1td6flx/
# Engagement: 79
# ===========================
_hint_packaging() {
    if [[ "$1" == *"pyinstaller"* || "$1" == *"exe"* || "$1" == *"desktop app"* ]]; then
        printf "\n💡 Packaging Python as a desktop app:\n"
        printf "     pip install pyinstaller\n"
        printf "     pyinstaller --onefile --windowed your_script.py\n"
        printf "   For GUI, use tkinter (built-in) or pip install customtkinter.\n"
        _clipboard_copy "pip install pyinstaller && pyinstaller --onefile --windowed your_script.py"
        printf "   (Cmd+V to paste)\n"
    fi
}

# ===========================
# HINT #7 — CSV to Image
# Pain: Manipulating a CSV file and making it into a JPG
# Source: https://reddit.com/r/learnpython/comments/1tewj69/
# Engagement: 43
# ===========================
_hint_csv_image() {
    if [[ "$1" == *"csv"* && "$1" == *"image"* || "$1" == *"jpg"* ]]; then
        printf "\n💡 Converting CSV to image with Python:\n"
        printf "     import pandas as pd, matplotlib.pyplot as plt\n"
        printf "     df = pd.read_csv('file.csv')\n"
        printf "     df.plot().get_figure().savefig('output.jpg')\n"
        printf "   Or use openpyxl + PIL for styled tables.\n"
    fi
}

# ===========================
# HINT #8 — List Comprehensions
# Pain: Using Built-in functions and Comprehensions — slow to understand
# Source: https://reddit.com/r/learnpython/comments/1tby9ma/
# Engagement: 29
# ===========================
_hint_comprehensions() {
    if [[ "$1" == *"python"* ]]; then
        printf "\n💡 Tip: List comprehensions simplify loops:\n"
        printf "     # Traditional loop:\n"
        printf "     doubled = []\n"
        printf "     for x in numbers:\n"
        printf "         doubled.append(x * 2)\n"
        printf "     \n"
        printf "     # Comprehension (same result):\n"
        printf "     doubled = [x * 2 for x in numbers]\n"
    fi
}

# ===========================
# HINT #9 — input() Called Multiple Times
# Pain: How to avoid calling a function with input() multiple times in Python?
# Source: https://reddit.com/r/learnpython/comments/1tdcgds/
# Engagement: 24
# ===========================
_hint_input_caching() {
    if [[ "$1" == *"EOFError"* ]]; then
        printf "\n💡 Calling input() multiple times? Store the result once:\n"
        printf "     ratings = get_ratings()  # call ONCE\n"
        printf "     process_movies(ratings)   # reuse variable\n"
    fi
}

# ===========================
# HINT #10 — Deploy Python Web App
# Pain: Turning a Python script into a web application that can be deployed in Azure
# Source: https://reddit.com/r/learnpython/comments/1td8cc2/
# Engagement: 23
# ===========================
_hint_web_deploy() {
    if [[ "$1" == *"flask"* || "$1" == *"fastapi"* || "$1" == *"deploy"* ]]; then
        printf "\n💡 Deploying Python web app? Start simple:\n"
        printf "     pip install flask\n"
        printf "     # app.py:\n"
        printf "     from flask import Flask\n"
        printf "     app = Flask(__name__)\n"
        printf "     @app.route('/')\n"
        printf "     def hello(): return 'Hello World!'\n"
        printf "     app.run()\n"
        printf "   Free hosting: Vercel, Railway, Render.\n"
    fi
}

# ===========================
# HINT #11 — OOP Basics
# Pain: Coming from 4 years of procedural / functional programming, I can't wrap my head around OOP
# Source: https://reddit.com/r/learnpython/comments/1tdtgs7/
# Engagement: 16
# ===========================
_hint_oop_basics() {
    if [[ "$1" == *"AttributeError"* || "$1" == *"self"* && "$1" == *"not defined"* ]]; then
        printf "\n💡 New to OOP? Think: class = blueprint, object = house.\n"
        printf "     class Dog:\n"
        printf "         def __init__(self, name):\n"
        printf "             self.name = name\n"
        printf "         def bark(self):\n"
        printf "             print(f'{self.name} says woof!')\n"
    fi
}

# ===========================
# HINT #12 — File I/O (readline vs readlines)
# Pain: Is my understanding of file(i/o) right? confused between readline and readlines
# Source: https://reddit.com/r/learnpython/comments/1tfrcvs/
# Engagement: 15
# ===========================
_hint_file_io() {
    if [[ "$1" == *"python"* ]]; then
        printf "\n💡 Working with files in Python:\n"
        printf "     readline()  = one line at a time (string)\n"
        printf "     readlines() = all lines at once (list)\n"
        printf "     Use 'with open(...) as f:' for auto-close.\n"
        printf "     with open('file.txt') as f:\n"
        printf "         lines = f.readlines()  # list of all lines\n"
    fi
}

# ===========================
# HINT #13 — Pygame Grid Positioning
# Pain: How do I position the player to be positioned on the matrix
# Source: https://reddit.com/r/learnpython/comments/1tdgez2/
# Engagement: 14
# ===========================
_hint_pygame_grid() {
    if [[ "$1" == *"pygame"* ]]; then
        printf "\n💡 Pygame grid positioning:\n"
        printf "     cell_size = 50\n"
        printf "     player_x = col * cell_size\n"
        printf "     player_y = row * cell_size\n"
        printf "     screen.blit(player_img, (player_x, player_y))\n"
    fi
}

# ===========================
# HINT #14 — Learning Resources
# Pain: Best way to learn Python for AI and automation as a beginner
# Source: https://reddit.com/r/learnpython/comments/1tdn6bq/
# Engagement: 141
# ===========================
_hint_learning_path() {
    if [[ "$1" == *"python"* ]]; then
        printf "\n📚 Best free Python resources:\n"
        printf "   • CS50p (Harvard) — free video course\n"
        printf "   • python.org/tutorial — official docs\n"
        printf "   • Automate the Boring Stuff — free online book\n"
        printf "   💡 Start with projects, not theory!\n"
        printf "   Run: python3 -c 'print(\"Hello World\")'\n"
    fi
}

# ===========================
# HINT #15 — Motivation / Getting Unstuck
# Pain: Anyone else have motivation issues?
# Source: https://reddit.com/r/learnpython/comments/1teji8s/
# Engagement: 17
# ===========================
_hint_motivation() {
    if [[ "$1" == *"python"* ]]; then
        printf "\n🤗 Stuck on OOP? Try this:\n"
        printf "     class Dog:\n"
        printf "         def __init__(self, name): self.name = name\n"
        printf "         def bark(self): print(f'{self.name} says woof!')\n"
        printf "   Build one small class, test it, then keep going!\n"
    fi
}

# ===========================
# HINT #16 — 30-Day Learning Plan
# Pain: 30-day python learning - Any Recommended guidelines or Resources
# Source: https://reddit.com/r/learnpython/comments/1te65hr/
# Engagement: 21
# ===========================
_hint_30day_plan() {
    if [[ "$1" == *"python"* ]]; then
        printf "\n📅 30-Day Python plan:\n"
        printf "   Week 1: syntax, variables, input/print, if/else\n"
        printf "   Week 2: loops (for/while), lists, dicts\n"
        printf "   Week 3: functions, file I/O, error handling\n"
        printf "   Week 4: projects! (CLI tool, web scraper, game)\n"
        printf "   Resources: python.org/tutorial, CS50p, Automate the Boring Stuff\n"
    fi
}

# ===========================
# HINT #17 — Python Mastery Plan
# Pain: Depth-first Python mastery plan (8-11 months)
# Source: https://reddit.com/r/learnpython/comments/1td03ta/
# Engagement: 23
# ===========================
_hint_mastery_plan() {
    if [[ "$1" == *"python"* ]]; then
        printf "\n🎯 Deep Python mastery path:\n"
        printf "   Phase 1 (months 1-2): Core language + daily coding\n"
        printf "   Phase 2 (months 3-4): OOP + design patterns\n"
        printf "   Phase 3 (months 5-6): Web frameworks + databases\n"
        printf "   Phase 4 (months 7-8): Contributing to open source\n"
    fi
}

# ===========================
# HINT #18 — Find Python Basics Course
# Pain: Suggest me some python course that can help me to learn python from basics
# Source: https://reddit.com/r/learnpython/comments/1tdmutx/
# Engagement: 34
# ===========================
_hint_python_course() {
    if [[ "$1" == *"python"* ]]; then
        printf "\n🎓 Top Python courses for beginners:\n"
        printf "   • CS50p (Harvard) — free, thorough\n"
        printf "   • Python Crash Course (book) — project-based\n"
        printf "   • 100 Days of Code (Udemy) — daily practice\n"
        printf "   Start with python.org/tutorial!\n"
    fi
}

# ===========================
# HINT #19 — Python for Beginners
# Pain: I want help finding the ropes for python
# Source: https://reddit.com/r/learnpython/comments/1tf4k29/
# Engagement: 18
# ===========================
_hint_find_ropes() {
    if [[ "$1" == *"python"* ]]; then
        printf "\n🧭 Finding your way with Python:\n"
        printf "   1. Install: python.org/downloads\n"
        printf "   2. Tutorial: docs.python.org/3/tutorial\n"
        printf "   3. Practice: build small CLI tools first\n"
        printf "   4. Community: r/learnpython, Python Discord\n"
        printf "   python3 -c 'print(\"You got this!\")'\n"
    fi
}

# ===========================
# HINT #20 — Build Logic After Learning
# Pain: Learned Python, but struggling to build logic while coding
# Source: https://reddit.com/r/learnpython/comments/1tcviwn/
# Engagement: 26
# ===========================
_hint_build_logic() {
    if [[ "$1" == *"python"* ]]; then
        printf "\n🧠 Stuck on building logic? Try this:\n"
        printf "   1. Write pseudocode FIRST (comments describing steps)\n"
        printf "   2. Break problem into smallest pieces\n"
        printf "   3. Solve one piece at a time\n"
        printf "   4. result = []  # initialize list\n"
        printf "      for item in items:\n"
        printf "          result.append(item * 2)  # accumulate results\n"
    fi
}

# ============================================================================
# AUTO-HOOK: Wire up hints to shell preexec (zsh) or DEBUG trap (bash)
# ============================================================================
_hook_hermes_hints() {
    local ret=$?
    local cmd="$1"
    # Only fire on errors from python commands
    if [[ $ret -ne 0 && "$cmd" == *python* ]]; then
        local last_stderr="${_HERMES_LAST_STDERR:-}"
        _hint_missing_pyodbc "$last_stderr" "$cmd"
        _hint_loop_accumulator "$last_stderr" "$cmd"
        _hint_rate_limit "$last_stderr" "$cmd"
        _hint_type_mismatch "$last_stderr" "$cmd"
        _hint_oop_basics "$last_stderr" "$cmd"
        _hint_input_caching "$last_stderr" "$cmd"
    fi
}

# Auto-install hook based on current shell
if [[ "$HERMES_HINT_ENABLED" == "1" ]]; then
    if [[ -n "$ZSH_VERSION" ]]; then
        preexec_functions+=(_hook_hermes_hints)
    elif [[ -n "$BASH_VERSION" ]]; then
        trap '_hook_hermes_hints "$BASH_COMMAND"' DEBUG
    fi
fi

# ============================================================================
# Self-help
# ============================================================================
hermes_hints_help() {
    echo "Hermes Pain-Hint Terminal Assistant"
    echo "====================================="
    echo "Hints: 20 terminal hints from r/learnpython analysis"
    echo ""
    echo "Available hint functions:"
    declare -F | grep _hint_ | sed 's/declare -f /  /'
    echo ""
    echo "Control:"
    echo "  HERMES_HINT_ENABLED=0  → disable all hints"
    echo "  hermes_hints_help      → show this help"
    echo "  source this file again to re-enable"
}
