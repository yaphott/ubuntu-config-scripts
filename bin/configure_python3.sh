#!/bin/bash -xe

if [[ ! $INSIDE_SCRIPT ]]; then
    echo 'Please run with the installer script. Exiting ...'
    exit
fi

# Configure Python 3.x
echo 'Configuring Python 3.x'

#### Update pip

python3 -m pip install -U --user pip setuptools wheel
python3 -m pip install -U --user build

#### Install dev tools

python3 -m pip install --user black yapf isort pylint
