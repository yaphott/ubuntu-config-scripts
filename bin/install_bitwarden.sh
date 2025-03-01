#!/bin/bash -e

echo '+++ Installing Bitwarden'

# Install from Snap Store
sudo snap install bitwarden

# Verify installation
if [[ ! -x "$(command -v bitwarden)" ]]; then
    echo 'Bitwarden not found.'
    exit 1
fi

echo 'Bitwarden installed successfully.'
