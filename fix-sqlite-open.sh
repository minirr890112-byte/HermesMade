#!/bin/sh
# fix-sqlite-open.sh — diagnose & fix "sqlite3.OperationalError: unable to open database file"
# Usage: sh fix-sqlite-open.sh /path/to/database.db
# Safe for beginners • POSIX-compliant • Idempotent • No sudo, no destructive ops
set -u

echo "==> SQLite 'unable to open database file' — root-cause checker"
echo ""

DB_PATH="${1:-}"

if [ -z "$DB_PATH" ]; then
  echo "Usage: sh $0 /path/to/database.db"
  echo ""
  echo "Find the path in your code after 'sqlite:///':"
  echo "    create_engine(\"sqlite:///mydb.db\")   ->  pass ./mydb.db"
  echo "    sqlite3.connect(\"data/app.db\")        ->  pass data/app.db"
  exit 1
fi

# --- 1. Relative vs absolute path -------------------------------------------
case "$DB_PATH" in
  /*) : ;;
  ~*)
    echo "⚠  Path starts with '~' — SQLite does NOT expand '~'."
    echo "   Fix: os.path.expanduser(\"$DB_PATH\") or use the full path /home/\$USER/..."
    echo ""
    ;;
  *)
    echo "⚠  Relative path detected: '$DB_PATH'"
    echo "   SQLite resolves relative paths against the CURRENT WORKING DIRECTORY,"
    echo "   NOT the script's folder. Running the script from another directory breaks it."
    echo "   Fix — build an absolute path from the script location:"
    echo "        import os; os.path.join(os.path.dirname(__file__), \"$DB_PATH\")"
    echo ""
    ;;
esac

# --- 2. Parent directory must exist -----------------------------------------
DB_DIR=$(dirname "$DB_PATH")
if [ ! -d "$DB_DIR" ]; then
  echo "✗ Parent directory does NOT exist: $DB_DIR"
  echo "   SQLite creates the file but NOT missing parent directories."
  echo "   Fix (shell):   mkdir -p \"$DB_DIR\""
  echo "   Fix (Python):  import os; os.makedirs(\"$DB_DIR\", exist_ok=True)"
  echo ""
else
  echo "✓ Parent directory exists: $DB_DIR"
fi

# --- 3. Directory / file writability ----------------------------------------
if [ -d "$DB_DIR" ] && [ ! -w "$DB_DIR" ]; then
  echo "✗ Directory is NOT writable: $DB_DIR"
  echo "   Fix: chmod u+w \"$DB_DIR\"  (or check ownership with ls -ld \"$DB_DIR\")"
  echo ""
else
  echo "✓ Directory is writable"
fi

if [ -f "$DB_PATH" ]; then
  echo "✓ Database file exists"
  [ -r "$DB_PATH" ] || echo "✗ File is not readable — fix: chmod u+r \"$DB_PATH\""
  [ -w "$DB_PATH" ] || echo "✗ File is not writable — fix: chmod u+w \"$DB_PATH\""
else
  echo "ℹ  Database file doesn't exist yet — SQLite will create it on first write,"
  echo "   but ONLY if the parent directory exists and is writable (checked above)."
fi

echo ""
echo "✓ Done. In ~90% of cases the fix is: create the parent dir + use an absolute path."
