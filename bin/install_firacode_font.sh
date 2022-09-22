#!/bin/bash -xe

if [[ ! $INSIDE_SCRIPT ]]; then
    echo 'Please run with the installer script. Exiting ...'
    exit
fi

# Install FiraCode Font
echo '+++ Installing FiraCode Font'

github_user='tonsky'
github_project='FiraCode'
github_api_url='https://api.github.com/repos/'"$github_user"'/'"$github_project"
github_std_url='https://github.com/'"$github_user"'/'"$github_project"

# Fetch the version of the latest release
#   https://fabianlee.org/2021/02/16/bash-determining-latest-github-release-tag-and-version/
latest_release_ver=$( curl -s "$github_api_url"'/releases/latest' | jq -r ".tag_name" )

# Validate release version
#   Allows for unlimited number/period combinations, and unlimited letters at the end
#   Must have at least one number in the version
#   Accepts:     Rejects:
#     1.2.3        1a.2.3
#     1.23.3.4a    1.2b.3
#     1.2.3.4ab    1.2a.3c
is_valid_release_ver=$( python3 -c '\
from string import ascii_letters; \
to_check="'"$latest_release_ver"'"; \
is_valid=to_check.rstrip(ascii_letters).replace(".","").isdigit(); \
is_valid_str=str(is_valid).lower(); \
print(is_valid_str)\
' )
if [ $is_valid_release_ver = false ]; then
    echo 'Failed to fetch version for latest release of '"$github_project"' by '"$github_user"'. Exiting ...'
    exit
fi

# Download a ZIP file containing the latest release
latest_release_name='Fira_Code_v'"$latest_release_ver"
latest_release_file="$latest_release_name"'.zip'
latest_release_file_url="$github_std_url"'/releases/download/'"$latest_release_ver"'/'"$latest_release_file"
wget "$latest_release_file_url" -O './tmp/'"$latest_release_file"

# Verify download
if [[ ! -f './tmp/'"$latest_release_file" ]]; then
    echo 'Failed to download '"$github_project"' by '"$github_user"' from '"$latest_release_file_url"'. Exiting ...'
    exit
fi

# Delete output folder if already exists
if [[ -d './tmp/'"$latest_release_name" ]]; then
    echo 'Folder already exists: ./tmp/'"$latest_release_name"'. Deleting ...'
    rm -r './tmp/'"$latest_release_name"
fi

# Create output folder and extract
mkdir './tmp/'"$latest_release_name"
unzip './tmp/'"$latest_release_name"'.zip' -d './tmp/'"$latest_release_name"

# Create user fonts directory if missing
if [[ ! -d "$HOME"'/.fonts' ]]; then
    mkdir "$HOME"'/.fonts'
fi

# Sometimes the uuid file needs deleting and regenerating
#   So we'll do it either way if it exists
if [[ -f "$HOME"'/.fonts/uuid' ]]; then
    rm "$HOME"'/.fonts/uuid'
fi

# Copy into fonts
cp './tmp/'"$latest_release_name"'/ttf/'*'.ttf' -t "$HOME"'/.fonts'

# Rebuild the font cache
fc-cache -f -v

# Clean up
rm './tmp/'"$latest_release_name"'.zip'
rm -r './tmp/'"$latest_release_name"
