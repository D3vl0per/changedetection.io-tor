#!/bin/ash

PRIVOXY_PORT=${PRIVOXY_PORT:-8118}
TOR_SERVICE_HOST=${TOR_SERVICE_HOST:-tor}
TOR_SERVICE_PORT=${TOR_SERVICE_PORT:-9100}
SKIP_CONFIG=${SKIP_CONFIG:-false}

PRIVOXY_CONFIG_PATH="/etc/privoxy/config"

if [ "$SKIP_CONFIG" = "false" ] || [ ! -f "$PRIVOXY_CONFIG_PATH" ]; then
    echo "Setting up Privoxy configuration..." 
    touch /etc/privoxy/config
    echo "forward-socks5t / $TOR_SERVICE_HOST:$TOR_SERVICE_PORT ." >> /etc/privoxy/config
    echo "listen-address 0.0.0.0:$PRIVOXY_PORT" >> /etc/privoxy/config
fi

privoxy --no-daemon $PRIVOXY_CONFIG_PATH