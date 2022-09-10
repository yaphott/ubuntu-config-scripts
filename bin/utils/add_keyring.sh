#!/bin/bash -xe

if [[ ! $INSIDE_SCRIPT ]]; then
    echo "Please run with the installer script"
    exit
fi

#### Insert Public Software Signing Key
# Parameters:
#   (1) URL of key to download
#   (2) Filename alias to use

temp_keyring_path='./tmp/'"$2"
repo_keyring_path='/usr/share/keyrings/'"$2"

echo 'Adding keyring --> '"$repo_keyring_path"

# Download
wget -qO - "$1" | gpg --dearmor > "$temp_keyring_path"

# Install
sudo install -D -o root -g root -m 644 "$temp_keyring_path" "$repo_keyring_path"

# Clean up
rm -f "$temp_keyring_path"
