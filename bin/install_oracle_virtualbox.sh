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
bash "$REPO_UTILS_PATH"'/add_keyring.sh' "$key_url" "$key_filename"

# Add to list of repositories
bash "$REPO_UTILS_PATH"'/add_repository.sh' 'deb [arch=amd64 signed-by='"$KEYRINGS_PATH"'/'"$key_filename"'] https://download.virtualbox.org/virtualbox/debian '"$LSB_RELEASE_CODENAME"' contrib' \
                                            "$repo_filename"

# Update package database and install
sudo apt-get update
sudo apt-get install -y virtualbox-6.1
