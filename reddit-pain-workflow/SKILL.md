|---
name: reddit-pain-workflow
description: Daily automated pipeline: scan Reddit developer communities → classify pain signals → generate markdown report. Identifies ERROR, UX, PRICE, MISSING, DOCS, PERF, LIMIT, and BREAK categories. No API key needed. Cron-friendly.
version: 1.2.0
author: minirr890112-byte
license: MIT
metadata:
  hermes:
    tags: [Reddit, Automation, Pipeline, Cron, Pain-Points, Reporting, Developer-Tools]
    homepage: https://github.com/minirr890112-byte/reddit-pain-workflow
---

# reddit-pain-workflow

## Problem → Solution

**The problem**: You want to know what developers are struggling with RIGHT NOW — what tools are breaking, what APIs are annoying, what pricing changes are causing outrage. Manually scrolling Reddit takes hours and you miss things.

**The solution**: One command scans 10 developer subreddits, classifies posts into 8 pain categories, and generates a ranked report — in under 15 seconds. No API key, no setup.

## Quick Start

```bash
pip install git+https://github.com/minirr890112-byte/reddit-pain-workflow.git

# Scan all developer subreddits
python reddit_pain_workflow.py

# Target a specific subreddit
python reddit_pain_workflow.py --subreddit cursor

# Cron-friendly JSON output
python reddit_pain_workflow.py --cron

# Save report to file
python reddit_pain_workflow.py --report markdown --output report.md
```

## Real Output

```markdown
# Reddit Pain Report
Generated: 2026-05-14T08:00:00+00:00
Scanned: 10 subreddits, 250 posts
Pain Signals: 23

## 🔥 Top Pain Signals

| Category | Count |
|---|---|
| ERROR | 8 |
| LIMIT | 5 |
| BREAK | 4 |
| PRICE | 3 |
| PERF | 2 |
| UX | 1 |

| # | Sub | Title | 💬 | ⬆ | Score | Categories |
|---|---|---|---|---|---|---|
| 1 | r/ClaudeAI | Code formatting completely broken after update | 47 | 230 | 52 | ERROR/BREAK |
| 2 | r/cursor | MCP connection fails every 10 minutes | 34 | 180 | 44 | ERROR/LIMIT |
| 3 | r/OpenAI | Rate limit cut by 80% without notice | 28 | 310 | 38 | LIMIT/PRICE/BREAK |
```

## Pain Categories

| Category | Detects |
|---|---|
| ERROR | crash, bug, broken, fail, exception |
| UX | confusing, terrible UI, hard to use |
| PRICE | expensive, overpriced, pricing change |
| MISSING | no way to, missing feature, can't do |
| DOCS | undocumented, outdated, no example |
| PERF | slow, timeout, hangs, freeze |
| LIMIT | rate limit, quota, threshold |
| BREAK | broke after update, regression, stopped working |

## Why This Exists

Built from 154+ pain signals mined from Chinese developer communities. The same methodology that identified cursor MCP errors (77 signals), Claude intelligence degradation (687-1022 spike), and 豆包 pricing outrage (50+ signals) — now available for any Reddit community.

## Why a Star? ⭐

This tool shipped cursor-doctor and claude-intel-monitor — products with real downloads. If this workflow saves you time or inspires your own project, star it → [GitHub](https://github.com/minirr890112-byte/reddit-pain-workflow)

---

**Next**: Pair with [pain-to-pip-package](https://github.com/minirr890112-byte/pain-to-pip-package) to convert these signals into actual CLI tools.
