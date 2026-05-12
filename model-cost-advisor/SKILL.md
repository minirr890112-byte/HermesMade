     1|---
     2|name: model-cost-advisor
     3|description: Analyze any task and recommend the most cost-effective LLM — with live pricing data from 30+ models, tier analysis, token estimation, and projected cost. Perfect for developers who use multiple LLMs and want to optimize spending.
     4|version: 1.1.0
     5|author: minirr890112-byte
     6|license: MIT
     7|metadata:
     8|  hermes:
     9|    tags: [AI, Cost, LLM, Pricing, Optimization, Budget, Model, Advisor]
    10|    homepage: https://github.com/minirr890112-byte/model-cost-advisor
    11|---
    12|
    13|# Model Cost Advisor
    14|
    15|## 一句话
    16|
    17|分析你的任务，从 30+ 模型中找到最具性价比的选择。实时定价 + 三层分级 + Token 预估 + 成本投影。
    18|
    19|## 核心功能
    20|
    21|- **30+ Models** — GPT-4、Claude、DeepSeek、GLM、Mixtral 等，含最新定价
    22|- **Tier Analysis** — budget / value / quality / premium 四层分级
    23|- **Token Estimation** — 根据任务类型智能预估 input/output token 数
    24|- **Cost Projection** — 单次运行成本 + 日/月/年投影
    25|- **Live Pricing** — 持续跟踪 API 价格变化，自动更新
    26|
    27|## 怎么用
    28|
    29|```bash
    30|model-cost "build a full-stack todo app with auth"
    31|```
    32|
    33|## 示例
    34|
    35|```bash
    36|$ model-cost "summarize 1000 customer reviews"
    37|
    38|📋 Task: Summarization batch (1000×)
    39|   Tokens: 500 in / 200 out per item
    40|
    41|🏷️  Tier: Value
    42|   → DeepSeek V4 Flash    $0.0003/item   $0.30/total
    43|   → GLM-4 Flash          $0.0004/item   $0.40/total
    44|
    45|🏷️  Tier: Quality
    46|   → DeepSeek V4 Pro      $0.0011/item   $1.10/total
    47|   → GPT-4o Mini          $0.0015/item   $1.50/total
    48|```
    49|
    50|## 数据来源
    51|
    52|定价数据来自各 LLM 服务商官方 API 文档，持续更新。与 HermesMade 的 model-watch 和 api-cost-compare 模块共享数据层。
    53|
    54|## 为什么给颗星？
    55|
    56|帮你每年轻松省下几百美元 API 费用。点 ⭐ 让更多开发者受益 → [GitHub](https://github.com/minirr890112-byte/model-cost-advisor)
    57|