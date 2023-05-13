#!/bin/bash -e

function exit_with_failure () { echo 'Failed to install Signal Desktop.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

# Install Signal Desktop
echo '+++ Installing Signal Desktop'

# Local variables
key_url='https://updates.signal.org/desktop/apt/keys.asc'
key_filename='signal-desktop-keyring.gpg'
repo_filename='signal-desktop.list'

# Insert public software signing key
bash ./bin/utils/add_keyring.sh "$key_url" "$key_filename" \
    || exit_with_failure

# Add to list of repositories
bash ./bin/utils/add_repository.sh 'deb [arch=amd64 signed-by=/usr/share/keyrings/'"$key_filename"'] https://updates.signal.org/desktop/apt xenial main' \
                                            "$repo_filename" \
    || exit_with_failure

# Update package database and install
( sudo apt-get update \
    && sudo apt-get install -y signal-desktop
) || exit_with_failure
