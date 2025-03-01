#!/bin/bash -e

echo '~~~ Configuring Power Profile'

if [[ "$(powerprofilesctl get)" == 'performance' ]]; then
    echo 'Power Profile already configured.'
    exit 0
fi

powerprofilesctl set performance

if [[ "$(powerprofilesctl get)" != 'performance' ]]; then
    echo 'Failed to configure Power Profile.'
    exit 1
fi

echo 'Power Profile configured successfully.'
