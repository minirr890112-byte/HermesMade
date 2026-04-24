#!/bin/bash
# HermesMade — 一键安装所有工具
# 将三个 CLI 工具注册到 PATH

HERMESMADE="$HOME/HermesMade"

echo "🔧 安装 HermesMade 工具..."

# Prompt Inspector
cat > /usr/local/bin/prompt-inspector << 'SCRIPT'
#!/bin/bash
exec python3 "$HOME/HermesMade/prompt-inspector/prompt-inspector.py" "$@"
SCRIPT
chmod +x /usr/local/bin/prompt-inspector 2>/dev/null || {
    mkdir -p ~/bin
    cp /usr/local/bin/prompt-inspector ~/bin/prompt-inspector 2>/dev/null || true
}

# Model Watch
cat > /usr/local/bin/model-watch << 'SCRIPT'
#!/bin/bash
exec python3 "$HOME/HermesMade/model-watch/model-watch.py" "$@"
SCRIPT
chmod +x /usr/local/bin/model-watch 2>/dev/null || true

# API Cost Compare
cat > /usr/local/bin/api-cost << 'SCRIPT'
#!/bin/bash
exec python3 "$HOME/HermesMade/api-cost-compare/api-cost-compare.py" "$@"
SCRIPT
chmod +x /usr/local/bin/api-cost 2>/dev/null || true

echo "✅ 完成！"
echo ""
echo "可用命令:"
echo "  prompt-inspector '你的提示词'    # 审查风险分析"
echo "  model-watch demo                 # 查看基准测试题目"
echo "  api-cost recommend coding        # 按场景推荐模型"
echo "  api-cost list                    # 列出所有定价"
