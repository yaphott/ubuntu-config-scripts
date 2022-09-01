#!/bin/bash -xe

# Install Google Chrome

key_url='https://dl-ssl.google.com/linux/linux_signing_key.pub'
key_filename='google-chrome-keyring.gpg'
key_directory='/usr/share/keyrings'

repo_filename='google-chrome.list'
repo_directory='/etc/apt/sources.list.d/'

# Insert public software signing key
bash utils/add_keyring.sh "$key_url" "$key_filename" "$key_directory"

# Add to list of repositories
bash utils/add_repository.sh 'deb [arch=amd64 signed-by='"$key_directory"'/'"$key_filename"'] http://dl.google.com/linux/chrome/deb/ stable main' \
                             "$repo_directory"'/'"$repo_filename"

# Update package database and install
sudo apt-get update
sudo apt-get install -y google-chrome-stable
