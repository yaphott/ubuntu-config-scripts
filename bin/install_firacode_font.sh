#!/bin/bash -xe

if [[ ! $INSIDE_SCRIPT ]]; then
    echo "Please run with the installer script"
    exit
fi

# Install FiraCode Font
echo 'Installing FiraCode Font'

# Fetch the latest version number
# https://fabianlee.org/2021/02/16/bash-determining-latest-github-release-tag-and-version/
github_user='tonsky'
github_project='FiraCode'
latest_release_version=$( curl -s 'https://api.github.com/repos/'"$github_user"'/'"$github_project"'/releases/latest' | jq -r ".tag_name" )

# Fetch the latest release
latest_release_name='Fira_Code_v'"$latest_release_version"
wget 'https://github.com/tonsky/FiraCode/releases/download/'"$latest_release_version"'/'"$latest_release_name"'.zip' \
     -O "$REPO_TMP_PATH"'/'"$latest_release_name"'.zip'
mkdir "$REPO_TMP_PATH"'/'"$latest_release_name"
unzip "$REPO_TMP_PATH"'/'"$latest_release_name"'.zip' -d "$REPO_TMP_PATH"'/'"$latest_release_name"

# Create user fonts directory
mkdir "$HOME"'/.fonts'

# Copy into fonts
cd "$latest_release_name"'/ttf'
cp "$latest_release_name"'/ttf/'*'.ttf' -t "$HOME"'/.fonts'

# Rebuild the font cache
fc-cache -f -v

# Clean up
rm -f "$REPO_TMP_PATH"'/'"$latest_release_name"'.zip'
rm -rf "$REPO_TMP_PATH"'/'"$latest_release_name"
