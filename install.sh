#!/bin/bash
# HermesMade — install all tools or individual ones
# Usage:
#   bash install.sh              # install all 3 tools
#   bash install.sh prompt       # install only prompt-inspector
#   bash install.sh model        # install only model-watch
#   bash install.sh api          # install only api-cost

set -e
HERMESMADE="$(cd "$(dirname "$0")" && pwd)"

install_one() {
    local dir="$1"
    local name="$2"
    echo "📦 Installing $name..."
    pip install --break-system-packages "$HERMESMADE/$dir" 2>/dev/null || \
    pip install "$HERMESMADE/$dir" 2>/dev/null || {
        echo "⚠ pip install failed, using symlink fallback..."
        ln -sf "$HERMESMADE/$dir/${name//-/_}/cli.py" "/usr/local/bin/$name" 2>/dev/null || {
            mkdir -p ~/bin
            ln -sf "$HERMESMADE/$dir/${name//-/_}/cli.py" "$HOME/bin/$name"
            echo "   Linked to ~/bin/$name (make sure ~/bin is in PATH)"
        }
    }
    echo "   ✅ $name installed"
}

case "${1:-all}" in
    prompt)
        install_one "prompt-inspector" "prompt-inspector"
        ;;
    model)
        install_one "model-watch" "model-watch"
        ;;
    api)
        install_one "api-cost-compare" "api-cost"
        ;;
    task)
        install_one "task-cost-estimator" "task-cost"
        ;;
    all|*)
        install_one "prompt-inspector" "prompt-inspector"
        install_one "model-watch" "model-watch"
        install_one "api-cost-compare" "api-cost"
        install_one "llm-deploy-helper" "llm-deploy"
        install_one "code-inspector" "code-inspector"
        install_one "task-cost-estimator" "task-cost"
        ;;
esac

echo ""
echo "Done! Available commands:"
echo "  prompt-inspector 'your prompt'"
echo "  model-watch demo"
echo "  api-cost recommend coding"
