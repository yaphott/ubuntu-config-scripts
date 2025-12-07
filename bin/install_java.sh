#!/bin/bash -e

echo '+++ Installing Java'

# Activate if not already
if [[ ! -x "$(command -v sdk)" ]]; then
    source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

# Install latest Zulu version
latest_version_full=$(sdk list java | awk '$8 ~ /^[0-9]+\.[0-9]+\.[0-9]+-zulu$/ { print $8 }' | sort -V | tail -n 1)
if [[ -z "$latest_version_full" ]]; then
    echo 'No Zulu Java versions found.'
    exit 1
fi
sdk install java "$latest_version_full"
sdk default java "$latest_version_full"

# Verify installation
if ! sdk current java | grep -q " ${latest_version_full}$"; then
    echo 'Failed to set default Java version.'
    exit 1
fi

echo 'Java installed successfully.'
