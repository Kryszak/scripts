#!/bin/bash

CONFIG_FILE=$1

if [[ -z $CONFI_FILE ]]; then
	echo "Configuration file not provided!"
	exit 1
fi

nmcli connection import type wireguard file $CONFIG_FILE
