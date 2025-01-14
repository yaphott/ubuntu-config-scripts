#!/bin/bash -e

function exit_with_failure () { echo 'Failed to install Yarn.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

echo '+++ Installing Yarn'

# Install
npm install -g yarn || exit_with_failure

# Verify installation
yarn --version > /dev/null || exit_with_failure

echo 'Yarn installed successfully.'
