#!/bin/bash -e

function exit_with_failure () { echo 'Failed to configure Swapfile.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

# Validate input parameters
#   (1) File path for swapfile
#   (2) Maximum size of swapfile
#   (2) Swappiness (default is 60 for most Linux distros)
if [[ (! "$1") || (! "$2") || (! "$3") ]]; then
    echo 'Missing expected input parameter(s).'
    exit_with_failure
fi

echo '~~~ Configuring Swapfile'

# View current swaps
# cat /proc/swaps
# grep swap /etc/fstab

# Disable and delete all current swaps
declare -a swapfiles
while read -r line; do
    swapfiles+=("$line")
done < <(grep swap /etc/fstab | awk '{print $1}')
if [[ "${#swapfiles[@]}" -gt 0 ]]; then
    for swapfile in "${swapfiles[@]}"; do
        if [[ ! -f "$swapfile" ]]; then
            echo 'Failed to find swapfile: '"$swapfile"'.'
            exit_with_failure
        fi
        sudo swapoff "$swapfile" || exit_with_failure
        sudo rm "$swapfile" || exit_with_failure
    done
fi

# Create new swap
( sudo touch "$1" \
    && sudo fallocate -l "$2" "$1" \
    && sudo chmod 600 "$1" \
    && sudo mkswap "$1"
) || exit_with_failure

# Enable new swap
sudo swapon "$1" || exit_with_failure

# View current swapiness
# cat /proc/sys/vm/swappiness

# Update swappiness
sudo sysctl 'vm.swappiness='"$3" || exit_with_failure
