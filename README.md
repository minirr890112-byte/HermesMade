# 🔥 HermesMade — From Reddit Pain to One-Command Fix

<p align="center">
  <img src="https://img.shields.io/badge/python-3.8+-blue" alt="Python">
  <img src="https://img.shields.io/badge/license-MIT-green" alt="License">
  <img src="https://img.shields.io/badge/tools-3%20%7C%20planned-5-orange" alt="Tools">
  <img src="https://img.shields.io/badge/data-343%20pain%20signals-red" alt="Data">
</p>

**Every tool in this repo solves a real problem real people are screaming about on Reddit — right now.**

> 数据驱动：扫描 6 个科技/AI subreddit → 343 条疼痛信号 → 8 个痛点 → 构建工具
>
> 📊 [飞书多维表格：完整痛点清单](https://cww5wjw5vx4.feishu.cn/base/FcHpbXLeLa4OEPsy0TFceLzfn2z)

---

## ⚡ Quick Install

```bash
git clone https://github.com/minirr890112-byte/HermesMade.git
cd HermesMade && bash install.sh
```

3 个工具立即可用：`prompt-inspector` | `model-watch` | `api-cost`

---

## 🛠 Tools

### 1. prompt-inspector — AI 审查风险分析

**痛点**：ChatGPT/Claude 的审查过滤器越来越激进，连园艺问题都被拒绝。

> *"I literally couldn't get an answer to a gardening question due to supposed 'violence'... Your filter thought my gardening pitchfork was a sign of satanism."* — r/ChatGPT (26↑)

```bash
$ prompt-inspector "write a story about a dictator who uses propaganda"

🟢 低风险 — 有可能通过，但建议改写
检测到 4 个触发词 (dictator, regime, propaganda, assassinate)

📝 推荐改写前缀：
  "For academic research and educational purposes..."

🔓 终极方案：本地无审查模型预设 (gemma/deepseek/llama)
```

| 功能 | 说明 |
|------|------|
| 6 类触发词扫描 | 暴力/自伤/成人/政治/宗教/毒品 |
| 改写建议 | 学术前缀、假设框架、技术化改写 |
| 无审查预设 | gemma/deepseek/llama system prompt 一键复制 |

---

### 2. model-watch — AI 模型质量监控

**痛点**：API 模型偷偷变笨，Anthropic 官方承认降级，用户却无从验证。

> *"Opus 4.7 was hallucinating a lot today... shocking to see such degradation"* — r/ClaudeAI (49↑)
> *"Anthropic admits to have made hosted models more stupid"* — r/LocalLLaMA (281↑)

```bash
$ model-watch history

时间                         总分       状态
2026-04-20 09:00:15     72.8%       ——
2026-04-21 09:00:22     21.0%    🔴 降级!
2026-04-22 09:00:31     66.4%    🟢 提升

$ model-watch alert
🔴 严重降级: 近3次平均 29.1%，比历史 72.8% 低 43.7%
🔴 绝对分数过低: 29.1%
```

| 功能 | 说明 |
|------|------|
| 7 道标准题 | 推理/代码/写作/指令遵循/幻觉检测 |
| 历史趋势 | 自动保存每次测试，可视化变化 |
| 降级告警 | 分数跌破阈值自动标记 |

---

### 3. api-cost — AI API 成本对比

**痛点**：API 定价混乱不透明，Claude 太贵，DeepSeek 被质疑 overpriced。

> *"Claude is definitely expensive."* — r/ChatGPT
> *"DeepSeek V4 Flash is actually overpriced at $0.14/$0.28"* — r/LocalLLaMA (50↑)

```bash
$ api-cost recommend coding

⭐ #1   Mistral Mistral Small 3        $1.65/月
⭐ #2   DeepSeek DeepSeek V4 Flash     $1.89/月
⭐ #3   OpenAI GPT-4o-mini             $2.92/月

💸 选择 #1 比 Anthropic Claude Opus 4.7
   月省 $335.85，年省 $4030
```

| 功能 | 说明 |
|------|------|
| 18 个模型定价 | OpenAI/Anthropic/Google/DeepSeek/xAI/Mistral |
| 4 种场景 | coding / chat / writing / reasoning |
| 花费追踪 | `api-cost track 2.50` 记录开销，按月汇总 |

---

## 🤔 Why This Exists

大多数开源工具来自开发者的「我觉得这个很酷」。

**HermesMade 反过来** — 先去 Reddit 听用户在骂什么，再动手。

| | 传统开源 | HermesMade |
|---|---|---|
| 选题 | 开发者直觉 | Reddit 真实痛点数据 |
| 验证 | 上线后才知道有没有人用 | 建之前就知道真有人在痛 |
| 文档 | "read the code" | 每个工具带用户原声引用 |
| 推广 | 发个帖子碰运气 | 回痛点原帖精准触达 |

---

## 🗺 Roadmap

| # | 痛点 | 频次 | 状态 |
|---|------|------|------|
| 1 | AI 审查过滤过度 | ★★★★★ | ✅ 已交付 |
| 2 | AI 模型偷偷变笨 | ★★★★★ | ✅ 已交付 |
| 3 | API 定价不透明 | ★★★★☆ | ✅ 已交付 |
| 4 | GitHub Actions 不可靠 | ★★★★☆ | ⬜ 待选择 |
| 5 | AI 代码质量不可控 | ★★★★☆ | ⬜ 待选择 |
| 6 | 本地 LLM 部署门槛高 | ★★★★☆ | ⬜ 待选择 |
| 7 | 供应链安全恐慌 | ★★★☆☆ | ⬜ 待选择 |
| 8 | Deepfake 焦虑 | ★★★☆☆ | ⬜ 待选择 |

---

## ⭐ Star History

如果这些工具帮到了你，给个 Star ⭐ 让更多人看到。

Star 数每涨 50，解锁下一个痛点工具。

---

## 📁 Structure

```
HermesMade/
├── prompt-inspector/     # 痛点 1
├── model-watch/          # 痛点 2
├── api-cost-compare/     # 痛点 3
├── install.sh            # 一键安装
├── LICENSE               # MIT
└── README.md
```
