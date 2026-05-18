     1|#!/bin/bash
     2|# Hermes Terminal Hints — Auto-generated from r/learnpython pain scan
     3|# Generated: 2026-05-18T23:07:18.672237Z
     4|# Subreddit: r/learnpython | Scanned: 101 posts | Pain detected: 44
     5|# Categories: Environment=24, API=9, Docs=10, Tooling=1
     6|
     7|# Rank #1: I made this 1.5 hours into python
     8|# Category: Docs | Score: 107 | Comments: 89
     9|# Reddit: https://reddit.com/r/learnpython/comments/1tfm72l/i_made_this_15_hours_into_python/
    10|_fix_docs_01() {
    11|  local stderr_output="$1"
    12|  if [[ "$stderr_output" == *"overwhelm"* ]]; then
    13|    printf "\\n💡 Docs Fix: Feeling overwhelmed? Start with python.org's official tutorial — it's structured for beginners\
    14|"
    15|    printf "   Run: python3 --version\
    16|"
    17|    printf "   (Press ↑ to recall, or Cmd+V / Ctrl+Shift+V to paste)\
    18|"
    19|  fi
    20|}
    21|# Install: add to preexec_functions+=( _fix_docs_01 ) in your .zshrc
    22|
    23|# Rank #2: Best way to learn Python for AI and automation as a beginner
    24|# Category: Docs | Score: 91 | Comments: 53
    25|# Reddit: https://reddit.com/r/learnpython/comments/1tdn6bq/best_way_to_learn_python_for_ai_and_automation_as/
    26|_fix_docs_02() {
    27|  local stderr_output="$1"
    28|  if [[ "$stderr_output" == *"overwhelm"* ]]; then
    29|    printf "\\n💡 Docs Fix: Python beginner? Run 'python3 -c "import this"' for the Zen of Python, then follow the official tutorial\
    30|"
    31|    printf "   Run: python3 -c 'import this'\
    32|"
    33|    printf "   (Press ↑ to recall, or Cmd+V / Ctrl+Shift+V to paste)\
    34|"
    35|  fi
    36|}
    37|# Install: add to preexec_functions+=( _fix_docs_02 ) in your .zshrc
    38|
    39|# Rank #3: How do you decide a Python package is safe enough to install?
    40|# Category: Environment | Score: 41 | Comments: 27
    41|# Reddit: https://reddit.com/r/learnpython/comments/1tgglox/how_do_you_decide_a_python_package_is_safe_enough/
    42|_fix_environment_03() {
    43|  local stderr_output="$1"
    44|  if [[ "$stderr_output" == *"pip install"* ]]; then
    45|    printf "\\n💡 Environment Fix: Before pip installing: check PyPI stats, GitHub stars, recent commits, and use pip's --dry-run to inspect\
    46|"
    47|    printf "   Run: pip install --report - -dry-run PACKAGE_NAME 2>&1 | head -20\
    48|"
    49|    printf "   (Press ↑ to recall, or Cmd+V / Ctrl+Shift+V to paste)\
    50|"
    51|  fi
    52|}
    53|# Install: add to preexec_functions+=( _fix_environment_03 ) in your .zshrc
    54|
    55|# Rank #4: I got work to debug a python code from a repo
    56|# Category: Docs | Score: 0 | Comments: 35
    57|# Reddit: https://reddit.com/r/learnpython/comments/1tgfihn/i_got_work_to_debugg_a_python_code_from_a_repo/
    58|_fix_docs_04() {
    59|  local stderr_output="$1"
    60|  if [[ "$stderr_output" == *"debug"* ]]; then
    61|    printf "\\n💡 Docs Fix: Need to debug? Use pdb: 'python3 -m pdb script.py'. Set breakpoints with 'b lineno', step with 'n', inspect with 'p var'\
    62|"
    63|    printf "   Run: python3 -m pdb SCRIPT.py\
    64|"
    65|    printf "   (Press ↑ to recall, or Cmd+V / Ctrl+Shift+V to paste)\
    66|"
    67|  fi
    68|}
    69|# Install: add to preexec_functions+=( _fix_docs_04 ) in your .zshrc
    70|
    71|# Rank #5: method overloading with wrapper classes
    72|# Category: API | Score: 0 | Comments: 35
    73|# Reddit: https://reddit.com/r/learnpython/comments/1tcy12o/method_overloading_with_wrapper_classes/
    74|_fix_api_05() {
    75|  local stderr_output="$1"
    76|  if [[ "$stderr_output" == *"TypeError"* ]]; then
    77|    printf "\\n💡 API Fix: Python doesn't have traditional method overloading — use functools.singledispatch or *args/**kwargs patterns instead\
    78|"
    79|    printf "   Run: python3 -c 'from functools import singledispatch; help(singledispatch)'\
    80|"
    81|    printf "   (Press ↑ to recall, or Cmd+V / Ctrl+Shift+V to paste)\
    82|"
    83|  fi
    84|}
    85|# Install: add to preexec_functions+=( _fix_api_05 ) in your .zshrc
    86|
    87|# ========== Installation ==========
    88|# Option 1 (Zsh): Add this line to ~/.zshrc:
    89|#   source ~/.hermes/terminal-hints.sh
    90|#   preexec_functions+=( _fix_docs_01 _fix_docs_02 _fix_environment_03 _fix_docs_04 _fix_api_05 )
    91|#
    92|# Option 2 (Bash): Source in ~/.bashrc and use DEBUG trap:
    93|#   trap '_fix_docs_01 "$_"' DEBUG
    94|