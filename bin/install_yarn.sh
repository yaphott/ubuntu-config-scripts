#!/bin/bash -e

function exit_with_failure () { echo 'Failed to install Yarn.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

echo '+++ Installing Yarn'

# Local variables
key_url='https://dl.yarnpkg.com/debian/pubkey.gpg'
key_filepath='/etc/apt/keyrings/yarn-keyring.gpg'

repo_options='signed-by='"$key_filepath"
repo_uri='https://dl.yarnpkg.com/debian'
repo_suite='stable'
repo_components='main'
repo_filepath='/etc/apt/sources.list.d/yarn.list'

# Insert public software signing key
bash ./bin/utils/add_keyring.sh "${key_url}" "${key_filename}" \
    || exit_with_failure

# Add to list of repositories
bash ./bin/utils/add_repository.sh "${repo_options}" "${repo_uri}" "${repo_suite}" "${repo_components}" "${repo_filepath}" \
    || exit_with_failure

# Update package database and install
( sudo apt-get update && sudo apt-get install -y yarn ) \
    || exit_with_failure

echo 'Yarn installed successfully.'
