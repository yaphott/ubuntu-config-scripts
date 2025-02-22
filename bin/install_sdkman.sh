#!/bin/bash -e

function exit_with_failure () { echo 'Failed to install SDKMAN.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

echo '+++ Installing SDKMAN'

# Install
curl -s "https://get.sdkman.io" | bash

# Verify installation
source "$HOME/.sdkman/bin/sdkman-init.sh" || exit_with_failure
sdk version > /dev/null || exit_with_failure

echo 'SDKMAN installed successfully.'
