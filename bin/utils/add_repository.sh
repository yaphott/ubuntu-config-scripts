#!/bin/bash -e

if [[ ! $INSIDE_SCRIPT ]]; then
    echo 'Please run with the installer script.'
    exit 1
fi

# Validate input parameters
#   (1) Contents of entry
#   (2) Filename to use
if [[ (! "$1") || (! "$2") ]]; then
    echo 'Missing expected input parameter(s).'
    exit 1
fi

repo_source_path='/etc/apt/sources.list.d/'"$2"

# Add to list of repositories
echo 'Adding repository --> '"$repo_source_path"

echo "$1" | sudo tee -a "$repo_source_path" > /dev/null
