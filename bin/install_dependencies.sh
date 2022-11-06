#!/bin/bash -e

function exit_with_failure () { echo 'Failed to install Dependencies.'; exit 1; }

if [[ ! $INSIDE_SCRIPT ]]; then
    echo 'Please run with the installer script.'
    exit_with_failure
fi

# Install Dependencies
echo '+++ Dependencies'

# Update package database and install
# +---------------------+-------------------------------------+
# | Software name(s)    | Reason for dependency               |
# +---------------------+-------------------------------------+
# | linux-generic       | Building software.                  |
# | build-essential     | APT with HTTPS.                     |
# | apt-transport-https | Fetching files and installing keys. |
# | gpg, wget, curl     | Fetching files and installing keys. |
# | lsb-core            | Release codename.                   |
# +---------------------+-------------------------------------+
( sudo apt-get update \
  && sudo apt-get install -y linux-generic \
                          build-essential \
                          apt-transport-https \
                          gpg wget curl \
                          lsb-core
) || exit_with_failure
