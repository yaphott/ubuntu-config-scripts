#!/bin/bash -e

function exit_with_failure () { echo 'Failed to install Node JS.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

echo '+++ Installing Node JS'

# Local variables
key_url='https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key'
key_filepath='/etc/apt/keyrings/nodesource-keyring.gpg'

node_major=20
repo_options='signed-by='"$key_filepath"
repo_uri='https://deb.nodesource.com/node_'"$node_major"'.x'
repo_suite='nodistro'
repo_components='main'
repo_filepath='/etc/apt/sources.list.d/nodesource.list'

# Insert public software signing key
bash ./bin/utils/add_keyring.sh "${key_url}" "${key_filepath}" \
    || exit_with_failure

# Add to list of repositories
bash ./bin/utils/add_repository.sh "${repo_options}" "${repo_uri}" "${repo_suite}" "${repo_components}" "${repo_filepath}" \
    || exit_with_failure

# Update package database and install
( sudo apt-get update && sudo apt-get install -y nodejs ) \
    || exit_with_failure

echo 'Node JS installed successfully.'
