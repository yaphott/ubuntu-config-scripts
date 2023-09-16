#!/bin/bash

box_name="ubuntu_config_scripts_base"
box_filepath='/tmp/'"$box_name.box"

function get_vagrant_directory () {
    local original_dir="$PWD"
    local vagrant_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
    cd "$original_dir"
    echo "$vagrant_dir"
}

# Get the directory of this script
vagrant_dir="$( get_vagrant_directory )"

# Store the current directory to return to later
original_dir="$PWD"
cd "$vagrant_dir"

# Remove any existing box
vagrant destroy -f
rm -f "$box_filepath"

# Create the new box
vagrant up
vagrant halt
vagrant package --output "$box_filepath"

# Add the box to Vagrant
vagrant box remove "$box_name" --force
vagrant box add "$box_name" "$box_filepath"

# Clean up
vagrant destroy -f
rm -f "$box_filepath"

# Return to the original directory
cd "$original_dir"
