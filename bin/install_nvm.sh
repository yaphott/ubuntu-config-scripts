#!/bin/bash -e

tmp_dir="$(mktemp -d)"

echo '+++ Installing Node Version Manager'

# Download the latest version
repo_owner='nvm-sh'
repo_name='nvm'
latest_tag="$(curl -fsLS --proto '=https' --tlsv1.2 "https://api.github.com/repos/${repo_owner}/${repo_name}/releases/latest" | jq -r '.tag_name')"
latest_url="https://github.com/${repo_owner}/${repo_name}/archive/refs/tags/${latest_tag}.tar.gz"
latest_file_name="$(basename "$latest_url")"

echo "Downloading ${latest_url}..."
curl -fsLS --proto '=https' --tlsv1.2 "$latest_url" -o "${tmp_dir}/${latest_file_name}"

echo "Extracting ${latest_file_name}..."
tar -xzf "${tmp_dir}/${latest_file_name}" -C "${tmp_dir}"

# Install
"${tmp_dir}/${repo_name}-${latest_tag#v}/install.sh" 

# Verify installation
export NVM_DIR="$HOME/.nvm"
source "$NVM_DIR/nvm.sh"
source "$NVM_DIR/bash_completion"
nvm --version > /dev/null

# Clean up
rm -r "$tmp_dir"

echo 'Node Version Manager installed successfully.'
