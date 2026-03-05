#!/usr/bin/env bash
set -e

echo '~~~ Configuring Rust'

# Add to path if not already
if [[ ! -x "$(command -v rustc)" ]]; then
    source "$HOME/.cargo/env"
fi

# Additional information
rustup show

rustup self update
rustup update stable
rustup default stable

# Additional information
rustup show
