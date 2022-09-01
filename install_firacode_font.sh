#!/bin/bash -xe

# Install FiraCode Font

# Fetch the latest version number
# https://fabianlee.org/2021/02/16/bash-determining-latest-github-release-tag-and-version/
github_user='tonsky'
github_project='FiraCode'
latest_release_version=$( curl -s 'https://api.github.com/repos/'"$github_user"'/'"$github_project"'/releases/latest' | jq -r ".tag_name" )

# Fetch the latest release
release_filename='Fira_Code_v'"$latest_release_version"
wget 'https://github.com/tonsky/FiraCode/releases/download/'"$latest_release_version"'/'"$release_filename"'.zip'
mkdir "$release_filename"
unzip "$release_filename"'.zip' -d "$release_filename"
rm "$release_filename"'.zip'

# Create user fonts directory
mkdir "$HOME"'/.fonts'

# Copy into fonts
cd "$release_filename"'/ttf'
cp "$release_filename"'/ttf/'*'.ttf' -t "$HOME"'/.fonts'

# Clean up
rm -r "$release_filename"

# Rebuild the font cache
fc-cache -f -v
