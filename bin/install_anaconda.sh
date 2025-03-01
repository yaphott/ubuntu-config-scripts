#!/bin/bash -e

echo '+++ Installing Anaconda'

# Download the latest version
archive_html=$(curl -fsL --proto '=https' --tlsv1.2 https://repo.anaconda.com/archive/)
latest_file_name=$(echo "$archive_html" | grep -oP 'Anaconda3-[0-9\.\-]+\-Linux-x86_64.sh' | sort -V | tail -n 1)

echo "Downloading $latest_file_name..."
curl -fsL --proto '=https' --tlsv1.2 "https://repo.anaconda.com/archive/$latest_file_name" -o './tmp/'"$latest_file_name"

# Install Anaconda
bash './tmp/'"$latest_file_name" -b -p "$HOME"/anaconda3 -b

# Add Anaconda to PATH in .bashrc
export PATH="$PATH:$HOME/anaconda3/bin"
conda init

# Verify installation
conda --version > /dev/null

# Base environment is activated by default
conda config --set auto_activate_base True

# Clean up
rm -f './tmp/'"$latest_file_name" || echo 'Failed to remove Anaconda installer.'

echo 'Anaconda installed successfully.'
