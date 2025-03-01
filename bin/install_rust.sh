#!/bin/bash -e

echo '+++ Installing Rust'

# Install
curl -fsL --proto '=https' --tlsv1.2 -o- https://sh.rustup.rs | bash -s -- -y

# Verify installation
source "$HOME/.cargo/env"
rustc --version > /dev/null

echo 'Rust installed successfully.'
