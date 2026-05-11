     1|#!/bin/bash
     2|# =============================================================================
     3|# Python Pain Hints — Auto-generated from r/learnpython scan
     4|# Generated: 2026-05-12
     5|# Source: r/learnpython (new, hot, top) — 20 posts classified
     6|# 
     7|# This script provides terminal-based hints for common Python mistakes
     8|# discovered on r/learnpython. Add to ~/.bashrc or ~/.zshrc:
     9|#   source ~/python-pain-hints.sh
    10|# =============================================================================
    11|set -euxo pipefail
    12|
    13|# --- Color helpers ---
    14|RED='\033[0;31m'
    15|GREEN='\033[0;32m'
    16|YELLOW='\033[1;33m'
    17|BLUE='\033[0;34m'
    18|NC='\033[0m' # No Color
    19|
    20|# =============================================================================
    21|# HINT 1: Pandas to_numeric dropping leading zeros / adding trailing 9s
    22|# Pain: pd.to_numeric() on datetime columns converts to nanosecond integers
    23|# Engage: 5 comments | Score: 1 | Category: API
    24|# See: https://reddit.com/r/learnpython/comments/1taaxg9/
    25|# =============================================================================
    26|_pain_pandas_to_numeric() {
    27|    if [[ "$1" == *"to_numeric"* ]] || [[ "$1" == *"datetime"* && "$1" == *"pandas"* ]]; then
    28|        echo -e "\n${YELLOW}💡 Pandas tip:${NC} Use ${GREEN}pd.to_datetime()${NC} not ${RED}pd.to_numeric()${NC} for dates"
    29|        echo "   to_numeric converts datetime64 to nanoseconds (adds 9 trailing zeros)"
    30|        echo "   Fix: pd.to_datetime(df['col']) or divide by 1e9 after conversion"
    31|        echo ""
    32|    fi
    33|}
    34|
    35|# =============================================================================
    36|# HINT 2: Circular imports with inheritance across files
    37|# Pain: NameError/ImportError when parent class imports child class at top level
    38|# Engage: 30 comments | Score: 0 | Category: API
    39|# See: https://reddit.com/r/learnpython/comments/1ta28qs/
    40|# =============================================================================
    41|_pain_circular_import() {
    42|    if [[ "$1" == *"circular import"* ]] || [[ "$1" == *"ImportError"* && "$1" == *"cannot import"* ]]; then
    43|        echo -e "\n${YELLOW}💡 Circular import fix:${NC}"
    44|        echo "   Instead of top-level: from other_module import ClassB"
    45|        echo "   Use ${GREEN}lazy import${NC} inside the method that needs it:"
    46|        echo "       def my_method(self):"
    47|        echo "           from other_module import ClassB  # Import here, not at top"
    48|        echo ""
    49|        echo "   Or for type hints only:"
    50|        echo "       ${GREEN}from __future__ import annotations"
    51|        echo "       from typing import TYPE_CHECKING"
    52|        echo "       if TYPE_CHECKING:"
    53|        echo "           from other_module import ClassB${NC}"
    54|        echo ""
    55|    fi
    56|}
    57|
    58|# =============================================================================
    59|# HINT 3: While loop never exits — += vs = trap
    60|# Pain: confirmation += input() concatenates instead of overwriting
    61|# Engage: 10 comments | Score: 10 | Category: UX
    62|# See: https://reddit.com/r/learnpython/comments/1t6ae1n/
    63|# =============================================================================
    64|_pain_while_loop_concat() {
    65|    if [[ "$1" == *"while"* && "$1" == *"True"* ]]; then
    66|        echo -e "\n${YELLOW}💡 Infinite loop?${NC} Check for ${RED}+=${NC} vs ${GREEN}=${NC} bug:"
    67|        echo "   ${RED}confirmation += input()${NC}  ← concatenates, never matches 'yes'"
    68|        echo "   ${GREEN}confirmation = input()${NC}   ← overwrites each time (correct)"
    69|        echo ""
    70|    fi
    71|}
    72|
    73|# =============================================================================
    74|# HINT 4: [[0]*n]*n matrix — shared reference trap
    75|# Pain: All rows point to the same list; changing one affects all
    76|# Engage: 10 comments | Score: 10 | Category: UX
    77|# See: https://reddit.com/r/learnpython/comments/1t7g3gj/
    78|# =============================================================================
    79|_pain_matrix_trap() {
    80|    if [[ "$1" == *"[[0]"* ]] || [[ "$1" == *"[0]*"* ]]; then
    81|        echo -e "\n${YELLOW}💡 Matrix trap:${NC} [[0]*n]*n creates ${RED}n pointers to the same list${NC}!"
    82|        echo "   Fix: ${GREEN}matrix = [[0] * n for _ in range(n)]${NC}  # each row is independent"
    83|        echo ""
    84|    fi
    85|}
    86|
    87|# =============================================================================
    88|# HINT 5: PyPI publish issues — check status first
    89|# Pain: PyPI web UI shows maintenance/404; twine upload still works
    90|# Engage: 3 comments | Score: 0 | Category: Environment
    91|# See: https://reddit.com/r/learnpython/comments/1ta0ih6/
    92|# =============================================================================
    93|_pain_pypi_publish() {
    94|    if [[ "$1" == *"twine"* ]] || [[ "$1" == *"pypi"* ]]; then
    95|        echo -e "\n${YELLOW}💡 PyPI publish tip:${NC}"
    96|        echo "   Check status: ${BLUE}https://status.python.org${NC}"
    97|        echo "   Test first: ${GREEN}twine upload --repository testpypi dist/*${NC}"
    98|        echo "   Skip duplicates: ${GREEN}twine upload --skip-existing dist/*${NC}"
    99|        echo ""
   100|    fi
   101|}
   102|
   103|# =============================================================================
   104|# HINT 6: Kivy installation issues — try lighter alternatives
   105|# Pain: Kivy has complex native dependencies (SDL2, Cython); beginners struggle
   106|# Engage: 6 comments | Score: 1 | Category: Environment
   107|# See: https://reddit.com/r/learnpython/comments/1t9xsnq/
   108|# =============================================================================
   109|_pain_kivy_alternatives() {
   110|    if [[ "$1" == *"kivy"* ]] || [[ "$1" == *"No module named kivy"* ]]; then
   111|        echo -e "\n${YELLOW}💡 Kivy alternatives for Python GUI:${NC}"
   112|        echo "   ${GREEN}CustomTkinter${NC} — simplest, modern look: pip install customtkinter"
   113|        echo "   ${GREEN}PyQt6${NC} — most powerful & mature: pip install PyQt6"
   114|        echo "   ${GREEN}Flet${NC} — Flutter-like, cross-platform: pip install flet"
   115|        echo ""
   116|    fi
   117|}
   118|
   119|# =============================================================================
   120|# HINT 7: help() / dir() overload — filter the noise
   121|# Pain: help() outputs walls of text; hard to navigate in coding interviews
   122|# Engage: 5 comments | Score: 0 | Category: Tooling
   123|# See: https://reddit.com/r/learnpython/comments/1t9k02y/
   124|# =============================================================================
   125|_pain_help_overload() {
   126|    if [[ "$1" == *"help("* ]] || [[ "$1" == *"dir("* ]]; then
   127|        echo -e "\n${YELLOW}💡 Taming help() output:${NC}"
   128|        echo "   Filter noise: ${GREEN}[m for m in dir(obj) if not m.startswith('_')]${NC}"
   129|        echo "   Class only: ${GREEN}help(obj.__class__)${NC}"
   130|        echo "   Best: use ${GREEN}ipython${NC} and type ${GREEN}obj?${NC} or ${GREEN}obj??${NC}"
   131|        echo ""
   132|    fi
   133|}
   134|
   135|# =============================================================================
   136|# HINT 8: bool('False') == True — non-empty string truthiness
   137|# Pain: bool() on string 'False'/'0'/'0.0' all return True
   138|# Engage: 30 comments | Score: 0 | Category: API
   139|# See: https://reddit.com/r/learnpython/comments/1t6wgca/
   140|# =============================================================================
   141|_pain_bool_strings() {
   142|    if [[ "$1" == *"bool("* && ( "$1" == *"False"* || "$1" == *"0"* ]]; then
   143|        echo -e "\n${YELLOW}💡 bool() trap:${NC} Any non-empty string is True!"
   144|        echo "   bool('False') == True  ${RED}← surprising but correct${NC}"
   145|        echo "   Use: ${GREEN}import ast; ast.literal_eval('False')${NC}"
   146|        echo "   Or: ${GREEN}int('0'); bool(result)${NC}"
   147|        echo ""
   148|    fi
   149|}
   150|
   151|# =============================================================================
   152|# INSTALLATION
   153|# =============================================================================
   154|# Zsh (~/.zshrc):
   155|#   source ~/python-pain-hints.sh
   156|#   preexec_functions+=(_pain_pandas_to_numeric _pain_circular_import _pain_while_loop_concat _pain_matrix_trap _pain_pypi_publish _pain_kivy_alternatives _pain_help_overload _pain_bool_strings)
   157|#
   158|# Bash (~/.bashrc):
   159|#   source ~/python-pain-hints.sh
   160|#   # Bash's PROMPT_COMMAND alternative (simplified):
   161|#   trap 'last_cmd=$BASH_COMMAND' DEBUG
   162|#   # Then check $last_cmd in PROMPT_COMMAND
   163|
   164|echo -e "${GREEN}✅ Python Pain Hints loaded!${NC} 8 terminal hints covering:"
   165|echo "   • pandas to_numeric datetime trap"
   166|echo "   • circular import resolution"
   167|echo "   • while loop += vs = bug"
   168|echo "   • [[0]*n]*n matrix reference trap"
   169|echo "   • PyPI publish troubleshooting"
   170|echo "   • Kivy GUI alternatives"
   171|echo "   • help()/dir() output filtering"
   172|echo "   • bool() string truthiness trap"
   173|echo ""
   174|