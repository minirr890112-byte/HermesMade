     1|---
     2|name: reddit-pain-workflow
     3|description: Daily automated pipeline: Reddit scan → classify → generate report → push to GitHub → metrics tracking. Cron-friendly with short timeouts. Drives star growth through content marketing. Generates V2EX-style pain point reports for any community.
     4|version: 1.1.0
     5|author: minirr890112-byte
     6|license: MIT
     7|metadata:
     8|  hermes:
     9|    tags: [Reddit, Automation, Pipeline, Cron, Pain-Points, Reporting, GitHub, Content]
    10|    homepage: https://github.com/minirr890112-byte/reddit-pain-workflow
    11|---
    12|
    13|# Reddit Pain Workflow
    14|
    15|## 一句话
    16|
    17|每日自动扫描 Reddit 开发者社区，发现痛点 → 分类 → 生成报告 → 推送 GitHub。Cron 友好，每个阶段有独立超时保护。
    18|
    19|## 核心功能
    20|
    21|- **Daily Reddit Scan** — 自动抓取 r/programming、r/webdev、r/cursor 等
    22|- **Pain Classifier** — NLP 分类：错误/体验/价格/缺失功能/文档
    23|- **Auto Report** — 生成 markdown 日报，推送 GitHub
    24|- **Cron-Ready** — 各阶段有独立超时，适合定时任务
    25|- **Star Growth Driver** — 报告吸引社区流量，驱动 GitHub 星数增长
    26|
    27|## 怎么用
    28|
    29|```bash
    30|python reddit_pain_workflow.py --cron
    31|```
    32|
    33|## 报告示例
    34|
    35|```markdown
    36|# Daily Pain Report 2026-05-10
    37|## 🔥 Hot Signals (>10 replies)
    38|- Cursor MCP connection fails: 23 replies
    39|- Claude Code formatting woes: 15 replies
    40|
    41|## 📊 Summary
    42|53 pain signals across 7 categories. Local LLM deployment (195 replies) trending.
    43|```
    44|
    45|## 为什么给颗星？
    46|
    47|已产出数百份信号报告驱动 HermesMade 生态系统 — 如果这个自动化对你有启发，点 ⭐ → [GitHub](https://github.com/minirr890112-byte/reddit-pain-workflow)
    48|