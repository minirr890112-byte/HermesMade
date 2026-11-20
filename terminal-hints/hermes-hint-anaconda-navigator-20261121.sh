#!/bin/sh
# hermes-hint-anaconda-navigator.sh — Fix "Anaconda Navigator won't open / not responding"
# Usage: run this from the Anaconda Prompt (Start menu) on Windows:
#   sh hermes-hint-anaconda-navigator-20261121.sh
# Safe for beginners • POSIX-compliant • Idempotent • No sudo, nothing destructive
#
# Recurring pain (r/learnpython, 2026-11-20):
#   Double-clicking Anaconda Navigator does nothing — no splash, no window.
#   "I've been using Anaconda without any issue ... it won't respond."
#   Most common on Windows after a Windows Update or an interrupted conda update.
#
# Root causes, most common first:
#   1. Corrupted Navigator config/state (~/.anaconda/navigator) after an update.
#   2. Stale conda in the `base` env (Navigator needs an up-to-date base conda).
#   3. Lingering package caches/locks left by a killed update.
set -u

echo "==> Anaconda Navigator fixer — 'Navigator won't open / not responding'"

# 1. Locate conda (Anaconda Prompt already has it on PATH; fall back to common roots)
CONDA="conda"
if ! command -v conda >/dev/null 2>&1; then
  for c in "$HOME/anaconda3/Scripts/conda.exe" "$HOME/miniconda3/Scripts/conda.exe" \
           "/c/ProgramData/Anaconda3/Scripts/conda.exe" "/c/ProgramData/Anaconda3/condabin/conda.bat" \
           "/opt/anaconda3/bin/conda" "$HOME/anaconda3/bin/conda" "$HOME/miniconda3/bin/conda"; do
    if [ -f "$c" ]; then CONDA="$c"; break; fi
  done
fi

if [ "$CONDA" = "conda" ] && ! command -v conda >/dev/null 2>&1; then
  echo "✗ Could not find conda. Open the 'Anaconda Prompt' from the Start menu and run this script there."
  exit 1
fi
echo "→ Using conda: $CONDA"

# 2. Reset Navigator state (fixes the silent 'nothing happens' launch)
echo "→ Resetting Anaconda Navigator state (fixes corrupted config)..."
"$CONDA" run -n base anaconda-navigator --reset >/dev/null 2>&1 || \
  anaconda-navigator --reset >/dev/null 2>&1 || \
  echo "   (--reset not available in this conda; continuing)"

# 3. Update base conda (a stale base conda is the #1 cause after a Windows update)
echo "→ Updating conda in the base environment..."
"$CONDA" update -n base -c defaults conda -y

# 4. Clean package caches (safe — removes only cached tarballs, never environments)
echo "→ Cleaning package caches (safe)..."
"$CONDA" clean --all -y

# 5. Relaunch
echo "✓ Done. Trying to launch Anaconda Navigator now..."
( "$CONDA" run -n base anaconda-navigator >/dev/null 2>&1 || anaconda-navigator >/dev/null 2>&1 ) &

cat <<'EOF'

If Navigator still won't open, try (in Anaconda Prompt):
  1. conda install -n base -c defaults anaconda-navigator   # reinstall Navigator itself
  2. conda update --all -y                                  # update every package
  3. conda info                                             # verify the base env is intact

Still stuck? The cause is likely Windows Defender/antivirus quarantine or a broken
.condarc — check:
  conda config --show-sources
  conda config --set auto_activate_base true
EOF
