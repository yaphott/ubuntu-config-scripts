#!/bin/bash -e

function exit_with_failure () { echo 'Failed to install Vagrant.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

echo '+++ Installing Vagrant'

key_url='https://apt.releases.hashicorp.com/gpg'
key_file_path='/etc/apt/keyrings/hashicorp-archive-keyring.gpg'

repo_options='signed-by='"$key_file_path"
repo_uri='https://apt.releases.hashicorp.com'
repo_suite="$(lsb_release -cs)"
repo_components='main'
repo_file_path='/etc/apt/sources.list.d/hashicorp.list'

# Insert public software signing key
bash ./bin/utils/add_keyring.sh "${key_url}" "${key_file_path}" \
    || exit_with_failure

# Add to list of repositories
bash ./bin/utils/add_repository.sh "${repo_options}" "${repo_uri}" "${repo_suite}" "${repo_components}" "${repo_file_path}" \
    || exit_with_failure

# Update package database and install
(sudo apt-get update && sudo apt-get install -y vagrant) \
    || exit_with_failure

# Verify installation
vagrant --version > /dev/null || exit_with_failure

echo 'Vagrant installed successfully.'
