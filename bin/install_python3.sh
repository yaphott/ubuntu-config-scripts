#!/bin/bash -e

echo '+++ Installing Python 3.x'

# Update package database and install
sudo apt-get update \
    && sudo apt-get install -y python3 \
    && sudo apt-get install -y python3-venv \
    && sudo apt-get install -y python3-dev \
    && sudo apt-get install -y python3-pip
