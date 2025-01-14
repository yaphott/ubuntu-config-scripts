#!/bin/bash -e

function exit_with_failure () { echo 'Failed to install Go.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

echo '+++ Installing Go'

# Download the latest version
latest_url_path=$(curl -fsL --proto '=https' --tlsv1.2 https://go.dev/dl/ | grep -o -m 1 -E '/dl/go[0-9]+\.[0-9]+\.[0-9]+\.linux-amd64.tar\.gz')
latest_url="https://go.dev$latest_url_path"
latest_file_name=$(echo $latest_url | grep -o -E '\b[a-zA-Z0-9\.\-]+\.tar\.gz$')

echo "Downloading $latest_file_name..."
curl -fsL --proto '=https' --tlsv1.2 "$latest_url" -o './tmp/'"$latest_file_name" || exit_with_failure

# Verify download
if [[ ! -f './tmp/'"$latest_file_name" ]]; then
    echo "Failed to download $latest_file_name from $latest_url."
    exit_with_failure
fi

# Remove any previous versions of Go
if [[ -d '/usr/local/go' ]]; then
    echo 'Removing previous installation of Go...'
    sudo rm -rf /usr/local/go || exit_with_failure
fi

# Extract
sudo tar -C /usr/local -xzf './tmp/'"$latest_file_name" || exit_with_failure

# Verify installation
export PATH="$PATH:/usr/local/go/bin"
go version > /dev/null || exit_with_failure

# Add Go to PATH in .bashrc
echo '# Go'                                  >> "$HOME/.bashrc"
echo 'export PATH="$PATH:/usr/local/go/bin"' >> "$HOME/.bashrc"
echo ''                                      >> "$HOME/.bashrc"

# Clean up
rm -f './tmp/'"$latest_file_name" || echo 'Failed to remove Go installer.'

echo '+++ Go has been successfully installed!'
