#!/bin/sh
# python-env-doctor.sh — diagnose & fix the most common beginner Python setup errors
# Usage: sh python-env-doctor.sh
# Safe for beginners • POSIX-compliant • Idempotent • No sudo, no destructive ops

echo "==> Python Env Doctor — checking your Python setup"

OS="$(uname)"
PY=""
if command -v python3 >/dev/null 2>&1; then PY="python3"
elif command -v python >/dev/null 2>&1; then PY="python"
fi

if [ -z "$PY" ]; then
  echo "✗ Python not found."
  if [ "$OS" = "Darwin" ]; then
    echo "  → macOS: xcode-select --install   (or: brew install python)"
  else
    echo "  → Linux: install via your package manager, e.g. 'apt install python3' (needs admin)"
  fi
  exit 1
fi

echo "→ Using:  $PY ($($PY --version 2>&1))"
echo "→ Path:   $(command -v "$PY")"

# 1. Virtualenv check — the #1 cause of 'externally managed' / permission errors
if [ -n "${VIRTUAL_ENV:-}" ]; then
  echo "✓ Inside a virtualenv: $VIRTUAL_ENV"
elif [ -n "${CONDA_PREFIX:-}" ]; then
  echo "✓ Inside a conda env:  $CONDA_PREFIX"
else
  echo "⚠ Not inside a virtualenv — this is the #1 cause of install failures."
  echo "  → Fix: $PY -m venv .venv && source .venv/bin/activate"
fi

# 2. pip check + python/pip mismatch
PIP=""
if command -v pip3 >/dev/null 2>&1; then PIP="pip3"
elif command -v pip >/dev/null 2>&1; then PIP="pip"
fi

if [ -z "$PIP" ]; then
  echo "✗ pip not found → run: $PY -m ensurepip --upgrade"
else
  echo "→ pip:    $($PIP --version 2>&1)"
  if $PY -m pip --version >/dev/null 2>&1; then
    echo "✓ '$PY -m pip' works — prefer it over bare 'pip'"
  fi
fi

# 3. SSL certificate check (CERTIFICATE_VERIFY_FAILED)
if $PY -c "import ssl; ssl.create_default_context()" >/dev/null 2>&1; then
  echo "✓ SSL certificates look OK"
else
  echo "✗ SSL certificate problem detected (common on macOS & conda)."
  echo "  → Fix: $PY -m pip install --upgrade certifi"
  if [ "$OS" = "Darwin" ]; then
    echo "  → macOS: run 'Install Certificates.command' inside your Python app folder"
  fi
fi

# 4. PEP 668 'externally managed environment' detection
EXTPY="$($PY -c 'import sysconfig; print(sysconfig.get_path("stdlib"))' 2>/dev/null)"
if [ -n "$EXTPY" ] && [ -f "$EXTPY/EXTERNALLY-MANAGED" ]; then
  echo "⚠ Detected PEP 668 'externally managed environment' (pip will refuse installs)."
  echo "  → Fix: use a virtualenv (step 1). Avoid --break-system-packages."
else
  echo "✓ No PEP 668 'externally managed' marker found"
fi

echo ""
echo "✓ Done. Cheat sheet:"
echo "  1) Always work in a venv:   $PY -m venv .venv && source .venv/bin/activate"
echo "  2) Install packages:        $PY -m pip install <pkg>"
echo "  3) Upgrade pip itself:      $PY -m pip install --upgrade pip"
echo "  4) If a CLI is 'not found' after install (e.g. django-admin), use:"
echo "     $PY -m <module>   (e.g. $PY -m django)  or add ~/.local/bin to your PATH"
