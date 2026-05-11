#!/usr/bin/env bash
set -e

echo '~~~ Configuring Rust'

# Add to path if not already
if [[ ! -x "$(command -v rustc)" ]]; then
    # shellcheck source=/dev/null
    source "$HOME/.cargo/env"
fi

rustup self update
rustup update stable
rustup default stable

echo 'Rust configured successfully.'
