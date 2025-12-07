#!/bin/bash -e

echo '~~~ Configuring Conda'

conda config --add channels conda-forge
conda config --set channel_priority strict

echo 'Conda configured successfully.'
