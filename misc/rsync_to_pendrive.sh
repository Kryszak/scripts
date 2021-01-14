#!/bin/bash
# export RSYNC_TARGET=<pendrive mount point>
rsync --modify-window 1 -avP --no-o --no-p --no-g --delete ~/Dokumenty ~/Obrazy ~/storage "${RSYNC_TARGET}"
