#!/bin/bash -xe

if [[ ! $INSIDE_SCRIPT ]]; then
    echo "Please run with the installer script"
    exit
fi

#### Add to List of Repositories
# Parameters:
#   (1) Entry to add
#   (2) Filename to use

echo 'Adding repository in '"$SOURCES_LIST_PATH"'/'"$2"

echo "$1" | sudo tee -a "$SOURCES_LIST_PATH"'/'"$2" > /dev/null
