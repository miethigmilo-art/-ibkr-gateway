# HELIX IB Gateway — Railway Service
FROM ghcr.io/gnzsnz/ib-gateway:stable

# Install socat to bridge Railway's dynamic $PORT to IB Gateway port 4002
USER root
RUN apt-get update -qq && apt-get install -y --no-install-recommends socat && rm -rf /var/lib/apt/lists/*

# Startup script: launch IB Gateway + socat bridge on Railway's $PORT
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 4002 4001 5900

CMD ["/start.sh"]
