#!/usr/bin/env python3
"""
GFW Fallback Scan — generates a real DAILY-REPORT.md when reddit.com / v2ex.com are blocked.

Primary source: Arctic Shift (arctic-shift.photon-reddit.com) — a full Reddit mirror
accessible from CN IPs. Returns actual posts + comments from the exact subreddits the
daily pipeline targets (ChatGPT, ClaudeAI, LocalLLaMA, programming, webdev, learnpython).

Supplementary: GitHub API (AI-tooling repos, reaction-sorted) + HN Algolia (tertiary).

Classification uses the refined first-match-wins taxonomy (see reddit-pain-scan-gfw skill).
Ranking is by total signal strength (sum of scores/reactions), not raw item count.
"""

import json, os, re, random, subprocess, sys, time
from datetime import datetime, timedelta
from collections import defaultdict
from urllib.request import Request, urlopen
from urllib.parse import urlencode

REPO_DIR = os.path.expanduser("~/HermesMade")
DATA_DIR = os.path.expanduser("~/.hermes/daily-pipeline")
os.makedirs(DATA_DIR, exist_ok=True)

UA = "HermesBot/1.0"

SUBREDDITS = ["ChatGPT", "ClaudeAI", "LocalLLaMA", "programming", "webdev", "learnpython"]
AS_POSTS = "https://arctic-shift.photon-reddit.com/api/posts/search"
AS_COMMENTS = "https://arctic-shift.photon-reddit.com/api/comments/search"

GITHUB_REPOS = [
    ("anthropics/claude-code", "claude-code"),
    ("openai/codex", "codex"),
    ("ollama/ollama", "ollama"),
]

PAIN_SIGNALS = [
    "frustrat", "annoy", "hate", "terrible", "awful", "broken", "useless",
    "waste", "garbage", "horrible", "pain", "sucks", "suck",
    "doesn't work", "not working", "stuck", "can't ", "cannot ",
    "bug", "issue", "problem", "error", "fail", "broke",
    "wish", "need", "missing", "should have",
    "if only", "i want", "please add",
    "confus", "unclear", "no tutorial",
    "hard to", "difficult to", "complicated",
    "hallucinat", "censored", "refus", "degrad", "dumber", "regress",
    "expensive", "overpriced", "privacy", "rate limit", "quota", "usage limit",
    "regression", "bring back", "removed feature", "alzheimer", "lobotom",
]

# Refined taxonomy (first-match wins). Short ascii tokens use \b word boundaries
# so "ui" doesn't match "guide"/"build", "ram" doesn't match "program", etc.
CATEGORY_TAXONOMY = [
    ("AI Censorship / Safety Overreach",
     ["censor", "refus", "block", "filter", "safety", "guardrail", "jailbreak", "restrict"]),
    ("Voice / Audio Mode",
     ["voice", "audio", "tts", "speech", "advanced voice", "talk"]),
    ("AI Model Degradation",
     ["degrad", "dumber", "worse", "hallucinat", "regress", "quality drop", "stupid",
      "suck", "alzheimer", "contrary", "got worse", "why did you change", "lobotom", "dumb"]),
    ("AI API Pricing / Usage Limits",
     ["pric", "cost", "expens", "token", "rate limit", "quota", "subscription",
      "usage limit", "overpriced", "afford", "session limit", "limit", "plan", "billing"]),
    ("AI Account / UX Friction",
     ["account", "login", "phone verification", "multi-account", "scroll",
      "verification", "banned", "ban ", "appeal", "suspension", "sign in", "sign-in"]),
    ("Feature Regression / Community Backlash",
     ["bring back", "removed feature", "regression", "revert", "missing feature",
      "please add", "i want", "gone", "removed", "undo", "rewind", "restore"]),
    ("IDE / Editor Integration",
     ["ide", "lsp", "vs code", "vscode", "jetbrains", "visual studio", "extension", "editor", "cursor"]),
    ("macOS / Desktop Performance",
     ["syspolicyd", "trustd", "macos", "mac os", "cpu", "memory run", "desktop", "runaway"]),
    ("Local LLM / Deployment",
     ["ollama", "llama", "gguf", "quantiz", "quant", "vram", "gpu", "deploy",
      "vllm", "rerank", "oom", "mcp", "npu", "multimodal", "vision model"]),
    ("GitHub / CI-CD",
     ["actions", "workflow", "pipeline", "dependabot", "ci/cd", "github action"]),
    ("AI Code Quality",
     ["vibe cod", "code quality", "broken code", "bug", "correctness", "bad code"]),
    ("Supply Chain / Licensing",
     ["supply chain", "dependenc", "vulnerab", "malware", "backdoor", "licens"]),
    ("Python Packaging / DevEx",
     ["pip", "package", "install", "virtualenv", "import", "pythonpath", "module", "venv", "conda"]),
    ("Python Runtime Errors / TypeErrors",
     ["typeerror", "nonetype", "unhashable", "mro", "string indices",
      "attributeerror", "keyerror", "valueerror"]),
    ("Documentation / DevEx",
     ["no tutorial", "unclear", "confus", "missing", "docs", "tutorial", "documentation"]),
]
FALLBACK_CAT = "Other / Uncategorized"

