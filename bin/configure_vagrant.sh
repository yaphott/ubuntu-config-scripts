#!/bin/bash -xe

if [[ ! $INSIDE_SCRIPT ]]; then
    echo 'Please run with the installer script. Exiting ...'
    exit
fi

# Configure Vagrant
echo '~~~ Configuring Vagrant'

#### Install Plugins

vagrant plugin install vagrant-disksize
