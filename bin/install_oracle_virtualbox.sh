#!/bin/bash -e

VBOX_VERSION='7.1'

echo "+++ Installing Oracle VirtualBox ${VBOX_VERSION}"

key_url='https://www.virtualbox.org/download/oracle_vbox_2016.asc'
key_file_path='/etc/apt/keyrings/oracle-virtualbox-2016-keyring.gpg'

repo_options="arch=$(dpkg --print-architecture) signed-by=${key_file_path}"
repo_uri='https://download.virtualbox.org/virtualbox/debian'
repo_suite="$(lsb_release -cs)"
repo_components='contrib'
repo_file_path='/etc/apt/sources.list.d/oracle-vbox.list'

# Insert public software signing key
bash ./bin/utils/add_keyring.sh "${key_url}" "${key_file_path}"

# Add to list of repositories
bash ./bin/utils/add_repository.sh "${repo_options}" "${repo_uri}" "${repo_suite}" "${repo_components}" "${repo_file_path}"

# Update package database and install
sudo apt-get update && sudo apt-get install -y "virtualbox-${VBOX_VERSION}"

# Verify installation
if [[ ! -x "$(command -v virtualbox)" ]]; then
    echo 'Oracle VirtualBox not found.'
    exit 1
fi

echo 'Oracle VirtualBox installed successfully.'
