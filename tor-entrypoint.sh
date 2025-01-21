#!/bin/ash

SOCKS_PORT=${SOCKS_PORT:-0.0.0.0:9100}
TOR_CONTROL_PORT=${TOR_CONTROL_PORT:-0.0.0.0:9051}
CONTROL_PASSWORD=${CONTROL_PASSWORD:-$(head -c 100 /dev/urandom | sha256sum | cut -b 1-32)}
HASHED_CONTROL_PASSWORD=${HASHED_CONTROL_PASSWORD:-$(su-exec nobody tor --hash-password "$CONTROL_PASSWORD")}
SKIP_CONFIG=${SKIP_CONFIG:-false}

TORRC_CONFIG_PATH="/etc/tor/torrc"

if [ "$SKIP_CONFIG" = "false" ] || [ ! -f "$TORRC_CONFIG_PATH" ]; then
    echo "Setting up Tor configuration..."

    cp /etc/tor/torrc.sample $TORRC_CONFIG_PATH

    if grep -q "#SOCKSPort 192.168.0.1:9100" "$TORRC_CONFIG_PATH"; then
        sed -i "s|#SOCKSPort 192.168.0.1:9100|SOCKSPort $SOCKS_PORT|" "$TORRC_CONFIG_PATH"
    fi

    if grep -q "#ControlPort 9051" "$TORRC_CONFIG_PATH"; then
        sed -i "s|#ControlPort 9051|ControlPort $TOR_CONTROL_PORT|" "$TORRC_CONFIG_PATH"
    fi
#HashedControlPassword 16:872860B76453A77D60CA2BB8C1A7042072093276A3D701AD684053EC4C
    if grep -q "#HashedControlPassword" "$TORRC_CONFIG_PATH"; then
        sed -i "s|#HashedControlPassword 16:872860B76453A77D60CA2BB8C1A7042072093276A3D701AD684053EC4C|HashedControlPassword $HASHED_CONTROL_PASSWORD|" "$TORRC_CONFIG_PATH"
        echo "Control Port Password Hash: $HASHED_CONTROL_PASSWORD"
        echo "Control Port Password: $CONTROL_PASSWORD"
    fi
fi

exec su-exec nobody tor 