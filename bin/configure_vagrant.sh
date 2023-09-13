#!/usr/bin/env bash -e

function exit_with_failure () { echo 'Failed to configure Vagrant.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

# Configure Vagrant
echo '~~~ Configuring Vagrant'

#### Install Plugins

vagrant plugin install vagrant-disksize \
    || exit_with_failure
