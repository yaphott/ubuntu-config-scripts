#!/usr/bin/env bash

VAGRANT_BOX_NAME="ubuntu_config_scripts_base"

# Prepare project files
rm -rf ./ubuntu-config-scripts
mkdir ./ubuntu-config-scripts
mkdir ./ubuntu-config-scripts/bin
mkdir ./ubuntu-config-scripts/tmp

# Copy project files
cp -r ../run.sh ubuntu-config-scripts/run.sh
cp -r ../run_in_vagrant.sh ubuntu-config-scripts/run_in_vagrant.sh
cp -r ../bin/* ./ubuntu-config-scripts/bin/

# Remove any existing box instance
vagrant destroy -f

# Create new box instance
vagrant up
vagrant halt
