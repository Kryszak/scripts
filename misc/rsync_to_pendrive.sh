#!/bin/bash
# export RSYNC_TARGET=<pendrive mount point>

if [[ ! -d $RSYNC_TARGET ]]; then
  echo "Target storage is not mounted! Aborting..."
  exit -1
fi

# --modify-window 1 --no-o --no-p --no-g for fat32
rsync -avP --delete ~/Dokumenty ~/Obrazy ~/storage "${RSYNC_TARGET}"
