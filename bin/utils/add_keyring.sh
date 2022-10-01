#!/bin/bash -xe

if [[ ! $INSIDE_SCRIPT ]]; then
    echo 'Please run with the installer script. Exiting ...'
    exit
fi

# Validate input parameters
#   (1) URL of key to download
#   (2) Alias name for key file
if [[ (! "$1") || (! "$2") ]]; then
    echo 'Missing expected input parameter(s). Exiting ...'
    exit
fi

temp_keyring_path='./tmp/'"$2"
repo_keyring_path='/usr/share/keyrings/'"$2"

# Insert Public Software Signing Key
# TODO: Check for existing gpg keys before adding
echo 'Adding keyring --> '"$repo_keyring_path"

# Download
wget -qO - "$1" | gpg --dearmor > "$temp_keyring_path"

# Install
sudo install -D -o root -g root -m 644 "$temp_keyring_path" "$repo_keyring_path"

# Clean up
rm "$temp_keyring_path"
