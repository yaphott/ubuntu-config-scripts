#!/bin/bash -e

# Validate input parameters
#   (1) Canonical Livepatch key
if [[ ! "$1" ]]; then
    echo 'Missing expected input parameter(s).'
    exit 1
fi

echo '~~~ Configuring Canonical Livepatch'

# Install from Snap Store
sudo snap install canonical-livepatch

# Configure and enable
# Ubuntu Advantage
# sudo ua attach "$1"
# Ubuntu Pro
# sudo pro attach "$1"
sudo canonical-livepatch enable "$1"

# Reload
sudo canonical-livepatch refresh

# Check current status of livepatch
# sudo canonical-livepatch status

echo 'Canonical Livepatch configured successfully.'
