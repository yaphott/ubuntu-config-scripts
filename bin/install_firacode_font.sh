#!/bin/bash -e

function exit_with_failure () { echo 'Failed to install FiraCode Font.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

echo '+++ Installing FiraCode Font'

github_user='tonsky'
github_project='FiraCode'
github_api_url="https://api.github.com/repos/${github_user}/${github_project}"
github_std_url="https://github.com/${github_user}/${github_project}"

# Fetch the version of the latest release
#   https://fabianlee.org/2021/02/16/bash-determining-latest-github-release-tag-and-version/
latest_release_ver="$(curl -fsL --proto '=https' --tlsv1.2 "${github_api_url}/releases/latest" | jq -r '.tag_name')" \
    || exit_with_failure

# Validate release version
#   Allows for unlimited number/period combinations, and unlimited letters at the end
#   Must have at least one number in the version
#   Accepts:     Rejects:
#     1.2.3        1a.2.3
#     1.23.3.4a    1.2b.3
#     1.2.3.4ab    1.2a.3c
is_valid_release_ver=$(python3 -c 'from string import ascii_letters; print(str("'"$latest_release_ver"'".rstrip(ascii_letters).replace(".","").isdigit()).lower())') \
    || exit_with_failure
if [[ -z "$is_valid_release_ver" || "$is_valid_release_ver" != 'true' ]]; then
    echo "Failed to fetch version for latest release of ${github_project} by ${github_user}."
    exit_with_failure
fi

# Download a ZIP file containing the latest release
latest_name="Fira_Code_v$latest_release_ver"
latest_file_name="$latest_name.zip"
latest_url="${github_std_url}/releases/download/${latest_release_ver}/${latest_file_name}"

curl -fsL --proto '=https' --tlsv1.2 "$latest_url" -o './tmp/'"$latest_file_name" \
    || exit_with_failure

# Verify download
if [[ ! -f './tmp/'"$latest_file_name" ]]; then
    echo "Failed to download ${github_project} by ${github_user} from ${latest_url}."
    exit_with_failure
fi

# Delete output folder if already exists
if [[ -d './tmp/'"$latest_name" ]]; then
    echo "Folder already exists: ./tmp/${latest_name}. Deleting..."
    rm -r './tmp/'"$latest_name" || exit_with_failure
fi

# Create output folder and extract
(mkdir './tmp/'"$latest_name" \
    && unzip './tmp/'"$latest_file_name" -d './tmp/'"$latest_name"
) || exit_with_failure

# Create user fonts directory if missing
if [[ ! -d "$HOME/.fonts" ]]; then
    mkdir "$HOME/.fonts" || exit_with_failure
fi

# Sometimes the uuid file needs deleting and regenerating
#   So we'll do it either way if it exists
if [[ -s "$HOME/.fonts/uuid" ]]; then
    rm "$HOME/.fonts/uuid" || exit_with_failure
fi

# Copy into fonts and rebuild font cache
(cp './tmp/'"$latest_name"'/ttf/'*'.ttf' -t "$HOME/.fonts" \
    && fc-cache -f -v
) || exit_with_failure

# Validate the fonts are installed
if [[ $(fc-list | grep -c 'Fira Code') -eq 0 ]]; then
    echo 'Failed to install FiraCode Font.'
    exit_with_failure
fi

# Clean up
(rm './tmp/'"$latest_file_name" \
    && rm -r './tmp/'"$latest_name"
) || exit_with_failure
