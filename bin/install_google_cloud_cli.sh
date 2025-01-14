#!/bin/bash -e

function exit_with_failure () { echo 'Failed to install Google Cloud CLI.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

echo '+++ Google Cloud CLI'

# Validate the download by checking the SHA256 hash.
#
# Usage:
#     validate_download <file_path> <expected_sha256>
#
# Example with expected hash:
#     validate_download /tmp/tmp.abc123/example.tar.gz abc123
#
# Example without expected hash:
#     validate_download /tmp/tmp.abc123/example.tar.gz
#
# Parameters:
#     file_path: Path to the downloaded file.
#     expected_sha256: Optional. Expected SHA256 hash of the downloaded file.
function validate_download () {
    file_path="$1"
    if [[ ! -f "$file_path" ]]; then
        echo 'Downloaded file does not exist.'
        return 1
    fi
    expected_sha256="$2"
    if [[ -n "$expected_sha256" ]]; then
        actual_sha256="$( sha256sum "$file_path" | awk '{ print $1 }' )"
        if [[ "$actual_sha256" != "$expected_sha256" ]]; then
            echo 'Downloaded file does not match expected SHA256 hash.'
            echo "    Expected: $expected_sha256"
            echo "    Actual:   $actual_sha256"
            return 1
        fi
    fi
    return 0
}

# TODO: Should determine latest version and download that instead of hard-coded.
google_cli_version='410.0.0'

latest_name="google-cloud-cli-$google_cli_version-linux-x86_64"
latest_file_name="$latest_name.tar.gz"
latest_url="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/$latest_file_name"

# Create working directory
tmp_dir="$(mktemp -d -p ./tmp/)"
if [[ ! -d "$tmp_dir" ]]; then
    echo 'Failed to create temporary directory.'
    exit 1
fi

# Download the latest installer
curl -fsL --proto '=https' --tlsv1.2 "$latest_url" -o "${tmp_dir}/${latest_file_name}" \
    || exit_with_failure

# Verify download
validate_download "${tmp_dir}/${latest_file_name}" \
    || exit_with_failure

# Extract
tar -xf "${tmp_dir}/${latest_file_name}" -C "$tmp_dir" \
    || exit_with_failure

# Install (opts out of anonymous usage reporting and opts in to command-completion)
"${tmp_dir}/google-cloud-sdk/install.sh" \
    --usage-reporting false \
    --command-completion true \
    --path-update true \
    --bash-completion true \
    --rc-path "$HOME/.bashrc" \
    --quiet \
    || exit_with_failure
#     --additional-components kubectl

# Avoid starting a new shell
# source "$HOME/.bashrc" || exit_with_failure

# Update SDK installation
# gcloud components update || exit_with_failure

# TODO: Add and verify
# Install components
# gcloud components install kubectl || exit_with_failure

# Clean up
rm -r "$tmp_dir" || echo 'Failed to remove temporary directory.'

# TODO: Needs to run 'gcloud init' in a new window
# NOTE: To update run 'gcloud components update'
