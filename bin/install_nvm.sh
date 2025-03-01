#!/bin/bash -e

echo '+++ Installing Node Version Manager'

# Install
curl -fsL --proto '=https' --tlsv1.2 -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

# Verify installation
export NVM_DIR="$HOME/.nvm"
source "$NVM_DIR/nvm.sh"
source "$NVM_DIR/bash_completion"
nvm --version > /dev/null

echo 'Node Version Manager installed successfully.'
