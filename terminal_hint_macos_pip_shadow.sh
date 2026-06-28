#!/usr/bin/env bash
# ============================================================================
# HermesMade Terminal Hint — r/learnpython Pain Fix
# Generated: 2026-06-28 23:13 UTC
# Source: https://reddit.com/r/learnpython/comments/1kphir9/need_help_with_installing_requirementstxt/
# ============================================================================
#
# PROBLEM: macOS users running "pip install -r requirements.txt" get:
#   install: illegal option -- r
#
# ROOT CAUSE: macOS ships /usr/bin/install (a file-copying tool) which
# shadows pip's "install" subcommand when pip resolves incorrectly.
# The shell runs the SYSTEM install, not pip.
#
# FIX: Use python3 -m pip (always resolves correct pip) or add an alias.
#
# QUICK FIX (run this for immediate relief):
#   python3 -m pip install -r requirements.txt
#
# PERMANENT FIX (add alias to shell config):
# ============================================================================

set -euo pipefail

readonly REQUIREMENTS_FILE="${1:-requirements.txt}"
readonly SHELL_RC="${HOME}/.bash_profile"  # macOS default; adjust for zsh

echo "🔧 HermesMade: Fixing macOS pip shadowing issue"
echo ""

# ---- Step 1: Detect macOS ----
if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "⚠️  This fix targets macOS. Your OS: $(uname -s)"
    echo "   Try: python3 -m pip install -r ${REQUIREMENTS_FILE}"
    exit 0
fi

echo "✅ Detected macOS"

# ---- Step 2: Verify python3 exists ----
if ! command -v python3 &>/dev/null; then
    echo "❌ python3 not found. Install it with: brew install python3"
    echo "   Or: xcode-select --install"
    exit 1
fi
echo "✅ Found: $(python3 --version)"

# ---- Step 3: Check which 'pip' resolves ----
RESOLVED_PIP=$(command -v pip 2>/dev/null || echo "NOT_FOUND")
echo "📍 'pip' resolves to: ${RESOLVED_PIP}"

if [[ "${RESOLVED_PIP}" == *"/usr/bin/pip"* ]] || command -v pip &>/dev/null && pip --version 2>/dev/null | grep -q python; then
    echo "✅ pip is correctly pointing to Python pip"
    echo "   Running: pip install -r ${REQUIREMENTS_FILE}"
    pip install -r "${REQUIREMENTS_FILE}"
else
    echo "⚠️  'pip' may be shadowed. Using python3 -m pip instead."
    echo "   Running: python3 -m pip install -r ${REQUIREMENTS_FILE}"
    python3 -m pip install -r "${REQUIREMENTS_FILE}"
fi

# ---- Step 4: Offer permanent alias fix ----
echo ""
echo "💡 To prevent this permanently, add this alias to your shell config:"
echo ""
echo "   echo 'alias pip="python3 -m pip"' >> ${SHELL_RC}"
echo "   source ${SHELL_RC}"
echo ""

read -p "Add alias to ${SHELL_RC}? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Check if alias already exists
    if grep -q 'alias pip=' "${SHELL_RC}" 2>/dev/null; then
        echo "⚠️  Alias already exists in ${SHELL_RC}"
    else
        echo "alias pip='python3 -m pip'" >> "${SHELL_RC}"
        echo "✅ Added alias to ${SHELL_RC}"
        echo "   Run: source ${SHELL_RC}  (or restart terminal)"
    fi
fi

echo ""
echo "🎉 Done! Your requirements should be installed."
echo "   Verify: python3 -m pip list | head"
