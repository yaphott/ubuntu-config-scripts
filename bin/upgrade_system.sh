#!/bin/bash -e

function exit_with_failure () { echo 'Failed to install System Upgrades.'; exit 1; }

if [[ ! $INSIDE_SCRIPT ]]; then
    echo 'Please run with the installer script.'
    exit_with_failure
fi

# Install System Upgrades
echo '+++ System Upgrades'

( sudo apt-get update \
  && sudo apt-get dist-upgrade -y
) || exit_with_failure
