#!/bin/sh

# Set hostname to "vagrant"
echo vagrant > /etc/hostname

# Set localtime to EDT
ln -s /usr/share/zoneinfo/America/New_York /etc/localtime

# Uncomment en_US.UTF-8 line in locale.gen and set locale
sed -i '/#en_US\.UTF-8 UTF-8/s/^#//g' /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf

# Create initramdisk
mkinitcpio -p linux

# Set root password
echo "root:vagrant" | chpasswd

# Install ssh tools and bootloader package
pacman -S --noconfirm openssh grub sudo

# Install bootloader
grub-install --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

# Create vagrant user and set pass
useradd -m vagrant
echo "vagrant:vagrant" | chpasswd

# Add vagrant entry for sudoers
echo "vagrant ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

exit
