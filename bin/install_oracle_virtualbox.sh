#!/bin/bash -e

function exit_with_failure () { echo 'Failed to install Oracle VirtualBox.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

VBOX_VERSION='7.1'

echo "+++ Installing Oracle VirtualBox ${VBOX_VERSION}"

key_url='https://www.virtualbox.org/download/oracle_vbox_2016.asc'
key_file_path='/etc/apt/keyrings/oracle-virtualbox-2016-keyring.gpg'

repo_options='arch=amd64 signed-by='"$key_file_path"
repo_uri='https://download.virtualbox.org/virtualbox/debian'
repo_suite="$( lsb_release -cs )"
repo_components='contrib'
repo_file_path='/etc/apt/sources.list.d/oracle-vbox.list'

# Insert public software signing key
bash ./bin/utils/add_keyring.sh "${key_url}" "${key_file_path}" \
    || exit_with_failure

# Add to list of repositories
bash ./bin/utils/add_repository.sh "${repo_options}" "${repo_uri}" "${repo_suite}" "${repo_components}" "${repo_file_path}" \
    || exit_with_failure

# Update package database and install
(sudo apt-get update && sudo apt-get install -y "virtualbox-${VBOX_VERSION}") \
    || exit_with_failure

# Verify installation
[[ -x "$(command -v virtualbox)" ]] || exit_with_failure

echo 'Oracle VirtualBox installed successfully.'
