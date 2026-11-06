#!/bin/sh
# hermes-hint-venv-doctor.sh — Diagnose & fix "VS Code can't import my packages" (venv/interpreter mismatch)
# Usage: sh hermes-hint-venv-doctor.sh [package-name]
# Safe for beginners • POSIX-compliant • Idempotent (read-only diagnosis + guidance)

set -u

PKG="${1:-django}"
echo "==> Python environment doctor — 'why can't VS Code import ${PKG}?'"

# 1. Which python is active right now?
echo ""
echo "== Active interpreter =="
if command -v python3 >/dev/null 2>&1; then
  echo "   python3  ->  $(command -v python3)"
  python3 --version 2>&1 | sed 's/^/               /'
else
  echo "   python3 not found in PATH"
fi

# 2. Is the package importable from THIS interpreter?
echo ""
echo "== Checking '${PKG}' import =="
if python3 -c "import ${PKG}" >/dev/null 2>&1; then
  echo "   [OK] ${PKG} IS importable from the active python3."
  echo "   -> If VS Code still can't import it, point it here:"
  echo "      Cmd/Ctrl+Shift+P  ->  'Python: Select Interpreter'  ->  pick the path above"
else
  echo "   [MISS] ${PKG} NOT importable from active python3."
  echo "   -> Likely cause: shell / VS Code is using a different interpreter"
  echo "      than the environment where ${PKG} is installed."
fi

# 3. Find virtual environments in/near the project
echo ""
echo "== Virtualenvs found =="
FOUND=0
for d in .venv venv env .env; do
  if [ -f "$d/pyvenv.cfg" ] || [ -f "$d/bin/activate" ] || [ -f "$d/Scripts/activate" ]; then
    echo "   -> $d"
    FOUND=1
  fi
done
find . -maxdepth 3 -name "pyvenv.cfg" 2>/dev/null | while read -r cfg; do
  echo "   -> $(dirname "$cfg")"
done
if [ "$FOUND" -eq 0 ]; then
  echo "   (none found — create one:) "
  echo "   python3 -m venv .venv && source .venv/bin/activate && python3 -m pip install ${PKG}"
fi

# 4. For each venv, check if it actually has the package
echo ""
echo "== Where is ${PKG} installed? =="
for d in .venv venv env; do
  if [ -x "$d/bin/python" ]; then
    "$d/bin/python" -c "import ${PKG}" >/dev/null 2>&1 && echo "   [OK] $d/bin/python  has ${PKG}"
  elif [ -x "$d/Scripts/python.exe" ]; then
    "$d/Scripts/python.exe" -c "import ${PKG}" >/dev/null 2>&1 && echo "   [OK] $d/Scripts/python.exe  has ${PKG}"
  fi
done

echo ""
echo "== Fix it now =="
echo "   1. Activate the venv that has ${PKG}:"
echo "        source .venv/bin/activate            # macOS / Linux"
echo "   2. Tell VS Code to use it:"
echo "        Cmd/Ctrl+Shift+P  ->  'Python: Select Interpreter'  ->  .venv/bin/python"
echo "   3. Re-run your script."
echo ""
echo "Done. If ${PKG} still won't import, install it into the venv:"
echo "    source .venv/bin/activate && python3 -m pip install ${PKG}"
