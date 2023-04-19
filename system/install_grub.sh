#!/bin/bash
echo "Installing grub"
sudo grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
echo "Generating new grub configuration"
sudo grub-mkconfig -o /boot/grub/grub.cfg
