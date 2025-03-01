#!/bin/bash -e

echo '+++ Installing Node JS'

# Activate if not already
if [[ ! -x "$(command -v nvm)" ]]; then
    export NVM_DIR="$HOME/.nvm"
    source "$NVM_DIR/nvm.sh"
    source "$NVM_DIR/bash_completion"
fi

# Install the latest stable version
nvm install --lts
nvm alias default node

# Verify installation
node --version > /dev/null

# Update Node Package Manager
npm install -g npm

echo 'Node JS installed successfully.'
