#!/bin/bash -e

function exit_with_failure () { echo 'Failed to install Google Chrome.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

echo '+++ Installing Google Chrome'

key_url='https://dl-ssl.google.com/linux/linux_signing_key.pub'
key_file_path='/etc/apt/keyrings/google-chrome-keyring.gpg'

repo_options='arch='"$(dpkg --print-architecture)"' signed-by='"$key_file_path"
repo_uri='http://dl.google.com/linux/chrome/deb/'
repo_suite='stable'
repo_components='main'
repo_file_path='/etc/apt/sources.list.d/google-chrome.list'

# Insert public software signing key
bash ./bin/utils/add_keyring.sh "${key_url}" "${key_file_path}" \
    || exit_with_failure

# Add to list of repositories
bash ./bin/utils/add_repository.sh "${repo_options}" "${repo_uri}" "${repo_suite}" "${repo_components}" "${repo_file_path}" \
    || exit_with_failure

# Update package database and install
(sudo apt-get update && sudo apt-get install -y google-chrome-stable) \
    || exit_with_failure

# Verify installation
google-chrome --version > /dev/null || exit_with_failure

echo 'Google Chrome installed successfully.'
