#!/bin/bash -e

# [[ $INSIDE_SCRIPT ]] || ( echo 'Please run with the installer script.'; exit 1; )

# Validate input parameters
if [[ (! "$1") || (! "$2") ]]; then
    echo 'Missing expected input parameters:'
    echo '    key_url: URL to the public software signing key (e.g. https://example.com/apt/keys.asc)'
    echo '    key_filepath: Complete path to write the key to locally (e.g. /etc/apt/keyrings/example-keyring.gpg)'
    echo ''
    echo 'Usage:'
    echo '    sudo add_keyring.sh <key_url> <keyring_path>'
    exit 1
fi

key_url="$1"
key_filepath="$2"

key_filename="$( basename "$key_filepath" )"
temp_key_filepath='./tmp/'"$key_filename"

echo 'Adding keyring --> '"$key_filepath"
if [ -f "$key_filepath" ]; then
    yes_or_no 'File already exists. Would you like to overwrite it?' || exit 1
    echo 'Overwriting file.'
fi

# Download, decrypt, and write to temporary file
# wget -qO - "$key_url" | gpg --dearmor > "$temp_key_filepath"
curl -fsSL "$key_url" | sudo gpg --dearmor -o "$temp_key_filepath"

# Install keyring
sudo install -D -o root -g root -m 644 "$temp_key_filepath" "$key_filepath"

# Clean up
if [ -f "$temp_key_filepath" ]; then
    echo 'Removing temporary file --> '"$temp_key_filepath"
    rm -f "$temp_key_filepath"
fi
