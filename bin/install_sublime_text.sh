#!/bin/bash -e

echo '+++ Installing Sublime Text'

key_url='https://download.sublimetext.com/sublimehq-pub.gpg'
key_file_path='/etc/apt/keyrings/sublime-text-keyring.gpg'

repo_options='arch='"$(dpkg --print-architecture)"' signed-by='"$key_file_path"
repo_uri='https://download.sublimetext.com/'
repo_suite='apt/stable/'
repo_components=''
repo_file_path='/etc/apt/sources.list.d/sublime-text.list'

# Insert public software signing key
bash ./bin/utils/add_keyring.sh "${key_url}" "${key_file_path}"

# Add to list of repositories
bash ./bin/utils/add_repository.sh "${repo_options}" "${repo_uri}" "${repo_suite}" "${repo_components}" "${repo_file_path}"

# Update package database and install
sudo apt-get update && sudo apt-get install -y sublime-text

# Verify installation
subl --version > /dev/null

echo 'Sublime Text installed successfully.'
