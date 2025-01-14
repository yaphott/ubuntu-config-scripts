#!/bin/bash -e

function exit_with_failure () { echo 'Failed to install Google Firebase CLI.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

echo '+++ Google Firebase CLI'

# Run install script
curl -fsL --proto '=https' --tlsv1.2 -o- https://firebase.tools | bash \
    || exit_with_failure

# Verify installation
firebase --version > /dev/null || exit_with_failure
