#!/bin/bash -e

function exit_with_failure () { echo 'Failed to install Yarn.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

# Install Yarn
echo '+++ Installing Yarn'

# Local variables
key_url='https://dl.yarnpkg.com/debian/pubkey.gpg'
key_filename='yarn-keyring.gpg'
repo_filename='yarn.list'

# Insert public software signing key
bash ./bin/utils/add_keyring.sh "$key_url" "$key_filename" \
    || exit_with_failure

# Add to list of repositories
bash ./bin/utils/add_repository.sh 'deb [signed-by=/usr/share/keyrings/'"$key_filename"'] https://dl.yarnpkg.com/debian stable main' \
                                            "$repo_filename" \
    || exit_with_failure

# Update package database and install
( sudo apt-get update \
    && sudo apt-get install -y yarn
) || exit_with_failure
