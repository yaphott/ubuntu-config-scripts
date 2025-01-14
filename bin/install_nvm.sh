#!/bin/bash -e

function exit_with_failure () { echo 'Failed to install Node Version Manager.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

echo '+++ Installing Node Version Manager'

# Install
curl -fsL --proto '=https' --tlsv1.2 -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash || exit_with_failure

# Verify installation
export NVM_DIR="$HOME/.nvm"
source "$NVM_DIR/nvm.sh" || exit_with_failure
nvm --version > /dev/null || exit_with_failure

echo 'Node Version Manager installed successfully.'
