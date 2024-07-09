
#!/bin/bash -e

BOLD="\033[1m"
NC="\033[0m"

echo -e "${BOLD}Backing up user files${NC}"
./rsync_to_pendrive.sh

echo -e "${BOLD}Creating new system snapshot${NC}"
sudo timeshift --create
echo -e "${BOLD}Clearing oldest snapshot${NC}"
sudo timeshift --delete --snapshot $(sudo timeshift --list | grep "0    >" | grep -Eo "[0-9]{4}-[0-9]{2}-[0-9]{2}_[0-9]{2}-[0-9]{2}-[0-9]{2}")
