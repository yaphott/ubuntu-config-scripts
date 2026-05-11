#!/usr/bin/env bash
set -e

echo '+++ Installing Discord'

# Install from Snap Store
sudo snap install discord

# Verify installation
if [[ ! -x "$(command -v discord)" ]]; then
    echo 'Discord not found.'
    exit 1
fi

echo 'Discord installed successfully.'
