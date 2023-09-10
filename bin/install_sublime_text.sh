#!/bin/bash -e

function exit_with_failure () { echo 'Failed to install Sublime Text.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

# Install Sublime Text
echo '+++ Installing Sublime Text'

# Local variables
key_url='https://download.sublimetext.com/sublimehq-pub.gpg'
key_filename='sublime-text-keyring.gpg'
repo_filename='sublime-text.list'

# Insert public software signing key
bash ./bin/utils/add_keyring.sh "$key_url" "$key_filename" \
    || exit_with_failure

# Add to list of repositories
bash ./bin/utils/add_repository.sh 'deb [arch=amd64 signed-by=/usr/share/keyrings/'"$key_filename"'] https://download.sublimetext.com/ apt/stable/' \
                                            "$repo_filename" \
    || exit_with_failure

# Update package database and install
( sudo apt-get update && sudo apt-get install -y sublime-text ) \
    || exit_with_failure
