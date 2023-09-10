#!/bin/bash -e

function exit_with_failure () { echo 'Failed to install Node.js.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

# Install Node.js
echo '+++ Installing Node.js'

# Insert public software signing key and add to list of repositories
curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash - \
    || exit_with_failure

# Update package database and install
( sudo apt-get update && sudo apt-get install -y nodejs ) \
    || exit_with_failure
