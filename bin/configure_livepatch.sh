#!/bin/bash -e

function exit_with_failure () { echo 'Failed to configure Canonical Livepatch.'; exit 1; }

if [[ ! $INSIDE_SCRIPT ]]; then
    echo 'Please run with the installer script.'
    exit_with_failure
fi

# Validate input parameters
#   (1) Canonical Livepatch key
if [[ ! "$1" ]]; then
    echo 'Missing expected input parameter(s).'
    exit_with_failure
fi

# Configure Canonical Livepatch
echo '~~~ Configuring Canonical Livepatch'

# Install
sudo snap install canonical-livepatch \
|| exit_with_failure

# Configure and enable
# Ubuntu Advantage
# sudo ua attach "$1"
# Ubuntu Pro
# sudo pro attach "$1"
sudo canonical-livepatch enable "$1" \
|| exit_with_failure

# Reload
sudo canonical-livepatch refresh \
|| exit_with_failure

# Check current status of livepatch
# sudo canonical-livepatch status
