#!/bin/bash -e

echo '+++ Installing Spotify'

# Install from Snap Store
sudo snap install spotify

# Verify installation
spotify --version > /dev/null

echo 'Spotify installed successfully.'
