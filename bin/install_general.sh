#!/usr/bin/env bash
set -e

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
    ntfs-3g
    nvme-cli
    php
    protobuf-compiler
    qgis
    qgis-plugin-grass
    postgresql-client
    ruby-full
    smartmontools
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
