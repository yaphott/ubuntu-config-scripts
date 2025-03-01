#!/bin/bash -e

echo '+++ Installing Visual Studio Code'

key_url='https://packages.microsoft.com/keys/microsoft.asc'
key_file_path='/etc/apt/keyrings/packages.microsoft.gpg'

repo_options='arch='"$(dpkg --print-architecture)"' signed-by='"$key_file_path"
repo_uri='https://packages.microsoft.com/repos/code'
repo_suite='stable'
repo_components='main'
repo_file_path='/etc/apt/sources.list.d/vscode.list'

# Insert public software signing key
bash ./bin/utils/add_keyring.sh "${key_url}" "${key_file_path}"

# Add to list of repositories
bash ./bin/utils/add_repository.sh "${repo_options}" "${repo_uri}" "${repo_suite}" "${repo_components}" "${repo_file_path}"

# Update package database and install
sudo apt-get update && sudo apt-get install -y code

# Verify installation
code --version > /dev/null

echo 'Visual Studio Code installed successfully.'
