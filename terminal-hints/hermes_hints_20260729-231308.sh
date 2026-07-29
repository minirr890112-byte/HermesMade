#!/usr/bin/env bash
# ==============================================================================
# Hermes Terminal Hints — r/learnpython Pain Point Fixes
# Generated: $(date -u +"%Y-%m-%dT%H:%M:%SZ") (UTC)
# Source: r/learnpython RSS scan + pain-classifier + pain-value-judgment
# Repo: HermesMade
#
# HINT #1 (PRIMARY): PEP 668 "externally-managed-environment" fix
#   Trigger: stderr contains "externally-managed-environment"
#   Pain: pip install fails on modern Python (Homebrew/Debian)
#   Fix: use venv or pipx
#
# HINT #2: PRAW MoreComments object confusion
#   Trigger: stderr contains "MoreComments"
#   Pain: trying to iterate comments but getting MoreComments objects
#   Fix: call replace_more() first
#
# HINT #3: Web crawler works locally, fails on production
#   Trigger: stderr contains "403" or "connection refused" near "playwright" or "requests"
#   Pain: anti-bot detection blocking production traffic
#   Fix: realistic headers + exponential backoff
#
# HINT #4: Clear/overwrite printed text in Python console
#   Trigger: user searches "clear printed text python" or "overwrite print"
#   Pain: don't know how to do loading animations
#   Fix: use \r carriage return + sys.stdout.flush()
# ==============================================================================

set -euo pipefail

OS_TYPE="$(uname -s)"

# ============================================================================
# HINT #1: PEP 668 externally-managed-environment (PRIMARY - HIGH PRIORITY)
# This error occurs on Python 3.11+ when pip is blocked by system package managers
# (Homebrew on macOS, apt on Debian/Ubuntu)
# ============================================================================

hint_pep668() {
    cat << 'HERMES_HINT'

╔══════════════════════════════════════════════════════════════════════════╗
║  🐍 PEP 668: "externally-managed-environment" Error — Quick Fix        ║
╚══════════════════════════════════════════════════════════════════════════╝

This error means your system Python is managed by a package manager
(Homebrew, apt) and blocks raw `pip install` to prevent breaking system tools.

══════════════ FIX (2 options) ═══════════════

  OPTION A — Virtual Environment (RECOMMENDED):
    python3 -m venv .venv
    source .venv/bin/activate  # Windows: .venv\Scripts\activate
    pip install YOUR_PACKAGE

  OPTION B — pipx (for CLI tools like black, ruff, mypy):
    pipx install YOUR_CLI_TOOL

══════════════ ONE-LINER (macOS/Linux) ═══════════════

  python3 -m venv .venv && source .venv/bin/activate && pip install YOUR_PACKAGE

══════════════ WHY THIS HAPPENS ═══════════════

  PEP 668 (Python 3.11+) added --break-system-packages as an escape hatch
  but marked it as unsafe. Your Python came from Homebrew or apt, which
  don't want raw pip to clobber their managed packages.

  DO NOT use --break-system-packages unless you understand the risks.
  It can silently break system scripts that depend on specific package
  versions.

══════════════ PERSISTENT SETUP ═══════════════

  Add to ~/.bashrc or ~/.zshrc to auto-activate per project:
    alias mkvenv='python3 -m venv .venv && echo "source .venv/bin/activate"'

HERMES_HINT
}

# ============================================================================
# HINT #2: PRAW MoreComments object
# ============================================================================

hint_praw_comments() {
    cat << 'HERMES_HINT'

╔══════════════════════════════════════════════════════════════════════════╗
║  📡 PRAW: "MoreComments" Object — Fix in 2 Lines                      ║
╚══════════════════════════════════════════════════════════════════════════╝

PRAW paginates comment trees for performance. `MoreComments` objects are
placeholders, not comments. You need to expand them:

══════════════ THE FIX ═══════════════

  submission.comments.replace_more(limit=None)
  all_comments = submission.comments.list()

  for comment in all_comments:
      print(comment.body)

══════════════ DETAILS ═══════════════

  - limit=None    → expand all "load more" links (slower but complete)
  - limit=5       → expand only top 5 per level (faster, most content)
  - .list()       → flattened DFS list of all comments
  - You can also iterate: for comment in submission.comments:

══════════════ FULL EXAMPLE ═══════════════

  import praw
  reddit = praw.Reddit(client_id='...', client_secret='...', user_agent='...')
  submission = reddit.submission(url='https://reddit.com/r/.../...')
  submission.comments.replace_more(limit=10)
  for comment in submission.comments.list():
      print(f"[{comment.score}] {comment.body[:200]}")

HERMES_HINT
}

