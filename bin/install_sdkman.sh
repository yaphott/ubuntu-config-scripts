#!/bin/bash -e

echo '+++ Installing SDKMAN'

# Install
curl -s "https://get.sdkman.io" | bash

# Verify installation
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk version > /dev/null

echo 'SDKMAN installed successfully.'
