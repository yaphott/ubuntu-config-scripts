#!/bin/bash -e

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
sudo apt-get update -y && sudo apt-get install -y "${PACKAGE_NAMES[@]}"
