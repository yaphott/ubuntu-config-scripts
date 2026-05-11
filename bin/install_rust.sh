#!/usr/bin/env bash
set -e

echo '+++ Installing Rust'

# Install
curl -fsLS --proto '=https' --tlsv1.2 -o- https://sh.rustup.rs | bash -s -- -y

# Verify installation
# shellcheck source=/dev/null
source "$HOME/.cargo/env"
rustc --version > /dev/null
cargo --version > /dev/null

echo 'Rust installed successfully.'
