#!/bin/bash -xe

if [[ ! $INSIDE_SCRIPT ]]; then
    echo "Please run with the installer script"
    exit
fi

# Install Oracle VirtualBox
echo 'Installing Oracle VirtualBox'

key_url='https://www.virtualbox.org/download/oracle_vbox_2016.asc'
key_filename='oracle-virtualbox-2016.gpg'
repo_filename='oracle-vbox.list'

# Insert public software signing key
bash ./bin/utils/add_keyring.sh "$key_url" "$key_filename"

# Add to list of repositories
bash ./bin/utils/add_repository.sh 'deb [arch=amd64 signed-by=/usr/share/keyrings/'"$key_filename"'] https://download.virtualbox.org/virtualbox/debian '"$( lsb_release -cs )"' contrib' \
                                            "$repo_filename"

# Update package database and install
sudo apt-get update
sudo apt-get install -y virtualbox-6.1
