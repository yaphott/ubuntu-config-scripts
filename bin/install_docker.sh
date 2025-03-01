#!/bin/bash -e

echo '+++ Installing Docker'

key_url='https://download.docker.com/linux/ubuntu/gpg'
key_file_path='/etc/apt/keyrings/docker-keyring.gpg'

repo_options='arch='"$(dpkg --print-architecture)"' signed-by='"$key_file_path"
repo_uri='https://download.docker.com/linux/ubuntu'
repo_suite="$(lsb_release -cs)"
repo_components='stable'
repo_file_path='/etc/apt/sources.list.d/docker.list'

# Insert public software signing key
bash ./bin/utils/add_keyring.sh "${key_url}" "${key_file_path}"

# Add to list of repositories
bash ./bin/utils/add_repository.sh "${repo_options}" "${repo_uri}" "${repo_suite}" "${repo_components}" "${repo_file_path}"

# Update package database and install
sudo apt-get update \
    && sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Set up Docker user group (check if the group already exists)
if [[ ! $(getent group docker) ]]; then
    echo 'Creating docker user group.'
    sudo groupadd docker
fi

# Add current user to docker user group (check if current user is already in the group)
if [[ ! $(groups | grep docker) ]]; then
    echo 'Adding current user to docker user group.'
    sudo usermod -aG docker "$USER"
fi

# Restart Docker daemon
echo 'Restarting Docker daemon.'
sudo systemctl restart docker

# Wait for Docker to start
function wait_for_docker () {
    local max_attempts=$1
    local wait_time=$2
    local attempt=0
    while [[ $attempt -lt $max_attempts ]]; do
        attempt=$((attempt + 1))
        if sudo docker info > /dev/null 2>&1; then
            echo 'Docker started.'
            return 0
        fi
        echo "Waiting for Docker to start ($attempt/$max_attempts)..."
        sleep $wait_time
    done
    return 1
}
if ! wait_for_docker 90 1; then
    echo 'Failed to start Docker.'
    exit 1
fi

# Verify installation
sudo docker run hello-world > /dev/null

echo 'Docker installed successfully.'

