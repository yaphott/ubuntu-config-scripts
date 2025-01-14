#!/bin/bash -e

function exit_with_failure () { echo 'Failed to install Node JS.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

echo '+++ Installing Node JS'

# Install the latest stable version
(nvm install --lts && nvm use --lts) || exit_with_failure

# Verify installation
node --version > /dev/null || exit_with_failure

# Update Node Package Manager
npm install -g npm || exit_with_failure

echo 'Node JS installed successfully.'
