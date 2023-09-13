#!/usr/bin/env bash -e

function exit_with_failure () { echo 'Failed to install Rust.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

echo '+++ Installing Rust'

# Install
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh


# Verify installation
rustc --version || exit_with_failure

echo 'Rust installed successfully.'
