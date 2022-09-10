#!/bin/bash -xe

if [ "$EUID" -eq 0 ]
    then echo "Please run without sudo"
    exit
fi
# User-configured variables
livepatch_key='LIVEPATCH_KEY_GOES_HERE'

# Helpful file/config watching commands
# (Requires inotify-tools)
#   inotifywatch -e modify,create,delete -r ~/.config
#   inotifywatch -e modify,create,delete -r ~/snap/firefox/common/.mozilla
#   inotifywatch -e modify,create,delete -r ~/.local
#   inotifywatch -e modify,create,delete -r /etc/default
#   dconf watch /

# TODO: Add waypoint check here to resume script at startup
# apt-get update
# apt-get dist-upgrade -y
# shutdown -r now

sudo apt-get update

sudo apt-get install -y linux-generic
sudo apt-get install -y build-essential
# Required for APT with HTTPS
sudo apt-get install -y apt-transport-https
# Required for fetching files and installing keys
sudo apt-get install -y gpg wget curl
# Required for release codename
sudo apt-get install -y lsb-core
# Install General Packages
sudo apt-get install -y protobuf-compiler usb-creator-gtk imagemagick bzip2 \
                   net-tools         nmap whois      unzip       zstd \
                   awscli            htop tmux       jq          exfatprogs \
                   synaptic          gparted         vlc         gimp \
                   git               nomacs          handbrake   filezilla \
                   ssh-askpass

# Flags
export INSIDE_SCRIPT=true
# User executing script
if [ $SUDO_USER ]; then
    export USER=$SUDO_USER;
else
    export USER=$LOGNAME;
fi
if [[ $USER == 'root' ]]; then
    echo 'Must run as non-root user!'
    exit
fi

# Install Python 3.X
bash ./bin/install_python3.sh
# TODO: Configure Python 3.X
# bash ./bin/configure_python3.sh

# Install Node.js
bash ./bin/install_nodejs.sh

# Install FiraCode Font
bash ./bin/install_firacode_font.sh

# Install Sublime Text
bash ./bin/install_sublime_text.sh

# Install Visual Studio Code
bash ./bin/install_visual_studio_code.sh

# TODO: Install GCloud
# bash ./bin/install_gcloud.sh

# Install Signal Desktop
bash ./bin/install_signal_desktop.sh

# TODO: Install Spotify
# sudo snap install spotify

# Install Oracle VirtualBox
bash ./bin/install_oracle_virtualbox.sh
# Configure Oracle VirtualBox
bash ./bin/configure_oracle_virtualbox.sh

# Install Vagrant
bash ./bin/install_vagrant.sh
# Configure Vagrant
bash ./bin/configure_vagrant.sh

# Install Google Chrome
bash ./bin/install_google_chrome.sh
# TODO: Configure Google Chrome
# bash ./bin/configure_google_chrome.sh

# TODO: Configure Mozilla Firefox
# bash ./bin/configure_mozilla_firefox.sh

# Configure Canonical Livepatch
bash ./bin/configure_livepatch.sh "$livepatch_key"

# Configure Firewall (UFW)
bash ./bin/configure_ufw.sh

#### Configure SSH
# sudo sed -i -e "s|^#PermitRootLogin yes|PermitRootLogin no|" \
# -e "s|^#PasswordAuthentication yes|PasswordAuthentication no|" \
# -e "s|^#PermitEmptyPasswords no|PermitEmptyPasswords no|" \
# -e "s|^#Port 22|Port 2222|" \
# -e "s|^#LoginGraceTime 2m|LoginGraceTime 2m|" \
# -e "s|^#MaxAuthTries 6|MaxAuthTries 6|" \
# -e "s|^#MaxSessions 10|MaxSessions 10|" /etc/ssh/sshd_config

# Add github to known hosts
# ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts

# Configure Swapfile
bash ./bin/configure_swapfile.sh

# Configure dconf
bash ./bin/configure_dconf.sh

# Change power mode to "performance"
powerprofilesctl set performance

# Change processor governors to "Performance"
# https://askubuntu.com/questions/604720/setting-to-high-performance
#   View available:
#     cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors 
#   View current:
#     cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
#   Change setting:
# echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

# Disable bluetooth
# https://unix.stackexchange.com/questions/387502/disable-bluetooth-at-boot
#   Modify the file located at /etc/bluetooth/main.conf
sudo sed 's|AutoEnable=true|AutoEnable=false|' -i /etc/bluetooth/main.conf

# miniconda3
# AWS settings and creds
# Disable watchdog in streamlit/config.toml
# cmdstan located in ~/.cmdstan/cmdstan-2.29.1
# Deepface weights
# Download, extract, and rename mujoco210 situation
# Custom cspell dictionary
# ~/.cspell/custom-dictionary-user.txt
# Github credentials
# ~/.gitconfig
# Pypi credentials ~/.pypirc
# ~/.bash_history and ~/.ssh
# Geckdriver and Chromedriver
# NOTE: Should add check for existing keys, ask for overriding, etc.
# Assign default DNS servers

sudo apt-get autoremove -y