# Existing HermesMade tools — used to flag "new tool candidates"
EXISTING_TOOL_MAP = [
    ("AI Censorship / Safety Overreach", "prompt-inspector"),
    ("AI Model Degradation", "model-watch"),
    ("AI API Pricing / Usage Limits", "api-cost-compare"),
    ("Local LLM / Deployment", "llm-deploy-helper"),
    ("AI Code Quality", "code-inspector"),
    ("Python Packaging / DevEx", "terminal-hints (pip/venv)"),
    ("Python Runtime Errors / TypeErrors", "terminal-hints (error fixes)"),
]


def word_match(text, kw):
    """Match kw in text; short pure-alpha tokens get \b word boundaries."""
    if len(kw) <= 4 and kw.isalpha():
        return re.search(r"\b" + re.escape(kw) + r"\b", text) is not None
    return kw in text


def http_json(url, timeout=15):
    req = Request(url, headers={"User-Agent": UA, "Accept": "application/json"})
    resp = urlopen(req, timeout=timeout)
    return json.loads(resp.read())


def scan_arctic_shift():
    results = []
    after = int((datetime.now() - timedelta(hours=48)).timestamp())
    for sub in SUBREDDITS:
        try:
            params = urlencode({"subreddit": sub, "limit": "75", "after": str(after), "sort": "desc"})
            data = http_json(f"{AS_POSTS}?{params}")
            for p in data.get("data", []):
                title = p.get("title", "") or ""
                selftext = (p.get("selftext", "") or "").replace("[removed]", "").replace("[deleted]", "")
                combined = f"{title} {selftext}".lower()
                matched = [s for s in PAIN_SIGNALS if s in combined]
                if matched and len(title) >= 20:
                    results.append({
                        "source": "arctic-shift", "subreddit": sub, "type": "post",
                        "body": title[:300], "content": selftext[:400],
                        "score": p.get("score", 0) or 0, "signals": matched,
                        "permalink": f"https://reddit.com{p.get('permalink','')}",
                    })
            time.sleep(0.4)
        except Exception as e:
            print(f"  ⚠ arctic-shift posts r/{sub}: {e}")
        try:
            params = urlencode({"subreddit": sub, "limit": "75", "after": str(after)})
            data = http_json(f"{AS_COMMENTS}?{params}")
            for c in data.get("data", []):
                body = (c.get("body", "") or "").replace("[removed]", "").replace("[deleted]", "")
                if len(body) < 50:
                    continue
                matched = [s for s in PAIN_SIGNALS if s in body.lower()]
                if matched:
                    results.append({
                        "source": "arctic-shift", "subreddit": sub, "type": "comment",
                        "body": body[:400], "content": "",
                        "score": c.get("score", 0) or 0, "signals": matched,
                        "permalink": f"https://reddit.com{c.get('permalink','')}",
                    })
            time.sleep(0.4)
        except Exception as e:
            print(f"  ⚠ arctic-shift comments r/{sub}: {e}")
    print(f"  Arctic Shift (Reddit mirror): {len(results)} pain signals from {len(SUBREDDITS)} subreddits")
    return results


