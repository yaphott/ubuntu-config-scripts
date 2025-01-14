#!/bin/bash -e

function exit_with_failure () { echo 'Failed to install Anaconda.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

echo '+++ Installing Anaconda'

# Download the latest version
archive_html=$(curl -fsL --proto '=https' --tlsv1.2 https://repo.anaconda.com/archive/)
latest_file_name=$(echo "$archive_html" | grep -oP 'Anaconda3-[0-9\.\-]+\-Linux-x86_64.sh' | sort -V | tail -n 1)

echo "Downloading $latest_file_name..."
curl -fsL --proto '=https' --tlsv1.2 "https://repo.anaconda.com/archive/$latest_file_name" -o './tmp/'"$latest_file_name" || exit_with_failure

# Install Anaconda
bash './tmp/'"$latest_file_name" -b -p "$HOME"/anaconda3 -b || exit_with_failure

# Add Anaconda to PATH in .bashrc
export PATH="$PATH:$HOME/anaconda3/bin" || exit_with_failure
conda init || exit_with_failure

# Verify installation
conda --version > /dev/null || exit_with_failure

# Base environment is activated by default
conda config --set auto_activate_base True || exit_with_failure

# Clean up
rm -f './tmp/'"$latest_file_name" || echo 'Failed to remove Anaconda installer.'

echo 'Anaconda installed successfully.'
