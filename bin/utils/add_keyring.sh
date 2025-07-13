#!/bin/bash -e

# Prevent running with sudo
if [ "$EUID" -eq 0 ]; then
    echo 'Please run without sudo.'
    exit 1
fi

# Prevent running as root user
if [[ $USER == 'root' ]]; then
    echo 'Please run as non-root user.'
    exit 1
fi

# Validate input parameters
if [[ $# -ne 2 ]]; then
    echo 'Missing expected input parameters:'
    echo '    key_url: URL to the public software signing key (e.g. https://example.com/apt/keys.asc).'
    echo '    key_path: Absolute path to write the key to locally (e.g. /etc/apt/keyrings/example-keyring.gpg).'
    echo ''
    echo 'Usage: add_keyring.sh <key_url> <key_path>'
    exit 1
fi

key_url="$1"
key_path="$2"

echo "Adding keyring to ${key_path}"
if [ -f "$key_path" ]; then
    backup_key_path="${key_path}.bak"
    echo "Backing up existing file ${key_path} to ${backup_key_path}"
    sudo cp -f "$key_path" "$backup_key_path"
fi
curl -fsLS --proto '=https' --tlsv1.2 "$key_url" \
    | sudo gpg --dearmor \
    | sudo install -D -o root -g root -m 644 /dev/stdin "$key_path"
