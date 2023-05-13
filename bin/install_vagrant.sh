#!/bin/bash -e

function exit_with_failure () { echo 'Failed to install Vagrant.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

# Install Vagrant
echo '+++ Installing Vagrant'

# Local variables
key_url='https://apt.releases.hashicorp.com/gpg'
key_filename='hashicorp-archive-keyring.gpg'
repo_filename='hashicorp.list'

# Insert public software signing key
bash ./bin/utils/add_keyring.sh "$key_url" "$key_filename" \
    || exit_with_failure

# Add to list of repositories
bash ./bin/utils/add_repository.sh 'deb [signed-by=/usr/share/keyrings/'"$key_filename"'] https://apt.releases.hashicorp.com '"$( lsb_release -cs )"' main' \
                                            "$repo_filename" \
    || exit_with_failure

# Update package database and install
( sudo apt-get update \
    && sudo apt-get install -y vagrant
) || exit_with_failure
