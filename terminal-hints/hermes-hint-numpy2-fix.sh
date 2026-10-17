#!/bin/sh
# hermes-hint-numpy2-fix.sh — Fix "TypeError: Too few arguments for numpy.complexfloating"
# Usage: ./hermes-hint-numpy2-fix.sh [--apply]
# Safe for beginners • POSIX-compliant • Idempotent • No sudo
#
# Root cause: NumPy 2.x turned abstract scalar types (np.complexfloating,
# np.float_, np.complex_, np.int_ ...) from classes into functions. Old
# scipy / scikit-learn / matplotlib builds that reference them bare raise:
#   TypeError: Too few arguments for numpy.complexfloating
# (often surfaced while importing sklearn.metrics, scipy.sparse, etc.)

set -u

APPLY=0
if [ "${1:-}" = "--apply" ] || [ "${1:-}" = "-a" ]; then
  APPLY=1
fi

PY="${PYTHON:-}"
if [ -z "$PY" ]; then
  if command -v python3 >/dev/null 2>&1; then PY=python3
  elif command -v python >/dev/null 2>&1; then PY=python
  else
    echo "✗ No Python interpreter found. Install Python 3 first." >&2
    exit 1
  fi
fi

echo "==> numpy2-fix — resolves numpy 2.x 'Too few arguments' TypeError"
echo "    (using interpreter: $PY)"

# 1. Confirm numpy is installed and capture its version
NUMPY_VER=$($PY -c 'import numpy; print(numpy.__version__)' 2>/dev/null || true)
if [ -z "$NUMPY_VER" ]; then
  echo "→ numpy is not importable in this environment."
  echo "  If you just hit the error in a notebook, the notebook may be using a"
  echo "  different interpreter than your shell. Re-run with:"
  echo "      PYTHON=/path/to/your/python $0 --apply"
  exit 2
fi

MAJOR=$(printf '%s' "$NUMPY_VER" | cut -d. -f1)
echo "→ Detected numpy $NUMPY_VER"

# 2. Only numpy 2.x exhibits this class->function breaking change
if [ "$MAJOR" != "2" ]; then
  echo "→ numpy is already on the 1.x line ($NUMPY_VER)."
  echo "  If you still see the TypeError, the offending environment is a different"
  echo "  interpreter/venv — check sys.executable inside your script/notebook."
  exit 0
fi

# 3. Diagnose: find which installed consumer packages may pull old binaries
echo "→ Checking consumers that commonly trip this error (scipy / scikit-learn):"
SCIPY_VER=$($PY -c 'import scipy; print(scipy.__version__)' 2>/dev/null || true)
SKLEARN_VER=$($PY -c 'import sklearn; print(sklearn.__version__)' 2>/dev/null || true)

[ -n "$SCIPY_VER" ]   && echo "    scipy        $SCIPY_VER"   || echo "    scipy        not installed"
[ -n "$SKLEARN_VER" ] && echo "    scikit-learn $SKLEARN_VER" || echo "    scikit-learn not installed"

# 4. Recommend the root-cause fix (two safe paths)
echo ""
echo "  FIX — pick ONE:"
echo "  ─────────────────────────────────────────────────────────────────"
echo "  (A) Downgrade numpy to the last 1.x release (most compatible):"
echo "      $PY -m pip install \"numpy<2\""
echo ""
echo "  (B) Keep numpy 2.x and upgrade the consumers to numpy-2 builds:"
echo "      $PY -m pip install -U scipy scikit-learn"
echo "  ─────────────────────────────────────────────────────────────────"
echo "  Recommendation: use (A) if your project pins TensorFlow < 2.12"
echo "  or any package with numpy<2 pins; use (B) otherwise."
echo ""

if [ "$APPLY" -eq 1 ]; then
  echo "→ --apply passed: downgrading numpy to <2 (option A, the safe default)."
  "$PY" -m pip install "numpy<2" || {
    echo "  ⚠ pip downgrade failed. Try with --user:" >&2
    echo "      $PY -m pip install --user \"numpy<2\"" >&2
    exit 1
  }
  echo "✓ Done. Verify with:"
  echo "      $PY -c 'import numpy, sklearn; print(numpy.__version__)'"
  echo "  If the import now succeeds, you're fixed."
else
  echo "→ Dry run (no changes made). Re-run with --apply to install the fix."
fi

# Idempotent: re-running with --apply when already on numpy 1.x exits 0 early.
exit 0
