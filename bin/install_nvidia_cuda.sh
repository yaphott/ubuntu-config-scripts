#!/bin/bash -e

cuda_version="$1"
function exit_with_failure () { echo 'Failed to install NVIDIA CUDA '"'""$cuda_version""'"'.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)
[[ $cuda_version ]] || (echo 'Missing expected input parameter: cuda_version.'; exit_with_failure)

echo '+++ Installing NVIDIA CUDA '"$cuda_version"

nvidia_ubuntu_ver="ubuntu$(lsb_release -rs | tr -d '.')"
base_url="https://developer.download.nvidia.com/compute/cuda/repos/$nvidia_ubuntu_ver/$(uname -m)"

key_url="$base_url/3bf863cc.pub"
key_file_path='/etc/apt/keyrings/nvidia-cuda-keyring.gpg'

repo_options='signed-by='"$key_file_path"
repo_uri="$base_url"
repo_suite='/'
repo_components=none
repo_file_path='/etc/apt/sources.list.d/nvidia-cuda.list'

# Insert public software signing key
bash ./bin/utils/add_keyring.sh "${key_url}" "${key_file_path}" \
    || exit_with_failure

# Add to list of repositories
bash ./bin/utils/add_repository.sh "${repo_options}" "${repo_uri}" "${repo_suite}" "${repo_components}" "${repo_file_path}" \
    || exit_with_failure

# Update package database and install
package_name='cuda-toolkit-'"${cuda_version//./-}"
(sudo apt-get update && sudo apt-get install -y "$package_name") \
    || exit_with_failure

# sudo apt-get install libcudnn8 libcudnn8-dev

# Verify installation
"/usr/local/cuda-$cuda_version/bin/nvcc" --version > /dev/null || exit_with_failure

echo 'NVIDIA CUDA '"$cuda_version"' installed successfully.'
