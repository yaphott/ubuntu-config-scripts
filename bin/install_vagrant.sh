#!/bin/bash -xe

if [[ ! $INSIDE_SCRIPT ]]; then
    echo "Please run with the installer script"
    exit
fi

# Install Vagrant
echo 'Installing Vagrant'

key_url='https://apt.releases.hashicorp.com/gpg'
key_filename='hashicorp-archive-keyring.gpg'

repo_filename='hashicorp.list'

# Insert public software signing key
bash "$REPO_UTILS_PATH"'/add_keyring.sh' "$key_url" "$key_filename"

# Add to list of repositories
bash "$REPO_UTILS_PATH"'/add_repository.sh' 'deb [signed-by='"$KEYRINGS_PATH"'/'"$key_filename"'] https://apt.releases.hashicorp.com '"$( lsb_release -cs )"' main' \
                                            "$repo_filename"

# Update package database and install
sudo apt-get update
sudo apt-get install -y vagrant
