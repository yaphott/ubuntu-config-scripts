#!/bin/bash -e

function exit_with_failure () { echo 'Failed to install Visual Studio Code.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

# Install Visual Studio Code
echo '+++ Installing Visual Studio Code'

# Local variables
key_url='https://packages.microsoft.com/keys/microsoft.asc'
key_filename='packages.microsoft.gpg'
repo_filename='vscode.list'

# Insert public software signing key
bash ./bin/utils/add_keyring.sh "$key_url" "$key_filename" \
    || exit_with_failure

# Add to list of repositories
bash ./bin/utils/add_repository.sh 'deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/'"$key_filename"'] https://packages.microsoft.com/repos/code stable main' \
                                            "$repo_filename" \
    || exit_with_failure

# Update package database and install
# or code-insiders
( sudo apt-get update && sudo apt-get install code ) \
    || exit_with_failure
