# HermesMade Promotion Strategy

## Goal
GitHub Stars: 0 → 50 → 100+
Strategy: "Pain-point reply" — go where people are hurting and offer the cure.

---

## Channel Matrix

### Channel 1: Reddit Pain-Thread Replies ⭐⭐⭐⭐⭐ (highest conversion)
Reply directly in threads where people are complaining about the exact problems we solve.

| Subreddit | Pain Thread | Tool |
|-----------|-------------|------|
| r/ChatGPT | "Updates for ChatGPT" (censorship complaints, 236↑) | prompt-inspector |
| r/ClaudeAI | "Post-mortem on recent Claude Code quality issues" (74↑) | model-watch |
| r/LocalLLaMA | "Anthropic admits to have made hosted models more stupid" (281↑) | model-watch |
| r/LocalLLaMA | DeepSeek V4 pricing discussions | api-cost |
| r/webdev | "Client is Saying I'm Charging too Much" (457↑) | api-cost (tangential) |

### Channel 2: Reddit Showcase Posts ⭐⭐⭐⭐
| Subreddit | Angle |
|-----------|-------|
| r/Python | "I scraped 343 Reddit comments about AI pain points and built 3 CLI tools" |
| r/coolgithubprojects | "HermesMade - From Reddit Pain to One-Command Fix" |
| r/commandline | CLI toolkit showcase |

### Channel 3: Hacker News ⭐⭐⭐⭐
- Show HN: "HermesMade — CLI tools born from 343 Reddit AI pain complaints"

### Channel 4: Dev.to / Medium ⭐⭐⭐
- Technical article: "How to use Reddit pain data to drive open-source tool development"
- Tutorial-style posts for each tool

### Channel 5: Product Hunt ⭐⭐
- Launch when we have screenshots/logo (needs design assets)

---

## Ready-to-Post Content

### Reddit Comment Template (for censorship threads)

```
I got so frustrated with this that I built a small CLI tool to help.
It scans your prompt for trigger words that get blocked, categorizes 
the risk level, and suggests neutral rewrites. Also ships with 
uncensored system prompts for local LLMs (Gemma, DeepSeek, Llama).

github.com/minirr890112-byte/HermesMade

Not a startup — just a weekend project born from this exact frustration. 
Hope it helps someone.
```

### Reddit Comment Template (for model degradation threads)

```
I built a CLI to track this. It runs 7 standardized benchmarks (reasoning, 
coding, writing, hallucination checks), stores scores over time, and flags 
when quality drops. 

github.com/minirr890112-byte/HermesMade (model-watch)

Takes 5 minutes to set up. You feed it model outputs, it tracks the trend.
```

### r/Python Post Template

**Title:** I scraped 343 Reddit comments about AI pain points and built 3 CLI tools

**Body:**
- Scanned 6 AI/tech subreddits (r/ChatGPT, r/ClaudeAI, r/LocalLLaMA, etc.)
- Found 8 recurring pain points with hundreds of upvotes
- Built 3 Python CLI tools that directly solve the top 3:
  - `prompt-inspector` — scan prompts for censorship trigger words
  - `model-watch` — benchmark API models, detect quality degradation
  - `api-cost` — compare 18 model pricing, find cheapest for your use case
- Every tool includes the original Reddit quote that inspired it
- GitHub: github.com/minirr890112-byte/HermesMade

### Show HN Template

**Title:** Show HN: HermesMade — CLI tools born from 343 Reddit AI pain complaints

**Body:**
Instead of building what I think is cool, I scraped 343 pain-signal comments 
from 6 AI subreddits, clustered them into 8 real problems people are screaming 
about RIGHT NOW, and built tools for the top 3.

The idea: every tool in this repo exists because real users on Reddit said 
"this sucks" and got hundreds of upvotes.

Would love feedback on whether this "data-driven open source" approach makes sense.

---

## Pre-Launch Checklist

- [x] Optimized README (badges, demos, comparison table)
- [x] LICENSE (MIT)
- [x] GitHub topics & description
- [x] Feishu/Lark bitable (shareable pain-point data)
- [ ] Self-star the repo (first star matters psychologically)
- [ ] Post on r/Python
- [ ] Post on r/coolgithubprojects
- [ ] Reply in pain threads on r/ChatGPT, r/ClaudeAI, r/LocalLLaMA
- [ ] Submit Show HN
- [ ] Seed initial stars (first 10 stars are the social-proof tipping point)
- [ ] Unlock next pain-point tool at 50 stars
