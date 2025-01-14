#!/bin/bash -e

function exit_with_failure () { echo 'Failed to install Spotify.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

echo '+++ Installing Spotify'

# Install from Snap Store
sudo snap install spotify || exit_with_failure

# Verify installation
spotify --version > /dev/null || exit_with_failure

echo 'Spotify installed successfully.'
