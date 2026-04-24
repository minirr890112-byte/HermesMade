#!/usr/bin/env python3
"""
API Cost Compare — AI API 成本对比与优化工具。
实时对比主流模型定价，按使用场景推荐最优方案，跟踪用量。

用法:
  api-cost list                  # 列出所有模型定价
  api-cost compare               # 交互式对比
  api-cost recommend coding      # 按场景推荐 (coding/writing/reasoning/chat)
  api-cost track $0.50           # 记录本次花费

来源: Reddit 痛点 #3 — AI API定价过高/成本不透明
仓库: github.com/minirr890112-byte/HermesMade
"""

import json, os, sys, time
from datetime import datetime

DATA_FILE = os.path.expanduser("~/.hermes/api-cost-tracker.json")

# ── 实时定价数据（2026年4月，定期更新）──
# 格式: provider, model, input/1M tokens, output/1M tokens, context_len
PRICING = [
    # OpenAI
    {"provider": "OpenAI", "model": "GPT-4o", "input_cost": 2.50, "output_cost": 10.00, "context": 128000, "tags": ["chat", "coding", "writing", "reasoning"]},
    {"provider": "OpenAI", "model": "GPT-4o-mini", "input_cost": 0.15, "output_cost": 0.60, "context": 128000, "tags": ["chat", "coding", "writing"]},
    {"provider": "OpenAI", "model": "GPT-4.1", "input_cost": 2.00, "output_cost": 8.00, "context": 1000000, "tags": ["coding", "reasoning", "writing"]},
    {"provider": "OpenAI", "model": "GPT-4.1-mini", "input_cost": 0.40, "output_cost": 1.60, "context": 1000000, "tags": ["chat", "coding", "writing"]},
    {"provider": "OpenAI", "model": "GPT-4.1-nano", "input_cost": 0.10, "output_cost": 0.40, "context": 1000000, "tags": ["chat"]},
    {"provider": "OpenAI", "model": "o3", "input_cost": 10.00, "output_cost": 40.00, "context": 200000, "tags": ["reasoning", "coding"]},
    {"provider": "OpenAI", "model": "o4-mini", "input_cost": 1.10, "output_cost": 4.40, "context": 200000, "tags": ["reasoning", "coding"]},

    # Anthropic
    {"provider": "Anthropic", "model": "Claude Opus 4.7", "input_cost": 15.00, "output_cost": 75.00, "context": 200000, "tags": ["coding", "writing", "reasoning"]},
    {"provider": "Anthropic", "model": "Claude Sonnet 4.5", "input_cost": 3.00, "output_cost": 15.00, "context": 200000, "tags": ["coding", "chat", "writing"]},
    {"provider": "Anthropic", "model": "Claude Haiku 4.5", "input_cost": 0.80, "output_cost": 4.00, "context": 200000, "tags": ["chat"]},

    # Google
    {"provider": "Google", "model": "Gemini 2.5 Pro", "input_cost": 1.25, "output_cost": 10.00, "context": 1000000, "tags": ["coding", "reasoning", "writing"]},
    {"provider": "Google", "model": "Gemini 2.5 Flash", "input_cost": 0.15, "output_cost": 0.60, "context": 1000000, "tags": ["chat", "coding", "writing"]},

    # DeepSeek
    {"provider": "DeepSeek", "model": "DeepSeek V4 Pro", "input_cost": 0.55, "output_cost": 2.19, "context": 1000000, "tags": ["coding", "reasoning", "writing", "chat"]},
    {"provider": "DeepSeek", "model": "DeepSeek V4 Flash", "input_cost": 0.14, "output_cost": 0.28, "context": 1000000, "tags": ["chat", "coding", "writing"]},
    {"provider": "DeepSeek", "model": "DeepSeek R1-0528", "input_cost": 0.55, "output_cost": 2.19, "context": 128000, "tags": ["reasoning", "coding"]},

    # xAI
    {"provider": "xAI", "model": "Grok 3", "input_cost": 3.00, "output_cost": 15.00, "context": 131072, "tags": ["chat", "reasoning", "coding"]},
    {"provider": "xAI", "model": "Grok 3 Mini", "input_cost": 0.30, "output_cost": 1.50, "context": 131072, "tags": ["chat", "coding"]},

    # Mistral
    {"provider": "Mistral", "model": "Mistral Large 2", "input_cost": 2.00, "output_cost": 6.00, "context": 128000, "tags": ["coding", "writing", "reasoning"]},
    {"provider": "Mistral", "model": "Mistral Small 3", "input_cost": 0.10, "output_cost": 0.30, "context": 128000, "tags": ["chat", "coding"]},
]

