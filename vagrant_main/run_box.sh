#!/bin/bash

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

# Provision the new box
vagrant up
vagrant reload

# Return to the original directory
cd "$original_dir"
