#!/bin/bash
# =============================================================================
# Hermes Terminal Hints — r/learnpython Pain Points
# Generated: 2026-06-10
# Source: Reddit r/learnpython scan via Pullpush API
# 
# PASTE these into your ~/.zshrc or ~/.bashrc to get automatic
# terminal hints when you hit common Python errors.
# =============================================================================

# ===== HINT 1: pip vs pip3 confusion (macOS) =====
# Pain: "install: illegal option -- r" when running `pip install -r requirements.txt`
# Impact: 10/10 | Category: Environment | Engagement: 28 comments
# Reddit: https://reddit.com/r/learnpython/comments/1kphir9/
_fix_pip_install_r() {
  if [[ "$1" == *"install: illegal option -- r"* ]]; then
    printf "\n💡 'pip' on macOS might be the Apple system tool!\n"
    printf "   Use: pip3 install -r requirements.txt\n"
    printf "   Or:   python3 -m pip install -r requirements.txt\n"
    echo "pip3 install -r requirements.txt" | pbcopy 2>/dev/null || true
  fi
}
preexec_functions+=(_fix_pip_install_r)

# ===== HINT 2: conda broken after installing uv =====
# Pain: "conda: command not found" after `uv` tool installation
# Impact: 9.4/10 | Category: Environment | Engagement: 13 comments
# Reddit: https://reddit.com/r/learnpython/comments/1kpxtpb/
_fix_conda_after_uv() {
  if [[ "$1" == *"conda: command not found"* ]]; then
    printf "\n💡 Conda missing? uv may have overridden your shell config.\n"
    printf "   Fix: conda init zsh && source ~/.zshrc\n"
    echo "conda init zsh && source ~/.zshrc" | pbcopy 2>/dev/null || true
  fi
}
preexec_functions+=(_fix_conda_after_uv)

# ===== HINT 3: pygame ModuleNotFoundError (IDLE vs terminal Python) =====
# Pain: pygame works in terminal but not in IDLE
# Impact: 6.2/10 | Category: Environment | Engagement: 5 comments
# Reddit: https://reddit.com/r/learnpython/comments/1kprxpg/
_fix_pygame_missing() {
  if [[ "$1" == *"ModuleNotFoundError: No module named 'pygame'"* ]]; then
    printf "\n💡 Pygame installed but IDLE can't find it?\n"
    printf "   IDLE might use a different Python than your terminal.\n"
    printf "   In IDLE, run: import sys; print(sys.executable)\n"
    printf "   Then: <that-path> -m pip install pygame\n"
    echo "python -m pip install pygame" | pbcopy 2>/dev/null || true
  fi
}
preexec_functions+=(_fix_pygame_missing)

# ===== HINT 4: Matplotlib backend broken after system update =====
# Pain: "ValueError: Key backend not valid" after OS update
# Impact: 5.4/10 | Category: Environment | Engagement: 3 comments
# Reddit: https://reddit.com/r/learnpython/comments/1kq9uch/
_fix_matplotlib_backend() {
  if [[ "$1" == *"not a valid value for backend"* ]]; then
    printf "\n💡 Matplotlib backend broken after system update?\n"
    printf "   Fix: pip install --upgrade matplotlib ipympl\n"
    printf "   Then restart your Jupyter kernel.\n"
    echo "pip install --upgrade matplotlib ipympl" | pbcopy 2>/dev/null || true
  fi
}
preexec_functions+=(_fix_matplotlib_backend)

# ===== HINT 5: Airflow port 8080 conflict =====
# Pain: "Errno 98: Address already in use" with airflow api-server
# Impact: 4.0/10 | Category: Tooling | Engagement: 1 comment
# Reddit: https://reddit.com/r/learnpython/comments/1kq7bc6/
_fix_airflow_port() {
  if [[ "$1" == *"Address already in use"* ]]; then
    printf "\n💡 Airflow port 8080 already in use!\n"
    printf "   Kill it: lsof -ti:8080 | xargs kill -9\n"
    printf "   Then: airflow api-server\n"
    echo "lsof -ti:8080 | xargs kill -9 && airflow api-server" | pbcopy 2>/dev/null || true
  fi
}
preexec_functions+=(_fix_airflow_port)

# =============================================================================
# Category Breakdown: Environment(5) Tooling(3) Docs(2) API(1) UX(1)
# Total pain posts found: 20 | Top pain posts classified: 12
# Data via Pullpush, ~1-7 days behind real-time Reddit
# =============================================================================
