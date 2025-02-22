#!/bin/bash -e

function exit_with_failure () { echo 'Failed to install Google Firebase CLI.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

echo '+++ Google Firebase CLI'

# Activate if not already
if [[ ! -x "$(command -v nvm)" ]]; then
    export NVM_DIR="$HOME/.nvm"
    source "$NVM_DIR/nvm.sh" || exit_with_failure
    source "$NVM_DIR/bash_completion" || exit_with_failure
fi

# Install
npm install -g firebase-tools || exit_with_failure

# Verify installation
firebase --version > /dev/null || exit_with_failure
