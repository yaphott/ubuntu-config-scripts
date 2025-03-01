#!/bin/bash -e

echo '+++ Installing Scala'

# Activate if not already
if [[ ! -x "$(command -v sdk)" ]]; then
    source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

# Install latest version
sdk install scala

# Verify installation
scala version > /dev/null

echo 'Scala installed successfully.'
