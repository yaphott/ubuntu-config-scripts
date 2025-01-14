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
if [[ (! "$1") || (! "$2") || (! "$3") || (! "$4") || (! "$5") ]]; then
    echo 'Missing expected input parameters:'
    echo '    repo_options: Repository options (e.g. arch=amd64 signed-by=/etc/apt/keyrings/example-keyring.gpg).'
    echo '    repo_uri: Repository URI (e.g. https://example.com/example-pub.gpg).'
    echo '    repo_suite: Repository suite (e.g. stable).'
    echo "    repo_components: Repository components (space-separated), or 'none' if none (e.g. main contrib non-free)."
    echo '    repo_filepath: Desired path to write the repository list file to (e.g. /etc/apt/sources.list.d/example.list).'
    echo ''
    echo 'Usage:'
    echo '    add_repository.sh <repo_options> <repo_uri> <repo_suite> <repo_components> <repo_filepath>'
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
if [[ "$4" == 'none' ]]; then
    repo_components=''
else
    repo_components="$4"
fi
repo_filepath="$5"

echo 'Adding repository --> '"$repo_filepath"
if [ -f "$repo_filepath" ]; then
    echo 'Backing up existing file.'
    sudo cp -f "$repo_filepath" "$repo_filepath.bak"
fi

entry_contents='deb [ '"$repo_options"' ] '"$repo_uri"' '"$repo_suite"
if [[ -n "$repo_components" ]]; then
    entry_contents+=' '"$repo_components"
fi
echo '# Added by the Ubuntu-Config-Scripts installer.'                               | sudo tee    "$repo_filepath" > /dev/null
echo '# For more information, see: https://github.com/yaphott/ubuntu-config-scripts' | sudo tee -a "$repo_filepath" > /dev/null
echo "$entry_contents"                                                               | sudo tee -a "$repo_filepath" > /dev/null
echo ''                                                                              | sudo tee -a "$repo_filepath" > /dev/null
