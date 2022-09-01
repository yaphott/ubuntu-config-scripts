#!/bin/bash -xe

# Install Visual Studio Code

# Required packages
sudo apt-get update
sudo apt-get install -y apt-transport-https

# Insert public software signing key
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
rm -f packages.microsoft.gpg

# Add to list of repositories
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'

# Update package database and install
sudo apt-get update
sudo apt-get install code # or code-insiders
