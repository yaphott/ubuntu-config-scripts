#!/usr/bin/env bash

box_name="ubuntu_config_scripts_base"
box_filepath='/tmp/'"$box_name.box"

# Remove any existing box
vagrant destroy -f
rm -f "$box_filepath"

# Create new box
vagrant up
vagrant halt
vagrant package --output "$box_filepath"

# Add box to Vagrant
vagrant box remove "$box_name" --force
vagrant box add "$box_name" "$box_filepath"

# Clean up
vagrant destroy -f
rm -f "$box_filepath"
