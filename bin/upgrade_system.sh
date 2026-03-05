#!/usr/bin/env bash
set -e

echo '+++ System Upgrades'

if [[ "$INSIDE_TEST" == 'true' ]]; then
    sudo apt-get update
    sudo apt-get install -y needrestart
    export NEEDRESTART_MODE=a
fi

sudo apt-get update
sudo apt-get dist-upgrade -y
sudo apt-get autoremove -y
sudo apt-get autoclean

if ! sudo snap refresh; then
    echo 'Failed to refresh snap packages, quitting snap-store and trying again.'
    snap-store --quit
    sudo snap refresh
fi

echo 'System Upgraded successfully.'
