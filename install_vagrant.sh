#!/bin/bash -xe

# Install Vagrant

# Required packages
sudo apt-get update
sudo apt-get install -y apt-transport-https

key_url='https://apt.releases.hashicorp.com/gpg'
key_filename='hashicorp-archive-keyring.gpg'
key_directory='/usr/share/keyrings'

repo_filename='hashicorp.list'
repo_directory='/etc/apt/sources.list.d/'

# Insert public software signing key
bash utils/add_keyring.sh "$key_url" "$key_filename" "$key_directory"

# Add to list of repositories
bash utils/add_repository.sh 'deb [signed-by='"$key_directory"'/'"$key_filename"'] https://apt.releases.hashicorp.com '"$( lsb_release -cs )"' main' \
                             "$repo_directory"'/'"$repo_filename"

# Update package database and install
sudo apt-get update
sudo apt-get install -y vagrant
