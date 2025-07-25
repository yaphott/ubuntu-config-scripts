#!/bin/bash -e

# Validate input parameters
if [[ $# -ne 3 ]]; then
    echo 'Missing expected input parameters:'
    echo '    swapfile_path: File path for swapfile (e.g. /swapfile).'
    echo '    swapfile_max_size: Maximum size of swapfile (e.g. 512M, 1G, or 2G).'
    echo '    swapfile_swappiness: Swappiness (default is 60 for most Linux distributions).'
    echo ''
    echo 'Usage: configure_swapfile.sh <swapfile_path> <swapfile_max_size> <swapfile_swappiness>'
    exit 1
fi

swapfile_path="$1"
swapfile_max_size="$2"
swapfile_swappiness="$3"

echo '~~~ Configuring Swapfile'

if [[ -s /etc/fstab ]]; then
    echo 'Backing up /etc/fstab...'
    sudo cp /etc/fstab /etc/fstab.bak
fi
if [[ -s /etc/sysctl.conf ]]; then
    echo 'Backing up /etc/sysctl.conf...'
    sudo cp /etc/sysctl.conf /etc/sysctl.conf.bak
fi

declare -a swapfiles
while read -r line; do
    swapfiles+=("$line")
done < <(grep -E '^[^#].*swap' /etc/fstab | awk '{print $1}')
if [[ "${#swapfiles[@]}" -gt 0 ]]; then
    echo 'Disabling and deleting existing swapfiles...'
    for swapfile in "${swapfiles[@]}"; do
        if [[ ! -f "$swapfile" ]]; then
            echo 'Failed to find swapfile: '"$swapfile"'.'
            exit 1
        fi
        sudo swapoff "$swapfile"
        sudo rm "$swapfile"
    done
fi

if [[ $(tail -n +2 /proc/swaps | wc -l) -ne 0 ]]; then
    echo "Expected 0 swaps, but found $num_swaps."
    exit 1
fi

echo "Creating new swapfile: ${swapfile_path}"
sudo touch "$swapfile_path"
sudo fallocate -l "$swapfile_max_size" "$swapfile_path"
sudo chmod 600 "$swapfile_path"
sudo mkswap "$swapfile_path"

echo "Enabling new swapfile: ${swapfile_path}"
sudo swapon "$swapfile_path"

echo 'Checking swapfile configuration...'
if [[ $(tail -n +2 /proc/swaps | awk '{print $1}' | grep -c '^'"$swapfile_path"'$') -ne 1 ]]; then
    echo 'Failed to find swapfile '"$swapfile_path"' in /proc/swaps.'
    exit 1
fi
# if [[ $(cat /etc/fstab | awk '{print $1}' | grep -c '^'"$swapfile_path"'$') -ne 1 ]]; then
#     echo 'Failed to find swapfile '"$swapfile_path"' in /etc/fstab.'
#     exit 1
# fi

if [[ "$(cat /proc/sys/vm/swappiness )" -ne "$swapfile_swappiness" ]]; then
    echo 'Configuring swappiness...'
    sudo sysctl "vm.swappiness=$swapfile_swappiness"
else
    echo 'Swappiness already configured...'
fi

echo 'Checking updated swappiness...'
if [[ "$(cat /proc/sys/vm/swappiness)" -ne "$swapfile_swappiness" ]]; then
    echo 'Failed to configure swappiness.'
    exit 1
fi

echo 'Swapfile configured successfully.'
