#!/usr/bin/env bash -e

function exit_with_failure () { echo 'Failed to install Oracle VirtualBox.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

echo '+++ Installing Oracle VirtualBox'

# Local variables
key_url='https://www.virtualbox.org/download/oracle_vbox_2016.asc'
key_filepath='/etc/apt/keyrings/oracle-virtualbox-2016-keyring.gpg'

repo_options='arch=amd64 signed-by='"$key_filepath"
repo_uri='https://download.virtualbox.org/virtualbox/debian'
repo_suite=$DIST_CODENAME
repo_components='contrib'
repo_filepath='/etc/apt/sources.list.d/oracle-vbox.list'

# Insert public software signing key
bash ./bin/utils/add_keyring.sh "${key_url}" "${key_filepath}" \
    || exit_with_failure

# Add to list of repositories
bash ./bin/utils/add_repository.sh "${repo_options}" "${repo_uri}" "${repo_suite}" "${repo_components}" "${repo_filepath}" \
    || exit_with_failure

# Update package database and install
( sudo apt-get update && sudo apt-get install -y virtualbox-6.1 ) \
    || exit_with_failure

echo 'Oracle VirtualBox installed successfully.'
