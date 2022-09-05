#!/bin/bash -xe

if [[ ! $INSIDE_SCRIPT ]]; then
    echo "Please run with the installer script"
    exit
fi

# Install Visual Studio Code
echo 'Installing Visual Studio Code'

key_url='https://packages.microsoft.com/keys/microsoft.asc'
key_filename='packages.microsoft.gpg'

repo_filename='vscode.list'

# Insert public software signing key
bash "$REPO_UTILS_PATH"'/add_keyring.sh' "$key_url" "$key_filename"

# Add to list of repositories
bash "$REPO_UTILS_PATH"'/add_repository.sh' 'deb [arch=amd64,arm64,armhf signed-by='"$KEYRINGS_PATH"'/'"$key_filename"'] https://packages.microsoft.com/repos/code stable main' \
                                            "$repo_filename"

# Update package database and install
sudo apt-get update
sudo apt-get install code # or code-insiders
