#!/bin/bash -e

function exit_with_failure () { echo 'Failed to install Bitwarden.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

echo '+++ Installing Bitwarden'

# Install from Snap Store
sudo snap install bitwarden || exit_with_failure

# Verify installation
[[ -x "$(command -v bitwarden)" ]] || exit_with_failure

echo 'Bitwarden installed successfully.'
