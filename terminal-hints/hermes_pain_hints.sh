     1|#!/usr/bin/env bash
     2|# ==============================================================================
     3|# HermesMade Terminal Hints — Auto-generated from r/learnpython pain scan
     4|# Generated: 2025-06-07
     5|# Source: r/learnpython via Pullpush API (~1 year data)
     6|# Install: source this file in your ~/.zshrc or ~/.bashrc
     7|#
     8|# Pain points addressed:
     9|#   1. [HIGH] install -r requirements.txt → "illegal option -- r" (28 comments)
    10|#   2. [MED] Matplotlib backend broken after system update (3 comments)
    11|#   3. [MED] ModuleNotFoundError — wrong Python/venv (5 comments)
    12|#   4. [LOW] uv broke conda in zsh (13 comments)
    13|# ==============================================================================
    14|
    15|# ---------------------------------------------------------------------------
    16|# Hint #1: "install -r" instead of "pip install -r"
    17|# Pain: User types bare `install -r requirements.txt` on macOS
    18|# Error: "install: illegal option -- r"
    19|# Solution: Prepend with pip or python3 -m pip
    20|# ---------------------------------------------------------------------------
    21|_fix_install_r() {
    22|    local last_stderr="$1"
    23|    if [[ "$last_stderr" == *"install: illegal option -- r"* ]]; then
    24|        printf "\n💡  \033[1;33mHermes detected:\033[0m You typed 'install -r' but meant 'pip install -r'\n"
    25|        printf "   Try this instead:\n"
    26|        printf "   \033[1;32m  pip install -r requirements.txt\033[0m\n"
    27|        printf "   \033[2m(We've copied it to your clipboard — just paste and press Enter)\033[0m\n\n"
    28|        # macOS clipboard
    29|        if command -v pbcopy &>/dev/null; then
    30|            echo -n "pip install -r requirements.txt" | pbcopy
    31|        fi
    32|        # Linux clipboard (X11)
    33|        if command -v xclip &>/dev/null; then
    34|            echo -n "pip install -r requirements.txt" | xclip -selection clipboard
    35|        fi
    36|        # If pip itself is missing
    37|        if ! command -v pip &>/dev/null && ! command -v pip3 &>/dev/null; then
    38|            printf "   \033[2mTip: pip not found. Try: python3 -m pip install -r requirements.txt\033[0m\n"
    39|        fi
    40|    fi
    41|}
    42|
    43|# ---------------------------------------------------------------------------
    44|# Hint #2: "CERTIFICATE_VERIFY_FAILED" / SSL errors
    45|# Pain: pip install fails with SSL certificate error
    46|# Fix: Upgrade certifi or use --trusted-host
    47|# ---------------------------------------------------------------------------
    48|_fix_pip_ssl() {
    49|    local last_stderr="$1"
    50|    if [[ "$last_stderr" == *"CERTIFICATE_VERIFY_FAILED"* ]] || [[ "$last_stderr" == *"SSL"*"certificate"* ]]; then
    51|        printf "\n🔒  \033[1;33mSSL Certificate Error:\033[0m pip can't verify the server's certificate.\n"
    52|        printf "   Quick fix (copy-pasted to clipboard):\n"
    53|        printf "   \033[1;32m  pip install --upgrade certifi\033[0m\n\n"
    54|        if command -v pbcopy &>/dev/null; then
    55|            echo -n "pip install --upgrade certifi" | pbcopy
    56|        fi
    57|        if command -v xclip &>/dev/null; then
    58|            echo -n "pip install --upgrade certifi" | xclip -selection clipboard
    59|        fi
    60|    fi
    61|}
    62|
    63|# ---------------------------------------------------------------------------
    64|# Hint #3: "No module named 'X'" — Python environment mismatch
    65|# Pain: User installed package but Python can't find it
    66|# Fix: Check which Python you're using
    67|# ---------------------------------------------------------------------------
    68|_fix_module_not_found() {
    69|    local last_stderr="$1"
    70|    if [[ "$last_stderr" == *"ModuleNotFoundError"* ]] || [[ "$last_stderr" == *"No module named"* ]]; then
    71|        local missing_mod=$(echo "$last_stderr" | grep -oP "No module named '\\K[^']+" | head -1)
    72|        printf "\n📦  \033[1;33mModule Not Found:\033[0m Python can't find '%s'\n" "$missing_mod"
    73|        printf "   Check which Python you're using (copy-pasted):\n"
    74|        printf "   \033[1;32m  python3 -c 'import sys; print(sys.executable)'\033[0m\n"
    75|        printf "   Then install with that Python:\n"
    76|        printf "   \033[1;32m  %s -m pip install %s\033[0m\n\n" "$(which python3 2>/dev/null || echo "python3")" "$missing_mod"
    77|        if command -v pbcopy &>/dev/null; then
    78|            echo -n "python3 -c 'import sys; print(sys.executable)'" | pbcopy
    79|        fi
    80|    fi
    81|}
    82|
    83|# ---------------------------------------------------------------------------
    84|# Hint #4: matplotlib_inline backend broken
    85|# Pain: After system update, "matplotlib_inline.backend_inline is not a valid backend"
    86|# Fix: Force reinstall matplotlib and matplotlib-inline
    87|# ---------------------------------------------------------------------------
    88|_fix_matplotlib_backend() {
    89|    local last_stderr="$1"
    90|    if [[ "$last_stderr" == *"matplotlib_inline"* ]] && [[ "$last_stderr" == *"backend"* ]]; then
    91|        printf "\n📊  \033[1;33mMatplotlib Backend Broken:\033[0m The inline backend is missing or outdated.\n"
    92|        printf "   Fix (copy-pasted to clipboard):\n"
    93|        printf "   \033[1;32m  pip install --force-reinstall matplotlib matplotlib-inline\033[0m\n"
    94|        printf "   Then restart Jupyter/VSCode.\n\n"
    95|        if command -v pbcopy &>/dev/null; then
    96|            echo -n "pip install --force-reinstall matplotlib matplotlib-inline" | pbcopy
    97|        fi
    98|        if command -v xclip &>/dev/null; then
    99|            echo -n "pip install --force-reinstall matplotlib matplotlib-inline" | xclip -selection clipboard
   100|        fi
   101|    fi
   102|}
   103|
   104|# ---------------------------------------------------------------------------
   105|# Hint #5: conda not found (uv broke it)
   106|# Pain: After installing uv, conda commands don't work in zsh
   107|# Fix: Re-run conda init
   108|# ---------------------------------------------------------------------------
   109|_fix_conda_broken() {
   110|    if [[ "$1" == *"conda"*"command not found"* ]] || [[ "$1" == *"conda: command not found"* ]]; then
   111|        printf "\n🐍  \033[1;33mConda Missing:\033[0m uv may have overwritten your shell config.\n"
   112|        printf "   Fix: Re-run conda init (we've copied the command):\n"
   113|        printf "   \033[1;32m  conda init zsh && source ~/.zshrc\033[0m\n"
   114|        printf "   \033[2mIf conda isn't found at all, check: ~/miniconda3/bin/conda init zsh\033[0m\n\n"
   115|        if command -v pbcopy &>/dev/null; then
   116|            echo -n "conda init zsh && source ~/.zshrc" | pbcopy
   117|        fi
   118|    fi
   119|}
   120|
   121|# ---------------------------------------------------------------------------
   122|# Hint #6: ruff — the Python ESLint
   123|# Pain: Coming from Node/Ruby, need linting + auto-fix
   124|# ---------------------------------------------------------------------------
   125|_fix_linting_hint() {
   126|    # Only show on first cd into a directory with .py files
   127|    # This is a proactive hint, not error-triggered
   128|    if [[ -z "$_HERMES_LINT_HINT_SHOWN" ]]; then
   129|        local py_count=$(find . -maxdepth 1 -name "*.py" 2>/dev/null | wc -l)
   130|        if [[ $py_count -gt 0 ]] && ! command -v ruff &>/dev/null; then
   131|            printf "\n🪶  \033[1;33mPython Linting:\033[0m Try ruff — it's like ESLint for Python.\n"
   132|            printf "   \033[1;32m  pip install ruff && ruff check --fix .\033[0m\n"
   133|            printf "   \033[2m(We'll only show this once per session)\033[0m\n\n"
   134|            export _HERMES_LINT_HINT_SHOWN=1
   135|        fi
   136|    fi
   137|}
   138|
   139|# ---------------------------------------------------------------------------
   140|# Main hook: zsh preexec
   141|# ---------------------------------------------------------------------------
   142|if [[ -n "$ZSH_VERSION" ]]; then
   143|    # Zsh: hook into preexec to capture stderr after each command
   144|    _hermes_preexec() {
   145|        _hermes_last_cmd="$1"
   146|    }
   147|    _hermes_precmd() {
   148|        local ret=$?
   149|        # We check common error patterns from last command's potential output
   150|        # This fires after every command, so keep it fast
   151|        if [[ -n "$_hermes_last_stderr" ]]; then
   152|            _fix_install_r "$_hermes_last_stderr"
   153|            _fix_pip_ssl "$_hermes_last_stderr"
   154|            _fix_module_not_found "$_hermes_last_stderr"
   155|            _fix_matplotlib_backend "$_hermes_last_stderr"
   156|            _fix_conda_broken "$_hermes_last_stderr"
   157|        fi
   158|        _hermes_last_stderr=""
   159|    }
   160|    autoload -Uz add-zsh-hook
   161|    add-zsh-hook preexec _hermes_preexec
   162|    add-zsh-hook precmd _hermes_precmd
   163|
   164|    # Also catch stderr redirect: this captures '2>' redirected output
   165|    # For direct terminal errors, we use a DEBUG trap-like approach
   166|    exec 2> >(while IFS= read -r line; do
   167|        _hermes_last_stderr="$_hermes_last_stderr
   168|$line"
   169|        # Show hints inline for immediate feedback
   170|        [[ "$line" == *"install: illegal option"* ]] && _fix_install_r "$line"
   171|        [[ "$line" == *"CERTIFICATE_VERIFY_FAILED"* ]] && _fix_pip_ssl "$line"
   172|        [[ "$line" == *"ModuleNotFoundError"* ]] && _fix_module_not_found "$line"
   173|        [[ "$line" == *"matplotlib_inline"* ]] && _fix_matplotlib_backend "$line"
   174|        # Print stderr normally
   175|        printf '%s\n' "$line" >&2
   176|    done)
   177|
   178|elif [[ -n "$BASH_VERSION" ]]; then
   179|    # Bash: use DEBUG trap
   180|    _hermes_stderr_capture() {
   181|        # Save stderr to temp file and check after command
   182|        exec 2> >(tee /tmp/.hermes_stderr.$$ >&2)
   183|    }
   184|    PROMPT_COMMAND="_hermes_check_hints ${PROMPT_COMMAND:+;$PROMPT_COMMAND}"
   185|    _hermes_check_hints() {
   186|        if [[ -f /tmp/.hermes_stderr.$$ ]]; then
   187|            local stderr_content=$(cat /tmp/.hermes_stderr.$$)
   188|            _fix_install_r "$stderr_content"
   189|            _fix_pip_ssl "$stderr_content"
   190|            _fix_module_not_found "$stderr_content"
   191|            _fix_matplotlib_backend "$stderr_content"
   192|            _fix_conda_broken "$stderr_content"
   193|            rm -f /tmp/.hermes_stderr.$$
   194|        fi
   195|    fi
   196|    # Proactive hint on directory change
   197|    cd() {
   198|        builtin cd "$@"
   199|        _fix_linting_hint
   200|    }
   201|fi
   202|
   203|# ==============================================================================
   204|# Installation:
   205|#   echo 'source ~/.hermes/hermes_pain_hints.sh' >> ~/.zshrc
   206|#   source ~/.zshrc
   207|# ==============================================================================
   208|