#!/bin/bash -e

echo '+++ Installing Google Cloud CLI'

key_url='https://packages.cloud.google.com/apt/doc/apt-key.gpg'
key_file_path='/etc/apt/keyrings/cloud.google.gpg'

repo_options='arch='"$(dpkg --print-architecture)"' signed-by='"$key_file_path"
repo_uri='https://packages.cloud.google.com/apt'
repo_suite='cloud-sdk'
repo_components='main'
repo_file_path='/etc/apt/sources.list.d/google-cloud-sdk.list'

# Insert public software signing key
bash ./bin/utils/add_keyring.sh "${key_url}" "${key_file_path}"

# Add to list of repositories
bash ./bin/utils/add_repository.sh "${repo_options}" "${repo_uri}" "${repo_suite}" "${repo_components}" "${repo_file_path}"

# Update package database and install
sudo apt-get update && sudo apt-get install -y google-cloud-cli

# Verify installation
gcloud version > /dev/null

echo 'Google Cloud CLI installed successfully.'
