#!/bin/bash -e

function exit_with_failure () { echo 'Failed to install Visual Studio Code.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

echo '+++ Installing Visual Studio Code'

key_url='https://packages.microsoft.com/keys/microsoft.asc'
key_file_path='/etc/apt/keyrings/packages.microsoft.gpg'

repo_options='arch=amd64,arm64,armhf signed-by='"$key_file_path"
repo_uri='https://packages.microsoft.com/repos/code'
repo_suite='stable'
repo_components='main'
repo_file_path='/etc/apt/sources.list.d/vscode.list'

# Insert public software signing key
bash ./bin/utils/add_keyring.sh "${key_url}" "${key_file_path}" \
    || exit_with_failure

# Add to list of repositories
bash ./bin/utils/add_repository.sh "${repo_options}" "${repo_uri}" "${repo_suite}" "${repo_components}" "${repo_file_path}" \
    || exit_with_failure

# Update package database and install
(sudo apt-get update && sudo apt-get install -y code) \
    || exit_with_failure

# Verify installation
code --version > /dev/null || exit_with_failure

echo 'Visual Studio Code installed successfully.'
