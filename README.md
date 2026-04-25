# 🔥 HermesMade — From Reddit Pain to One-Command Fix

<p align="center">
  <img src="https://img.shields.io/badge/python-3.8+-blue" alt="Python">
  <img src="https://img.shields.io/badge/license-MIT-green" alt="License">
  <img src="https://img.shields.io/badge/tools-6-orange" alt="Tools">
  <img src="https://img.shields.io/github/stars/minirr890112-byte/HermesMade" alt="Stars">
  <img src="https://img.shields.io/badge/data-343%20pain%20signals-red" alt="Data">
</p>

**Every tool in this repo solves a real problem real people are screaming about on Reddit — right now.**

> Data-driven: scanned 6 AI/tech subreddits → 343 pain signals → 8 pain points → built tools
>
> 📊 [Feishu Bitable: full pain-point inventory](https://cww5wjw5vx4.feishu.cn/base/FcHpbXLeLa4OEPsy0TFceLzfn2z)

---

## ⚡ Install

### All tools at once

```bash
git clone https://github.com/minirr890112-byte/HermesMade.git
cd HermesMade && bash install.sh
```

### Individual tools (pip)

```bash
pip install git+https://github.com/minirr890112-byte/HermesMade.git#subdirectory=prompt-inspector
pip install git+https://github.com/minirr890112-byte/HermesMade.git#subdirectory=model-watch
pip install git+https://github.com/minirr890112-byte/HermesMade.git#subdirectory=api-cost-compare
pip install git+https://github.com/minirr890112-byte/HermesMade.git#subdirectory=llm-deploy-helper
pip install git+https://github.com/minirr890112-byte/HermesMade.git#subdirectory=code-inspector
pip install git+https://github.com/minirr890112-byte/HermesMade.git#subdirectory=task-cost-estimator
```

6 standalone CLIs: `prompt-inspector` | `model-watch` | `api-cost` | `llm-deploy` | `code-inspector` | `task-cost`

---

## 🛠 Tools

### 1. prompt-inspector — AI Censorship Risk Analyzer

**Pain**: ChatGPT/Claude safety filters are getting insanely aggressive. Even gardening questions get blocked.

> *"I literally couldn't get an answer to a gardening question due to supposed 'violence'... Your filter thought my gardening pitchfork was a sign of satanism."* — r/ChatGPT (26↑)

```bash
$ prompt-inspector "write a story about a dictator who uses propaganda"

🟢 LOW RISK — likely passes, but rewrites recommended
Detected 4 trigger words (dictator, regime, propaganda, assassinate)

📝 Recommended prefix:
  "For academic research and educational purposes..."

🔓 Uncensored local LLM presets (gemma/deepseek/llama)
```

| Feature | Description |
|---------|-------------|
| 6 trigger categories | violence, self-harm, adult, politics, religion, drugs |
| Rewrite strategies | academic prefix, hypothetical framing, technical reframing |
| Uncensored presets | ready-to-copy system prompts for Gemma, DeepSeek, Llama |

---

### 2. model-watch — AI Model Quality Watchdog

**Pain**: API models silently get dumber. Anthropic admitted to degradation. Users have no way to verify.

> *"Opus 4.7 was hallucinating a lot today... shocking to see such degradation"* — r/ClaudeAI (49↑)
> *"Anthropic admits to have made hosted models more stupid"* — r/LocalLLaMA (281↑)

```bash
$ model-watch history

Timestamp            Score    Status
2026-04-20 09:00    72.8%    ——
2026-04-21 09:00    21.0%    🔴 DEGRADED!
2026-04-22 09:00    66.4%    🟢 Recovered

$ model-watch alert
🔴 Severe degradation: recent 3 avg 29.1% vs historical 72.8% (-43.7%)
🔴 Absolute score critical: 29.1%
```

| Feature | Description |
|---------|-------------|
| 7 standardized tests | reasoning, coding, writing, instruction following, hallucination |
| Trend tracking | automatic score history with visual diff |
| Degradation alerts | flags drops >10% vs historical baseline |

---

### 3. api-cost — AI API Cost Optimizer

**Pain**: API pricing is opaque and confusing. Claude is expensive. DeepSeek questioned as overpriced.

> *"Claude is definitely expensive."* — r/ChatGPT
> *"DeepSeek V4 Flash is actually overpriced at $0.14/$0.28"* — r/LocalLLaMA (50↑)

```bash
$ api-cost recommend coding

⭐ #1   Mistral Mistral Small 3        $1.65/mo
⭐ #2   DeepSeek DeepSeek V4 Flash     $1.89/mo
⭐ #3   OpenAI GPT-4o-mini             $2.92/mo

💸 Picking #1 over Claude Opus 4.7 saves $335.85/mo ($4,030/yr)
```

| Feature | Description |
|---------|-------------|
| 18 models priced | OpenAI, Anthropic, Google, DeepSeek, xAI, Mistral |
| 4 usage scenarios | coding, chat, writing, reasoning |
| Spending tracker | `api-cost track 2.50` to log & summarize costs |

---

## 🤔 Why This Exists

Most open-source tools come from a developer thinking "this would be cool."

**HermesMade flips that** — go to Reddit first, listen to what people are actually complaining about, then build.

| | Traditional OSS | HermesMade |
|---|---|---|
| Ideation | Developer intuition | Reddit pain-point data |
| Validation | Ship first, see if anyone cares | Know people are hurting before you build |
| Docs | "read the code" | Every tool cites the Reddit quote that inspired it |
| Promotion | Post and hope | Reply in the exact pain threads where users are |

---

## 🗺 Roadmap

| # | Pain Point | Frequency | Status |
|---|-----------|-----------|--------|
| 1 | AI censorship overreach | ★★★★★ | ✅ prompt-inspector |
| 2 | AI models silently degrading | ★★★★★ | ✅ model-watch |
| 3 | Opaque API pricing | ★★★★☆ | ✅ api-cost / task-cost |
| 4 | Local LLM setup too hard | ★★★★☆ | ✅ llm-deploy |
| 5 | AI-generated code quality | ★★★★☆ | ✅ code-inspector |
| 6 | GitHub Actions unreliable | ★★★★☆ | ⬜ Up next |
| 7 | Supply chain security fear | ★★★☆☆ | ⬜ Planned |
| 8 | Deepfake detection anxiety | ★★★☆☆ | ⬜ Planned |

---

## ⭐ Star History

If these tools help you, drop a ⭐ so others find them.

Every 50 stars unlocks the next pain-point tool.

---

## 📁 Structure

```
HermesMade/
├── prompt-inspector/     # Pain #1 — censorship risk analyzer
├── model-watch/          # Pain #2 — model quality watchdog
├── api-cost-compare/     # Pain #3 — API cost optimizer
├── install.sh            # one-command installer
├── LICENSE               # MIT
├── PROMOTION.md          # star-growth strategy
└── README.md
```

### 4. llm-deploy — Local LLM One-Command Setup

**Pain**: Users buying wrong hardware, struggling to figure out which model fits.

> *"most annoyed I've ever been at myself for not going overboard with RAM"* — r/LocalLLaMA (227↑)

```bash
$ llm-deploy coding

🖥 Hardware: Darwin | RAM: 16GB | GPU: Apple Silicon
⭐ #1 Qwen2.5 7B (4.5G, 28% util) → ollama pull qwen2.5:7b
```

### 5. code-inspector — AI Code Quality Scanner

**Pain**: AI-generated code looks fine until edge cases hit.

> *"everything seemed fine until you inspected the edge cases"* — r/webdev (27↑)

```bash
$ code-inspector app.py

📊 Score: 85/100 → 🟡 NEEDS REVIEW
🔴 Hardcoded API key on line 12
🟠 Mutable default on line 45
```
