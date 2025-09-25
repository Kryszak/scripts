#!/bin/bash

LIMIT=80

echo "Setting battery charge limit to $LIMIT%"
echo "$LIMIT" | sudo tee /sys/class/power_supply/BAT0/charge_stop_threshold >/dev/null
