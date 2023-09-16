#!/bin/bash -e

function exit_with_failure () { echo 'Failed to install Signal Desktop.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

echo '+++ Installing Signal Desktop'

# Local variables
key_url='https://updates.signal.org/desktop/apt/keys.asc'
key_filepath='/etc/apt/keyrings/signal-desktop-keyring.gpg'

repo_options='arch=amd64 signed-by='"$key_filepath"
repo_uri='https://updates.signal.org/desktop/apt'
repo_suite='xenial'
repo_components='main'
repo_filepath='/etc/apt/sources.list.d/signal-desktop.list'

# Insert public software signing key
bash ./bin/utils/add_keyring.sh "${key_url}" "${key_filepath}" \
    || exit_with_failure

# Add to list of repositories
bash ./bin/utils/add_repository.sh "${repo_options}" "${repo_uri}" "${repo_suite}" "${repo_components}" "${repo_filepath}" \
    || exit_with_failure

# Update package database and install
( sudo apt-get update && sudo apt-get install -y signal-desktop ) \
    || exit_with_failure

echo 'Signal Desktop installed successfully.'
