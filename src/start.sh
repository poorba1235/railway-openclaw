#!/bin/bash
set -e

# Create a 1GB swap file in the ephemeral volume if not present (Railway volumes might persist it, which is fine)
if [ ! -f /tmp/swapfile ]; then
  echo "[start.sh] Creating 1GB swapfile in /tmp..."
  dd if=/dev/zero of=/tmp/swapfile bs=1M count=1024
  chmod 600 /tmp/swapfile
  mkswap /tmp/swapfile
fi

# Enable swap (best effort, requires privileges usually)
# Railway usually allows this on their platform if user is root (which we are)
echo "[start.sh] Enabling swap..."
swapon /tmp/swapfile || echo "[start.sh] Failed to enable swap (permission denied?)"

# Start the application
echo "[start.sh] Starting server..."
exec node src/server.js
