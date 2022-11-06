#!/bin/bash -e

function exit_with_failure () { echo 'Failed to configure Swapfile.'; exit 1; }

if [[ ! $INSIDE_SCRIPT ]]; then
    echo 'Please run with the installer script.'
    exit_with_failure
fi

# Validate input parameters
#   (1) File path for swapfile
#   (2) Maximum size of swapfile
#   (2) Swappiness (default is 60 for most Linux distros)
if [[ (! "$1") || (! "$2") || (! "$3") ]]; then
    echo 'Missing expected input parameter(s).'
    exit_with_failure
fi

# Configure Swapfile
echo '~~~ Configuring Swapfile'

# View current swaps
# cat /proc/swaps
# grep swap /etc/fstab

# Disable current swap and remove the file
( sudo swapoff "$1" \
  && sudo rm -f "$1"
) || exit_with_failure

# Create new swap
( sudo fallocate -l "$2" "$1" \
  && sudo chmod 600 "$1" \
  && sudo mkswap "$1"
) || exit_with_failure

# Enable new swap
sudo swapon "$1" \
|| exit_with_failure

# View current swapiness
# cat /proc/sys/vm/swappiness

# Update swappiness
sudo sysctl 'vm.swappiness='"$3" \
|| exit_with_failure
