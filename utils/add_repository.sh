#!/bin/bash -xe

# Add to List of Repositories
# Parameters:
#   (1) Entry to add
#   (2) Filename to use

echo "$1" | sudo tee -a "$2" > /dev/null
