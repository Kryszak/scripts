#!/bin/bash
set -e

BOLD="\033[1m"
NC="\033[0m"
DELETE_LATEST_SNAPSHOT_THRESHOLD=3

echo -e "${BOLD}Backing up user files${NC}"
./rsync_to_pendrive.sh

echo -e "${BOLD}Creating new system snapshot${NC}"
sudo timeshift --create

SNAPSHOT_COUNT=$(sudo timeshift --list | awk '/------------------------------------------------------------------------------/{y=1;next}y' | grep . | wc -l)
if [[ $SNAPSHOT_COUNT -ge $DELETE_LATEST_SNAPSHOT_THRESHOLD ]]; then
	echo -e "${BOLD}Clearing oldest snapshot${NC}"
	sudo timeshift --delete --snapshot $(sudo timeshift --list | grep "0    >" | grep -Eo "[0-9]{4}-[0-9]{2}-[0-9]{2}_[0-9]{2}-[0-9]{2}-[0-9]{2}")
else
	echo -e "${BOLD}Less than ${DELETE_LATEST_SNAPSHOT_THRESHOLD} snapshots present, no cleanup${NC}"
fi

echo -e "${BOLD}Present snapshots${NC}"
sudo timeshift --list
