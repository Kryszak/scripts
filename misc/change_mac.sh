#!/bin/bash

# Change mac address for given network interface

NET_INTERFACE=${1:-wlp3s0}
ip link set dev ${NET_INTERFACE} down
macchanger -r ${NET_INTERFACE}
ip link set dev ${NET_INTERFACE} up
