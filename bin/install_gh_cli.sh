#!/bin/bash -e

echo '+++ Installing GitHub CLI'

key_url='https://cli.github.com/packages/githubcli-archive-keyring.gpg'
key_file_path='/etc/apt/keyrings/githubcli-archive-keyring.gpg'

repo_options="arch=$(dpkg --print-architecture) signed-by=${key_file_path}"
repo_uri='https://cli.github.com/packages'
repo_suite='stable'
repo_components='main'
repo_file_path='/etc/apt/sources.list.d/github-cli.list'

# Insert public software signing key
bash ./bin/utils/add_keyring.sh "${key_url}" "${key_file_path}"

# Add to list of repositories
bash ./bin/utils/add_repository.sh "${repo_options}" "${repo_uri}" "${repo_suite}" "${repo_components}" "${repo_file_path}"

# Update package database and install
sudo apt-get update && sudo apt-get install -y gh

# Verify installation
gh --version > /dev/null

echo 'Signal Desktop installed successfully.'
