#!/bin/bash -e

function exit_with_failure () { echo 'Failed to install Google Chrome.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

echo '+++ Installing Google Chrome'

# Local variables
key_url='https://dl-ssl.google.com/linux/linux_signing_key.pub'
key_filepath='/etc/apt/keyrings/google-chrome-keyring.gpg'

repo_options='arch='"$(dpkg --print-architecture)"' signed-by='"$key_filepath"
repo_uri='http://dl.google.com/linux/chrome/deb/'
repo_suite="$( lsb_release -cs )"
repo_components='stable main'
repo_filepath='/etc/apt/sources.list.d/google-chrome.list'

# Insert public software signing key
bash ./bin/utils/add_keyring.sh "${key_url}" "${key_filepath}" \
    || exit_with_failure

# Add to list of repositories
bash ./bin/utils/add_repository.sh "${repo_options}" "${repo_uri}" "${repo_suite}" "${repo_components}" "${repo_filepath}" \
    || exit_with_failure

# Update package database and install
( sudo apt-get update && sudo apt-get install -y google-chrome-stable ) \
    || exit_with_failure

echo 'Google Chrome installed successfully.'
