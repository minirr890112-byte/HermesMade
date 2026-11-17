#!/usr/bin/env bash
#
# =============================================================================
#  Terminal Hint: Fix "numpy build fails" on macOS (uv + Homebrew)
#  ---------------------------------------------------------------------------
#  Recurring pain (r/learnpython, seen again 2026-11-13):
#    uv/pip builds numpy from source and fails:
#      fatal error: 'atomic.h'   file not found
#      fatal error: 'ostream.h'  file not found
#      fatal error: 'cstddef.h'  file not found
#
#  Root cause: no prebuilt wheel exists for a very new CPython (3.14/3.15), so
#  numpy compiles C++ locally and needs Apple's libc++ headers from the Xcode
#  Command Line Tools SDK. They go "missing" when (a) the Xcode license was
#  never accepted, (b) the active developer dir points at a deleted SDK, or
#  (c) CLT are partially installed.
#
#  This hint CONSOLIDATES + EXTENDS the earlier numpy-macos hints with the
#  single most common silent root cause: the Xcode license-acceptance step.
#
#  Source: https://www.reddit.com/r/learnpython/comments/1xvb0ub/
#  Run:    bash hermes-hint-numpy-macos-clt-20261118.sh
# =============================================================================
set -uo pipefail

c_yellow='\033[1;33m'; c_green='\033[1;32m'; c_red='\033[1;31m'; c_reset='\033[0m'
say()  { printf "${c_yellow}==>${c_reset} %s\n" "$*"; }
ok()   { printf "${c_green}OK${c_reset}  %s\n" "$*"; }
warn() { printf "${c_red}!!${c_reset}  %s\n" "$*"; }

if [[ "$(uname -s)" != "Darwin" ]]; then
  warn "This fix targets macOS (current: $(uname -s))."
  warn "Linux: sudo apt-get install build-essential python3-dev"
  exit 1
fi

MISSING_CLT=0; SDK_BROKEN=0

# 1. DIAGNOSE
say "Diagnosing Xcode Command Line Tools (CLT)..."
dev_dir="$(xcode-select -p 2>/dev/null || true)"
if [[ -z "$dev_dir" ]]; then
  warn "No active developer directory -> CLT missing/unlinked."
  MISSING_CLT=1
else
  ok "Active developer directory: $dev_dir"
fi

sdk_path="$(xcrun --show-sdk-path 2>/dev/null || true)"
if [[ -z "$sdk_path" ]]; then
  warn "xcrun cannot resolve SDK (license not accepted or SDK missing)."
  SDK_BROKEN=1
else
  ok "SDK path: $sdk_path"
  if [[ -f "$sdk_path/usr/include/c++/v1/cstddef" || -f "$sdk_path/usr/include/c++/4.2.1/cstddef" ]]; then
    ok "C++ stdlib headers present."
  else
    warn "C++ headers NOT found under SDK include dir."
    SDK_BROKEN=1
  fi
fi

# 2. FIX
say "Applying fixes (some need sudo)..."
if [[ "$MISSING_CLT" == "1" ]]; then
  say "Installing Xcode Command Line Tools (GUI prompt appears)..."
  xcode-select --install || true
  warn "Click 'Install' in the dialog, then re-run this script."
  exit 0
fi

# 2a. Accept license — the #1 silent breaker for xcrun/clang.
say "Accepting Xcode license (sudo)..."
if sudo xcodebuild -license accept >/dev/null 2>&1; then
  ok "License accepted."
else
  warn "Manual: sudo xcodebuild -license accept"
fi

# 2b. Reset broken developer dir.
if [[ "$SDK_BROKEN" == "1" ]]; then
  say "Resetting developer directory..."
  sudo xcode-select --reset >/dev/null 2>&1 \
    || sudo xcode-select -s /Library/Developer/CommandLineTools
  ok "Developer directory reset."
fi

# 3. VERIFY the compiler can find <cstddef>/<atomic>
say "Verifying C++ headers resolve..."
printf '#include <cstddef>\n#include <atomic>\nint main(){return 0;}\n' > /tmp/_hermes_clt_check.cpp
if c++ /tmp/_hermes_clt_check.cpp -o /tmp/_hermes_clt_check 2>/tmp/_hermes_clt_check.err; then
  ok "c++ compiles using <cstddef>/<atomic>."
else
  warn "c++ still fails. Output:"
  cat /tmp/_hermes_clt_check.err
  warn "Stale env vars override the SDK — clear them and rebuild:"
  warn "  unset SDKROOT CPLUS_INCLUDE_PATH CXXFLAGS"
fi
rm -f /tmp/_hermes_clt_check.cpp /tmp/_hermes_clt_check /tmp/_hermes_clt_check.err

# 4. RETRY the build
say "Retrying the numpy build..."
if command -v uv >/dev/null 2>&1; then
  uv pip install numpy 2>&1 | tail -n 20 && ok "numpy installed via uv." \
    || warn "Still failing: rm -rf .venv && uv venv && uv pip install numpy"
elif command -v pip3 >/dev/null 2>&1; then
  pip3 install numpy 2>&1 | tail -n 20 && ok "numpy installed via pip3." \
    || warn "Still failing — see fallback hints above."
else
  warn "No uv/pip3 found. Run: uv pip install numpy"
fi

say "Done. Remaining cause is usually a stale SDKROOT/CPLUS_INCLUDE_PATH."
