#!/bin/bash -e

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

sudo snap refresh

echo 'System Upgraded successfully.'
