#!/bin/bash -e

echo '+++ Installing Anaconda'

tmp_dir="$(mktemp -d)"

# Download the latest version
archive_html=$(curl -fsLS --proto '=https' --tlsv1.2 https://repo.anaconda.com/archive/)
latest_file_name=$(echo "$archive_html" | grep -oP 'Anaconda3-[0-9\.\-]+\-Linux-x86_64.sh' | sort -V | tail -n 1)
latest_url="https://repo.anaconda.com/archive/${latest_file_name}"

echo "Downloading ${latest_file_name}..."
curl -fsLS --proto '=https' --tlsv1.2 "$latest_url" -o "${tmp_dir}/${latest_file_name}"

# Verify download
if [[ ! -f "${tmp_dir}/${latest_file_name}" ]]; then
    echo "Failed to download ${latest_file_name} from ${latest_url}."
    exit 1
fi

# Install Anaconda
bash "${tmp_dir}/${latest_file_name}" -b -p "$HOME/anaconda3" -b

# Add Anaconda to PATH in .bashrc
export PATH="$PATH:$HOME/anaconda3/bin"
conda init

# Verify installation
conda --version > /dev/null

# Base environment is activated by default
conda config --set auto_activate_base True

# Clean up
rm -r "$tmp_dir"

echo 'Anaconda installed successfully.'
