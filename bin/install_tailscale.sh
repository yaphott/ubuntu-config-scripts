#!/usr/bin/env bash
set -e

echo '+++ Installing Tailscale'

# Install
curl -fsLS --proto '=https' --tlsv1.2 -o- https://tailscale.com/install.sh | bash

# Verify installation
tailscale version > /dev/null

echo '+++ Tailscale has been successfully installed!'