def scan_github():
    results = []
    for repo, label in GITHUB_REPOS:
        try:
            params = urlencode({
                "q": f"repo:{repo} state:open is:issue",
                "sort": "reactions-+1", "order": "desc", "per_page": "12",
            })
            data = http_json(f"https://api.github.com/search/issues?{params}")
            for it in data.get("items", []):
                title = it.get("title", "")
                body = (it.get("body") or "")[:300]
                reactions = it.get("reactions", {}).get("total_count", 0)
                comments = it.get("comments", 0)
                results.append({
                    "source": "github", "subreddit": label, "type": "issue",
                    "body": title[:300], "content": body,
                    "score": reactions + comments,
                    "signals": ["issue"],
                    "permalink": it.get("html_url", ""),
                })
            time.sleep(1.0)
        except Exception as e:
            print(f"  ⚠ github {repo}: {e}")
    print(f"  GitHub (AI-tooling repos): {len(results)} issues")
    return results


def scan_hn():
    results = []
    try:
        params = urlencode({
            "query": "claude OR chatgpt OR llm frustrating OR broken",
            "tags": "story", "hitsPerPage": "15",
            "numericFilters": "created_at_i>%d" % int((datetime.now() - timedelta(hours=72)).timestamp()),
        })
        data = http_json(f"https://hn.algolia.com/api/v1/search?{params}")
        for hit in data.get("hits", []):
            title = hit.get("title", "") or ""
            matched = [s for s in PAIN_SIGNALS if s in title.lower()]
            if matched:
                results.append({
                    "source": "hn", "subreddit": "hackernews", "type": "story",
                    "body": title[:300], "content": "",
                    "score": hit.get("points", 0) or 0, "signals": matched,
                    "permalink": f"https://news.ycombinator.com/item?id={hit.get('objectID','')}",
                })
    except Exception as e:
        print(f"  ⚠ hn: {e}")
    print(f"  HN Algolia: {len(results)} stories")
    return results


def classify(results):
    """First-match-wins classification + dedup by normalized prefix.
    GitHub issues are always kept (reaction-weighted, high signal);
    Reddit posts/comments must meet a score threshold to reduce noise."""
    clusters = defaultdict(list)
    seen = set()
    for r in results:
        bl = r["body"].lower()
        key = re.sub(r"\s+", " ", bl)[:55]
        if key in seen:
            continue
        seen.add(key)

        # noise gate: Reddit items below score 2 are dropped
        if r["type"] != "issue" and r["score"] < 2:
            continue

        cat = FALLBACK_CAT
        for cname, kws in CATEGORY_TAXONOMY:
            if any(word_match(bl, kw) for kw in kws):
                cat = cname
                break
        clusters[cat].append(r)
    return clusters


def existing_tool_for(category):
    for cname, tool in EXISTING_TOOL_MAP:
        if cname == category:
            return tool
    return None


def generate_report(clusters, metrics):
    today = datetime.now().strftime("%Y-%m-%d")
    total = sum(len(v) for v in clusters.values())
    L = []
    L.append(f"# Daily Pain Scan — {today}")
    L.append("")
    L.append("Auto-generated by HermesMade daily pipeline (GFW fallback mode).")
    L.append("")
    L.append("> ⚠️ **Data-source note:** `reddit.com` and `v2ex.com` are unreachable from this CN IP today. "
             "This report was sourced from the **Arctic Shift Reddit mirror** (arctic-shift.photon-reddit.com), "
             "the **GitHub API** (AI-tooling repos, reaction-sorted), and **HN Algolia**.")
    L.append("")
    L.append(f"## Summary: {total} pain signals, {len(clusters)} categories")
    L.append("")

    # Rank categories by total signal strength (sum of scores)
    ranked = sorted(clusters.items(), key=lambda x: -sum(i["score"] for i in x[1]))

    for cat, items in ranked:
        strength = sum(i["score"] for i in items)
        tool = existing_tool_for(cat)
        badge = f" 🔧 → `{tool}`" if tool else " 🆕 No tool yet"
        L.append(f"### {cat} ({len(items)} signals, {strength} total strength){badge}")
        L.append("")
        for item in sorted(items, key=lambda x: -x["score"])[:3]:
            src = item.get("subreddit", "?")
            body = item['body'][:180]
            L.append(f"> *\"{body}...\"*")
            L.append(f"> — {item['source']}/{src} ({item['score']}↑) | [link]({item['permalink']})")
            L.append("")
        L.append("")

    # New tool candidates: no existing tool + meaningful strength
    new_cats = [(c, i) for c, i in ranked
                if existing_tool_for(c) is None and sum(x["score"] for x in i) >= 200]
    if new_cats:
        L.append("## 🛠 New Tool Candidates (no existing tool, strong signal)")
        L.append("")
        for idx, (cat, items) in enumerate(new_cats, 1):
            strength = sum(i["score"] for i in items)
            top = max(items, key=lambda x: x["score"])
            L.append(f"{idx}. **{cat}** — {len(items)} signals, {strength} total strength")
            L.append(f"   Top: *\"{top['body'][:140]}...\"* ({top['score']}↑)")
            L.append("")

    L.append("## 📈 Growth Strategy Tip")
    tips = [
        "Reply to today's top pain thread on Reddit with a link to our tool",
        "Check if any of today's pain threads have >50 upvotes — those are posting opportunities",
        "Cross-post our best tool to r/coolgithubprojects",
        "Tweet about today's top finding with #AI #DevTools",
        "If a pain category hits 10+ signals in one day, build the tool immediately",
    ]
    L.append(f"💡 Today's tip: {random.choice(tips)}")
    L.append("")

    if metrics:
        L.append("## 📊 Repo Metrics")
        L.append(f"⭐ {metrics.get('stars',0)} stars | 🍴 {metrics.get('forks',0)} forks | 👁 {metrics.get('views',0)} views")
        L.append("")

    L.append("---")
    L.append(f"*Next scan: tomorrow ~{datetime.now().strftime('%H:%M')}*")
    return "\n".join(L)


