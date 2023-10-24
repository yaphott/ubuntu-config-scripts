
#!/bin/bash -e

function exit_with_failure () { echo 'Failed to install Google Cloud CLI.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

echo '+++ Google Cloud CLI'

# Validate the download by checking the SHA256 hash.
#
# Usage:
#     validate_download <downloaded_file_path> <expected_sha256_hash>
#
# Example with expected hash:
#     validate_download /tmp/tmp.abc123/example.tar.gz abc123
#
# Example without expected hash:
#     validate_download /tmp/tmp.abc123/example.tar.gz
#
# Parameters:
#     downloaded_file_path: Path to the downloaded file.
#     expected_sha256_hash: Optional. Expected SHA256 hash of the downloaded file.
function validate_download () {
    downloaded_file_path="$1"
    if [[ ! -f "$downloaded_file_path" ]]; then
        echo 'Downloaded file does not exist.'
        return 1
    fi

    expected_sha256_hash="$2"
    if [[ ! -z "$expected_sha256_hash" ]]; then
        actual_sha256_hash="$( sha256sum "$downloaded_file_path" | awk '{ print $1 }' )"
        if [[ "$actual_sha256_hash" != "$expected_sha256_hash" ]]; then
            echo 'Downloaded file does not match expected SHA256 hash.'
            echo '    Expected: '"$expected_sha256_hash"
            echo '    Actual:   '"$actual_sha256_hash"
            return 1
        fi
    fi

    return 0
}

# Download a file from a URL.
#
# Usage:
#     download_file <url> <output_path>
#
# Example:
#     download_file https://example.com/example.tar.gz /tmp/example.tar.gz
#
# Parameters:
#     url: URL to download the file from.
#     output_path: Path to save the downloaded file to.
function download_file () {
    local url="$1"
    local output_path="$2"
    wget "$url" -O "$output_path"
}

# TODO: Should determine latest version and download that instead of hard-coded.
google_cli_version='410.0.0'

# Local variables
latest_release_name='google-cloud-cli-'"$google_cli_version"'-linux-x86_64'
latest_release_file="$latest_release_name"'.tar.gz'
latest_release_file_url='https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/'"$latest_release_file"

# Create working directory
temp_dir="$( mktemp -d )" || exit_with_failure

# Download the latest installer
download_file "$latest_release_file_url" "$temp_dir"'/'"$latest_release_file" \
    || exit_with_failure

# Verify download
validate_download "$temp_dir"'/'"$latest_release_file"

# Extract
tar -xf "$temp_dir"'/'"$latest_release_file" -C "$temp_dir" \
    || exit_with_failure

# Install (opts out of anonymous usage reporting and opts in to command-completion)
"$temp_dir"'/google-cloud-sdk/install.sh' \
    --usage-reporting false \
    --command-completion true \
    --path-update true \
    --bash-completion true \
    --rc-path "$HOME"'/.bashrc' \
    --quiet \
    || exit_with_failure
#     --additional-components kubectl

# Avoid starting a new shell
# source "$HOME"'/.bashrc' || exit_with_failure

# Update SDK installation
# gcloud components update || exit_with_failure

# Install components
# gcloud components install kubectl || exit_with_failure
# TODO: Add more components

# Clean up
rm -r "$temp_dir_path" || echo 'Failed to remove temporary directory.'


# TODO: Needs to run 'gcloud init' in a new window
# NOTE: To update run 'gcloud components update'
