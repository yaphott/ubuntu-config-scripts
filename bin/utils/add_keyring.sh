#!/bin/bash -xe

if [[ ! $INSIDE_SCRIPT ]]; then
    echo "Please run with the installer script"
    exit
fi

#### Insert Public Software Signing Key
# Parameters:
#   (1) URL of key to download
#   (2) Filename alias to use

echo 'Adding keyring in '"$KEYRINGS_PATH"'/'"$2"

# Download
wget -qO - "$1" | gpg --dearmor > "$REPO_TMP_PATH"'/'"$2"

# Install
sudo install -D -o root -g root -m 644 "$REPO_TMP_PATH"'/'"$2" "$KEYRINGS_PATH"'/'"$2"

# Clean up
rm -f "$REPO_TMP_PATH"'/'"$2"
