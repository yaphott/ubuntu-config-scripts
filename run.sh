#!/bin/bash -xe

# TODO: Add temporary build directory to prevent conflicting file/folder names

# User-configured variables
livepatch_key='LIVEPATCH_KEY_GOES_HERE'

# Helpful file/config watching commands
# (Requires inotify-tools)
#   inotifywatch -e modify,create,delete -r ~/.config
#   inotifywatch -e modify,create,delete -r ~/snap/firefox/common/.mozilla
#   inotifywatch -e modify,create,delete -r ~/.local
#   inotifywatch -e modify,create,delete -r /etc/default
#   dconf watch /

# TODO: Add check to skip to waypoint
sudo apt-get update
sudo apt-get dist-upgrade -y
sudo apt-get update
sudo apt-get autoremove -y
sudo shutdown -r now
# TODO: Add waypoint here
sudo apt-get update
sudo apt-get install -y linux-generic
sudo apt-get install -y build-essential



# Install General Packages
#   Currently excluded: audacity inkscape yt-dlp inotify-tools
sudo apt-get update
sudo apt-get install -y curl      wget   gpg      protobuf-compiler \
                        net-tools unzip  zstd     git \
                        awscli    tmux   jq       exfatprogs \
                        gparted   vlc    gimp     handbrake \
                        filezilla nomacs          usb-creator-gtk

# Install Python 3
bash install_python3.sh

# Install Node.js
bash install_nodejs.sh

# Install FiraCode Font
bash install_firacode_font.sh

# Install Sublime Text
bash install_sublime_text.sh

# Install Visual Studio Code
bash install_visual_studio_code.sh

#### Install GCloud
# NOTE: The following code no longer works
# sudo apt-get update
# sudo apt-get install apt-transport-https ca-certificates gnupg
# # Add the gcloud CLI distribution URI as a package source. If your distribution supports the signed-by option
# echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
# # Add the gcloud CLI distribution URI as a package source. If your distribution supports the signed-by option
# curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
# # Update and install the gcloud CLI
# sudo apt-get update
# sudo apt-get install -y google-cloud-cli
# # Update the Components
# gcloud components update
# # Authenticate
# # gcloud auth login
# sudo snap install google-cloud-cli --classic

# Install Signal Desktop
bash install_signal_desktop.sh

# Install Spotify
# sudo snap install spotify

# Install Oracle VirtualBox
bash install_oracle_virtualbox.sh
# Configure Oracle VirtualBox
bash configure_oracle_virtualbox.sh

# Install Google Chrome
bash install_google_chrome.sh

# Configure Canonical Livepatch
bash configure_livepatch.sh "$livepatch_key"

# Configure swapfile
bash configure_swapfile.sh

# Configure Firewall (UFW)
bash configure_ufw.sh

#### Configure SSH
# sudo sed -i -e "s|^#PermitRootLogin yes|PermitRootLogin no|" \
# -e "s|^#PasswordAuthentication yes|PasswordAuthentication no|" \
# -e "s|^#PermitEmptyPasswords no|PermitEmptyPasswords no|" \
# -e "s|^#Port 22|Port 2222|" \
# -e "s|^#LoginGraceTime 2m|LoginGraceTime 2m|" \
# -e "s|^#MaxAuthTries 6|MaxAuthTries 6|" \
# -e "s|^#MaxSessions 10|MaxSessions 10|" /etc/ssh/sshd_config

# Configure Swapfile
bash configure_swapfile.sh

# Configure dconf
bash configure_dconf.sh

# Change power mode to "Performance"
powerprofilesctl set performance

# # Change processor governors to "Performance"
# # https://askubuntu.com/questions/604720/setting-to-high-performance
# #   View available:
# #     cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors 
# #   View current:
# #     cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
# #   Change setting:
# echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

# #############################################
# TODO: Explore more of these settings in /etc
# #############################################

# Disable bluetooth
# https://unix.stackexchange.com/questions/387502/disable-bluetooth-at-boot
#   Modify the file located at /etc/bluetooth/main.conf
sudo sed 's|AutoEnable=true|AutoEnable=false|' -i /etc/bluetooth/main.conf



# Configuring browser and browser extensions? Probs not because settings can be synced

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

# Firefox

# NOTE: Should add check for existing keys, ask for overriding, etc.
