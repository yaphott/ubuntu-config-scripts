#!/bin/bash -xe

if [[ ! $INSIDE_SCRIPT ]]; then
    echo 'Please run with the installer script. Exiting ...'
    exit
fi

# Validate input parameters
#   (1) Contents of entry
#   (2) Filename to use
if [[ (! "$1") || (! "$2") ]]; then
    echo 'Missing expected input parameter(s). Exiting ...'
    exit
fi

# Add to List of Repositories
echo 'Adding repository --> '"$repo_source_path"

repo_source_path='/etc/apt/sources.list.d/'"$2"

echo "$1" | sudo tee -a "$repo_source_path" > /dev/null
