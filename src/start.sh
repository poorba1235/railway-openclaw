#!/bin/bash
set -e

# Create a 512MB swap file in /data (persistent volume) if not present
if [ ! -f /data/swapfile ]; then
  echo "[start.sh] Creating 512MB swapfile in /data..."
  # 512MB ensures we don't fill the entire 1GB volume (leaving ~500MB for app data)
  dd if=/dev/zero of=/data/swapfile bs=1M count=512
  chmod 600 /data/swapfile
  mkswap /data/swapfile
fi

# Enable swap (best effort, requires privileges usually)
echo "[start.sh] Enabling swap..."
swapon /data/swapfile || echo "[start.sh] Failed to enable swap (permission denied?)"

# Start the application
echo "[start.sh] Starting server..."
exec node src/server.js
