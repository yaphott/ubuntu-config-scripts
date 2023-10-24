#!/bin/bash

# Skip the prompt for the Livepatch key by setting it here.
export LIVEPATCH_KEY='fake-livepatch-key'
# Override the default swapfile size to prevent the system from running out of memory.
export SWAPFILE_SIZE='2G'

cd ~/ubuntu-config-scripts
bash run.sh
