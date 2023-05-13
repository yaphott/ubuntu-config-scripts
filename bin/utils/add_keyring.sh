#!/bin/bash -e

if [[ ! $INSIDE_SCRIPT ]]; then
    echo 'Please run with the installer script.'
    exit 1
fi

# Validate input parameters
# 1. Key URL (e.g. https://updates.signal.org/desktop/apt/keys.asc)
# 2. Key filename to write to (e.g. signal-desktop-keyring.gpg)
if [[ (! "$1") || (! "$2") ]]; then
    echo 'Missing expected input parameters:'
    echo '    key_url: Key URL (e.g. https://updates.signal.org/desktop/apt/keys.asc)'
    echo '    key_filename: Key filename to write to (e.g. signal-desktop-keyring.gpg)'
    echo ''
    echo 'Example:'
    echo '    bash ./bin/utils/add_keyring.sh https://updates.signal.org/desktop/apt/keys.asc signal-desktop-keyring.gpg'
    exit 1
fi

key_url="$1"
key_filename="$2"

temp_keyring_path='./tmp/'"$key_filename"
repo_keyring_path='/etc/apt/keyrings/'"$key_filename"

echo 'Adding keyring --> '"$repo_keyring_path"
# if [ -f "$repo_keyring_path" ]; then
#     echo 'Keyring already exists. Would you like to overwrite it?'
#     while true; do
#         read -p 'Overwrite? [y/n] ' yn
#         case $yn in
#             [Yy][Ee][Ss] | [Yy] ) break;;
#             [Nn][Oo] | [Nn] ) exit 1;;
#             * ) echo 'Please answer yes or no.';;
#         esac
#     done
#     echo 'Overwriting keyring.'
# fi

# Download, decrypt, and write to temporary file
wget -qO - "$key_url" | gpg --dearmor > "$temp_keyring_path"

# Install keyring
sudo install -D -o root -g root -m 644 "$temp_keyring_path" "$repo_keyring_path"

# Clean up
rm "$temp_keyring_path"
