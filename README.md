# HELIX IB Gateway

Interactive Brokers gateway service for the HELIX trading system.

## What this is

A minimal Railway-deployable wrapper around [`ghcr.io/gnzsnz/ib-gateway`](https://github.com/gnzsnz/ib-gateway),
which runs IB Gateway in a Docker container so master-bot can connect to IBKR
via the TWS API without needing a local installation.

## Railway Deployment

### 1. Create the Railway service

In your Railway project (same project as master-bot):
1. Click **+ New** → **GitHub Repo** → select `ibkr-gateway`
2. Railway auto-detects the Dockerfile and builds

### 2. Set environment variables (Railway → Variables)

| Variable | Value | Description |
|---|---|---|
| `TWS_USERID` | your IBKR username | IBKR account login |
| `TWS_PASSWORD` | your IBKR password | IBKR account password |
| `TRADING_MODE` | `paper` or `live` | Start with `paper`! |
| `VNC_PASSWORD` | any password | For VNC remote desktop |
| `TWOFA_TIMEOUT_ACTION` | `restart` | What to do if 2FA times out |
| `AUTO_RESTART_TIME` | `11:59 PM` | Daily restart to refresh session |
| `RELOGIN_AFTER_2FA_TIMEOUT` | `yes` | Auto-relogin |
| `TWS_SETTINGS_PATH` | `/home/ibgateway/Jts` | IB Gateway settings path |

### 3. Configure master-bot

In Railway → master-bot → Variables, add:

| Variable | Value |
|---|---|
| `BROKER_ADAPTER` | `ibkr` |
| `IBKR_HOST` | `ibkr-gateway.railway.internal` |
| `IBKR_PORT` | `4002` (paper) or `4001` (live) |
| `IBKR_CLIENT_ID` | `1` |
| `IBKR_ACCOUNT` | `U1234567` (your IBKR account number) |

Railway internal hostnames (`*.railway.internal`) work within the same project
without exposing the port publicly.

### 4. First login (2FA)

IB Gateway may require interactive 2FA on first boot.
Connect via VNC to approve:

1. In Railway → ibkr-gateway → Settings → Networking → add a TCP proxy on port `5900`
2. Connect with any VNC client (macOS: Finder → Go → Connect to Server → `vnc://...`)
3. Approve the 2FA prompt in the IB Gateway UI
4. After approval, remove the VNC TCP proxy (keep the port internal)

## Ports

| Port | Use |
|---|---|
| `4002` | TWS API — paper trading (master-bot connects here) |
| `4001` | TWS API — live trading |
| `5900` | VNC remote desktop (for 2FA / monitoring) |

## Monitoring

Check connection status via master-bot's health endpoint:
```
GET https://web-production-2aca3.up.railway.app/api/broker/health
```

## Important

- **Start with `TRADING_MODE=paper`** and verify HELIX connects before switching to live
- IBKR sessions expire — IB Gateway auto-restarts daily at `AUTO_RESTART_TIME`
- Do NOT add a public Railway domain to this service (API port stays internal)
