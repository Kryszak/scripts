#!/bin/bash

# This script cleans disk space on Arch Linux

CYAN='\033[0;36m'
NC='\033[0m'

echo "Cleaning up journal logs"
journalctl --disk-usage
sudo journalctl --vacuum-size=50M
echo "Cleaning up paru caches"
sudo paru -Sccd
sudo paccache -rvuk0
echo "Cleaning up systemd coredumps"
sudo rm -f /var/lib/systemd/coredump/*
echo "Cleaning up spotify cache"
rm -rf ~/.cache/spotify/*
echo "Cleaning up cargo cache"
rm -rf ~/.cargo/registry/*
echo -e "${CYAN}Packages not used by any other package:${NC}"
echo ""
pacman -Qdt || true

