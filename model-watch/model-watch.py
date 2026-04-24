#!/usr/bin/env python3
"""
Model Watch — AI模型基准测试与质量监控。
检测模型降级（偷偷变笨），记录历史趋势，可推送飞书告警。

用法:
  model-watch run              # 运行一次基准测试
  model-watch history          # 查看历史趋势
  model-watch alert            # 检查是否有模型质量下降
  model-watch serve            # 启动定时监控 (cron mode)

来源: Reddit 痛点 #2 — AI模型降级/偷偷变笨
仓库: github.com/minirr890112-byte/HermesMade
"""

import json, os, time, sys
from datetime import datetime

DATA_FILE = os.path.expanduser("~/.hermes/model-watch-history.json")

# ── 基准测试题目 ──
# 覆盖：推理、代码、写作、指令遵循
BENCHMARKS = [
    {
        "id": "reasoning_1",
        "category": "reasoning",
        "prompt": "If a bat and ball cost $1.10 total, and the bat costs $1.00 more than the ball, how much does the ball cost? Show your reasoning step by step.",
        "expected_keywords": ["0.05", "5 cents", "$0.05"],
        "weight": 1.0,
    },
    {
        "id": "reasoning_2",
        "category": "reasoning",
        "prompt": "A farmer has 17 sheep. All but 9 die. How many are left?",
        "expected_keywords": ["9", "nine"],
        "weight": 0.5,
    },
    {
        "id": "coding_1",
        "category": "coding",
        "prompt": "Write a Python function that finds the first non-repeating character in a string. Include a test case. Return ONLY the code, no explanation.",
        "expected_keywords": ["def ", "return", "count", "OrderedDict", "Counter", "collections"],
        "weight": 1.5,
    },
    {
        "id": "coding_2",
        "category": "coding",
        "prompt": "What's wrong with this code? 'list = [1,2,3]; for i in list: list.append(i)' — explain in one sentence.",
        "expected_keywords": ["infinite", "loop", "forever", "never end", "grow"],
        "weight": 1.0,
    },
    {
        "id": "writing_1",
        "category": "writing",
        "prompt": "Write a 3-sentence product description for a smartphone. Make it compelling but factual. No buzzwords like 'revolutionary' or 'game-changing'.",
        "expected_keywords": [],  # evaluated by structure
        "weight": 1.0,
    },
    {
        "id": "instruction_1",
        "category": "instruction_following",
        "prompt": "List 5 countries. Format them as a JSON array of strings. Output ONLY the JSON, nothing else.",
        "expected_keywords": ['["', '"]', '","'],
        "weight": 2.0,
    },
    {
        "id": "hallucination_1",
        "category": "hallucination",
        "prompt": "What is the capital of France? Answer with ONLY the city name, nothing else.",
        "expected_keywords": ["Paris"],
        "weight": 0.5,
    },
    {
        "id": "hallucination_2",
        "category": "hallucination",
        "prompt": "Who wrote the novel '1984'? Answer with ONLY the author's full name.",
        "expected_keywords": ["George Orwell"],
        "weight": 0.5,
    },
]


def load_history() -> list:
    if os.path.exists(DATA_FILE):
        with open(DATA_FILE) as f:
            return json.load(f)
    return []


def save_history(history: list):
    os.makedirs(os.path.dirname(DATA_FILE), exist_ok=True)
    with open(DATA_FILE, "w") as f:
        json.dump(history, f, indent=2)


def score_response(benchmark: dict, response: str) -> float:
    """评分：0.0-1.0"""
    response_lower = response.lower()
    score = 0.0
    max_score = len(benchmark["expected_keywords"]) if benchmark["expected_keywords"] else 3
    if max_score == 0:
        max_score = 3

    for kw in benchmark["expected_keywords"]:
        if kw.lower() in response_lower:
            score += 1.0

    # 基础质量检查
    if len(response) < 10:
        score -= 1
    if len(response) > 50:
        score += 0.5

    return max(0, min(1.0, score / max_score)) * benchmark["weight"]


def run_benchmarks(model_outputs: dict = None) -> dict:
    """运行基准测试。model_outputs: {benchmark_id: response_text}"""
    if model_outputs is None:
        print("❌ 需要提供模型输出。用法示例:")
        print("  先用 API 获取每个 benchmark 的回复，然后传入此函数。")
        print("  或使用 --demo 查看基准测试题目。")
        sys.exit(1)

    results = {}
    total_score = 0
    total_weight = sum(b["weight"] for b in BENCHMARKS)

    for b in BENCHMARKS:
        if b["id"] not in model_outputs:
            continue
        s = score_response(b, model_outputs[b["id"]])
        results[b["id"]] = {
            "category": b["category"],
            "score": round(s, 3),
            "weight": b["weight"],
        }
        total_score += s

    overall = round(total_score / total_weight * 100, 1) if total_weight > 0 else 0

    entry = {
        "timestamp": datetime.now().isoformat(),
        "overall_score": overall,
        "details": results,
    }

    history = load_history()
    history.append(entry)
    save_history(history)

    return entry


