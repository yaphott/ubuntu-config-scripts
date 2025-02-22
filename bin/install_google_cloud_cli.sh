#!/bin/bash -e

function exit_with_failure () { echo 'Failed to install Google Cloud CLI.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

echo '+++ Installing Google Cloud CLI'

key_url='https://packages.cloud.google.com/apt/doc/apt-key.gpg'
key_file_path='/etc/apt/keyrings/cloud.google.gpg'

repo_options='arch='"$(dpkg --print-architecture)"' signed-by='"$key_file_path"
repo_uri='https://packages.cloud.google.com/apt'
repo_suite='cloud-sdk'
repo_components='main'
repo_file_path='/etc/apt/sources.list.d/google-cloud-sdk.list'

# Insert public software signing key
bash ./bin/utils/add_keyring.sh "${key_url}" "${key_file_path}" \
    || exit_with_failure

# Add to list of repositories
bash ./bin/utils/add_repository.sh "${repo_options}" "${repo_uri}" "${repo_suite}" "${repo_components}" "${repo_file_path}" \
    || exit_with_failure

# Update package database and install
(sudo apt-get update && sudo apt-get install -y google-cloud-cli) \
    || exit_with_failure

# Verify installation
gcloud version > /dev/null || exit_with_failure

echo 'Google Cloud CLI installed successfully.'
