#!/bin/bash -e

# Validate input parameters
if [[ $# -ne 1 ]]; then
    echo 'Missing expected input parameters:'
    echo '    livepatch_key: Canonical Livepatch key.'
    echo ''
    echo 'Usage: configure_livepatch.sh <livepatch_key>'
    exit 1
fi

livepatch_key="$1"

echo '~~~ Configuring Canonical Livepatch'

# Install from Snap Store
sudo snap install canonical-livepatch

# Configure and enable
# Ubuntu Advantage
# sudo ua attach "$1"
# Ubuntu Pro
# sudo pro attach "$1"
sudo canonical-livepatch enable "$livepatch_key"

# Reload
sudo canonical-livepatch refresh

# Check current status of livepatch
# sudo canonical-livepatch status

echo 'Canonical Livepatch configured successfully.'
