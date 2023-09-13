#!/usr/bin/env bash -e

function exit_with_failure () { echo 'Failed to install Vagrant.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

echo '+++ Installing Vagrant'

# Local variables
key_url='https://apt.releases.hashicorp.com/gpg'
key_filepath='/etc/apt/keyrings/hashicorp-archive-keyring.gpg'

repo_options='signed-by='"$key_filepath"
repo_uri='https://apt.releases.hashicorp.com'
repo_suite="$( lsb_release -cs )"
repo_components='main'
repo_filepath='/etc/apt/sources.list.d/hashicorp.list'

# Insert public software signing key
bash ./bin/utils/add_keyring.sh "${key_url}" "${key_filepath}" \
    || exit_with_failure

# Add to list of repositories
bash ./bin/utils/add_repository.sh "${repo_options}" "${repo_uri}" "${repo_suite}" "${repo_components}" "${repo_filepath}" \
    || exit_with_failure

# Update package database and install
( sudo apt-get update && sudo apt-get install -y google-chrome-stable ) \
    || exit_with_failure

echo 'Vagrant installed successfully.'
