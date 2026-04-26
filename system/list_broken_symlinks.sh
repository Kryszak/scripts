#!/bin/bash

echo "Broken symlinks found on system:"
sudo find / -type d \( -path "/dev" -o -path "/proc" -o -path "/run" -o -path "/sys" \) -prune -o -xtype l -print
