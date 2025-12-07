#!/bin/bash -e

echo '+++ Installing Yarn'

# Activate if not already
if [[ ! -x "$(command -v nvm)" ]]; then
    export NVM_DIR="$HOME/.nvm"
    source "$NVM_DIR/nvm.sh"
    source "$NVM_DIR/bash_completion"
fi

# Install
npm install -g yarn

# Verify installation
yarn --version > /dev/null

echo 'Yarn installed successfully.'
