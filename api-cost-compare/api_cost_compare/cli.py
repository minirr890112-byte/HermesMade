#!/usr/bin/env python3
"""
API Cost Compare — Compare AI API pricing across 18 models and optimize costs.
Find the cheapest model for your use case, track spending over time.

Usage:
  api-cost list                  # list all model pricing
  api-cost recommend coding      # recommend per scenario (coding/chat/writing/reasoning)
  api-cost track 2.50 openai     # log a spend
  api-cost report                # spending summary

Source: Reddit pain #3 — AI API pricing opaque and expensive
Repo: github.com/minirr890112-byte/HermesMade
"""

import json, os, sys, time
from datetime import datetime

DATA_FILE = os.path.expanduser("~/.hermes/api-cost-tracker.json")

# ── Live pricing data (April 2026) ──
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

# ── Typical scenario token estimates ──
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
    print("  API Cost Compare — AI API Pricing (April 2026)")
    print("=" * 80)
    print(f"{'Provider':<14} {'Model':<22} {'Input/1M':>8} {'Output/1M':>10} {'Context':>10}")
    print("-" * 70)

    for p in sorted(PRICING, key=lambda x: (x["provider"], x["output_cost"])):
        print(f"{p['provider']:<14} {p['model']:<22} ${p['input_cost']:>7.2f} ${p['output_cost']:>9.2f} {p['context']:>9,}")

    print("-" * 70)
    print("💡 Use 'api-cost recommend <scenario>' for personalized recommendations")


def recommend(scenario_name: str = None):
    if scenario_name not in SCENARIOS:
        print(f"Available scenarios: {', '.join(SCENARIOS.keys())}")
        print("Usage: api-cost recommend coding")
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
    print(f"  Scenario: {scenario_name}")
    print(f"  Est: {scenario['input_tokens']:,} input / {scenario['output_tokens']:,} output tokens/request")
    print(f"  Volume: {scenario['requests_per_day']} requests/day")
    print(f"{'='*70}")
    print(f"{'Rank':<6} {'Model':<40} {'Daily':>8} {'Monthly':>8}")
    print("-" * 66)

    for i, r in enumerate(results[:10], 1):
        marker = "⭐" if i <= 3 else "  "
        print(f"{marker} #{i:<3} {r['model']:<40} ${r['daily']:>7.2f} ${r['monthly']:>7.2f}")

    print("-" * 66)

    if len(results) >= 2:
        cheapest = results[0]
        expensive = results[-1]
        savings = expensive["monthly"] - cheapest["monthly"]
        print(f"\n💸 Choosing {cheapest['model']} over {expensive['model']}")
        print(f"   Saves ${savings:.2f}/month, ${savings*12:.2f}/year")
        print(f"   That's {(savings/expensive['monthly']*100):.0f}% cheaper")


def compare_two(model1_idx: int, model2_idx: int, scenario_name: str):
    if scenario_name not in SCENARIOS:
        scenario_name = "chat"
    scenario = SCENARIOS[scenario_name]

    m1 = PRICING[model1_idx] if 0 <= model1_idx < len(PRICING) else None
    m2 = PRICING[model2_idx] if 0 <= model2_idx < len(PRICING) else None

    if not m1 or not m2:
        print("Run 'api-cost list' first to see model indices")
        return

    d1, m1_cost = daily_cost(m1, scenario), monthly_cost(m1, scenario)
    d2, m2_cost = daily_cost(m2, scenario), monthly_cost(m2, scenario)

    print(f"\nComparison: {m1['provider']} {m1['model']} vs {m2['provider']} {m2['model']}")
    print(f"Scenario: {scenario_name} ({scenario['requests_per_day']} req/day)")
    print(f"{'':>30} {'Model 1':>15} {'Model 2':>15}")
    print(f"{'Daily cost':>30} ${d1:>14.2f} ${d2:>14.2f}")
    print(f"{'Monthly cost':>30} ${m1_cost:>14.2f} ${m2_cost:>14.2f}")
    print(f"{'Yearly cost':>30} ${m1_cost*12:>14.2f} ${m2_cost*12:>14.2f}")
    diff = m1_cost - m2_cost
    if diff > 0:
        print(f"\n💰 Model 2 saves ${diff:.2f}/month")
    else:
        print(f"\n💰 Model 1 saves ${-diff:.2f}/month")


def track_spending(amount: float, provider: str = "", model: str = ""):
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

    print(f"✅ Logged: ${amount:.2f}")
    print(f"   This month: ${this_month:.2f}")
    print(f"   All time: ${total:.2f}")


def spending_report():
    if not os.path.exists(DATA_FILE):
        print("No spending records yet. Use 'api-cost track <amount>' to log.")
        return

    with open(DATA_FILE) as f:
        records = json.load(f)

    total = sum(r["amount"] for r in records)
    monthly = {}
    for r in records:
        month = r["date"][:7]
        monthly[month] = monthly.get(month, 0) + r["amount"]

    print(f"\n📊 Spending Report")
    print(f"All time: ${total:.2f} | Entries: {len(records)}")
    print(f"{'Month':<10} {'Amount':>10}")
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
            print("Usage: api-cost recommend <scenario>")
            print(f"Scenarios: {', '.join(SCENARIOS.keys())}")
        else:
            recommend(scenario)

    elif cmd == "compare":
        if len(sys.argv) < 4:
            print("Usage: api-cost compare <idx1> <idx2> [scenario]")
            print("Run 'api-cost list' first to see indices")
        else:
            compare_two(int(sys.argv[2]), int(sys.argv[3]),
                       sys.argv[4] if len(sys.argv) > 4 else "chat")

    elif cmd == "track":
        if len(sys.argv) < 3:
            print("Usage: api-cost track <amount> [provider] [model]")
        else:
            amount = float(sys.argv[2])
            provider = sys.argv[3] if len(sys.argv) > 3 else ""
            model = sys.argv[4] if len(sys.argv) > 4 else ""
            track_spending(amount, provider, model)

    elif cmd == "report":
        spending_report()

    elif cmd == "scenarios":
        print("Available scenarios and estimates:")
        for name, params in SCENARIOS.items():
            print(f"  {name}: {params['input_tokens']:,} in / {params['output_tokens']:,} out × {params['requests_per_day']} req/day")

    else:
        print("API Cost Compare — AI API Cost Optimizer")
        print("")
        print("Commands:")
        print("  list              List all 18 models with pricing")
        print("  recommend <scenario>  Recommend cheapest for your use case")
        print("  compare <i1> <i2> Compare two specific models")
        print("  track <amount>    Log a spending entry")
        print("  report            View spending summary")
        print("  scenarios         Show scenario parameters")
        print("")
        print("Examples:")
        print("  api-cost recommend coding")
        print("  api-cost track 2.50 openai gpt-4o")


if __name__ == "__main__":
    main()
