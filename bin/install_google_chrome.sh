#!/bin/bash -e

function exit_with_failure () { echo 'Failed to install Google Chrome.'; exit 1; }

if [[ ! $INSIDE_SCRIPT ]]; then
    echo 'Please run with the installer script.'
    exit_with_failure
fi

# Install Google Chrome
echo '+++ Installing Google Chrome'

# Local variables
key_url='https://dl-ssl.google.com/linux/linux_signing_key.pub'
key_filename='google-chrome-keyring.gpg'
repo_filename='google-chrome.list'

# Insert public software signing key
bash ./bin/utils/add_keyring.sh "$key_url" "$key_filename" \
|| exit_with_failure

# Add to list of repositories
bash ./bin/utils/add_repository.sh 'deb [arch=amd64 signed-by=/usr/share/keyrings/'"$key_filename"'] http://dl.google.com/linux/chrome/deb/ stable main' \
                                            "$repo_filename" \
|| exit_with_failure

# Update package database and install
( sudo apt-get update && \
  sudo apt-get install -y google-chrome-stable
) || exit_with_failure
