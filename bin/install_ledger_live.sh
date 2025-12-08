#!/bin/bash -e

echo '+++ Installing Ledger Live'

latest_url='https://download.live.ledger.com/latest/linux'
latest_url="$(curl -sLS --proto '=https' --tlsv1.2 -o /dev/null -w '%{url_effective}' "$latest_url")"
latest_file_name="$(echo "$latest_url" | grep -oP '[^/]+$')"

echo "Downloading ${latest_file_name}..."
curl -fsLS --proto '=https' --tlsv1.2 "$latest_url" -o "$HOME/${latest_file_name}"

# Verify download
if [[ ! -f "$HOME/${latest_file_name}" ]]; then
    echo "Failed to download ${latest_file_name} from ${latest_url}."
    exit 1
fi

# Make the binary file executable
sudo chmod +x "$HOME/${latest_file_name}"

# Setup udev rules
# https://support.ledger.com/article/115005165269-zd
curl -fsLS --proto '=https' --tlsv1.2 https://raw.githubusercontent.com/LedgerHQ/udev-rules/master/add_udev_rules.sh | sudo bash

echo 'Ledger Live installed successfully.'
