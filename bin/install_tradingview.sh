#!/usr/bin/env bash
set -e

echo '+++ Installing TradingView'

# Install from Snap Store
sudo snap install tradingview

# Verify installation
if [[ ! -x "$(command -v tradingview)" ]]; then
    echo 'TradingView not found.'
    exit 1
fi

echo 'TradingView installed successfully.'
