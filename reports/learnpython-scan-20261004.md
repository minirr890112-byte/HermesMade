# r/learnpython Pain-Point Scan — 2026-10-04

## Scan metadata
- **Source**: Arctic Shift API (Reddit mirror, no auth)
- **Subreddit**: r/learnpython
- **Posts fetched**: 100 | **Comments fetched**: 100
- **Freshness**: ~1.8h to ~6.4 days old (median ~3.4 days)
- **Pain-signal matches (broad)**: 45 (posts 28, comments 17)
- **Specific tech-error matches**: 22

## Category breakdown
| Category | Count | Notes |
|----------|-------|-------|
| Environment | 21 | pip/PATH/venv/install failures |
| Tooling | 15 | IDE/terminal/interpreter confusion |
| Docs | 6 | "how do I learn / get unstuck" |
| API | 1 | library behavior |
| Other | 2 | misc |

## Top pain points (terminal-fixable)

### 1. "python/pip not recognized / not on PATH" — HIGHEST SIGNAL ⭐
Multiple independent signals this scan:
- *"pip install tensorflow doesn't seem to work"* → user hit **"WARNING: The script ... is installed in '...\Python314\Scripts' which is not on PATH."**
- Top comment explains the **py.exe launcher vs python.exe on PATH** breakdown.
- Recurring theme: **pip installs fine but the tool command is "not recognized"**.
- Evidence: https://reddit.com/r/learnpython/comments/1wwlaie/

### 2. Terminal vs Python confusion
Beginners run shell commands (`cd`, `pip install`) *inside* the Python REPL:
- *"Why i cannot run anything in the terminal"* → `cd` typed into `>>>` prompt.
- Comment: *"You don't run python commands in the terminal. You pip install things there."*
- Evidence: https://reddit.com/r/learnpython/comments/1wwpotl/

### 3. Pydroid/Android pip install Traceback
`pip install pytest` crashes on Pydroid (aarch64-linux-android) with an ImportError deep in pip internals. Platform-specific, low general fixability.

### 4. VS Code "Run Python File" 5s startup delay
*"VS Code 'Run Python File' takes 5 seconds while running the same file in terminal is instant"* (7 upvotes).

## Pain-value judgment (top pain #1)
| Axis | Verdict |
|------|---------|
| ✅ Reasonableness | ✓ Safe — diagnostic-only; recommends `python -m pip`; no side effects; version-agnostic |
| 🎯 Reachability | Channel: **terminal-hint** · Trigger: **on-error** ("command not found / not recognized") |
| 🧠 Teachability | Design: **auto-paste-hint** — prints the exact fix command; immediate feedback |

## Deliverable
- `hermes-hint-pip-not-on-path-20261004.sh` → committed to `minirr890112-byte/HermesMade`
