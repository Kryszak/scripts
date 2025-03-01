#!/bin/bash

EFI_DIRECTORY="/boot"
echo "Installing grub to $EFI_DIRECTORY"
read -p "Are you sure this is correct location? [y/n] " -n 1 -r
echo    
if [[ $REPLY =~ ^[Yy]$ ]]
then
    sudo grub-install --target=x86_64-efi --efi-directory=$EFI_DIRECTORY --bootloader-id=GRUB
    echo "Generating new grub configuration"
    sudo grub-mkconfig -o "$EFI_DIRECTORY/grub/grub.cfg"
fi

