#!/bin/bash -e

function exit_with_failure () { echo 'Failed to install Google Chrome.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

# Install Google Chrome
echo '+++ Installing Google Chrome'

# Local variables
key_url='https://dl-ssl.google.com/linux/linux_signing_key.pub'
key_filename='google-chrome-keyring.gpg'

repo_options='arch='"$(dpkg --print-architecture)"' signed-by=/usr/share/keyrings/'"$key_filename"
repo_uri='http://dl.google.com/linux/chrome/deb/'
repo_suite="$(. /etc/os-release && echo "$VERSION_CODENAME")"
repo_components='stable main'
repo_filename='google-chrome.list'

# Insert public software signing key
bash ./bin/utils/add_keyring.sh "${key_url}" "${key_filename}" \
    || exit_with_failure

# Add to list of repositories
bash ./bin/utils/add_repository.sh "${repo_options}" "${repo_uri}" "${repo_suite}" "${repo_components}" "${repo_filename}" \
    || exit_with_failure

# Update package database and install
( sudo apt-get update && sudo apt-get install -y google-chrome-stable ) \
    || exit_with_failure

echo 'Google Chrome installed successfully.'
