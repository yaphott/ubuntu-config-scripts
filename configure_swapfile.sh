#!/bin/bash -xe

# Configure swapfile

swap_file='/swapfile'
swap_size='12g'
swap_swappiness='90'

# View current swaps
# cat /proc/swaps
# grep swap /etc/fstab

# Disable swap
sudo swapoff "$swap_file"
# Remove swap
sudo rm "$swap_file"

# Create swap
sudo fallocate -l "$swap_size" "$swap_file"
sudo chmod 600 "$swap_file"
sudo mkswap "$swap_file"
# Enable swap
sudo swapon $swap_file

# View current swapiness
# cat /proc/sys/vm/swappiness

# Update swappiness
sudo sysctl 'vm.swappiness='"$swap_swappiness"
