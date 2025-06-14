#!/bin/bash -e

echo '+++ Installing Vagrant'

key_url='https://apt.releases.hashicorp.com/gpg'
key_file_path='/etc/apt/keyrings/hashicorp-archive-keyring.gpg'

repo_options='arch='"$(dpkg --print-architecture)"' signed-by='"$key_file_path"
repo_uri='https://apt.releases.hashicorp.com'
repo_suite="$(lsb_release -cs)"
repo_components='main'
repo_file_path='/etc/apt/sources.list.d/hashicorp.list'

# Insert public software signing key
bash ./bin/utils/add_keyring.sh "${key_url}" "${key_file_path}"

# Add to list of repositories
bash ./bin/utils/add_repository.sh "${repo_options}" "${repo_uri}" "${repo_suite}" "${repo_components}" "${repo_file_path}"

# Update package database and install
sudo apt-get update && sudo apt-get install -y vagrant

# Verify installation
vagrant --version > /dev/null

echo 'Vagrant installed successfully.'
