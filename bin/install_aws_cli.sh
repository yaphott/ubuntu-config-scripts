#!/bin/bash -e

echo '+++ Installing AWS CLI'

tmp_dir="$(mktemp -d)"

installer_file_name='awscli-exe-linux-x86_64.zip'
installer_url="https://awscli.amazonaws.com/$installer_file_name"

# Download
echo "Downloading ${installer_file_name}..."
curl -fsLS --proto '=https' --tlsv1.2 "$installer_file_name" -o "${tmp_dir}/${installer_file_name}"

# Verify download
if [[ ! -f "${tmp_dir}/${installer_file_name}" ]]; then
    echo "Failed to download ${installer_file_name} from ${installer_url}."
    exit 1
fi

# Extract
unzip -q "${tmp_dir}/${installer_file_name}" -d "$tmp_dir"

# Install
sudo "${tmp_dir}/aws/install"

# Verify installation
aws --version > /dev/null

# Clean up
rm -r "$tmp_dir"

echo '+++ AWS CLI has been successfully installed!'