# ============================================================================
# HINT #3: Web crawler fails on production (anti-bot detection)
# ============================================================================

hint_crawler_production() {
    cat << 'HERMES_HINT'

╔══════════════════════════════════════════════════════════════════════════╗
║  🕷️ Web Crawler Works Locally, Fails on Production — Fix             ║
╚══════════════════════════════════════════════════════════════════════════╝

Production servers/cloud IPs are often blocked by anti-bot systems.
Here's what to add:

══════════════ FIX: Realistic Headers + Retry ═══════════════

  import time, random
  import requests

  headers = {
      'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36',
      'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
      'Accept-Language': 'en-US,en;q=0.9',
      'Accept-Encoding': 'gzip, deflate, br',
      'DNT': '1',
      'Connection': 'keep-alive',
  }

  session = requests.Session()
  session.headers.update(headers)

  for attempt in range(3):
      try:
          resp = session.get(url, timeout=30)
          resp.raise_for_status()
          break
      except (requests.RequestException, ConnectionError) as e:
          if attempt == 2:
              raise
          delay = 2 ** attempt + random.uniform(0, 1)
          print(f"Retry {attempt+1}/3 in {delay:.1f}s...")
          time.sleep(delay)

══════════════ FOR PLAYWRIGHT USERS ═══════════════

  browser = await playwright.chromium.launch(
      headless=True,
      args=['--no-sandbox', '--disable-blink-features=AutomationControlled']
  )
  context = await browser.new_context(
      user_agent='Mozilla/5.0 ... (same as above)',
      viewport={'width': 1920, 'height': 1080},
  )

══════════════ ADDITIONAL TIPS ═══════════════

  - Rotate User-Agents (use fake-useragent library)
  - Add random delays between requests (0.5-3s)
  - Use residential proxies if needed (respect rate limits!)
  - Respect robots.txt — getting blocked is a signal to slow down
  - Try playwright-stealth for advanced anti-detection

HERMES_HINT
}

# ============================================================================
# HINT #4: Clear/overwrite printed text in Python console
# ============================================================================

hint_console_overwrite() {
    cat << 'HERMES_HINT'

╔══════════════════════════════════════════════════════════════════════════╗
║  📺 Clear/Overwrite Console Text in Python — Loading Animations       ║
╚══════════════════════════════════════════════════════════════════════════╝

Use \r (carriage return) to go back to the start of the current line
without advancing to a new line:

══════════════ SIMPLE LOADING BAR ═══════════════

  import time, sys

  for i in range(101):
      print(f'\rProgress: [{"#" * (i // 5)}{"." * (20 - i // 5)}] {i}%', end='')
      sys.stdout.flush()
      time.sleep(0.05)
  print()  # final newline

══════════════ SPINNER ═══════════════

  import time, sys, itertools

  spinner = itertools.cycle(['|', '/', '-', '\\'])
  for i in range(40):
      print(f'\r{next(spinner)} Working...', end='')
      sys.stdout.flush()
      time.sleep(0.1)
  print('\rDone!           ')

══════════════ KEY FUNCTIONS ═══════════════

  \r           → carriage return (moves cursor to column 0)
  end=''       → suppress newline (print normally adds \n)
  flush()      → force output immediately (sys.stdout is buffered)
  \033[K       → ANSI: clear from cursor to end of line

══════════════ CROSS-PLATFORM NOTE ═══════════════

  \r works everywhere (Windows, macOS, Linux).
  \033[K needs ANSI support (built-in on macOS/Linux/Win10+).

HERMES_HINT
}

# ============================================================================
# MAIN: Detection and dispatch
# ============================================================================

main() {
    local last_stderr="${1:-}"

    if [[ -z "$last_stderr" ]]; then
        # No input — print ALL hints
        echo ""
        hint_pep668
        echo ""
        hint_praw_comments
        echo ""
        hint_crawler_production
        echo ""
        hint_console_overwrite
        return
    fi

    # Pattern matching
    if echo "$last_stderr" | grep -qi "externally-managed-environment"; then
        hint_pep668
    elif echo "$last_stderr" | grep -qi "morecomments"; then
        hint_praw_comments
    elif echo "$last_stderr" | grep -qiE "403|connection refused|connectionerror" && echo "$last_stderr" | grep -qiE "playwright|requests\.|crawl|scrap"; then
        hint_crawler_production
    else
        echo "No matching hint found for this error. Showing all hints:"
        hint_pep668
        echo ""
        hint_praw_comments
    fi
}

# Run
main "$@"
