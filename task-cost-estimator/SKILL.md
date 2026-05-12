     1|---
     2|name: task-cost-estimator
     3|description: Before starting any AI task, find the most cost-effective model and estimated cost. 4 modes (value, quality, balanced, local). Task profiling + model matching + cost estimation in one command. Tracks lifetime Bonus.
     4|version: 1.1.0
     5|author: minirr890112-byte
     6|license: MIT
     7|metadata:
     8|  hermes:
     9|    tags: [AI, Cost, Model, Task, Estimator, Budget, Optimization, LLM]
    10|    homepage: https://github.com/minirr890112-byte/task-cost-estimator
    11|---
    12|
    13|# task-cost-estimator
    14|
    15|## 一句话
    16|
    17|Before you start any AI task, find the cheapest model that can handle it — and estimate what you'll spend.
    18|
    19|## 核心功能
    20|
    21|- **Task Profiling** — 自动分析任务需要什么能力（推理/编码/写作/研究）
    22|- **Model Matching** — 匹配 18 个模型，按匹配度排序
    23|- **Cost Estimation** — 预估单次运行成本、日成本
    24|- **4 Modes** — value（省钱）、quality（质量）、balanced（均衡）、local（本地）
    25|
    26|## 怎么用
    27|
    28|```bash
    29|task-cost "describe your task here"
    30|```
    31|
    32|## 示例
    33|
    34|```bash
    35|$ task-cost "build a REST API with JWT auth in Python"
    36|
    37|📋 Task: REST API with JWT auth
    38|   Needs: reasoning=7/10  coding=9/10  writing=3/10
    39|   Est. tokens: ~1,000 in / ~1,000 out
    40|
    41|⭐ DeepSeek V4 Flash    $0.0004/run  87% match
    42|   DeepSeek V4 Pro      $0.0027/run  96% match
    43|```
    44|
    45|## 数据来源
    46|
    47|Built from HermesMade's pain point intelligence pipeline. Developers lose money using GPT-4 for simple tasks. This tool gives you the cheapest model that can actually do the job.
    48|
    49|## Install
    50|
    51|```bash
    52|pip install git+https://github.com/minirr890112-byte/task-cost-estimator.git#subdirectory=task-cost-estimator
    53|```
    54|
    55|## 为什么给颗星？
    56|
    57|如果你觉得有用，点个 ⭐ 让更多人找到它 → [GitHub](https://github.com/minirr890112-byte/task-cost-estimator)
    58|