#!/bin/bash -xe

if [[ ! $INSIDE_SCRIPT ]]; then
    echo "Please run with the installer script"
    exit
fi

# Flags
echo 'Declaring flags'

# Codename of the release
export LSB_RELEASE_CODENAME="$( lsb_release -cs )"

# Keyrings path
export KEYRINGS_PATH='/usr/share/keyrings'

# Sources list path
export SOURCES_LIST_PATH='/etc/apt/sources.list.d/'

# Repository paths
export REPO_BIN_PATH="$PWD"'/bin'
export REPO_UTILS_PATH="$PWD"'/bin/utils'
export REPO_TMP_PATH="$PWD"'/tmp'

# User executing the script
if [ $SUDO_USER ]; then
    export USER=$SUDO_USER;
else
    export USER=$LOGNAME;
fi

# Home path for the user
if [[ $USER == 'root' ]]; then
    export HOME_PATH='/root'
else
    export HOME_PATH='/home/'"$USER"
fi

# TODO: Add check during dconf and other configuration, otherwise modify in a way that
#       applies the configuration universally.
if [[ $USER == 'root' ]]; then
    then echo "Please run as non-root user"
    exit
fi