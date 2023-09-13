#!/bin/bash -e

function exit_with_failure () { echo 'Failed to install Sublime Text.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

echo '+++ Installing Sublime Text'

# Local variables
key_url='https://download.sublimetext.com/sublimehq-pub.gpg'
key_filepath='/etc/apt/keyrings/sublime-text-keyring.gpg'

repo_options='arch=amd64 signed-by='"$key_filepath"
repo_uri='https://download.sublimetext.com/'
repo_suite='apt/stable/'
repo_components='none'
repo_filepath='/etc/apt/sources.list.d/sublime-text.list'

# Insert public software signing key
bash ./bin/utils/add_keyring.sh "${key_url}" "${key_filepath}" \
    || exit_with_failure

# Add to list of repositories
bash ./bin/utils/add_repository.sh "${repo_options}" "${repo_uri}" "${repo_suite}" "${repo_components}" "${repo_filepath}" \
    || exit_with_failure

# Update package database and install
( sudo apt-get update && sudo apt-get install -y sublime-text ) \
    || exit_with_failure

echo 'Sublime Text installed successfully.'
