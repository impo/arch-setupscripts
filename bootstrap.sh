#!/bin/sh

# Install git
sudo pacman -S --noconfirm git

# Ensure ssh directories exist
mkdir -p /home/vagrant/.ssh/authorized_keys
cd /home/vagrant

# Make sure ssh directories have correct permissions
chmod 700 /home/vagrant/.ssh
chmod 600 /home/vagrant/.ssh/authorized_keys

# Move keys into proper directory
sudo mv /vagrant /home/vagrant/.ssh/authorized_keys
sudo mv /vagrant.pub /home/vagrant/.ssh/authorized_keys

# Take ownership of keys
sudo chown vagrant /home/vagrant/.ssh/authorized_keys/vagrant
sudo chown vagrant /home/vagrant/.ssh/authorized_keys/vagrant.pub

echo "UseDNS no" >> /home/vagrant/.ssh/config

sudo echo -e "[archlinuxfr]\nServer = http://repo.archlinux.fr/$arch" >> /etc/pacman.conf
