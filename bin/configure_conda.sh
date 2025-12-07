#!/bin/bash -e

echo '~~~ Configuring Conda'


# Add to path if not already
if [[ ! -x "$(command -v conda)" ]]; then
    export PATH="$PATH:$HOME/miniconda3/bin"
fi

conda config --add channels conda-forge
conda config --set channel_priority strict

echo 'Conda configured successfully.'
