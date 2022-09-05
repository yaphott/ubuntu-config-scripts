#!/bin/bash -xe

if [[ ! $INSIDE_SCRIPT ]]; then
    echo "Please run with the installer script"
    exit
fi

# Configure Canonical Livepatch
# TODO: Add value check onto user input
echo 'Configuring Canonical Livepatch'

# Install
sudo snap install canonical-livepatch

# Configure and enable
sudo canonical-livepatch enable "$0"

# Reload
sudo canonical-livepatch refresh

# Check current status of livepatch
# sudo canonical-livepatch status
