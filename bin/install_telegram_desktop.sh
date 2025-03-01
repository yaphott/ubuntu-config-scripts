#!/bin/bash -e

echo '+++ Installing Telegram Desktop'

# Install from Snap Store
sudo snap install telegram-desktop

# Verify installation
if [[ ! -x "$(command -v telegram-desktop)" ]]; then
    echo 'Telegram Desktop not found.'
    exit 1
fi

echo 'Telegram Desktop installed successfully.'
