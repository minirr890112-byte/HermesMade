#!/bin/sh
# hermes-hint-numpy-sklearn-fix.sh — Fix "TypeError: Too few arguments for numpy.complexfloating"
# Usage: sh hermes-hint-numpy-sklearn-fix.sh
# Safe for beginners • POSIX-compliant • Idempotent • No sudo required
set -e

echo "==> NumPy / scikit-learn version-mismatch fixer"
echo "    Fixes: TypeError: Too few arguments for numpy.complexfloating"
echo "    (importing sklearn right after: pip install scikit-learn)"

if ! command -v python3 >/dev/null 2>&1; then
  echo "✗ python3 not found — install Python 3.10+ first."
  exit 1
fi

echo ""
echo "→ Installed versions:"
python3 -m pip list 2>/dev/null | grep -iE "^(numpy|scikit-learn|scikit)" || echo "   (numpy / scikit-learn not found)"

echo ""
echo "→ Cause: NumPy 2.x changed 'complexfloating' into a generic type,"
echo "  which breaks older scikit-learn releases. Upgrading both fixes the import."
echo ""
echo "→ Applying fix (user-level, no sudo):"
python3 -m pip install --upgrade pip
python3 -m pip install --upgrade numpy scikit-learn

echo ""
echo "→ If your project needs NumPy 1.x (very old code), pin it instead:"
echo "    python3 -m pip install 'numpy<2'"

echo ""
echo "✓ Done. Re-run 'import sklearn' to confirm the error is gone."
