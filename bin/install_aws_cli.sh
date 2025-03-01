#!/bin/bash -e

echo '+++ Installing AWS CLI'

installer_file_name='awscli-exe-linux-x86_64.zip'
installer_url="https://awscli.amazonaws.com/$installer_file_name"

# Remove artifacts from previous installation attempts
rm -f './tmp/'"$installer_file_name" && rm -rf './tmp/aws'

# Download
echo "Downloading $installer_file_name..."
curl -fsL --proto '=https' --tlsv1.2 "$installer_file_name" -o './tmp/'"$installer_file_name"

# Verify download
if [[ ! -f './tmp/'"$installer_file_name" ]]; then
    echo "Failed to download $installer_file_name from $installer_url."
    exit 1
fi

# Extract
unzip -q './tmp/'"$installer_file_name" -d './tmp/'

# Install
sudo ./aws/install

# Verify installation
aws --version > /dev/null

# Clean up
(rm './tmp/'"$installer_file_name" && rm -rf './tmp/aws') \
    || echo 'Failed to remove AWS CLI installer.'

echo '+++ AWS CLI has been successfully installed!'
