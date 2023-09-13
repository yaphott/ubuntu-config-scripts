#!/usr/bin/env bash -e

function exit_with_failure () { echo 'Failed to install NVIDIA CUDA 11.3.'; exit 1; }

if [[ ! $INSIDE_SCRIPT ]]; then
    echo 'Please run with the installer script.'
    exit_with_failure
fi

echo '+++ Installing NVIDIA CUDA 11.2'

# TODO: Parse together expected ubuntu version
nvidia_ubuntu_ver='ubuntu2204'

# Local variables
key_url='https://developer.download.nvidia.com/compute/cuda/repos/'"$nvidia_ubuntu_ver"'/x86_64/3bf863cc.pub'
key_filepath='/etc/apt/keyrings/nvidia-cuda-keyring.gpg'

repo_options='signed-by='"$key_filepath"
repo_uri='https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/'
repo_suite='/'
repo_components=none
repo_filepath='/etc/apt/sources.list.d/nvidia-cuda.list'

( wget 'https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-'"$nvidia_ubuntu_ver"'.pin' \
    && sudo mv 'cuda-'"$nvidia_ubuntu_ver"'.pin' /etc/apt/preferences.d/cuda-repository-pin-600
) || exit_with_failure

# Insert public software signing key
bash ./bin/utils/add_keyring.sh "${key_url}" "${key_filepath}" \
    || exit_with_failure

# Add to list of repositories
bash ./bin/utils/add_repository.sh "${repo_options}" "${repo_uri}" "${repo_suite}" "${repo_components}" "${repo_filepath}" \
    || exit_with_failure

# Update package database and install
( sudo apt-get update && sudo apt-get install -y cuda-toolkit-11-2 ) \
    || exit_with_failure

# or for 11.3
# sudo apt-get install -y cuda-toolkit-11-3

# sudo apt-get install libcudnn8 libcudnn8-dev

echo 'NVIDIA CUDA 11.2 installed successfully.'
