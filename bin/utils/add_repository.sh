#!/bin/bash -xe

if [[ ! $INSIDE_SCRIPT ]]; then
    echo "Please run with the installer script"
    exit
fi

#### Add to List of Repositories
# Parameters:
#   (1) Entry to add
#   (2) Filename to use

repo_source_path='/etc/apt/sources.list.d/'"$2"

echo 'Adding repository --> '"$repo_source_path"

echo "$1" | sudo tee -a "$repo_source_path" > /dev/null
