#!/usr/bin/env bash -e

function exit_with_failure () { echo 'Failed to install Scala.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

echo '+++ Installing Scala'

# Local variables
latest_release_name='coursier'
latest_release_file='cs-x86_64-pc-linux.gz'
latest_release_file_url='https://github.com/coursier/coursier/releases/latest/download/'"$latest_release_file"

# Delete output folder if already exists
if [[ -d './tmp/'"$latest_release_name" ]]; then
    echo 'Folder already exists: ./tmp/'"$latest_release_name"'. Deleting ...'
    rm -r './tmp/'"$latest_release_name" || exit_with_failure
fi

# Create output folder
mkdir './tmp/'"$latest_release_name" || exit_with_failure

# Download the latest installer
wget "$latest_release_file_url" -O './tmp/'"$latest_release_file" \
    || exit_with_failure

# Verify download
if [[ ! -f './tmp/'"$latest_release_file" ]]; then
    echo 'Failed to download '"$latest_release_file"' from '"$latest_release_file_url"'.'
    exit_with_failure
fi

# Extract
gunzip -c './tmp/'"$latest_release_file" > './tmp/'"$latest_release_name"'/cs' \
    || exit_with_failure

# Install
( sudo chmod +x './tmp/'"$latest_release_name"'/cs' \
    && './tmp/'"$latest_release_name"'/cs' setup \
) || exit_with_failure

# Verify installation
"$HOME"'/.local/share/coursier/bin/coursier' --help \
    || exit_with_failure

# Clean up
( rm './tmp/'"$latest_release_file" \
    && rm -r './tmp/'"$latest_release_name"
) || exit_with_failure

echo 'Scala installed successfully.'