def show_history():
    """展示历史趋势"""
    history = load_history()
    if not history:
        print("📭 暂无测试数据。先运行 model-watch run")
        return

    print("=" * 60)
    print("  Model Watch — 模型质量趋势")
    print("=" * 60)
    print(f"{'时间':<22} {'总分':>6} {'状态':>8}")
    print("-" * 40)

    scores = []
    for i, entry in enumerate(history):
        ts = entry["timestamp"][:19].replace("T", " ")
        sc = entry["overall_score"]
        scores.append(sc)

        if i > 0:
            prev = history[i - 1]["overall_score"]
            diff = sc - prev
            if diff < -10:
                status = "🔴 降级!"
            elif diff < -5:
                status = "🟡 下降"
            elif diff > 5:
                status = "🟢 提升"
            else:
                status = "➡ 稳定"
        else:
            status = "——"

        print(f"{ts:<22} {sc:>5.1f}% {status:>8}")

    print("-" * 40)
    if len(scores) >= 2:
        trend = scores[-1] - scores[-2]
        print(f"最近变化: {trend:+.1f}%")
        avg = sum(scores) / len(scores)
        print(f"历史均值: {avg:.1f}%")
        print(f"最新得分: {scores[-1]:.1f}%")

    # 检查是否显著下降
    if len(scores) >= 3:
        recent_avg = sum(scores[-3:]) / 3
        older_avg = sum(scores[:-3]) / max(1, len(scores) - 3)
        drop = older_avg - recent_avg
        if drop > 10:
            print(f"\n⚠️ 警告: 近3次平均比历史低 {drop:.1f}%，可能模型降级！")


def check_alert() -> dict:
    """检查是否需要告警"""
    history = load_history()
    if len(history) < 3:
        return {"alert": False, "reason": "数据不足（至少需要3次测试）"}

    recent = [h["overall_score"] for h in history[-3:]]
    older = [h["overall_score"] for h in history[:-3]]

    recent_avg = sum(recent) / 3
    older_avg = sum(older) / max(1, len(older))
    drop = older_avg - recent_avg

    alerts = []
    if drop > 15:
        alerts.append(f"🔴 严重降级: 近3次平均 {recent_avg:.1f}%，比历史 {older_avg:.1f}% 低 {drop:.1f}%")
    elif drop > 10:
        alerts.append(f"🟡 可能降级: 近3次平均 {recent_avg:.1f}%，比历史 {older_avg:.1f}% 低 {drop:.1f}%")

    if recent_avg < 50:
        alerts.append(f"🔴 绝对分数过低: {recent_avg:.1f}%")

    return {
        "alert": len(alerts) > 0,
        "alerts": alerts,
        "recent_avg": recent_avg,
        "older_avg": older_avg,
        "drop": drop,
    }


def show_benchmarks():
    """展示基准测试题目"""
    print("=" * 60)
    print("  Model Watch — 基准测试题目")
    print("=" * 60)
    for b in BENCHMARKS:
        print(f"\n[{b['id']}] {b['category']} (权重:{b['weight']})")
        print(f"  {b['prompt'][:120]}...")
        if b["expected_keywords"]:
            print(f"  期望关键词: {', '.join(b['expected_keywords'])}")


def main():
    cmd = sys.argv[1] if len(sys.argv) > 1 else "help"

    if cmd == "run":
        print("📊 Model Watch — 运行基准测试")
        print("=" * 40)
        print("此工具需要你提供模型对各题目的回复。")
        print("")
        print("用法：先用你的 AI API 获取回复，然后：")
        print("  model-watch submit '{\"reasoning_1\": \"...\", \"coding_1\": \"...\"}'")
        print("")
        print("先看看题目：")
        show_benchmarks()

    elif cmd == "demo" or cmd == "benchmarks":
        show_benchmarks()

    elif cmd == "submit":
        if len(sys.argv) < 3:
            print("用法: model-watch submit '<json_outputs>'")
            sys.exit(1)
        outputs = json.loads(sys.argv[2])
        result = run_benchmarks(outputs)
        print(f"✅ 测试完成。总分: {result['overall_score']}%")
        print(f"详情已保存到 {DATA_FILE}")

    elif cmd == "history":
        show_history()

    elif cmd == "alert":
        result = check_alert()
        print(json.dumps(result, indent=2, ensure_ascii=False))

    elif cmd == "serve":
        print("🔄 Model Watch 定时监控模式")
        print("建议通过 cronjob 设置定期运行:")
        print("  hermes cronjob create --name model-watch \\")
        print("    --schedule '0 9 * * *' \\")
        print("    --prompt '运行 model-watch alert，如果有告警推送到飞书'")

    else:
        print("Model Watch — AI模型质量监控")
        print("")
        print("命令:")
        print("  demo        查看基准测试题目")
        print("  run         交互式运行测试")
        print("  submit JSON 提交模型输出")
        print("  history     查看历史趋势")
        print("  alert       检查告警")
        print("  serve       显示定时监控设置")


if __name__ == "__main__":
    main()
