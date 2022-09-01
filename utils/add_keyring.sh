#!/bin/bash -xe

# Insert Public Software Signing Key
# Parameters:
#   (1) URL of key to download
#   (2) Filename alias to use
#   (3) Keyrings directory

# Download
wget -qO - "$1" | gpg --dearmor > "$2"

# Install
sudo install -D -o root -g root -m 644 "$2" "$3"'/'"$2"

# Clean up
rm -f "$2"
