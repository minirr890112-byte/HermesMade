#!/bin/sh
# detect-module-shadow.sh — Find .py files whose names shadow Python modules
# Usage: ./detect-module-shadow.sh [directory]   (default: current directory)
# Safe for beginners • POSIX-compliant • Idempotent • Read-only
set -u

DIR="${1:-.}"

echo "==> detect-module-shadow — flagging local .py files that shadow Python modules"
echo "    Scanning directory: $DIR"
echo

if [ ! -d "$DIR" ]; then
    echo "⚠ '$DIR' is not a directory."
    exit 1
fi

# Curated list of the most common filename collisions (works with no deps).
BASE_MODULES="six
pandas
numpy
requests
random
test
email
json
csv
string
typing
collections
math
os
sys
time
re
copy
io
logging
datetime
calendar
decimal
fractions
functools
itertools
operator
pathlib
pprint
shutil
tempfile
unittest
argparse
asyncio
ctypes
hashlib
secrets
struct
uuid
warnings
weakref
bisect
heapq
array
ast
dis
inspect
traceback
codecs
zlib
gzip
sqlite3
enum
pickle
socket
statistics
threading
queue
subprocess
types
xml
http
urllib
contextlib
dataclasses"

# Best-effort enrichment with the live module list (builtins + stdlib + packages).
MODULES="$BASE_MODULES"
if command -v python3 >/dev/null 2>&1; then
    PY_MODULES="$(python3 - <<'PY' 2>/dev/null
import sys, pkgutil
names = set(sys.builtin_module_names)
names.update(getattr(sys, "stdlib_module_names", ()))
names.update(m.name for m in pkgutil.iter_modules())
for n in sorted(names):
    print(n)
PY
)"
    MODULES="$BASE_MODULES
$PY_MODULES"
fi

FOUND=0
for file in "$DIR"/*.py; do
    [ -e "$file" ] || continue
    base="${file##*/}"
    stem="${base%.py}"
    if printf '%s\n' "$MODULES" | grep -qxF -- "$stem"; then
        echo "  ⚠ $base  →  shadows the real Python module '$stem'"
        FOUND=$((FOUND + 1))
    fi
done

echo
if [ "$FOUND" -eq 0 ]; then
    echo "✓ No shadowing filenames found in $DIR."
else
    echo "✗ $FOUND filename(s) collide with installed Python modules."
    echo
    echo "  Why it breaks: Python imports your local file (six.py, pandas.py,"
    echo "  random.py, test.py, ...) BEFORE the installed package of the same"
    echo "  name, so you get ImportError / ModuleNotFoundError / IndentationError."
    echo
    echo "  Fix: rename the conflicting file, then re-run your program, e.g.:"
    echo "    mv six.py six_utils.py"
fi
