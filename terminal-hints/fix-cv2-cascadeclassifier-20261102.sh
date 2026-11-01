#!/bin/sh
# fix-cv2-cascadeclassifier.sh — fix "AttributeError: module 'cv2' has no attribute 'CascadeClassifier'"
# Usage: ./fix-cv2-cascadeclassifier.sh [--check]
# Safe for beginners • POSIX-compliant • Idempotent
#
# Root cause: a dummy `cv2` package (or conflicting opencv-python /
# opencv-contrib-python install) shadows the real OpenCV bindings, so the
# CascadeClassifier attribute is missing. This script removes the bad installs
# and installs the official `opencv-python` package, then verifies the fix.
set -e

echo "==> OpenCV CascadeClassifier fix — resolves 'module cv2 has no attribute CascadeClassifier'"

# Prerequisites
if ! command -v python3 >/dev/null 2>&1; then
  echo "✗ python3 not found. Install Python 3 first, then re-run this script."
  exit 1
fi

# Check-only mode: diagnose without changing anything
if [ "${1:-}" = "--check" ]; then
  echo "→ Diagnosis:"
  python3 - <<'PY'
try:
    import cv2
    print(f"   cv2 version: {cv2.__version__}")
    print(f"   cv2 location: {cv2.__file__}")
    print(f"   has CascadeClassifier: {hasattr(cv2, 'CascadeClassifier')}")
except Exception as e:
    print(f"   cv2 import error: {e}")
PY
  echo "→ If CascadeClassifier is missing, run this script WITHOUT --check to fix."
  exit 0
fi

# Remove the dummy `cv2` package and conflicting installs (safe to re-run).
# `|| true` keeps the script going when a package was never installed.
echo "→ Removing conflicting OpenCV packages (cv2, opencv-python, opencv-contrib-python)..."
python3 -m pip uninstall -y cv2 opencv-python opencv-contrib-python >/dev/null 2>&1 || true

echo "→ Installing the official opencv-python bindings..."
python3 -m pip install --user opencv-python

echo "→ Verifying CascadeClassifier is now available..."
python3 - <<'PY'
import cv2
assert hasattr(cv2, "CascadeClassifier"), "CascadeClassifier still missing!"
print(f"✓ Done! OpenCV {cv2.__version__} installed.")
print(f"  CascadeClassifier available: {cv2.CascadeClassifier}")
PY

echo "✓ Fixed. Restart your terminal/editor, then re-run your script."
echo "  Quick test: python3 -c \"import cv2; print(cv2.CascadeClassifier)\""
