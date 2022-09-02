#!/bin/bash -xe

# Install Signal Desktop

# Required packages
sudo apt-get update
sudo apt-get install -y apt-transport-https

key_url='https://updates.signal.org/desktop/apt/keys.asc'
key_filename='signal-desktop-keyring.gpg'
key_directory='/usr/share/keyrings'

repo_filename='signal-xenial.list'
repo_directory='/etc/apt/sources.list.d/'

# Insert public software signing key
bash utils/add_keyring.sh "$key_url" "$key_filename" "$key_directory"

# Add to list of repositories
bash utils/add_repository.sh 'deb [arch=amd64 signed-by='"$key_directory"'/'"$key_filename"'] https://updates.signal.org/desktop/apt xenial main' \
                             "$repo_directory"'/'"$repo_filename"

# Update package database and install
sudo apt-get update
sudo apt-get install -y signal-desktop
