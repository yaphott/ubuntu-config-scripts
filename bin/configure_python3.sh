#!/bin/bash -xe

if [[ ! $INSIDE_SCRIPT ]]; then
    echo "Please run with the installer script"
    exit
fi

# Configure Oracle VirtualBox
echo 'Configuring Oracle VirtualBox'

#### Update pip
python3 -m pip install -U --user pip setuptools wheel
python3 -m pip install -U --user build

#### Install dev tools
python3 -m pip install --user black yapf isort
