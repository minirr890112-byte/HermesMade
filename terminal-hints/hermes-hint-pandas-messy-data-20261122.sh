#!/bin/sh
# hermes-hint-pandas-messy-data-20261122.sh — audit a messy CSV before you clean it
# Usage: ./hermes-hint-pandas-messy-data-20261122.sh [file.csv]
# Safe for beginners • POSIX-compliant • Read-only (never modifies your data)
set -e

CSV="${1:-}"

if [ -z "$CSV" ]; then
  echo "==> pandas-messy-data audit — see what's actually wrong with your CSV"
  echo "    Usage: $0 your_data.csv"
  echo ""
  echo "    CSVs in this folder:"
  command -p ls -1 ./*.csv 2>/dev/null || echo "    (none found)"
  exit 0
fi

if [ ! -f "$CSV" ]; then
  echo "✗ File not found: $CSV"
  echo "  Usage: $0 your_data.csv"
  exit 1
fi

# Interpreter detection (macOS may need bare `python`)
PY=python3
if [ "$(uname)" = "Darwin" ]; then
  command -v python3 >/dev/null 2>&1 || PY=python
fi
command -v "$PY" >/dev/null 2>&1 || {
  echo "✗ No Python 3 found. Install it first: https://python.org"
  exit 1
}

# pandas prerequisite check
"$PY" -c "import pandas" 2>/dev/null || {
  echo "✗ pandas is not installed."
  echo "  Fix: $PY -m pip install pandas"
  exit 1
}

"$PY" - "$CSV" <<'PY'
import sys
import pandas as pd
from collections import Counter

path = sys.argv[1]
print("=" * 62)
print(f"DATA AUDIT: {path}")
print("=" * 62)

try:
    df = pd.read_csv(path)
except Exception as e:
    print(f"✗ Could not read as comma-separated CSV: {e}")
    print("  Try: pd.read_csv(path, sep=';', encoding='latin-1')  # European/legacy files")
    sys.exit(1)

print(f"\nShape: {df.shape[0]:,} rows x {df.shape[1]} columns")
print(f"Memory: {df.memory_usage(deep=True).sum()/1e6:.1f} MB")

# 1. 'Unnamed' columns (malformed / stray-delimiter headers)
unnamed = [c for c in df.columns if str(c).startswith("Unnamed")]
if unnamed:
    print(f"\n⚠ {len(unnamed)} 'Unnamed' column(s) — header likely has a stray delimiter:")
    for c in unnamed:
        print(f"    - {c!r}")
    print("  Fix: pd.read_csv(path, index_col=0)  OR re-export without the extra column")

# 2. Missing values
missing = df.isna().sum()
pct = (df.isna().mean() * 100).round(1)
report = pd.DataFrame({"missing": missing, "pct": pct})
report = report[report["missing"] > 0].sort_values("missing", ascending=False)
print(f"\nMissing values: {int(df.isna().sum().sum()):,} cells across {len(report)} column(s)")
for col, row in report.head(15).iterrows():
    print(f"    {str(col)!r}: {int(row['missing']):,} missing ({row['pct']}%)")
if len(report) > 15:
    print(f"    ... and {len(report) - 15} more columns with missing data")

# 3. dtype overview
print("\nColumn types:")
for col in df.columns:
    print(f"    {str(col)!r}: {df[col].dtype}  ({df[col].nunique()} unique)")

# 4. Mixed date-format heuristic (object columns only)
print("\nDate-like column check:")
found = False
for col in df.select_dtypes(include="object").columns:
    sample = df[col].dropna().astype(str).head(200)
    if sample.empty:
        continue
    shapes = Counter(
        "".join("d" if ch.isdigit() else ("s" if ch in "-/.: " else "x") for ch in s)
        for s in sample
    )
    if len(shapes) > 1 and any("d" in k for k in shapes):
        print(f"    ⚠ {str(col)!r} looks like dates in MULTIPLE formats ({len(shapes)} patterns)")
        print("      Fix: pd.to_datetime(df[col], format='mixed')  # pandas 2.0+")
        found = True
        break
if not found:
    print("    (no obvious mixed-format date columns)")

# 5. Duplicate rows
dupes = int(df.duplicated().sum())
if dupes:
    print(f"\n⚠ {dupes:,} duplicate row(s). Fix: df.drop_duplicates(inplace=True)")

print("\n" + "=" * 62)
print("HOW TO KNOW WHEN TO STOP CLEANING")
print("=" * 62)
print("Rule of thumb: clean only what your *specific question* needs.")
print("  1. Pick ONE question you want to answer from the data")
print("  2. Keep only the columns you'll use:  df = df[['a','b','c']]")
print("  3. Drop missing only for the columns in your query:")
print("       df = df.dropna(subset=['col_i_need'])")
print("  4. Run your analysis; if the result looks sane, STOP.")
print("You don't need a perfect dataset — you need a usable one.")
PY
