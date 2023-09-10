#!/bin/bash -e

function exit_with_failure () { echo 'Failed to install General Packages.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

# Install General Packages
echo '+++ General Packages'

# Update package database and install
# Excluded: libdvd-pkg
( sudo apt-get update && sudo apt-get install -y \
    git        synaptic    htop             tmux               awscli \
    net-tools  nmap        whois            ssh-askpass        filezilla \
    nomacs     gimp        imagemagick      vlc                handbrake \
    bzip2      unzip       zstd             file-roller        jq \
    gparted    exfatprogs  usb-creator-gtk  protobuf-compiler  libreoffice \
    evince     wireshark   linssid          sqlitebrowser      ffmpeg \
    ruby-full  php         qgis             qgis-plugin-grass
) || exit_with_failure
