#!/bin/bash -e

# [[ $INSIDE_SCRIPT ]] || ( echo 'Please run with the installer script.'; exit 1; )

# Validate input parameters
if [[ (! "$1") || (! "$2") || (! "$3") || (! "$4") || (! "$5") ]]; then
    echo 'Missing expected input parameters:'
    echo '    options: Repository options (e.g. arch=amd64 signed-by=/etc/apt/keyrings/example-keyring.gpg)'
    echo '    uri: Repository URI (e.g. https://example.com/example-pub.gpg)'
    echo '    suite: Repository suite (e.g. stable)'
    echo '    components: Repository components (space-separated)'
    echo '    filepath: Repository filepath (e.g. /etc/apt/sources.list.d/example.list)'
    echo ''
    echo '    Example usage inside of script:'
    echo '        add_repository.sh "arch=amd64 signed-by=/etc/apt/keyrings/example-keyring.gpg" \'
    echo '            https://example.com/example-pub.gpg \'
    echo '            stable \'
    echo '            main \'
    echo '            /etc/apt/sources.list.d/example.list'
    echo ''
    echo '    Example usage outside of script:'
    echo '        sudo add_repository.sh "arch=amd64 signed-by=/etc/apt/keyrings/example-keyring.gpg" \'
    echo '            https://example.com/example-pub.gpg \'
    echo '            stable \'
    echo '            main \'
    echo '            /etc/apt/sources.list.d/example.list'
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
    yes_or_no 'File already exists. Would you like to overwrite it?' || exit 1
    echo 'Overwriting file.'
fi

echo "# Added by the Ubuntu-Config-Scripts installer."            | sudo tee -a "$repo_filepath" > /dev/null
echo "deb [$repo_options] $repo_uri $repo_suite $repo_components" | sudo tee -a "$repo_filepath" > /dev/null
echo ""                                                           | sudo tee -a "$repo_filepath" > /dev/null
