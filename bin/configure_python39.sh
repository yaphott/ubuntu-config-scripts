#!/bin/bash -e

function exit_with_failure () { echo 'Failed to configure Python 3.9.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

echo '~~~ Configuring Python 3.9'

#### Update pip

( python3.9 -m pip install -U --user pip setuptools wheel \
    && python3.9 -m pip install -U --user build
) || exit_with_failure

#### Install dev tools

python3.9 -m pip install --user black yapf isort pylint \
    || exit_with_failure
