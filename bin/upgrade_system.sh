#!/bin/bash -e

echo '+++ System Upgrades'

sudo apt-get update && sudo apt-get install -y needrestart

sudo apt-get update \
    && sudo NEEDRESTART_MODE=a apt-get dist-upgrade -y \
    && sudo apt-get autoremove -y \
    && sudo apt-get autoclean

sudo snap refresh

echo 'System Upgraded successfully.'
