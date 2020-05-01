#!/bin/bash

# This script cleans disk space on Manjaro Linux

set -ex
sudo journalctl --vacuum-size=50M
sudo pacman -Scc
sudo rm -f /var/lib/systemd/coredump/*

sudo paccache -r
sudo paccache -ruk0

rm -rf ~/.cache/spotify/Storage/*