# ── 典型使用场景的 token 消耗估算 ──
SCENARIOS = {
    "coding":     {"input_tokens": 5000, "output_tokens": 2000, "requests_per_day": 50},
    "chat":       {"input_tokens": 500,  "output_tokens": 500,  "requests_per_day": 100},
    "writing":    {"input_tokens": 1000, "output_tokens": 3000, "requests_per_day": 10},
    "reasoning":  {"input_tokens": 2000, "output_tokens": 4000, "requests_per_day": 20},
}


def daily_cost(model: dict, scenario: dict) -> float:
    in_cost = model["input_cost"] / 1_000_000 * scenario["input_tokens"]
    out_cost = model["output_cost"] / 1_000_000 * scenario["output_tokens"]
    return (in_cost + out_cost) * scenario["requests_per_day"]


def monthly_cost(model: dict, scenario: dict) -> float:
    return daily_cost(model, scenario) * 30


def list_all():
    print("=" * 80)
    print("  API Cost Compare — 主流 AI API 定价 (2026.04)")
    print("=" * 80)
    print(f"{'Provider':<14} {'Model':<22} {'Input/1M':>8} {'Output/1M':>10} {'Context':>10}")
    print("-" * 70)

    for p in sorted(PRICING, key=lambda x: (x["provider"], x["output_cost"])):
        print(f"{p['provider']:<14} {p['model']:<22} ${p['input_cost']:>7.2f} ${p['output_cost']:>9.2f} {p['context']:>9,}")

    print("-" * 70)
    print("💡 用 'api-cost recommend <scenario>' 按场景推荐最优方案")


def recommend(scenario_name: str = None):
    if scenario_name not in SCENARIOS:
        print(f"可用场景: {', '.join(SCENARIOS.keys())}")
        print("用法: api-cost recommend coding")
        return

    scenario = SCENARIOS[scenario_name]
    candidates = [p for p in PRICING if scenario_name in p["tags"]]

    results = []
    for p in candidates:
        daily = daily_cost(p, scenario)
        monthly = monthly_cost(p, scenario)
        results.append({
            "model": f"{p['provider']} {p['model']}",
            "daily": daily,
            "monthly": monthly,
        })

    results.sort(key=lambda x: x["monthly"])

    print(f"\n{'='*70}")
    print(f"  场景: {scenario_name}")
    print(f"  估算: {scenario['input_tokens']:,} input / {scenario['output_tokens']:,} output tokens/次")
    print(f"  频率: {scenario['requests_per_day']} 次/天")
    print(f"{'='*70}")
    print(f"{'排名':<6} {'模型':<40} {'日费用':>8} {'月费用':>8}")
    print("-" * 66)

    for i, r in enumerate(results[:10], 1):
        marker = "⭐" if i <= 3 else "  "
        print(f"{marker} #{i:<3} {r['model']:<40} ${r['daily']:>7.2f} ${r['monthly']:>7.2f}")

    print("-" * 66)

    # 对比
    if len(results) >= 2:
        cheapest = results[0]
        expensive = results[-1]
        savings = expensive["monthly"] - cheapest["monthly"]
        print(f"\n💸 选择 {cheapest['model']} 比 {expensive['model']}")
        print(f"   月省 ${savings:.2f}，年省 ${savings*12:.2f}")
        print(f"   节省 {(savings/expensive['monthly']*100):.0f}%")


