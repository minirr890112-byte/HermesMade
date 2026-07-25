#!/bin/bash
# r/learnpython Pain Point Terminal Hint — generated 2026-07-26
# Source: Pullpush API (May 2025 data) — reddit-scan-anon pipeline
# Categories: API (9), Tooling (4), Environment (3), UX (2), Docs (1)

echo '╔══════════════════════════════════════════════════╗'
echo '║    🐍 r/learnpython Pain Points — Terminal Hint  ║'
echo '╚══════════════════════════════════════════════════╝'
echo ''
echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
echo '📌 Pain #1: Dropna() is not working, can you tell me why?'
echo '   ↑3 | https://reddit.com/r/learnpython/comments/1kopfc4/dropna_is_not_working_can_you_tell_me_why/'
echo ''
echo '💡 pandas dropna() returns a NEW DataFrame by default — it doesn't modify the original!

🔧 Quick fix: df = df.dropna()   OR   df.dropna(inplace=True)

🪤 Common trap: df.dropna()  # does nothing unless you reassign or use inplace=True'
echo ''
echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
echo '📌 Pain #2: pygame not working — ModuleNotFoundError: No module named 'p'
echo '   ↑1 | https://reddit.com/r/learnpython/comments/1kprxpg/pygame_not_working/'
echo ''
echo '💡 You might be installing pygame for one Python and running with another!

🔧 Check which Python you're using:
   which python3 && python3 --version
   python3 -m pip install pygame

🪤 Common trap: Python 3.13 may not have pre-built wheels for pygame — try Python 3.11 or 3.12'
echo ''
echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
echo '📌 Pain #3: Error running code — python.exe: can't open file 'hello.py':'
echo '   ↑3 | https://reddit.com/r/learnpython/comments/1kp1hye/error_running_code/'
echo ''
echo '💡 VS Code runs scripts from your workspace root, not the file's directory.

🔧 In VS Code: Open the folder containing hello.py FIRST (File → Open Folder), then run.
   OR: cd into the right directory in terminal first:
   cd path/to/your/script && python hello.py

🪤 Common trap: Relative file paths in your script break if you run from wrong directory'
echo ''
echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
echo ''
echo '📊 Scan stats: 100 posts scanned, 19 pain posts found'
echo '📁 Categories: API 47% | Tooling 21% | Env 16% | UX 11% | Docs 5%'
echo '⏰ Data window: May 2025 (Pullpush — Reddit API blocked in sandbox)'
echo ''
echo '💬 Join the discussion at: https://reddit.com/r/learnpython'