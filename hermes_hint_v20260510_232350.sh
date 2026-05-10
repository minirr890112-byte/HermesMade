#!/bin/bash
# Hermes Auto-Generated Terminal Hint
# Generated: 2026-05-10 23:23:50 UTC
# Pain: What's the simplest way to distribute a Python app to normal users?
# Category: Environment
# Score: 87 | Comments: 49
# Viability Score: 8.8/10
# Source: https://reddit.com/r/learnpython/comments/1t7y5m7/whats_the_simplest_way_to_distribute_a_python_app/

set -euo pipefail

echo ""
echo "============================================="
echo "  Python App Distribution Quick Guide"
echo "  Trigger: python app|distribut|packaging|pyinstaller|setup.py"
echo "============================================="
echo ""
echo "=== Option 1: PyInstaller (simplest, single executable) ==="
echo ""
echo "pip install pyinstaller"
echo "pyinstaller --onefile your_app.py"
echo ""
echo "  Output: dist/your_app (or .exe on Windows)"
echo "  Best for: quick distribution, no Python required on target"
echo ""
echo "=== Option 2: Briefcase (native OS installers) ==="
echo ""
echo "pip install briefcase"
echo "briefcase new"
echo "briefcase create"
echo "briefcase build"
echo "briefcase package"
echo ""
echo "  Output: .app (macOS), .msi (Windows), .AppImage (Linux)"
echo "  Best for: polished distribution, auto-updates"
echo ""
echo "=== Option 3: Nuitka (compiled, faster) ==="
echo ""
echo "pip install nuitka"
echo "nuitka --standalone your_app.py"
echo ""
echo "  Output: your_app.dist/ folder with optimized binary"
echo "  Best for: performance-sensitive apps"
echo ""
echo "=== Quick Comparison ==="
echo "  PyInstaller: Easiest, .exe/.app, larger file size"
echo "  Briefcase:  Native installers, best UX for end users"
echo "  Nuitka:     Fastest execution, C-compiled"
echo ""
echo "Source: https://reddit.com/r/learnpython/comments/1t7y5m7/"
echo "Hint delivered via Hermes Agent Pipeline [auto]"
