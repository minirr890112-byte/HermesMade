#!/bin/sh
# HermesMade v0.3.2 | sha256: 94ad2a9a15dca2c9aa7943a06afc1e338a37979ab05d331b8e34859baf38bf39
# Auto-generated terminal hints for Python pain points
# Source in .bashrc/.zshrc: [ -f ~/.hermes/hints.sh ] && . ~/.hermes/hints.sh
[ -n "$HERMES_SKIP_HINT" ] && return 0
HERMES_RUN_ID="hermes-run-20260619-python-pain"
HERMES_LAST_CHECK="$HOME/.hermes/.last_hint_check"
HERMES_COOLDOWN=86400
_now=$(date +%s)
if [ -f "$HERMES_LAST_CHECK" ]; then
    _last=$(cat "$HERMES_LAST_CHECK" 2>/dev/null)
    [ -n "$_last" ] && [ $((_now - _last)) -lt $HERMES_COOLDOWN ] && return 0
fi
echo "$_now" > "$HERMES_LAST_CHECK"

_shown=0
_show() {
    [ $_shown -ge 3 ] && return 0
    _shown=$((_shown + 1))
    printf '\033[33m💡 %s\033[0m\n' "$1"
}

# Hint 1: pip install -r fails with 'illegal option -- r'
if ls *.txt 2>/dev/null | grep -q requirements.txt && command -v pip >/dev/null; then
    _show "pip3 install -r requirements.txt  # or: python3 -m pip install -r requirements.txt"
fi

# Hint 2: ModuleNotFoundError after pip install
if pip list 2>/dev/null | grep -q pygame && ! python3 -c "import pygame" 2>/dev/null; then
    _show "python3 -m pip install --user pygame  # Use --user to avoid system-install conflicts"
fi

# Hint 3: matplotlib backend broken after system update
if python3 -c "import matplotlib; print(matplotlib.get_backend())" 2>&1 | grep -q "not a valid value"; then
    _show "mkdir -p ~/.matplotlib && echo 'backend: TkAgg' >> ~/.matplotlib/matplotlibrc  # Fix broken backend"
fi

# Hint 4: venv packages not detected by IDE after OS upgrade
if [ -d venv ] || [ -d .venv ]; then
    _show "source venv/bin/activate 2>/dev/null || source .venv/bin/activate 2>/dev/null  # Activate venv before IDE"
fi

# Hint 5: uv broke conda shell integration and aliases
if command -v conda >/dev/null 2>&1 && command -v uv >/dev/null 2>&1; then
    _show "conda init --reverse zsh && conda init zsh  # Reset conda after uv interference"
fi

# End of HermesMade hints