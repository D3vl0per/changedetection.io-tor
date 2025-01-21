#!/bin/ash

TOR_SERVICE_HOST=${TOR_SERVICE_HOST:-tor}
TOR_SERVICE_PORT=${TOR_SERVICE_PORT:-9051}
CONTROL_PASSWORD=${CONTROL_PASSWORD}
SKIP_CONFIG=${SKIP_CONFIG:-false}

VANGUARDS_CONFIG=${VANGUARDS_CONFIG:-/opt/vanguards/vanguards.conf}

if [ "$SKIP_CONFIG" = "false" ] || [ ! -f "$VANGUARDS_CONFIG" ]; then
    echo "Setting up Vanguards configuration..."

    cp /opt/vanguards/vanguards-example.conf $VANGUARDS_CONFIG

    if [ -z "$CONTROL_PASSWORD" ]; then
        echo "ERROR: CONTROL_PASSWORD is not set"
        exit 1
    fi
    echo "Control Port Password: $CONTROL_PASSWORD"

    sed -i "s|control_ip = 127.0.0.1|control_ip = $TOR_SERVICE_HOST|" "$VANGUARDS_CONFIG"
    sed -i "s|control_port = |control_port = $TOR_SERVICE_PORT|" "$VANGUARDS_CONFIG"
    sed -i "s|control_pass = |control_pass = $CONTROL_PASSWORD|" "$VANGUARDS_CONFIG"

fi

source /opt/vanguards/vanguardenv/bin/activate
cd /opt/vanguards
# The Control Password somehow cannot be declared in the vanguards.conf file
vanguards --control_pass $CONTROL_PASSWORD