#!/bin/bash -xe

if [[ ! $INSIDE_SCRIPT ]]; then
    echo 'Please run with the installer script. Exiting ...'
    exit
fi

# Validate input parameters
#   (1) File path for swapfile
#   (2) Maximum size of swapfile
#   (2) Swappiness (default is 60 for most Linux distros)
if [[ (! "$1") || (! "$2") || (! "$3") ]]; then
    echo 'Missing expected input parameter(s). Exiting ...'
    exit
fi

# Configure Swapfile
echo 'Configuring Swapfile'

# View current swaps
# cat /proc/swaps
# grep swap /etc/fstab

# Disable current swap
sudo swapoff "$1"
# Remove current swap
sudo rm -f "$1"

# Create new swap
sudo fallocate -l "$2" "$1"
sudo chmod 600 "$1"
sudo mkswap "$1"

# Enable new swap
sudo swapon "$1"

# View current swapiness
# cat /proc/sys/vm/swappiness

# Update swappiness
sudo sysctl 'vm.swappiness='"$3"
