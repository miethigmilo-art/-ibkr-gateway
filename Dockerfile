# HELIX IB Gateway — Railway Service
# Wraps ghcr.io/gnzsnz/ib-gateway with Railway-compatible configuration.
#
# This service provides the Interactive Brokers TWS API socket on port 4002 (paper)
# or 4001 (live). master-bot connects to it via Railway's internal network:
#   IBKR_HOST=ibkr-gateway.railway.internal  IBKR_PORT=4002
#
# Required env vars (set in Railway dashboard):
#   TWS_USERID        — IBKR username
#   TWS_PASSWORD      — IBKR password
#   TRADING_MODE      — paper | live
#   VNC_PASSWORD      — any password (for VNC remote desktop access)

FROM ghcr.io/gnzsnz/ib-gateway:stable

# Default to paper trading port
EXPOSE 4002 4001 5900

# Healthcheck: verify API port is listening
HEALTHCHECK --interval=30s --timeout=10s --start-period=120s --retries=3 \
  CMD nc -z localhost 4002 || exit 1
