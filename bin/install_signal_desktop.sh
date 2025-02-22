#!/bin/bash -e

function exit_with_failure () { echo 'Failed to install Signal Desktop.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

echo '+++ Installing Signal Desktop'

key_url='https://updates.signal.org/desktop/apt/keys.asc'
key_file_path='/etc/apt/keyrings/signal-desktop-keyring.gpg'

repo_options='arch='"$(dpkg --print-architecture)"' signed-by='"$key_file_path"
repo_uri='https://updates.signal.org/desktop/apt'
repo_suite='xenial'
repo_components='main'
repo_file_path='/etc/apt/sources.list.d/signal-desktop.list'

# Insert public software signing key
bash ./bin/utils/add_keyring.sh "${key_url}" "${key_file_path}" \
    || exit_with_failure

# Add to list of repositories
bash ./bin/utils/add_repository.sh "${repo_options}" "${repo_uri}" "${repo_suite}" "${repo_components}" "${repo_file_path}" \
    || exit_with_failure

# Update package database and install
(sudo apt-get update && sudo apt-get install -y signal-desktop) \
    || exit_with_failure

# Verify installation
[[ -x "$(command -v signal-desktop)" ]] || exit_with_failure

echo 'Signal Desktop installed successfully.'
