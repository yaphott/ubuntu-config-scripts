#!/bin/bash -e

# Prevent running with sudo
if [ "$EUID" -eq 0 ]; then
    echo 'Please run without sudo.'
    exit 1
fi

# Prevent running as root user
if [[ $USER == 'root' ]]; then
    echo 'Please run as non-root user.'
    exit 1
fi

# Validate input parameters
if [[ $# -ne 5 ]]; then
    echo 'Missing expected input parameters:'
    echo '    options: Repository options (e.g. arch=amd64 signed-by=/etc/apt/keyrings/example-keyring.gpg).'
    echo '    uri: Repository URI (e.g. https://example.com/example-pub.gpg).'
    echo '    suite: Repository suite (e.g. stable).'
    echo "    components: Repository components (space-separated), or empty if none (e.g. main contrib non-free)."
    echo '    file_path: Desired path to write the repository list file to (e.g. /etc/apt/sources.list.d/example.list).'
    echo ''
    echo 'Usage:'
    echo '    add_repository.sh <options> <uri> <suite> <components> <file_path>'
    exit 1
fi

# The format for two one-line-style entries using the deb and deb-src types is:
#
#     deb [ option1=value1 option2=value2 ] uri suite [component1] [component2] [...]
#     deb-src [ option1=value1 option2=value2 ] uri suite [component1] [component2] [...]
#
# See https://manpages.ubuntu.com/manpages/xenial/man5/sources.list.5.html for more details.

repo_options="$1"
repo_uri="$2"
repo_suite="$3"
repo_components="$4"
repo_file_path="$5"

echo "Adding repository to ${repo_file_path}"
if [ -f "$repo_file_path" ]; then
    backup_repo_file_path="${repo_file_path}.bak"
    echo "Backing up existing file ${repo_file_path} to ${backup_repo_file_path}"
    sudo cp -f "$repo_file_path" "$backup_repo_file_path"
fi

entry_contents='deb [ '"$repo_options"' ] '"$repo_uri"' '"$repo_suite"
if [[ -n "$repo_components" ]]; then
    entry_contents+=' '"$repo_components"
fi
# TODO: Replace this with single call
echo '# Added by the Ubuntu-Config-Scripts installer.'                               | sudo tee    "$repo_file_path" > /dev/null
echo '# For more information, see: https://github.com/yaphott/ubuntu-config-scripts' | sudo tee -a "$repo_file_path" > /dev/null
echo "$entry_contents"                                                               | sudo tee -a "$repo_file_path" > /dev/null
echo ''                                                                              | sudo tee -a "$repo_file_path" > /dev/null
