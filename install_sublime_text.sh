#!/bin/bash -xe

# Install Sublime Text

# Required packages
sudo apt-get update
sudo apt-get install -y apt-transport-https

key_url='https://download.sublimetext.com/sublimehq-pub.gpg'
key_filename='sublime-text-keyring.gpg'
key_directory='/usr/share/keyrings'

repo_filename='sublime-text.list'
repo_directory='/etc/apt/sources.list.d/'

# Insert public software signing key
bash utils/add_keyring.sh "$key_url" "$key_filename" "$key_directory"

# Add to list of repositories
bash utils/add_repository.sh 'deb [arch=amd64 signed-by='"$key_directory"'/'"$key_filename"'] https://download.sublimetext.com/ apt/stable/' \
                             "$repo_directory"'/'"$repo_filename"

# Update package database and install
sudo apt-get update
sudo apt-get install -y sublime-text
