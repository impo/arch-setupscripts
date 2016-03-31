#!/bin/sh

# Install guest utils package
sudo pacman -S --noconfirm --needed virtualbox-guest-utils linux-headers nfs-utils

# Enable modules
sudo systemctl enable vboxservice

# Set up folder sharing
sudo gpasswd -a vagrant vboxsf
