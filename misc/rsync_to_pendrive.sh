#!/bin/bash
# export RSYNC_TARGET=<pendrive mount point>
rsync --modify-window 2 -avP --no-o --no-p --no-g ~/Dokumenty ~/Obrazy ~/storage ${RSYNC_TARGET} --delete
