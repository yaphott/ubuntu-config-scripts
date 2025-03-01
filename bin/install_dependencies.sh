#!/bin/bash -e

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
# | ca-certificates     | HTTPS.                              |
# | gnupg               | Fetching files and installing keys. |
# +---------------------+-------------------------------------+
PACKAGE_NAMES=(
    linux-generic
    build-essential
    apt-transport-https
    gpg
    wget
    curl
    lsb-core
    ca-certificates
    gnupg
)
sudo apt-get update && sudo apt-get install -y "${PACKAGE_NAMES[@]}"
