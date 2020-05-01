#!/bin/bash

# Script for rescue Manjaro system procedure (allows to execute commands from live boot of other linux system)

# system partition
TARGETDEV="/dev/sda6"
# mount point
TARGETDIR="/mnt"

mount $TARGETDEV $TARGETDIR
mount -t proc /proc $TARGETDIR/proc
mount --rbind /sys $TARGETDIR/sys
mount --rbind /dev $TARGETDIR/dev

cp /etc/hosts $TARGETDIR/etc
cp /etc/resolv.conf $TARGETDIR/etc
chroot $TARGETDIR rm /etc/mtab 2> /dev/null
chroot $TARGETDIR ln -s /proc/mounts /etc/mtab

chroot $TARGETDIR
