#!/bin/bash -e

function exit_with_failure () { echo 'Failed to install Telegram Desktop.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

echo '+++ Installing Telegram Desktop'

# Install from Snap Store
sudo snap install telegram-desktop || exit_with_failure

# Verify installation
[[ -x "$(command -v telegram-desktop)" ]] || exit_with_failure

echo 'Telegram Desktop installed successfully.'
