#!/bin/bash -xe

# Install Visual Studio Code

# Required packages
sudo apt-get update
sudo apt-get install -y apt-transport-https

key_url='https://packages.microsoft.com/keys/microsoft.asc'
key_filename='packages.microsoft.gpg'
key_directory='/usr/share/keyrings'

repo_filename='vscode.list'
repo_directory='/etc/apt/sources.list.d/'

# Insert public software signing key
bash utils/add_keyring.sh "$key_url" "$key_filename" "$key_directory"

# Add to list of repositories
bash utils/add_repository.sh 'deb [arch=amd64,arm64,armhf signed-by='"$key_directory"'/'"$key_filename"'] https://packages.microsoft.com/repos/code stable main' \
                             "$repo_directory"'/'"$repo_filename"

# Update package database and install
sudo apt-get update
sudo apt-get install code # or code-insiders
