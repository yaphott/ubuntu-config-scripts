#!/bin/bash -e

echo '+++ Installing Java'

# Activate if not already
if [[ ! -x "$(command -v sdk)" ]]; then
    source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

# Install latest Zulu version
sdk install java zulu

# Verify installation
java --version > /dev/null

echo 'Java installed successfully.'