def main():
    print("=" * 60)
    print("  HermesMade GFW Fallback Scan")
    print(f"  {datetime.now().strftime('%Y-%m-%d %H:%M')}")
    print("=" * 60)

    print("\n🔍 Scanning Arctic Shift (Reddit mirror)...")
    results = scan_arctic_shift()
    print("\n🐙 Scanning GitHub AI-tooling repos...")
    results += scan_github()
    print("\n🟠 Scanning HN Algolia...")
    results += scan_hn()

    print("\n📊 Classifying...")
    clusters = classify(results)

    data_path = os.path.join(DATA_DIR, f"fallback-scan-{datetime.now().strftime('%Y%m%d')}.json")
    with open(data_path, "w") as f:
        json.dump({"results": results, "clusters": {k: len(v) for k, v in clusters.items()}}, f, indent=2)
    print(f"  Raw data → {data_path}")

    # Metrics via gh CLI
    metrics = {"stars": 0, "forks": 0, "views": 0}
    try:
        raw = subprocess.run(["gh", "repo", "view", "minirr890112-byte/HermesMade",
                              "--json", "stargazerCount,forks", "-q",
                              ".stargazerCount, .forks.totalCount"],
                             capture_output=True, text=True).stdout.strip()
        parts = [p.strip() for p in raw.split(",")]
        if len(parts) == 2:
            metrics["stars"] = int(parts[0] or 0)
            metrics["forks"] = int(parts[1] or 0)
    except Exception as e:
        print(f"  ⚠ metrics stars/forks: {e}")

    report = generate_report(clusters, metrics)
    report_path = os.path.join(REPO_DIR, "DAILY-REPORT.md")
    with open(report_path, "w") as f:
        f.write(report)
    print(f"\n📝 Report → {report_path}")

    # Push to GitHub
    print("\n📤 Pushing to GitHub...")
    os.chdir(REPO_DIR)
    subprocess.run(["git", "pull", "--rebase"], capture_output=True)
    subprocess.run(["git", "add", "DAILY-REPORT.md"])
    subprocess.run(["git", "commit", "-m", f"report: daily pain scan {datetime.now().strftime('%Y-%m-%d')}"], capture_output=True)
    push = subprocess.run(["git", "push"], capture_output=True, text=True)
    if push.returncode == 0:
        print("   ✅ Pushed to GitHub")
    else:
        print(f"   ⚠ Push: {push.stderr[:200]}")

    ranked = sorted(clusters.items(), key=lambda x: -sum(i["score"] for i in x[1]))
    total = sum(len(v) for v in clusters.values())
    print("\n" + "=" * 60)
    print(f"  Done. {total} signals, {len(clusters)} categories.")
    for cat, items in ranked[:5]:
        strength = sum(i["score"] for i in items)
        print(f"    • {cat}: {len(items)} signals, {strength} strength")
    print("=" * 60)


if __name__ == "__main__":
    main()
