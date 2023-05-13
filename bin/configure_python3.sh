#!/bin/bash -e

function exit_with_failure () { echo 'Failed to configure Python 3.x.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

# Configure Python 3.x
echo '~~~ Configuring Python 3.x'

#### Update pip

( python3 -m pip install -U --user pip \
    && python3 -m pip install -U setuptools wheel \
    && python3 -m pip install -U --user build
) || exit_with_failure

#### Install dev tools

python3 -m pip install --user black yapf isort pylint pytest mypy \
    || exit_with_failure
