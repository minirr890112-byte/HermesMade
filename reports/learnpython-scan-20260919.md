# r/learnpython Pain Scan Report

**Generated:** 2026-09-18 23:07 UTC
**Source:** Reddit JSON API (native)
**Subreddit:** r/learnpython
**Data range:** 1.22h – 133.8h ago (all fresh, <6 days)

## Scan Summary

| Metric | Value |
|--------|-------|
| Posts fetched | 75 |
| Pain signals detected | 44 |

## Classification

| Category | Count |
|----------|-------|
| API | 34 |
| Environment | 6 |
| Tooling | 7 |
| Docs | 19 |
| UX | 0 |
| General | 9 |

## Top Pain Points

### 1. [API] `return "text", value` silently creates a tuple
- **Thread:** "Help! Why is my code doing this?" — **8 pts, 18 comments, 3.9h ago**
- **Symptom:** `return "Both are above 10. \n average is", average` prints as a tuple `('Both are above 10. ...', 12.5)`.
- **Fix:** use an f-string: `return f"Both are above 10. \n average is {average}"`
- **Reasonableness:** ✓ Safe | **Channel:** `web-overlay` | **Trigger:** `on-error` | **Design:** `auto-paste-hint`
- **Link:** https://reddit.com/r/learnpython/comments/1wjzhwm/help_why_is_my_code_doing_this/

### 2. [API] Passing `input` (function object) instead of calling it
- **Thread:** same as #1 — `print(check(input, input))` passes the builtin function, not its return value.
- **Fix:** `check(input(), input())` or read values before the call.
- **Reasonableness:** ✓ Safe | **Channel:** `web-overlay` | **Trigger:** `on-error`
- **Link:** https://reddit.com/r/learnpython/comments/1wjzhwm/help_why_is_my_code_doing_this/

### 3. [Environment] Shell metacharacters (`+ - * / =`) mangle CLI arguments
- **Thread:** "Stupid argparse tricks" — **3 pts, 5 comments, 5.0h ago**
- **Symptom:** running `python script.py A.csv + B.csv = C.csv` loses/rewrites `+` and `=` before Python sees them.
- **Fix:** quote each symbol (`"+"`, `"="`) or use named flags (`--op +`, `--out C.csv`).
- **Reasonableness:** ✓ Safe | **Channel:** `terminal-hint` | **Trigger:** `on-error` | **Design:** `auto-paste-hint`
- **Deliverable:** `hermes-hint-shell-args-20260919.sh` (committed this run)
- **Link:** https://reddit.com/r/learnpython/comments/1wjxoj6/stupid_argparse_tricks/

### 4. [Docs/API] `:.0f` format spec rounds instead of truncating
- **Thread:** "Regarding simple question" — **9 pts, 11 comments, 4.2d ago**
- **Symptom:** `f"{0.6548:.0f}"` → `"1"` (rounding), not `"0"` (truncation).
- **Fix:** use `int(num)`, `math.trunc(num)`, or `math.floor(num)` to truncate.
- **Reasonableness:** ✓ Safe | **Channel:** `web-overlay` | **Trigger:** `on-error`
- **Link:** https://reddit.com/r/learnpython/comments/1wgd55g/regarding_simple_question/

### 5. [Tooling] Editor choice / no autocomplete in notepad++
- **Thread:** "i need a simple code editor that works for a beginner" (+ "vscode sporadically freezing", 11c)
- **Symptom:** notepad++ doesn't autocomplete imports; VSCode freezes on long scripts.
- **Fix:** recommend VSCode + Python extension, Thonny, or PyCharm Community.
- **Reasonableness:** ✓ Safe | **Channel:** `web-overlay`
- **Link:** https://reddit.com/r/learnpython/comments/1wk2jq2/i_need_a_simple_code_editor_that_works_for_a/

### 6. [Tooling] pip vs uv vs Poetry vs pip-tools confusion
- **Symptom:** recurring "which package manager" debates; "uv is the clear winner" thread.
- **Fix:** recommend `uv` for speed/determinism; `venv + pip` for absolute beginners.
- **Reasonableness:** ⚠️ Needs guardrails (env isolation)

## Terminal Hint Deliverable
Generated and committed: **`hermes-hint-shell-args-20260919.sh`** — a POSIX-safe, idempotent,
no-sudo shell-argument inspector that shows exactly which arguments the shell mangled and
prints the corrected (quoted) invocation. Addresses pain point #3.
