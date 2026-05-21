#!/usr/bin/env bash
# ================================================================
# HermesMade — Auto-generated Terminal Hints for r/learnpython Pains
# Generated: 2026-05-22
# Source: r/learnpython pain scan via Pullpush API
# ================================================================

# ---- Shell Detection ----
if [ -n "$ZSH_VERSION" ]; then
  SHELL_TYPE="zsh"
elif [ -n "$BASH_VERSION" ]; then
  SHELL_TYPE="bash"
fi

# ---- Helper: Auto-detect clipboard command ----
_hermes_clipboard() {
  if command -v pbcopy &>/dev/null; then
    echo "$1" | pbcopy  # macOS
  elif command -v xclip &>/dev/null; then
    echo "$1" | xclip -selection clipboard  # Linux X11
  elif command -v wl-copy &>/dev/null; then
    echo "$1" | wl-copy  # Linux Wayland
  elif command -v clip.exe &>/dev/null; then
    echo "$1" | clip.exe  # Windows WSL
  fi
}

# ---- Hint: FizzBuzz Loop Fix ----
_hint_fizzbuzz() {
  if [[ "$1" == *"Fizz"* ]] || [[ "$1" == *"Buzz"* ]]; then
    printf "\n💡 FizzBuzz tip: Use a SINGLE loop, not nested loops!\n"
    printf "   for i in range(1, 101):\n"
    printf "       if i %% 15 == 0: print('FizzBuzz')\n"
    printf "       elif i %% 3 == 0: print('Fizz')\n"
    printf "       elif i %% 5 == 0: print('Buzz')\n"
    printf "       else: print(i)\n"
    _hermes_clipboard "for i in range(1, 101):\n    if i % 15 == 0: print('FizzBuzz')\n    elif i % 3 == 0: print('Fizz')\n    elif i % 5 == 0: print('Buzz')\n    else: print(i)"
    printf "\n   📋 Copied to clipboard — paste into your .py file!\n"
  fi
}

# ---- Hint: XML Chunking (Don't Byte-Split) ----
_hint_xml_chunk() {
  if [[ "$1" == *"ParseError"* ]] || [[ "$1" == *"xml"* && "$1" == *"error"* ]]; then
    printf "\n💡 XML chunking tip: Don't split by bytes! Use iterparse() for streaming:\n"
    printf "   import xml.etree.ElementTree as ET\n"
    printf "   for event, elem in ET.iterparse('large.xml', events=('end',)):\n"
    printf "       # process elem, then elem.clear() to free memory\n"
    _hermes_clipboard "import xml.etree.ElementTree as ET\nfor event, elem in ET.iterparse('input.xml', events=('end',)):\n    if elem.tag == 'your_target':\n        # process element\n        pass\n    elem.clear()"
    printf "\n   📋 XML streaming snippet copied — paste & adapt!\n"
  fi
}

# ---- Hint: Clipboard in Python ----
_hint_clipboard() {
  if [[ "$1" == *"clipboard"* ]] || [[ "$1" == *"pyperclip"* ]]; then
    printf "\n💡 Instead of simulating Ctrl+C, use pyperclip!\n"
    printf "   pip install pyperclip\n"
    printf "   Then: import pyperclip; text = pyperclip.paste()\n"
    _hermes_clipboard "pip install pyperclip && python -c 'import pyperclip; print(pyperclip.paste())'"
    printf "\n   📋 Command copied — run to test!\n"
  fi
}

# ---- Hint: Python Uninstall ----
_hint_python_uninstall() {
  if [[ "$1" == *"uninstall"* ]] && [[ "$1" == *"python"* ]]; then
    printf "\n💡 Python uninstall guide:\n"
    printf "   macOS: Check /Applications, /Library/Frameworks, and /usr/local/bin\n"
    printf "   Linux: sudo apt remove python3 / sudo dnf remove python3\n"
    printf "   Windows: Settings > Apps > Python > Uninstall\n"
    printf "   Or use pyenv to manage versions cleanly: curl https://pyenv.run | bash\n"
  fi
}

# ---- Hint: Try/Except Order ----
_hint_try_except() {
  if [[ "$1" == *"FileNotFoundError"* ]] || [[ "$1" == *"SyntaxError"* && "$1" == *"except"* ]]; then
    printf "\n💡 Python try/except tip: except must come AFTER try, not before!\n"
    printf "   try:\n"
    printf "       with open(file) as f: ...\n"
    printf "   except FileNotFoundError:\n"
    printf "       print(f'File not found')\n"
  fi
}

# ---- Hint: Learning Backend (Video Resources) ----
_hint_backend_learn() {
  if [[ "$1" == *"flask"* ]] || [[ "$1" == *"django"* ]]; then
    printf "\n💡 Learn Python backend with videos:\n"
    printf "   🎥 Corey Schafer Django/Flask series (YouTube)\n"
    printf "   🎥 freeCodeCamp Python Backend (4hr)\n"
    printf "   🎥 CS50 Web with Python (Harvard)\n"
    printf "   📋 All linked at: https://github.com/topics/python-backend\n"
  fi
}

# ================================================================
# Register hooks based on shell type
# ================================================================
if [ "$SHELL_TYPE" = "zsh" ]; then
  # Zsh: hook into preexec to inspect stderr of last command
  _hermes_pain_check() {
    local last_output="$1"
    _hint_fizzbuzz "$last_output"
    _hint_xml_chunk "$last_output"
    _hint_clipboard "$last_output"
    _hint_python_uninstall "$last_output"
    _hint_try_except "$last_output"
    _hint_backend_learn "$last_output"
  }
  # Add to preexec functions (safe re-add check)
  if ! printf "%s\n" "${preexec_functions[@]}" | grep -q "_hermes_pain_check"; then
    preexec_functions+=(_hermes_pain_check)
  fi
elif [ "$SHELL_TYPE" = "bash" ]; then
  # Bash: use DEBUG trap (fires before each command)
  trap '_hermes_pain_check "$_"' DEBUG
fi

echo "✅ HermesMade pain-point hints installed! Your terminal now watches for common Python pitfalls."
echo "   Hints active: FizzBuzz loops, XML chunking, clipboard speed, Python uninstall, try/except order, backend learning"