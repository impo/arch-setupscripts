#!/bin/sh

# Add archlinuxfr repo for yaourt access
echo 'echo -e "[archlinuxfr]\nServer = http://repo.archlinux.fr/\$arch" >> /etc/pacman.conf' | sudo -s

# Refresh pacman repos
sudo pacman -Syy

# Install non-community packages
sudo pacman -S --noconfirm --needed git neovim gvim rust cargo sqlite yaourt rsync

# Install community packages
yaourt -S --noconfirm vcsh
