#!/bin/bash -e


[[ $INSIDE_SCRIPT ]] || ( echo 'Please run with the installer script.'; exit 1; )

# Validate input parameters
# 1. Repository options (e.g. arch=amd64 signed-by=/usr/share/keyrings/sublime-text-keyring.gpg)
# 2. Repository URI (e.g. https://download.sublimetext.com/sublimehq-pub.gpg)
# 3. Repository suite (e.g. stable)
# 4. Repository components (space-separated)
# 5. Repository filename to write to (e.g. sublime-text.list)
if [[ (! "$1") || (! "$2") || (! "$3") || (! "$4") || (! "$5") ]]; then
    echo 'Missing expected input parameters:'
    echo '    options: Repository options (e.g. arch=amd64 signed-by=/usr/share/keyrings/sublime-text-keyring.gpg)'
    echo '    uri: Repository URI (e.g. https://download.sublimetext.com/sublimehq-pub.gpg)'
    echo '    suite: Repository suite (e.g. stable)'
    echo '    components: Repository components (space-separated)'
    echo '    filename: Repository filename to write to (e.g. sublime-text.list)'
    echo ''
    echo 'Example:'
    echo '    add_repository.sh "arch=amd64 signed-by=/usr/share/keyrings/sublime-text-keyring.gpg" "https://download.sublimetext.com/sublimehq-pub.gpg" "stable" "main" "sublime-text.list"'
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
repo_filename="$5"

repo_source_path='/etc/apt/sources.list.d/'"$repo_filename"

echo 'Adding repository --> '"$repo_source_path"
# if [ -f "$repo_source_path" ]; then
#     echo 'File already exists. Would you like to overwrite it?'
#     while true; do
#         read -p 'Overwrite? [y/n] ' yn
#         case $yn in
#             [Yy][Ee][Ss] | [Yy] ) break;;
#             [Nn][Oo] | [Nn] ) exit 1;;
#             * ) echo 'Please answer yes or no.';;
#         esac
#     done
#     echo 'Overwriting file.'
# fi

echo "\
# Added by the Ubuntu-Config-Scripts installer.
deb [$repo_options] $repo_uri $repo_suite $repo_components
" | sudo tee -a "$repo_source_path" > /dev/null
