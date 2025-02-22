#!/bin/bash -e

function exit_with_failure () { echo 'Failed to install Scala.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

echo '+++ Installing Scala'

# Activate if not already
if [[ ! -x "$(command -v sdk)" ]]; then
    source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

# Install latest version
sdk install scala || exit_with_failure

# Verify installation
scala version > /dev/null || exit_with_failure

echo 'Scala installed successfully.'
