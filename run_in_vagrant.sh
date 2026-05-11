#!/usr/bin/env bash
set -e

# NOTE: This script is intended for testing within a VM.
export INSIDE_TEST=true

# Smaller swapfile size
export SWAPFILE_SIZE='2G'

# TODO: Check if guest additions are installed here, and install them if they are not?

cd ~/ubuntu-config-scripts
bash run.sh
