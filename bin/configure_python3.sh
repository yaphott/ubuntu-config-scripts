#!/bin/bash -e

echo '~~~ Configuring Python 3.x'

#### Update pip

python3 -m pip install -U --user pip \
    && python3 -m pip install -U setuptools wheel \
    && python3 -m pip install -U --user build

#### Install dev tools

# python3 -m pip install --user black yapf isort pylint pytest mypy isort

echo 'Python 3.x configured successfully.'
