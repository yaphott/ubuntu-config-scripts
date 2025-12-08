#!/bin/bash -e

echo '+++ Installing FiraCode Font'

tmp_dir="$(mktemp -d)"

github_user='tonsky'
github_project='FiraCode'
github_api_url="https://api.github.com/repos/${github_user}/${github_project}"
github_std_url="https://github.com/${github_user}/${github_project}"

# Fetch the version of the latest release
#   https://fabianlee.org/2021/02/16/bash-determining-latest-github-release-tag-and-version/
latest_release_ver="$(curl -fsLS --proto '=https' --tlsv1.2 "${github_api_url}/releases/latest" | jq -r '.tag_name')"

# Validate release version
#   Allows for unlimited number/period combinations, and unlimited letters at the end
#   Must have at least one number in the version
#   Accepts:     Rejects:
#     1.2.3        1a.2.3
#     1.23.3.4a    1.2b.3
#     1.2.3.4ab    1.2a.3c
is_valid_release_ver=$(python3 -c 'from string import ascii_letters; print(str("'"$latest_release_ver"'".rstrip(ascii_letters).replace(".","").isdigit()).lower())')
if [[ -z "$is_valid_release_ver" || "$is_valid_release_ver" != 'true' ]]; then
    echo "Failed to fetch version for latest release of ${github_project} by ${github_user}."
    exit 1
fi

# Download a ZIP file containing the latest release
latest_name="Fira_Code_v$latest_release_ver"
latest_file_name="$latest_name.zip"
latest_url="${github_std_url}/releases/download/${latest_release_ver}/${latest_file_name}"

curl -fsLS --proto '=https' --tlsv1.2 "$latest_url" -o "${tmp_dir}/${latest_file_name}"

# Verify download
if [[ ! -f "${tmp_dir}/${latest_file_name}" ]]; then
    echo "Failed to download ${github_project} by ${github_user} from ${latest_url}."
    exit 1
fi

# Delete output folder if already exists
if [[ -d "${tmp_dir}/${latest_name}" ]]; then
    echo "Folder already exists: ${tmp_dir}/${latest_name}. Deleting..."
    rm -r "${tmp_dir}/${latest_name}"
fi

# Create output folder and extract
mkdir "${tmp_dir}/${latest_name}"
unzip "${tmp_dir}/${latest_file_name}" -d "${tmp_dir}/${latest_name}"

# Create user fonts directory if missing
if [[ ! -d "$HOME/.fonts" ]]; then
    mkdir "$HOME/.fonts"
fi

# Sometimes the uuid file needs deleting and regenerating
#   So we'll do it either way if it exists
if [[ -s "$HOME/.fonts/uuid" ]]; then
    rm "$HOME/.fonts/uuid"
fi

# Copy into fonts and rebuild font cache
cp "${tmp_dir}/${latest_name}"'/ttf/'*'.ttf' -t "$HOME/.fonts"
fc-cache -f -v

# Validate the fonts are installed
if [[ $(fc-list | grep -c 'Fira Code') -eq 0 ]]; then
    echo 'Failed to install FiraCode Font.'
    exit 1
fi

# Clean up
rm -r "$tmp_dir"
