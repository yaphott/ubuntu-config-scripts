#!/bin/bash -xe

if [[ ! $INSIDE_SCRIPT ]]; then
    echo "Please run with the installer script"
    exit
fi

# Install Python 3.X
echo 'Installing Python 3.X'

# Update package database and install
sudo apt-get update
sudo apt-get install -y python3
sudo apt-get install -y python3-venv
sudo apt-get install -y python3-dev
sudo apt-get install -y python3-pip
