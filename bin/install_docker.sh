#!/bin/bash -e

function exit_with_failure () { echo 'Failed to install Docker.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

echo '+++ Installing Docker'

key_url='https://download.docker.com/linux/ubuntu/gpg'
key_file_path='/etc/apt/keyrings/docker-keyring.gpg'

repo_options='arch='"$( dpkg --print-architecture )"' signed-by='"$key_file_path"
repo_uri='https://download.docker.com/linux/ubuntu'
repo_suite="$( lsb_release -cs )"
repo_components='stable'
repo_file_path='/etc/apt/sources.list.d/docker.list'

# Insert public software signing key
bash ./bin/utils/add_keyring.sh "${key_url}" "${key_file_path}" \
    || exit_with_failure

# Add to list of repositories
bash ./bin/utils/add_repository.sh "${repo_options}" "${repo_uri}" "${repo_suite}" "${repo_components}" "${repo_file_path}" \
    || exit_with_failure

# Update package database and install
( sudo apt-get update \
    && sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
) || exit_with_failure

# Set up Docker user group (check if the group already exists)
if [[ ! $(getent group docker) ]]; then
    echo 'Creating docker user group.'
    sudo groupadd docker || exit_with_failure
fi

# Add current user to docker user group (check if current user is already in the group)
if [[ ! $(groups | grep docker) ]]; then
    echo 'Adding current user to docker user group.'
    sudo usermod -aG docker "$USER" || exit_with_failure
fi

# Restart Docker daemon
echo 'Restarting Docker daemon.'
sudo systemctl restart docker || exit_with_failure

# Validate installation
# echo 'Validating installation.'
# docker run hello-world > /dev/null || exit_with_failure
