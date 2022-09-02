#!/bin/bash -xe

# Install Oracle VirtualBox

# Required packages
sudo apt-get update
sudo apt-get install -y apt-transport-https

key_url='https://www.virtualbox.org/download/oracle_vbox_2016.asc'
key_filename='oracle-virtualbox-2016.gpg'
key_directory='/usr/share/keyrings'

repo_filename='oracle-vbox.list'
repo_directory='/etc/apt/sources.list.d/'

# Insert public software signing key
bash utils/add_keyring.sh "$key_url" "$key_filename" "$key_directory"

# Add to list of repositories
bash utils/add_repository.sh 'deb [arch=amd64 signed-by='"$key_directory"'/'"$key_filename"'] https://download.virtualbox.org/virtualbox/debian '"$( lsb_release -cs )"' contrib' \
                             "$repo_directory"'/'"$repo_filename"

# Update package database and install
sudo apt-get update
sudo apt-get install -y virtualbox-6.1
