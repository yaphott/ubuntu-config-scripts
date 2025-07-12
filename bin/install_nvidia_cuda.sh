#!/bin/bash -e

if [[ $# -ne 1 ]]; then
    echo 'Missing expected input parameter(s).'
    echo '    cuda_version: Version of NVIDIA CUDA to install (e.g. 12.0).'
    echo ''
    echo 'Usage: install_nvidia_cuda.sh <cuda_version>'
    exit 1
fi

cuda_version="$1"

echo "+++ Installing NVIDIA CUDA ${cuda_version}"

nvidia_ubuntu_ver="ubuntu$(lsb_release -rs | tr -d '.')"
base_url="https://developer.download.nvidia.com/compute/cuda/repos/$nvidia_ubuntu_ver/$(uname -m)"

key_url="$base_url/3bf863cc.pub"
key_file_path='/etc/apt/keyrings/nvidia-cuda-keyring.gpg'

repo_options='signed-by='"$key_file_path"
repo_uri="$base_url"
repo_suite='/'
repo_components=''
repo_file_path='/etc/apt/sources.list.d/nvidia-cuda.list'

# Insert public software signing key
bash ./bin/utils/add_keyring.sh "${key_url}" "${key_file_path}"

# Add to list of repositories
bash ./bin/utils/add_repository.sh "${repo_options}" "${repo_uri}" "${repo_suite}" "${repo_components}" "${repo_file_path}"

# Update package database and install
package_name="cuda-toolkit-${cuda_version//./-}"
sudo apt-get update && sudo apt-get install -y "$package_name"

# sudo apt-get install libcudnn8 libcudnn8-dev

# Verify installation
"/usr/local/cuda-$cuda_version/bin/nvcc" --version > /dev/null

echo "NVIDIA CUDA ${cuda_version} installed successfully."
