#!/bin/bash -e

# TODO: WIP


echo '+++ Installing Vulkan SDK'

key_url='https://packages.lunarg.com/lunarg-signing-key-pub.asc'
key_file_path='/etc/apt/keyrings/vulkan-sdk.gpg'

repo_options='arch='"$(dpkg --print-architecture)"' signed-by='"$key_file_path"
repo_uri='https://packages.lunarg.com/vulkan'
repo_suite="$(lsb_release -cs)"
repo_components='main'
repo_file_path='/etc/apt/sources.list.d/vulkan-sdk.list'

# Insert public software signing key
bash ./bin/utils/add_keyring.sh "${key_url}" "${key_file_path}"

# Add to list of repositories
bash ./bin/utils/add_repository.sh "${repo_options}" "${repo_uri}" "${repo_suite}" "${repo_components}" "${repo_file_path}"

# Update package database and install
sudo apt-get update && sudo apt-get install -y vulkan-sdk

# Verify installation
vulkaninfo > /dev/null

echo 'Vulkan SDK installed successfully.'

