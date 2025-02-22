#!/bin/bash -e

function exit_with_failure () { echo 'Failed to install Java.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

echo '+++ Installing Java'

# Activate if not already
if [[ ! -x "$(command -v sdk)" ]]; then
    source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

# Install latest Zulu version
sdk install java zulu

# Verify installation
java --version > /dev/null || exit_with_failure

echo 'Java installed successfully.'
