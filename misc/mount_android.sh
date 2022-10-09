#!/bin/bash

MOUNT_POINT=~/mnt

if [[ -d $MOUNT_POINT ]]; then
    echo "Mount point exists"
else
    echo "Creating mount point"
    mkdir $MOUNT_POINT
fi

aft-mtp-mount $MOUNT_POINT
