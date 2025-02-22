#!/bin/bash -e

function exit_with_failure () { echo 'Failed to install General Packages.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

echo '+++ General Packages'

PACKAGE_NAMES=(
    btop
    bzip2
    evince
    exfatprogs
    ffmpeg
    file-roller
    filezilla
    gimp
    git
    gparted
    handbrake
    htop
    imagemagick
    jq
    libreoffice
    linssid
    net-tools
    nmap
    nomacs
    php
    protobuf-compiler
    qgis
    qgis-plugin-grass
    ruby-full
    sqlitebrowser
    ssh-askpass
    synaptic
    tmux
    unzip
    usb-creator-gtk
    vlc
    whois
    wireshark
    zstd
)
# Update package database and install
(sudo apt-get update -y && sudo apt-get install -y "${PACKAGE_NAMES[@]}") \
    || exit_with_failure
