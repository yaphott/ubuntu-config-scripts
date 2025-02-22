#!/bin/bash -e

function exit_with_failure () { echo 'Failed to install Node JS.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

echo '+++ Installing Node JS'

# Activate if not already
if [[ ! -x "$(command -v nvm)" ]]; then
    export NVM_DIR="$HOME/.nvm"
    source "$NVM_DIR/nvm.sh" || exit_with_failure
    source "$NVM_DIR/bash_completion" || exit_with_failure
fi

# Install the latest stable version
nvm install --lts || exit_with_failure
nvm alias default node || exit_with_failure

# Verify installation
node --version > /dev/null || exit_with_failure

# Update Node Package Manager
npm install -g npm || exit_with_failure

echo 'Node JS installed successfully.'
