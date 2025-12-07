#!/bin/bash -e

echo '+++ Google Firebase CLI'

# Activate if not already
if [[ ! -x "$(command -v nvm)" ]]; then
    export NVM_DIR="$HOME/.nvm"
    source "$NVM_DIR/nvm.sh"
    source "$NVM_DIR/bash_completion"
fi

# Install
npm install -g firebase-tools

# Verify installation
firebase --version > /dev/null
