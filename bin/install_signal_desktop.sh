#!/bin/bash -xe

if [[ ! $INSIDE_SCRIPT ]]; then
    echo 'Please run with the installer script. Exiting ...'
    exit
fi

# Install Signal Desktop
echo 'Installing Signal Desktop'

key_url='https://updates.signal.org/desktop/apt/keys.asc'
key_filename='signal-desktop-keyring.gpg'
repo_filename='signal-desktop.list'

# Insert public software signing key
bash ./bin/utils/add_keyring.sh "$key_url" "$key_filename"

# Add to list of repositories
bash ./bin/utils/add_repository.sh 'deb [arch=amd64 signed-by=/usr/share/keyrings/'"$key_filename"'] https://updates.signal.org/desktop/apt xenial main' \
                                            "$repo_filename"

# Update package database and install
sudo apt-get update
sudo apt-get install -y signal-desktop
