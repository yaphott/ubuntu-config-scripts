#!/bin/bash -xe

# Configure Canonical Livepatch
# TODO: Add value check onto user input

# Install
sudo snap install canonical-livepatch

# Configure and enable
sudo canonical-livepatch enable "$0"

# Reload
sudo canonical-livepatch refresh

# Check current status of livepatch
# sudo canonical-livepatch status
