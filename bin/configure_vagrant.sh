#!/bin/bash -e

echo '~~~ Configuring Vagrant'

# Install Plugins
vagrant plugin install vagrant-disksize

# Verify Plugins
if [[ $(vagrant plugin list | awk '{print $1}' | grep -c '^vagrant-disksize$') -ne 1 ]]; then
    echo 'Vagrant plugin not found.'
    exit 1
fi

echo 'Vagrant configured successfully.'
