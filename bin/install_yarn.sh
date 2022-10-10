#!/bin/bash -xe

if [[ ! $INSIDE_SCRIPT ]]; then
    echo 'Please run with the installer script. Exiting ...'
    exit
fi

# Install Yarn
echo '+++ Installing Yarn'

key_url='https://dl.yarnpkg.com/debian/pubkey.gpg'
key_filename='yarn-keyring.gpg'
repo_filename='yarn.list'

# Insert public software signing key
bash ./bin/utils/add_keyring.sh "$key_url" "$key_filename"

# Add to list of repositories
bash ./bin/utils/add_repository.sh 'deb [signed-by=/usr/share/keyrings/'"$key_filename"'] https://dl.yarnpkg.com/debian stable main' \
                                            "$repo_filename"

# Update package database and install
sudo apt-get update
sudo apt-get install -y yarn
