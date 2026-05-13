     1|#!/usr/bin/env bash
     2|# HermesMade — Python Pain Point Terminal Hints
     3|# Generated from r/learnpython scan | 15 pain points addressed
     4|# Source: reddit.com/r/learnpython
     5|# Install: source this file in your ~/.zshrc or ~/.bashrc
     6|
     7|# Enable preexec hook for zsh
     8|if [[ -n "$ZSH_VERSION" ]]; then
     9|  autoload -Uz add-zsh-hook
    10|  preexec_functions=()
    11|  _hermes_preexec() {
    12|    local cmd="$1"
    13|    local output
    14|    for fn in ${preexec_functions[@]}; do
    15|      $fn "$output" 2>/dev/null
    16|    done
    17|  }
    18|  add-zsh-hook preexec _hermes_preexec
    19|fi
    20|
    21|# ============================================================
    22|# Pain: Teaching Python 3 years: students freeze when writing from scratch
    23|# Delivery: terminal-hint:auto-paste-hint | Trigger: on-first-open
    24|# Category: Docs
    25|# ============================================================
    26|# Blank page fear fix
    27|_fix_blank_page() {
    28|  if [[ "$1" == *"NameError"* ]] || [[ "$1" == *"SyntaxError"* ]]; then
    29|    printf "\n💡 Staring at a blank page? Start here:\n"
    30|    printf "   1. Write pseudocode as comments first:\n"
    31|    printf "      # Step 1: read the input\n"
    32|    printf "      # Step 2: validate the input\n"
    33|    printf "      # Step 3: process the data\n"
    34|    printf "      # Step 4: print the result\n"
    35|    printf "   2. Then fill in each comment one at a time\n"
    36|    printf "   3. Run after EACH step — don't write it all at once\n"
    37|  fi
    38|}
    39|preexec_functions+=(_fix_blank_page)
    40|
    41|# ============================================================
    42|# Pain: OOP completely loses me — when to use class vs function?
    43|# Delivery: terminal-hint:auto-paste-hint | Trigger: on-error
    44|# Category: API
    45|# ============================================================
    46|# OOP guidance
    47|_fix_oop_confusion() {
    48|  if [[ "$1" == *"TypeError"* ]] && [[ "$1" == *"self"* ]]; then
    49|    printf "\n💡 OOP tip: Did you forget 'self' as first parameter?\n"
    50|    printf "   class MyClass:\n"
    51|    printf "       def __init__(self):         # constructor, no return\n"
    52|    printf "           self.data = []          # instance variable\n"
    53|    printf "       def method(self, arg):     # self required!\n"
    54|    printf "           return self.data + arg\n"
    55|    printf "\n💡 When to use a class: data + behavior together\n"
    56|    printf "   When NOT to: just write a function if you only transform data\n"
    57|  fi
    58|}
    59|preexec_functions+=(_fix_oop_confusion)
    60|
    61|# ============================================================
    62|# Pain: Simplest way to distribute a Python app to normal users?
    63|# Delivery: terminal-hint:default-value | Trigger: on-demand
    64|# Category: Environment
    65|# ============================================================
    66|# Distribution help
    67|_fix_distribute() {
    68|  printf "\n💡 Distributing Python apps:\n"
    69|  printf "   Quick:   pip install pyinstaller && pyinstaller --onefile script.py\n"
    70|  printf "   Better:  Use pyproject.toml with [project.scripts] entry points\n"
    71|  printf "   Best:    pip install briefcase (cross-platform native installers)\n"
    72|  printf "   GUI:     pip install pywebview (web-based desktop apps)\n"
    73|}
    74|# Run on-demand: call _fix_distribute from your shell
    75|
    76|
    77|# ============================================================
    78|# Pain: CS student: blank out when I close the tutorial and try alone
    79|# Delivery: terminal-hint:auto-paste-hint | Trigger: on-first-open
    80|# Category: Docs
    81|# ============================================================
    82|# Tutorial trap fix
    83|_fix_tutorial_trap() {
    84|  printf "\n💡 Escaping the tutorial trap:\n"
    85|  printf "   1. After watching a tutorial section → CLOSE IT\n"
    86|  printf "   2. Try to rebuild from memory (even if you fail)\n"
    87|  printf "   3. Only peek at the tutorial AFTER trying for 5 minutes\n"
    88|  printf "   4. Build tiny projects: dice roller, to-do CLI, weather fetcher\n"
    89|  printf "   Key insight: Following ≠ Understanding. Struggle builds it.\n"
    90|}
    91|# Run on-demand: call _fix_tutorial_trap
    92|
    93|
    94|# ============================================================
    95|# Pain: Circular import with inheritance — classes can't see each other
    96|# Delivery: terminal-hint:auto-paste-hint | Trigger: on-error
    97|# Category: Environment
    98|# ============================================================
    99|# Detect circular import errors
   100|_fix_circular_import() {
   101|  if [[ "$1" == *"ImportError"* ]] || [[ "$1" == *"circular"* ]]; then
   102|    printf "\n💡 Circular import detected! 3 fixes (pick one):\n"
   103|    printf "   1. Lazy import: move 'import X' inside the function body\n"
   104|    printf "   2. Shared module: put common code in shared.py, import from there\n"
   105|    printf "   3. Dependency injection: pass objects as arguments instead of importing\n"
   106|  fi
   107|}
   108|preexec_functions+=(_fix_circular_import)
   109|
   110|# ============================================================
   111|# Pain: Loop overwrites variable instead of storing all values
   112|# Delivery: terminal-hint:auto-paste-hint | Trigger: on-error
   113|# Category: API
   114|# ============================================================
   115|# Loop collection fix
   116|_fix_loop_collect() {
   117|  if [[ "$1" == *"NameError"* ]] || [[ "$1" == *"UnboundLocalError"* ]]; then
   118|    printf "\n💡 Collecting loop results — 3 patterns:\n"
   119|    printf "   # Pattern 1: append to list\n"
   120|    printf "   results = []\n"
   121|    printf "   for item in items:\n"
   122|    printf "       results.append(process(item))\n"
   123|    printf "   # Pattern 2: list comprehension (faster)\n"
   124|    printf "   results = [process(item) for item in items]\n"
   125|    printf "   # Pattern 3: accumulator pattern\n"
   126|    printf "   total = 0\n"
   127|    printf "   for item in items:\n"
   128|    printf "       total += item  # use += not =\n"
   129|  fi
   130|}
   131|preexec_functions+=(_fix_loop_collect)
   132|
   133|# ============================================================
   134|# Pain: Can I learn Python with zero coding knowledge?
   135|# Delivery: terminal-hint:one-click-button | Trigger: on-first-open
   136|# Category: Docs
   137|# ============================================================
   138|# Beginner learning path
   139|_fix_beginner_path() {
   140|  printf "\n💡 Learning Python from zero — proven path:\n"
   141|  printf "   1. Start: docs.python.org/3/tutorial/ (2 weeks)\n"
   142|  printf "   2. Practice: automatetheboringstuff.com (free, project-based)\n"
   143|  printf "   3. Projects: dice roller → number guesser → todo CLI → weather app\n"
   144|  printf "   4. Go deeper: cs50.harvard.edu/python (free Harvard course)\n"
   145|  printf "   Key: Code EVERY day, even 20 minutes. Consistency > intensity.\n"
   146|}
   147|# Run on-demand: call _fix_beginner_path
   148|
   149|
   150|# ============================================================
   151|# Pain: My Python code works but I have no idea WHY — normal?
   152|# Delivery: terminal-hint:auto-paste-hint | Trigger: on-first-open
   153|# Category: Docs
   154|# ============================================================
   155|# Code understanding fix
   156|_fix_understand_code() {
   157|  printf "\n💡 Understanding WHY your code works:\n"
   158|  printf "   1. Add print() after every variable assignment\n"
   159|  printf "   2. Use pythontutor.com — paste your code, watch it execute line by line\n"
   160|  printf "   3. Python debugger: add 'breakpoint()' then run, use 'p var' to inspect\n"
   161|  printf "   4. Rubber duck: explain each line out loud to an imaginary duck\n"
   162|  printf "   Normal? YES — every programmer goes through this phase. Keep going.\n"
   163|}
   164|# Run on-demand: call _fix_understand_code
   165|
   166|
   167|# ============================================================
   168|# Pain: How to go from scripts to real backend project structure?
   169|# Delivery: terminal-hint:one-click-button | Trigger: on-first-open
   170|# Category: Docs
   171|# ============================================================
   172|# Project structure guide
   173|_fix_project_structure() {
   174|  printf "\n💡 Structuring Python projects:\n"
   175|  printf "   Basic layout:\n"
   176|  printf "   myproject/\n"
   177|  printf "   ├── src/myproject/     # your code\n"
   178|  printf "   │   ├── __init__.py\n"
   179|  printf "   │   ├── models.py      # database logic\n"
   180|  printf "   │   └── routes.py      # API endpoints\n"
   181|  printf "   ├── tests/\n"
   182|  printf "   ├── pyproject.toml     # config + deps\n"
   183|  printf "   └── .env               # secrets (never commit!)\n"
   184|  printf "   Quick start: pip install cookiecutter\n"
   185|  printf "   cookiecutter gh:cjolowicz/cookiecutter-hypermodern-python\n"
   186|}
   187|# Run on-demand: call _fix_project_structure
   188|
   189|
   190|# ============================================================
   191|# Pain: When is Python going to make sense? Been learning for a month
   192|# Delivery: terminal-hint:one-click-button | Trigger: on-first-open
   193|# Category: Docs
   194|# ============================================================
   195|# Learning wall fix
   196|_fix_learning_wall() {
   197|  printf "\n💡 The 1-month learning wall is UNIVERSAL. Here's how to break through:\n"
   198|  printf "   1. STOP doing tutorials. START building tiny projects\n"
   199|  printf "   2. This week: build a tip calculator (input → math → print)\n"
   200|  printf "   3. Next week: build a quiz game (lists, loops, conditionals)\n"
   201|  printf "   4. Week after: build a CLI to-do list (file I/O, functions)\n"
   202|  printf "   5. Use r/learnpython — post your code, ask for feedback\n"
   203|  printf "   Every expert was once a confused beginner. You're on track.\n"
   204|}
   205|# Run on-demand: call _fix_learning_wall
   206|
   207|
   208|# ============================================================
   209|# Pain: Why can't I use return in __init__?
   210|# Delivery: terminal-hint:auto-paste-hint | Trigger: on-error
   211|# Category: API
   212|# ============================================================
   213|# __init__ return fix
   214|_fix_init_return() {
   215|  if [[ "$1" == *"TypeError"* ]] && [[ "$1" == *"__init__"* ]]; then
   216|    printf "\n💡 __init__ can't return a value!\n"
   217|    printf "   __init__ initializes the object (sets self.attrs)\n"
   218|    printf "   It ALWAYS returns None — Python enforces this\n"
   219|    printf "   Instead use:\n"
   220|    printf "   • __str__() — for human-readable string: return f'...'\n"
   221|    printf "   • __repr__() — for developer representation\n"
   222|    printf "   • @property — for computed attributes\n"
   223|  fi
   224|}
   225|preexec_functions+=(_fix_init_return)
   226|
   227|# ============================================================
   228|# Pain: 'zsh: killed' — merging CSV files on Mac M5 works then dies
   229|# Delivery: terminal-hint:auto-paste-hint | Trigger: on-error
   230|# Category: Environment
   231|# ============================================================
   232|# OOM kill fix
   233|_fix_oom_kill() {
   234|  if [[ "$1" == *"killed"* ]]; then
   235|    printf "\n💡 Process killed = OUT OF MEMORY! Fixes:\n"
   236|    printf "   # Read CSV in chunks (works with any file size):\n"
   237|    printf "   import pandas as pd\n"
   238|    printf "   chunks = []\n"
   239|    printf "   for chunk in pd.read_csv('big.csv', chunksize=10000):\n"
   240|    printf "       chunks.append(chunk)\n"
   241|    printf "   df = pd.concat(chunks)\n"
   242|    printf "   # Or use Dask for very large data:\n"
   243|    printf "   pip install dask\n"
   244|    printf "   import dask.dataframe as dd\n"
   245|    printf "   df = dd.read_csv('*.csv')  # lazy, memory-efficient\n"
   246|  fi
   247|}
   248|preexec_functions+=(_fix_oom_kill)
   249|
   250|# ============================================================
   251|# Pain: Virtual environments + Jupyter: notebook doesn't use my venv
   252|# Delivery: terminal-hint:auto-paste-hint | Trigger: on-error
   253|# Category: Environment
   254|# ============================================================
   255|# Jupyter + venv fix
   256|_fix_venv_jupyter() {
   257|  if [[ "$1" == *"not writeable"* ]] || [[ "$1" == *"defaulting"* ]]; then
   258|    printf "\n💡 Jupyter not using your venv? Fix:\n"
   259|    printf "   # Inside your venv:\n"
   260|    printf "   pip install ipykernel\n"
   261|    printf "   python -m ipykernel install --user --name=myenv\n"
   262|    printf "   # Then in Jupyter: Kernel → Change Kernel → myenv\n"
   263|    printf "   # Verify: import sys; print(sys.executable)\n"
   264|  fi
   265|}
   266|preexec_functions+=(_fix_venv_jupyter)
   267|
   268|# ============================================================
   269|# Pain: Module not found — pip installed but wrong Python version?
   270|# Delivery: terminal-hint:auto-paste-hint | Trigger: on-error
   271|# Category: Environment
   272|# ============================================================
   273|# Module not found auto-fix
   274|_fix_module_not_found() {
   275|  if [[ "$1" == *"ModuleNotFoundError"* ]]; then
   276|    local mod=$(echo "$1" | grep -oP "(?<=No module named ')[^']+")
   277|    printf "\n💡 Module '%s' not found! Debug checklist:\n" "$mod"
   278|    printf "   1. which python  # right Python/venv?\n"
   279|    printf "   2. pip list | grep %s  # is it installed?\n" "$mod"
   280|    printf "   3. python -c 'import sys; print(sys.path)'  # right paths?\n"
   281|    printf "   4. pip install %s  # install if missing\n" "$mod"
   282|    if [[ -n "$VIRTUAL_ENV" ]]; then
   283|      printf "   ✅ venv active: %s\n" "$VIRTUAL_ENV"
   284|    else
   285|      printf "   ⚠️  No venv active. Consider: python -m venv venv && source venv/bin/activate\n"
   286|    fi
   287|  fi
   288|}
   289|preexec_functions+=(_fix_module_not_found)
   290|
   291|# ============================================================
   292|# Pain: Good-looking tooltips on macOS with Tkinter?
   293|# Delivery: vscode-popup | Trigger: on-status-bar-click
   294|# Category: Tooling
   295|# ============================================================
   296|# Tkinter macOS fix
   297|_fix_tkinter_mac() {
   298|  printf "\n💡 macOS tkinter tooltips looking bad? Options:\n"
   299|  printf "   1. pip install ttkbootstrap  # modern themed tkinter\n"
   300|  printf "   2. pip install PySide6  # native macOS look, better tooltips\n"
   301|  printf "   3. Use ttk instead of tk for widgets (ttk.Label, not tk.Label)\n"
   302|  printf "   Note: Tkinter on macOS is notoriously rough. PySide6 = Qt native.\n"
   303|}
   304|# Run on-demand: call _fix_tkinter_mac
   305|
   306|