#!/bin/bash -e

function exit_with_failure () { echo 'Failed to install Rust.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

echo '+++ Installing Rust'

# Install
curl -fsL --proto '=https' --tlsv1.2 -o- https://sh.rustup.rs | bash -s -- -y \
    || exit_with_failure

# Verify installation
source "$HOME/.cargo/env"
rustc --version > /dev/null || exit_with_failure

echo 'Rust installed successfully.'
