#!/usr/bin/bash -e

echo "~~~ Configuring NVIDIA Container Toolkit"

# Configure for Docker
sudo nvidia-ctk runtime configure --runtime=docker

# Restart Docker service
sudo systemctl restart docker

# Verify
if [[ $(nvidia-smi -L | wc -l) -gt 0 ]]; then
    sudo docker run --rm --runtime=nvidia --gpus all ubuntu nvidia-smi > /dev/null
else
    echo 'No NVIDIA GPU devices found'
fi

echo 'NVIDIA Container Toolkit configured successfully.'
