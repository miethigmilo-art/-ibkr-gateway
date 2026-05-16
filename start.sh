#!/bin/bash
# Start IB Gateway in background (original entrypoint)
/opt/ibc/scripts/ibcstart.sh &

# Bridge Railway's dynamic $PORT to IB Gateway API port 4002
# This satisfies Railway's TCP health check while keeping the real API on 4002
PORT=${PORT:-8080}
echo "[HELIX] Bridging Railway PORT=${PORT} -> IB Gateway :4002"

# Wait for IB Gateway to start before bridging
sleep 90
socat TCP-LISTEN:${PORT},fork,reuseaddr TCP:localhost:4002 &

# Keep container alive
wait
