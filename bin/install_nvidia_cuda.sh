#!/bin/bash -xe

if [[ ! $INSIDE_SCRIPT ]]; then
    echo 'Please run with the installer script. Exiting ...'
    exit
fi

# Install NVIDIA CUDA 11.3
echo '+++ Installing NVIDIA CUDA 11.3'

# TODO: Parse together expected ubuntu version
nvidia_ubuntu_ver='ubuntu2204'

key_url='https://developer.download.nvidia.com/compute/cuda/repos/'"$nvidia_ubuntu_ver"'/x86_64/3bf863cc.pub'
key_filename='nvidia-cuda-keyring.gpg'
repo_filename='nvidia-cuda.list'

wget 'https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-'"$nvidia_ubuntu_ver"'.pin'
sudo mv 'cuda-'"$nvidia_ubuntu_ver"'.pin' /etc/apt/preferences.d/cuda-repository-pin-600

# Insert public software signing key
bash ./bin/utils/add_keyring.sh "$key_url" "$key_filename"

# Add to list of repositories
bash ./bin/utils/add_repository.sh 'deb [signed-by=/usr/share/keyrings/'"$key_filename"'] https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/ /' \
                                            "$repo_filename"

# Update package database and install
sudo apt-get update
sudo apt-get install -y cuda-toolkit-11-3
# or for 11.6
# sudo apt-get install -y cuda-toolkit-11-6