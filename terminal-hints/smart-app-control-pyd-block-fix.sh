#!/bin/sh
# hermes-hint.sh — Diagnose & fix "Smart App Control / App Control blocking Python .pyd/.dll"
# Usage: ./smart-app-control-pyd-block-fix.sh
# Safe for beginners • POSIX-compliant • Idempotent • No destructive ops
#
# Fixes: import pandas (numpy/pyproj/etc.) raising
#   ImportError: DLL load failed  /  "Operation did not complete because the file
#   contains a virus or potentially unwanted software"
# caused by Windows 11 Smart App Control (SAC) / Windows Defender Application
# Control (WDAC) blocking unsigned compiled extension files (.pyd/.dll), and
# PyInstaller-built .exe files being flagged as malware.
set -e

echo "==> Smart App Control blocking Python compiled extensions — diagnostic"

OS="$(uname -s 2>/dev/null || uname)"

case "$OS" in
  Darwin)
    echo "→ Detected macOS. Checking Gatekeeper + quarantine flags on native extensions..."
    if command -p spctl >/dev/null 2>&1; then
      spctl --status 2>/dev/null || true
    fi
    echo "→ Checking quarantined .so/.dylib files (xattr com.apple.quarantine):"
    command -p python3 -c "import site,sys; print('\\n'.join(site.getsitepackages()))" 2>/dev/null | while read -r dir; do
      [ -d "$dir" ] && command -p find "$dir" -name '*.so' -o -name '*.dylib' 2>/dev/null | head -n 200
    done | while read -r f; do
      if command -p xattr "$f" 2>/dev/null | command -p grep -q com.apple.quarantine; then
        echo "    ⚠ quarantined: $f"
        echo "      fix: xattr -d com.apple.quarantine \"$f\"   (then re-import)"
      fi
    done
    echo "✓ Done. If you see 'killed: 9' or 'malware' on import, clear quarantine on the .so above."
    ;;

  Linux)
    echo "→ Detected Linux. Checking for AppArmor / SELinux denials on Python imports..."
    if [ -d /sys/kernel/security/apparmor ] && command -p aa-status >/dev/null 2>&1; then
      aa-status 2>/dev/null | command -p grep -i -E 'denied|complain' || echo "    No AppArmor denials found."
    fi
    if command -p getenforce >/dev/null 2>&1; then
      echo "    SELinux mode: $(command -p getenforce 2>/dev/null)"
    fi
    echo "    If a .so import is denied, check: dmesg | grep -i 'apparmor\\|denied'"
    echo "✓ Done. Most Linux import failures are missing dev headers, not App Control."
    ;;

  MINGW*|MSYS*|CYGWIN*|*_NT*)
    echo "→ Detected Windows (Git Bash / MSYS). Checking Smart App Control state..."
    if command -v powershell.exe >/dev/null 2>&1; then
      echo "→ Smart App Control / Defender status:"
      powershell.exe -NoProfile -Command \
        "Get-MpComputerStatus | Select-Object -Property SmartAppControlState,RealTimeProtectionEnabled | Format-List" 2>/dev/null || true
    else
      echo "    powershell.exe not found — run in PowerShell:"
      echo "      Get-MpComputerStatus | Select SmartAppControlState"
    fi
    echo ""
    echo "→ Interpreting SmartAppControlState:"
    echo "    Off         → not the cause; check your venv / DLL path instead."
    echo "    Evaluation  → you can turn it OFF: Windows Security → App & browser"
    echo "                  control → Smart App Control → Off (no admin needed)."
    echo "    On          → Windows won't let you disable it without a reset. Workarounds:"
    echo "                  (1) exclude Python site-packages from Defender scanning:"
    echo "                      Add-MpPreference -ExclusionPath (python -c \"import site; print(site.getsitepackages()[0])\")"
    echo "                  (2) reinstall Python to a non-blocked path, or"
    echo "                  (3) use signed wheels / official installers (python.org)."
    echo "→ Find the site-packages dir to exclude:"
    command -p python -c "import site; print(site.getsitepackages()[0])" 2>/dev/null || \
    command -p python3 -c "import site; print(site.getsitepackages()[0])" 2>/dev/null || true
    echo ""
    echo "✓ Done. If SmartAppControlState=Evaluation, disable it and re-run your import."
    ;;

  *)
    echo "→ Unknown platform ($OS). For Windows, run this in Git Bash or PowerShell:"
    echo "    Get-MpComputerStatus | Select SmartAppControlState"
    ;;
esac

echo ""
echo "Still stuck? Reproduce the exact error and post it with: python -c \"import pandas\" 2>&1 | tail -n 5"
