
#!/usr/bin/env bash -e

function exit_with_failure () { echo 'Failed to install Google Cloud CLI.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

echo '+++ Google Cloud CLI'

# TODO: Should determine latest version and download that instead of hard-coded.
google_cli_version='410.0.0'

# Local variables
latest_release_name='google-cloud-cli-'"$google_cli_version"'-linux-x86_64'
latest_release_file="$latest_release_name"'.tar.gz'
latest_release_file_url='https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/'"$latest_release_file"

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
tar -xf './tmp/'"$latest_release_file" -C './tmp/'"$latest_release_name" \
    || exit_with_failure

# Install
'./tmp/'"$latest_release_name"'/google-cloud-sdk/install.sh' \
    || exit_with_failure

# Avoid starting a new shell
source "$HOME"'/.bashrc' || exit_with_failure

# Update SDK installation
gcloud components update || exit_with_failure

# Clean up
( rm './tmp/'"$latest_release_file" \
    && rm -r './tmp/'"$latest_release_name"
) || exit_with_failure


# TODO: Needs to run 'gcloud init' in a new window
# NOTE: To update run 'gcloud components update'
