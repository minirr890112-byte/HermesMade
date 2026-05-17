|---
name: task-cost-estimator
description: Before starting any AI task, find the most cost-effective model and estimated cost. 4 modes (value, quality, balanced, local). Task profiling + model matching + cost estimation in one command. Tracks lifetime savings.
version: 1.2.0
author: minirr890112-byte
license: MIT
metadata:
  hermes:
    tags: [AI, Cost, Model, Task, Estimator, Budget, Optimization, LLM]
    homepage: https://github.com/minirr890112-byte/task-cost-estimator
---

# task-cost-estimator

## Problem → Solution

**The problem**: You fire up Codex or Claude Code to build a feature. 750 tool calls later, you check your API bill and you've burned $12 on a task DeepSeek could have done for $0.40. Every developer has done this. The "just use GPT-4.1 for everything" tax is real.

**The solution**: Before you start any AI task, type it here. It profiles what the task needs (reasoning vs coding vs writing), matches 18 models by capability, and estimates the cost. Pick the cheapest model that can actually do the job.

## Quick Start

```bash
pip install git+https://github.com/minirr890112-byte/task-cost-estimator.git

task-cost "your task description here"
```

## Real Output

```
$ task-cost "build a REST API with JWT auth in Python"

📋 Task: REST API with JWT auth
   Needs: reasoning=7/10  coding=9/10  writing=3/10  research=2/10
   Est. tokens: ~1,200 in / ~1,500 out

🏷️  Value Mode (cheapest that can handle it):
   ⭐ DeepSeek V4 Flash    $0.0004/run   87% match  [PICK THIS]
     DeepSeek V4 Pro       $0.0027/run   96% match
     GPT-4o Mini           $0.0030/run   85% match

🏷️  Quality Mode (highest accuracy):
     Claude Sonnet 4       $0.0150/run   98% match
     GPT-4.1               $0.0216/run   95% match
```

## 4 Modes

| Mode | Strategy | Use Case |
|---|---|---|
| `value` | Cheapest capable model | Routine tasks, batch processing |
| `quality` | Highest accuracy | Production code, security audits |
| `balanced` | Sweet spot | General development |
| `local` | Free (local LLM) | Offline, privacy-sensitive |

## Real Savings Example

```
Build a full-stack app (500 AI interactions):
  Default (GPT-4.1):     500 × $0.043/run = $21.50
  Smart (DeepSeek V4):   500 × $0.0027/run = $13.50
  Savings: $8.00 saved in one afternoon
```

## Why a Star? ⭐

If this saves you from a $20 API bill regret, star it → [GitHub](https://github.com/minirr890112-byte/task-cost-estimator)
