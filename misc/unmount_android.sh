#!/bin/bash

MOUNT_POINT=~/mnt

fusermount -u $MOUNT_POINT
rm -rf $MOUNT_POINT