def compare_two(model1_idx: int, model2_idx: int, scenario_name: str):
    """对比两个模型"""
    if scenario_name not in SCENARIOS:
        scenario_name = "chat"
    scenario = SCENARIOS[scenario_name]

    m1 = PRICING[model1_idx] if 0 <= model1_idx < len(PRICING) else None
    m2 = PRICING[model2_idx] if 0 <= model2_idx < len(PRICING) else None

    if not m1 or not m2:
        print("先运行 'api-cost list' 查看模型索引")
        return

    d1, m1_cost = daily_cost(m1, scenario), monthly_cost(m1, scenario)
    d2, m2_cost = daily_cost(m2, scenario), monthly_cost(m2, scenario)

    print(f"\n对比: {m1['provider']} {m1['model']} vs {m2['provider']} {m2['model']}")
    print(f"场景: {scenario_name} ({scenario['requests_per_day']}次/天)")
    print(f"{'':>30} {'Model 1':>15} {'Model 2':>15}")
    print(f"{'日费用':>30} ${d1:>14.2f} ${d2:>14.2f}")
    print(f"{'月费用':>30} ${m1_cost:>14.2f} ${m2_cost:>14.2f}")
    print(f"{'年费用':>30} ${m1_cost*12:>14.2f} ${m2_cost*12:>14.2f}")
    diff = m1_cost - m2_cost
    if diff > 0:
        print(f"\n💰 Model 2 月省 ${diff:.2f}")
    else:
        print(f"\n💰 Model 1 月省 ${-diff:.2f}")


def track_spending(amount: float, provider: str = "", model: str = ""):
    """记录花费"""
    records = []
    if os.path.exists(DATA_FILE):
        with open(DATA_FILE) as f:
            records = json.load(f)

    records.append({
        "date": datetime.now().isoformat()[:10],
        "amount": amount,
        "provider": provider,
        "model": model,
    })

    os.makedirs(os.path.dirname(DATA_FILE), exist_ok=True)
    with open(DATA_FILE, "w") as f:
        json.dump(records, f, indent=2)

    total = sum(r["amount"] for r in records)
    this_month = sum(r["amount"] for r in records
                     if r["date"][:7] == datetime.now().isoformat()[:7])

    print(f"✅ 记录: ${amount:.2f}")
    print(f"   本月: ${this_month:.2f}")
    print(f"   累计: ${total:.2f}")


def spending_report():
    if not os.path.exists(DATA_FILE):
        print("暂无花费记录。用 'api-cost track <金额>' 记录")
        return

    with open(DATA_FILE) as f:
        records = json.load(f)

    total = sum(r["amount"] for r in records)
    monthly = {}
    for r in records:
        month = r["date"][:7]
        monthly[month] = monthly.get(month, 0) + r["amount"]

    print(f"\n📊 花费报告")
    print(f"累计: ${total:.2f} | 记录: {len(records)} 条")
    print(f"{'月份':<10} {'金额':>10}")
    for m in sorted(monthly.keys()):
        bar = "█" * int(monthly[m] * 2)
        print(f"{m:<10} ${monthly[m]:>8.2f}  {bar}")


def main():
    cmd = sys.argv[1] if len(sys.argv) > 1 else "help"

    if cmd == "list":
        list_all()

    elif cmd == "recommend":
        scenario = sys.argv[2] if len(sys.argv) > 2 else None
        if not scenario:
            print("用法: api-cost recommend <scenario>")
            print(f"场景: {', '.join(SCENARIOS.keys())}")
        else:
            recommend(scenario)

    elif cmd == "compare":
        if len(sys.argv) < 4:
            print("用法: api-cost compare <idx1> <idx2> [scenario]")
            print("先用 'api-cost list' 查看索引")
        else:
            compare_two(int(sys.argv[2]), int(sys.argv[3]),
                       sys.argv[4] if len(sys.argv) > 4 else "chat")

    elif cmd == "track":
        if len(sys.argv) < 3:
            print("用法: api-cost track <金额> [provider] [model]")
        else:
            amount = float(sys.argv[2])
            provider = sys.argv[3] if len(sys.argv) > 3 else ""
            model = sys.argv[4] if len(sys.argv) > 4 else ""
            track_spending(amount, provider, model)

    elif cmd == "report":
        spending_report()

    elif cmd == "scenarios":
        print("可用场景及估算参数:")
        for name, params in SCENARIOS.items():
            print(f"  {name}: {params['input_tokens']:,} in / {params['output_tokens']:,} out × {params['requests_per_day']}次/天")

    else:
        print("API Cost Compare — AI API 成本对比与优化")
        print("")
        print("命令:")
        print("  list              列出所有模型定价")
        print("  recommend <场景>   按场景推荐最优模型")
        print("  compare <i1> <i2>  对比两个模型")
        print("  track <金额>       记录花费")
        print("  report             花费报告")
        print("  scenarios          查看场景参数")
        print("")
        print("示例:")
        print("  api-cost recommend coding")
        print("  api-cost track 2.50 openai gpt-4o")


if __name__ == "__main__":
    main()
