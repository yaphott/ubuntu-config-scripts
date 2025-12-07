#!/bin/bash -e

echo '+++ Installing Go'

tmp_dir="$(mktemp -d)"

# Download the latest version
latest_url_path=$(curl -fsLS --proto '=https' --tlsv1.2 https://go.dev/dl/ | grep -o -m 1 -E '/dl/go[0-9]+\.[0-9]+\.[0-9]+\.linux-amd64.tar\.gz')
latest_url="https://go.dev$latest_url_path"
latest_file_name=$(echo $latest_url | grep -o -E '\b[a-zA-Z0-9\.\-]+\.tar\.gz$')

echo "Downloading ${latest_file_name}..."
curl -fsLS --proto '=https' --tlsv1.2 "$latest_url" -o "${tmp_dir}/${latest_file_name}"

# Verify download
if [[ ! -f "${tmp_dir}/${latest_file_name}" ]]; then
    echo "Failed to download ${latest_file_name} from ${latest_url}."
    exit 1
fi

# Remove any previous versions of Go
if [[ -d '/usr/local/go' ]]; then
    echo 'Removing previous installation of Go...'
    sudo rm -rf /usr/local/go
fi

# Extract
sudo tar -C /usr/local -xzf "${tmp_dir}/${latest_file_name}"

# Verify installation
export PATH="$PATH:/usr/local/go/bin"
go version > /dev/null

# Add Go to PATH in .bashrc
echo '# Go'                                  >> "$HOME/.bashrc"
echo 'export PATH="$PATH:/usr/local/go/bin"' >> "$HOME/.bashrc"
echo ''                                      >> "$HOME/.bashrc"

# Clean up
rm -r "$tmp_dir"

echo '+++ Go has been successfully installed!'
