#!/bin/bash -e

function exit_with_failure () { echo 'Failed to install Java.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

echo '+++ Installing Java'

# Install the latest Zulu
sdk install java zulu

# Verify installation
java --version > /dev/null || exit_with_failure

echo 'Java installed successfully.'
