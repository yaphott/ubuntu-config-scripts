#!/bin/bash -e

function exit_with_failure () { echo 'Failed to install AWS CLI.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

echo '+++ Installing AWS CLI'

installer_file_name='awscli-exe-linux-x86_64.zip'
installer_url="https://awscli.amazonaws.com/$installer_file_name"

# Remove artifacts from previous installation attempts
rm -f './tmp/'"$installer_file_name" && rm -rf './tmp/aws'

# Download
echo "Downloading $installer_file_name..."
curl -fsL --proto '=https' --tlsv1.2 "$installer_file_name" -o './tmp/'"$installer_file_name" || exit_with_failure

# Verify download
if [[ ! -f './tmp/'"$installer_file_name" ]]; then
    echo "Failed to download $installer_file_name from $installer_url."
    exit_with_failure
fi

# Extract
unzip -q './tmp/'"$installer_file_name" -d './tmp/' || exit_with_failure

# Install
sudo ./aws/install

# Verify installation
aws --version > /dev/null || exit_with_failure

# Clean up
(rm './tmp/'"$installer_file_name" && rm -rf './tmp/aws') \
    || echo 'Failed to remove AWS CLI installer.'

echo '+++ AWS CLI has been successfully installed!'
