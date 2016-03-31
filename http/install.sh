#!/bin/sh

# Enable network time
timedatectl set-ntp true

# Set timezone to New York
timedatectl set-timezone America/New_York

# to create the partitions programatically (rather than manually)
# we're going to simulate the manual input to fdisk
# The sed script strips off all the comments so that we can 
# document what we're doing in-line with the actual commands
# Note that a blank line (commented as "defualt" will send a empty
# line terminated with a newline to take the fdisk default.
sed -e 's/\t\([\+0-9a-zA-Z]*\)[ \t].*/\1/' << EOF | fdisk /dev/sda
	n # new partition
	p # primary partition
	1 # partition number 1
	  # First sector
	  # Last sector
	a # Make the partition bootable
	w # write the partition table
EOF

# Format our new partition as ext4 and mount it to /mnt
mkfs.ext4 /dev/sda1
mount /dev/sda1 /mnt

# Copy chroot script to new root
cp chroot.sh /mnt/chroot.sh

# Copy keys to new root
cp vagrant.pub /mnt/

# Filter mirrorlist for just US mirrors
wget -O /etc/pacman.d/mirrorlist https://www.archlinux.org/mirrorlist/all/
awk -v GG="United States" '{if(match($0,GG) != "0")AA="1";if(AA == "1"){if( length($2) != "0"  )print substr($0,2) ;else AA="0"} }' \
 /etc/pacman.d/mirrorlist > /etc/pacman.d/mirrorlist.backup

# Rank mirrors
rankmirrors -n 6 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist

# Install base packages
pacstrap /mnt base base-devel

# Generate fstab
genfstab -p /mnt >> /mnt/etc/fstab

# Change root to /mnt and run the chroot.sh script
arch-chroot /mnt /bin/bash chroot.sh

reboot
