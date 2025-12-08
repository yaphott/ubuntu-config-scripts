#!/bin/bash -e

if [[ $# -ne 1 ]]; then
    echo 'Missing expected input parameter(s).'
    echo '    toolkit_version: Version of NVIDIA Container Toolkit to install (e.g. 1.18.1-1).'
    echo ''
    echo 'Usage: install_nvidia_container_toolkit.sh <toolkit_version>'
    exit 1
fi

toolkit_version="$1"

echo "+++ Installing NVIDIA Container Toolkit ${toolkit_version}"

base_url="https://nvidia.github.io/libnvidia-container"

key_url="$base_url/gpgkey"
key_file_path='/etc/apt/keyrings/nvidia-container-toolkit-keyring.gpg'

repo_options='signed-by='"$key_file_path"
repo_uri="https://nvidia.github.io/libnvidia-container/stable/deb/$(dpkg --print-architecture)"
repo_suite='/'
repo_components=''
repo_file_path='/etc/apt/sources.list.d/nvidia-container-toolkit.list'

# Insert public software signing key
bash ./bin/utils/add_keyring.sh "${key_url}" "${key_file_path}"

# Add to list of repositories
bash ./bin/utils/add_repository.sh "${repo_options}" "${repo_uri}" "${repo_suite}" "${repo_components}" "${repo_file_path}"

# Install
sudo apt-get update
sudo apt-get install -y \
    "nvidia-container-toolkit=${toolkit_version}" \
    "nvidia-container-toolkit-base=${toolkit_version}" \
    "libnvidia-container-tools=${toolkit_version}" \
    "libnvidia-container1=${toolkit_version}"

echo "NVIDIA Container Toolkit installed successfully."
