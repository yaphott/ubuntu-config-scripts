#!/bin/bash -xe

if [[ ! $INSIDE_SCRIPT ]]; then
    echo 'Please run with the installer script. Exiting ...'
    exit
fi

# Install Node.js
echo '+++ Installing Node.js'

# Insert public software signing key and add to list of repositories
curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash -

# Update package database and install
sudo apt-get update
sudo apt-get install -y nodejs
