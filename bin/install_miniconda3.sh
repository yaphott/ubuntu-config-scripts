#!/bin/bash -e

echo '+++ Installing Miniconda 3'

tmp_dir="$(mktemp -d)"

# Download the latest version
latest_url="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-$(uname -m).sh"
latest_file_name="$(echo "$latest_url" | grep -oP '[^/]+$')"

echo "Downloading ${latest_file_name}..."
curl -fsLS --proto '=https' --tlsv1.2 "$latest_url" -o "${tmp_dir}/${latest_file_name}"

# Verify download
if [[ ! -f "${tmp_dir}/${latest_file_name}" ]]; then
    echo "Failed to download ${latest_file_name} from ${latest_url}."
    exit 1
fi

# Install Miniconda 3
bash "${tmp_dir}/${latest_file_name}" -b -p "$HOME/miniconda3"

# Add Miniconda 3 to PATH in .bashrc
export PATH="$PATH:$HOME/miniconda3/bin"
conda init

# Verify installation
conda --version > /dev/null

# Base environment is activated by default
conda config --set auto_activate_base True

# Clean up
rm -r "$tmp_dir"

echo 'Miniconda 3 installed successfully.'
