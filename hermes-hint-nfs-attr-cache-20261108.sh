#!/bin/sh
# hermes-hint-nfs-attr-cache.sh — Fix "Path.exists() returns False" on NFS mounts
# Usage: sh hermes-hint-nfs-attr-cache.sh [path]   (default: current directory)
# Safe for beginners • POSIX sh • Idempotent • advisory only (no sudo, nothing destructive)
set -u

TARGET="${1:-.}"

echo "==> NFS attribute-cache hint"
echo "    Symptom: Python Path.exists() / os.path.exists() reports False for a"
echo "    file that is actually present and readable on an NFS share."
echo

# --- 1. Detect NFS + show mount options ---
echo "→ 1) Is '$TARGET' on an NFS mount?"
if [ "$(uname)" = "Darwin" ]; then
    if mount | grep -qi nfs; then
        echo "    NFS mount detected:"
        mount | grep -i nfs | sed 's/^/      /'
    else
        echo "    No NFS mount found for '$TARGET'."
        echo "    If the files live on NFS, run this on the host/container that serves them."
        exit 0
    fi
else
    FSTYPE=$(df -T "$TARGET" 2>/dev/null | awk 'NR==2 {print $2}')
    if [ "$FSTYPE" = "nfs" ] || [ "$FSTYPE" = "nfs4" ]; then
        echo "    '$TARGET' is on an NFS ($FSTYPE) mount:"
        grep -E ' (nfs|nfs4) ' /proc/mounts 2>/dev/null | sed 's/^/      /'
    else
        echo "    '$TARGET' is on '$FSTYPE', not NFS."
        echo "    This hint targets NFS attribute caching — your issue may be elsewhere."
        exit 0
    fi
fi
echo

# --- 2. Explain the root cause ---
echo "→ 2) Root cause: the NFS client caches file attributes."
echo "    Path.exists() → os.stat() → stat(2) → NFS GETATTR, which is served from"
echo "    the client attribute cache (defaults: acregmin≈3s, acdirmin≈30s on Linux)."
echo "    A freshly created file can look 'absent' for up to ~30 seconds."
echo

# --- 3. The fix (advisory — you run these with your own privileges) ---
echo "→ 3) Fix: stop (or shorten) attribute caching on the NFS client mount."
echo "    Option A — disable attribute caching entirely (matches the 'noac' you tested):"
echo "      mount -o remount,actimeo=0  <server>:<export>  <mountpoint>"
echo
echo "    Option B — NFSv4 only: keep the data cache, never cache attributes:"
echo "      mount -o remount,lookupcache=none  <mountpoint>"
echo
echo "    Note: 'noac'/'actimeo=0' works but costs performance on busy shares."
echo "          'lookupcache=none' is the more granular NFSv4 alternative."
echo
echo "    ⚠  If the API runs inside a CONTAINER (Docker/K8s/systemd with private"
echo "       mounts), its NFS mount is a SEPARATE cache from the host's. That is why"
echo "       'ls' on the host works but os.listdir() inside the API does not — apply"
echo "       the remount option to the *container's* mount, not the host's."
echo

# --- 4. Python-side workaround (no remount required) ---
echo "→ 4) Python workaround — force a fresh stat instead of trusting Path.exists():"
cat <<'PYEOF'
    import os, time
    def exists_fresh(path: str, retries: int = 5, delay: float = 0.5) -> bool:
        """NFS-safe existence check that forces attribute revalidation."""
        path = os.path.abspath(path)
        parent = os.path.dirname(path)
        for _ in range(retries):
            os.listdir(parent)              # READDIR revalidates the directory
            try:
                os.stat(path)               # fresh GETATTR on the file
                return True
            except FileNotFoundError:
                time.sleep(delay)
        return False
PYEOF
echo
echo "✓ Done. Re-run this script any time the symptom reappears."
