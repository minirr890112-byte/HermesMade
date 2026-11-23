#!/bin/sh
# hermes-hint-winerror-4551-torch-20261124.sh
# Fix `OSError: [WinError 4551] An Application Control policy has blocked this file`
# when importing torch (or other compiled libraries) on Windows 11.
#
# Usage (Git Bash / Anaconda Prompt / WSL is NOT needed — run in Git Bash):
#   sh hermes-hint-winerror-4551-torch-20261124.sh
# Safe for beginners • POSIX-compliant • Idempotent • No sudo • Nothing destructive
#
# Recurring pain (r/learnpython, 2026-11-20):
#   "It was working fine last night. Windows updated before shutdown. Now:
#      OSError: [WinError 4551] An Application Control policy has blocked this file.
#    on `import torch`."
#
# Root cause: Windows 11 Smart App Control (SAC) / Windows Defender Application
# Control (WDAC) blocks unsigned or "untrusted" native binaries (the .dll/.pyd
# files torch bundles). A Windows Update can re-enable SAC or refresh the trust
# database, so a previously-working `import torch` suddenly raises WinError 4551.
#
# Fix, in order of preference:
#   1. Reinstall torch from a trusted, signed wheel (clears the untrusted flag).
#   2. If you trust the source, turn Smart App Control OFF (or "Evaluation").
#   3. On a managed/lab machine, ask IT — the policy may be centrally enforced.
#
# Source: https://www.reddit.com/r/learnpython/comments/1y0b5qj/
set -u

echo "==> WinError 4551 fixer — 'An Application Control policy has blocked this file'"
echo ""

# --- 0) Confirm platform ------------------------------------------------------
case "$(uname -s 2>/dev/null)" in
  MINGW*|MSYS*|CYGWIN*) : ;;
  *)
    echo "i This error is Windows-specific. The torch-reinstall step (3) still"
    echo "  applies on macOS/Linux, but the Smart App Control steps (1 & 4) do not."
    ;;
esac

# --- 1) Show Smart App Control (SAC) state ------------------------------------
echo "-> [1/4] Checking Smart App Control (SAC) state..."
SAC_STATE="unknown"
if command -v reg.exe >/dev/null 2>&1; then
  # VerifiedAndReputablePolicyState: 0=Off, 1=On, 2=Evaluation
  VAL="$(reg.exe query 'HKLM\SYSTEM\CurrentControlSet\Control\CI\Policy' \
        /v VerifiedAndReputablePolicyState 2>/dev/null | tr -d '\r' \
        | awk '/VerifiedAndReputablePolicyState/ {print $NF}')"
  case "$VAL" in
    0) SAC_STATE="OFF";;
    1) SAC_STATE="ON  (this is likely blocking torch)";;
    2) SAC_STATE="Evaluation mode";;
    *) SAC_STATE="(registry key not present or unreadable: '$VAL')";;
  esac
else
  SAC_STATE="(reg.exe not found -- run this from Git Bash, or use PowerShell: Get-MpComputerStatus)"
fi
echo "   Smart App Control = $SAC_STATE"
echo ""

# --- 2) Locate Python + confirm the torch failure -----------------------------
echo "-> [2/4] Locating Python and checking torch..."
PY=""
for c in python python3 py; do
  if command -v "$c" >/dev/null 2>&1; then PY="$c"; break; fi
done
if [ -z "$PY" ]; then
  echo "   x No Python on PATH. Install from https://www.python.org/downloads/ or activate your conda env."
else
  echo "   Interpreter: $PY ($($PY --version 2>&1))"
  TORCH_VER="$($PY -c 'import torch; print(torch.__version__)' 2>&1)"
  case "$TORCH_VER" in
    *WinError\ 4551*|*Application\ Control*)
      echo "   x Confirmed: 'import torch' raises WinError 4551.";;
    *2.[0-9]*|*1.[0-9]*)
      echo "   v torch $TORCH_VER imports fine now (already resolved?).";;
    *)
      echo "   i torch not importable / not installed: $TORCH_VER";;
  esac
fi
echo ""

# --- 3) Reinstall torch (preferred fix) ---------------------------------------
echo "-> [3/4] Reinstalling torch from PyPI (trusted, signed wheels)..."
echo "   This forces a fresh signed copy so Windows trusts it again."
echo "   NOTE: this is a large download (a few hundred MB, more for CUDA builds)."
if [ -n "${PY:-}" ]; then
  "$PY" -m pip install --upgrade --force-reinstall torch
else
  echo "   (skipped -- no Python found)"
fi
echo ""

# --- 4) Optional: disable Smart App Control -----------------------------------
echo "-> [4/4] To disable Smart App Control (only if you trust your sources):"
echo "   Windows 11: Settings > Privacy & security > Windows Security"
echo "              > App & browser control > Smart App Control settings > Off"
echo "   (On managed machines this may be greyed out -- contact IT.)"
echo ""
echo "   Quick PowerShell check:"
echo "     Get-MpComputerStatus | Select SmartAppControlExpiration, SmartAppControlState"
echo ""

echo "v Done. Re-run your script. If the error persists:"
echo "  * Confirm Defender hasn't quarantined torch's .dll files:"
echo "      Get-MpThreatDetection | Select -First 5"
echo "  * On a lab/corporate machine the WDAC policy is centrally managed --"
echo "    the fix must come from your IT admin."
