# HermesMade

从 Reddit 真实用户痛点出发，构建的实用 CLI 工具集合。

> 数据来源: 6 个科技/AI subreddit | 343 条疼痛信号 | 2026.04

---

## 📊 飞书多维表格

完整 8 个痛点分析 + 方案: [飞书查看](https://cww5wjw5vx4.feishu.cn/base/FcHpbXLeLa4OEPsy0TFceLzfn2z)

---

## 🛠 已构建工具（痛点 1-3，已选择）

### 1. Prompt Inspector
AI 审查风险分析 & 提示词改写工具

```bash
prompt-inspector "你的提示词"
echo "提示词" | prompt-inspector
```

- 扫描触发词（暴力/自伤/成人/政治/宗教等 6 大类）
- 提供中性改写建议
- 输出无审查本地模型预设（gemma/deepseek/llama）

**Reddit 原声**:
> "I literally couldn't get an answer to a gardening question due to supposed 'violence'... Your filter thought my gardening pitchfork was a sign of satanism." (score:26, r/ChatGPT)

---

### 2. Model Watch
AI 模型质量监控 & 基准测试

```bash
model-watch demo           # 查看基准测试题目
model-watch history        # 查看历史趋势
model-watch alert          # 检查是否需要告警
```

- 7 道标准化测试题（推理/代码/写作/幻觉检测）
- 追踪质量变化趋势
- 自动检测模型降级

**Reddit 原声**:
> "Opus 4.7 was hallucinating a lot today... I never noticed it with 4.5 and 4.6 — shocking to see such degradation." (score:49, r/ClaudeAI)
> "Anthropic admits to have made hosted models more stupid." (score:281, r/LocalLLaMA)

---

### 3. API Cost Compare
AI API 成本对比 & 优化

```bash
api-cost list                    # 列出 18 个主流模型定价
api-cost recommend coding        # 按场景推荐最优
api-cost track 2.50              # 记录花费
api-cost report                  # 花费报告
```

- 覆盖 OpenAI/Anthropic/Google/DeepSeek/xAI/Mistral
- 4 种使用场景（coding/chat/writing/reasoning）
- 月度/年度节省金额对比

**Reddit 原声**:
> "Claude is definitely expensive." | "DeepSeek V4 Flash is actually overpriced." (score:50)
> "This is really annoying for a paid product. Unpredictable, unreliable, unprofessional." (score:52)

---

## 🚀 安装

```bash
cd ~/HermesMade && bash install.sh
```

---

## 📋 待选择痛点（4-8）

| # | 痛点 | 频次 | 方案 |
|---|------|------|------|
| 4 | GitHub Actions 不可靠 | ★★★★☆ | CI 健康检查工具 |
| 5 | AI 代码质量不可控 | ★★★★☆ | 代码质量审查 CLI |
| 6 | 本地 LLM 部署门槛高 | ★★★★☆ | 一键部署脚本 |
| 7 | 供应链安全 | ★★★☆☆ | 依赖安全检查器 |
| 8 | Deepfake 焦虑 | ★★★☆☆ | 内容可信度检测器 |

---

## 📁 结构

```
HermesMade/
├── prompt-inspector/     # 痛点 1 - 审查绕过
│   └── prompt-inspector.py
├── model-watch/          # 痛点 2 - 模型监控
│   └── model-watch.py
├── api-cost-compare/     # 痛点 3 - 成本对比
│   └── api-cost-compare.py
├── install.sh            # 一键安装
└── README.md
```
