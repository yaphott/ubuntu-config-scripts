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
if [[ (! "$1") || (! "$2") ]]; then
    echo 'Missing expected input parameters:'
    echo '    key_url: URL to the public software signing key (e.g. https://example.com/apt/keys.asc).'
    echo '    key_filepath: Complete path to write the key to locally (e.g. /etc/apt/keyrings/example-keyring.gpg).'
    echo ''
    echo 'Usage:'
    echo '    add_keyring.sh <key_url> <keyring_path>'
    exit 1
fi

key_url="$1"
key_filepath="$2"

key_filename="$( basename "$key_filepath" )"
tmp_dir="$(mktemp -d)"
tmp_key_filepath="${tmp_dir}/${key_filename}"

echo 'Adding keyring --> '"$key_filepath"
if [ -f "$key_filepath" ]; then
    echo 'Backing up existing file.'
    sudo cp -f "$key_filepath" "$key_filepath.bak"
fi

# Download, decrypt, and write to temporary file
curl -fsSL "$key_url" | sudo gpg --dearmor -o "$tmp_key_filepath"

# Install keyring
sudo install -D -o root -g root -m 644 "$tmp_key_filepath" "$key_filepath"

# Clean up
if [ -d "$tmp_dir" ]; then
    sudo rm -rf "$tmp_dir"
fi
