#!/bin/bash -e

function exit_with_failure () { echo 'Failed to configure Power Profile.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

echo '~~~ Configuring Power Profile'

if [[ "$(powerprofilesctl get)" == 'performance' ]]; then
    echo 'Power Profile already configured.'
    exit 0
fi

powerprofilesctl set performance || exit_with_failure

if [[ "$(powerprofilesctl get)" != 'performance' ]]; then
    exit_with_failure
fi

echo 'Power Profile configured successfully.'
