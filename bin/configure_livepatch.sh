#!/bin/bash -xe

if [[ ! $INSIDE_SCRIPT ]]; then
    echo 'Please run with the installer script. Exiting ...'
    exit
fi

# Validate input parameters
#   (1) Canonical Livepatch key
if [[ ! "$1" ]]; then
    echo 'Missing expected input parameter(s). Exiting ...'
    exit
fi

# Configure Canonical Livepatch
echo 'Configuring Canonical Livepatch'

# Install
sudo snap install canonical-livepatch

# Configure and enable
sudo canonical-livepatch enable "$1"

# Reload
sudo canonical-livepatch refresh

# Check current status of livepatch
# sudo canonical-livepatch status
