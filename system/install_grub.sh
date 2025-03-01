#!/bin/bash

set -euo pipefail

EFI_DIRECTORY="/boot"

echo "Attempting grub installation to $EFI_DIRECTORY"
echo "$EFI_DIRECTORY content:"
ls --color=auto -l $EFI_DIRECTORY
echo
echo "Target directory MUST contain 'EFI' directory and 'grub' directory"
read -p "Are you sure this is correct location? [y/n] " -n 1 -r
echo 
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "Installing grub"
    sudo grub-install --target=x86_64-efi --efi-directory=$EFI_DIRECTORY --bootloader-id=GRUB
    echo "Generating new grub configuration"
    sudo grub-mkconfig -o "$EFI_DIRECTORY/grub/grub.cfg"
else
    echo "No changes were made, aborting."
fi

