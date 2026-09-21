#!/bin/sh
# hermes-hint-python-env.sh — diagnose which Python/pip you're actually using
# Usage: sh hermes-hint-python-env.sh
# Safe for beginners • POSIX-compliant • Read-only • Idempotent • No sudo
set -u

echo "==> Python Env Check — which Python am I actually running?"

# --- 1. Locate the interpreter (bypass aliases with `command -p`) ---
echo ""
echo "── Interpreters on your PATH ──"
for c in python python3; do
  if command -p "$c" >/dev/null 2>&1; then
    printf "  %-8s -> %s\n" "$c" "$(command -p "$c")"
  else
    printf "  %-8s -> (not found)\n" "$c"
  fi
done

# --- 2. Real version + executable path (using sysconfig, the ground truth) ---
echo ""
echo "── Ground truth (what Python itself reports) ──"
if command -p python3 >/dev/null 2>&1; then
  command -p python3 - <<'PY'
import sys, sysconfig
print("  python3  ->", sys.executable)
print("  version  ->", sys.version.split()[0])
print("  is venv  ->", sys.prefix != sys.base_prefix)
print("  prefix   ->", sys.prefix)
print("  user site->", sysconfig.get_path("userbase"))
PY
fi

# --- 3. pip resolution ---
echo ""
echo "── pip resolution ──"
if command -p python3 >/dev/null 2>&1; then
  command -p python3 -m pip --version 2>/dev/null && echo "  (use: python3 -m pip ... — always matches the interpreter above)" \
    || echo "  ⚠ python3 -m pip not available — install it with: python3 -m ensurepip"
fi

# --- 4. What's installed right now (and WHERE) ---
echo ""
echo "── Packages visible to this Python ──"
if command -p python3 >/dev/null 2>&1; then
  command -p python3 -m pip list 2>/dev/null | head -n 30
  echo "  (full list: python3 -m pip list   |   save to file: python3 -m pip freeze > requirements.txt)"
fi

# --- 5. Plain-language guidance ---
echo ""
echo "── If you're confused ──"
echo "  • 'python' vs 'python3' pointing to different versions is NORMAL on macOS/Linux."
echo "    Always run code with the SAME command you install packages with."
echo "  • To be safe, use:  python3 -m pip install <pkg>   (never bare 'pip')."
echo "  • Create an isolated project env:  python3 -m venv .venv && source .venv/bin/activate"
echo "  • List packages in the ACTIVE venv:  python3 -m pip list"
echo ""
echo "✓ Done. If a package installs but 'import' still fails, re-run this script inside your venv."
