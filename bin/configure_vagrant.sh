#!/bin/bash -e

function exit_with_failure () { echo 'Failed to configure Vagrant.'; exit 1; }

if [[ ! $INSIDE_SCRIPT ]]; then
    echo 'Please run with the installer script.'
    exit_with_failure
fi

# Configure Vagrant
echo '~~~ Configuring Vagrant'

#### Install Plugins

vagrant plugin install vagrant-disksize \
|| exit_with_failure
