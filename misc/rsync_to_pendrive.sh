#!/bin/bash
# export RSYNC_TARGET=<pendrive mount point>
# --modify-window 1 --no-o --no-p --no-g for fat32
rsync -avP --delete ~/Dokumenty ~/Obrazy ~/storage "${RSYNC_TARGET}"
