#!/bin/sh
# hermes-hint-macos-python-install.sh — Install Python correctly on macOS
# (no more "command not found" or "externally-managed-environment" pain)
# Usage:  ./hermes-hint-macos-python-install.sh
# Safe for beginners • POSIX-compliant • Read-only diagnostic (prints commands, installs nothing) • No sudo
set -u

OS="$(uname -s)"
if [ "$OS" != "Darwin" ]; then
    echo "This hint targets macOS. Detected OS: $OS"
    echo "For other platforms, try hermes-hint-python-setup.sh"
    exit 0
fi

echo "==> macOS Python Install — the right way"
echo ""

# ---- 1. Current state ----
echo "── What you have now ──"
if command -v python3 >/dev/null 2>&1; then
    P3="$(command -v python3)"
    echo "  python3  ->  $P3"
    case "$P3" in
        /usr/bin/python3)
            echo "     !  This is Apple's Command-Line-Tools stub, NOT a real interpreter."
            echo "        It pops the 'install developer tools' dialog and gives an old Python 3.9."
            ;;
        /Library/Frameworks/Python.framework/*|/opt/homebrew/*|/usr/local/*|$HOME/.local/*|*uv*|*pyenv*)
            echo "     ~  Looks like a real Python install."
            ;;
    esac
else
    echo "  python3  ->  (not found)"
fi
echo ""

# ---- 2. Diagnose the classic pitfalls ----
echo "── Why beginners get stuck ──"
echo "  * macOS no longer ships Python (removed in macOS 12.3 Monterey)."
echo "  * /usr/bin/python3 is a stub that installs CLT Python 3.9 — old and awkward."
echo "  * Homebrew Python is 'externally managed' — plain 'pip install' fails with:"
echo "        error: externally-managed-environment"
echo ""

# ---- 3. Recommended fix (print commands, do not auto-run) ----
echo "── The fix: pick ONE of these ──"
echo ""
echo "  [A] Fastest (uv, recommended in 2026):"
echo "        curl -LsSf https://astral.sh/uv/install.sh | sh"
echo "        uv python install 3.12"
echo ""
echo "  [B] Classic GUI installer (best for absolute beginners):"
echo "        1. Visit https://www.python.org/downloads/"
echo "        2. Download the macOS 64-bit installer (.pkg) and run it"
echo "        3. Re-open your terminal, then run: python3 --version"
echo ""
echo "  [C] Power-user version manager (pyenv):"
echo "        brew install pyenv && pyenv install 3.12 && pyenv global 3.12"
echo ""
echo "  x  Avoid: /usr/bin/python3 (CLT stub), and Homebrew Python for pip installs."
echo "     Use a venv instead: python3 -m venv .venv && source .venv/bin/activate"
echo ""

# ---- 4. Verify ----
echo "── After installing, verify ──"
echo "  python3 --version         # expect Python 3.12.x (or newer)"
echo "  command -v python3        # should NOT be /usr/bin/python3"
echo "  python3 -m pip --version  # pip should work here"
echo ""
echo "Done. Start every project in a venv: python3 -m venv .venv && source .venv/bin/activate"
