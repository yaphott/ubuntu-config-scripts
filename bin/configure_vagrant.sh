#!/bin/bash -e

function exit_with_failure () { echo 'Failed to configure Vagrant.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

echo '~~~ Configuring Vagrant'

# Install Plugins
vagrant plugin install vagrant-disksize \
    || exit_with_failure

# Verify Plugins
if [[ $(vagrant plugin list | awk '{print $1}' | grep -c '^vagrant-disksize$') -ne 1 ]]; then
    exit_with_failure
fi

echo 'Vagrant configured successfully.'
