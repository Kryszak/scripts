#!/bin/bash
# export RSYNC_TARGET=<pendrive mount point>
# --no-o --no-p --no-g for fat32
rsync --modify-window 1 -avP --delete ~/Dokumenty ~/Obrazy ~/storage "${RSYNC_TARGET}"
