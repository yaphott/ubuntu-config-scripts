#!/usr/bin/env bash
set -e

echo '+++ Installing Scala'

# Activate if not already
if [[ ! -x "$(command -v sdk)" ]]; then
    source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

# Additional information
sdk current scala

# Install latest version
sdk install scala

# Verify installation
scala version > /dev/null

# Additional information
sdk current scala

echo 'Scala installed successfully.'
