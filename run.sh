#!/bin/bash -xe

if [ "$EUID" -ne 0 ]
    then echo "Please run with sudo"
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

function clear_tmp () {
    echo 'Emptying temporary working directory '"$REPO_TMP_PATH"
    rm -rf "$REPO_TMP_PATH"'/'*
}

# TODO: Add waypoint check here to resume script at startup
# apt-get update
# apt-get dist-upgrade -y
# shutdown -r now

apt-get update
apt-get install -y linux-generic
apt-get install -y build-essential
# Required for APT with HTTPS
apt-get install -y apt-transport-https
# Required for fetching files and installing keys
apt-get install -y gpg wget curl
# Required for release codename
apt-get install -y lsb-core

# Clear Temporary Files
clear_tmp

# Install General Packages
apt-get update
apt-get install -y protobuf-compiler usb-creator-gtk imagemagick bzip2 \
                   net-tools         nmap whois      unzip       zstd \
                   awscli            htop tmux       jq          exfatprogs \
                   synaptic          gparted         vlc         gimp \
                   git               nomacs          handbrake   filezilla

# Flags
export INSIDE_SCRIPT=true
source "$REPO_BIN_PATH"'/flags.sh'

# Install Python 3.X
bash "$REPO_BIN_PATH"'/install_python3.sh'

# Install Node.js
bash "$REPO_BIN_PATH"'/install_nodejs.sh'

# Install FiraCode Font
bash "$REPO_BIN_PATH"'/install_firacode_font.sh'

# Install Sublime Text
bash "$REPO_BIN_PATH"'/install_sublime_text.sh'

# Install Visual Studio Code
bash "$REPO_BIN_PATH"'/install_visual_studio_code.sh'

# TODO: Install GCloud

# Install Signal Desktop
bash "$REPO_BIN_PATH"'/install_signal_desktop.sh'

# Install Spotify
# sudo snap install spotify

# Install Oracle VirtualBox
bash "$REPO_BIN_PATH"'/install_oracle_virtualbox.sh'
# Configure Oracle VirtualBox
bash "$REPO_BIN_PATH"'/configure_oracle_virtualbox.sh'
# Install Vagrant
bash "$REPO_BIN_PATH"'/install_vagrant.sh'
# Configure Vagrant
echo 'vagrant plugin install vagrant-disksize' | bash -

# Install Google Chrome
bash "$REPO_BIN_PATH"'/install_google_chrome.sh'

# Configure Canonical Livepatch
bash "$REPO_BIN_PATH"'/configure_livepatch.sh' "$livepatch_key"

# Configure Firewall (UFW)
bash "$REPO_BIN_PATH"'/configure_ufw.sh'

#### Configure SSH
# sudo sed -i -e "s|^#PermitRootLogin yes|PermitRootLogin no|" \
# -e "s|^#PasswordAuthentication yes|PasswordAuthentication no|" \
# -e "s|^#PermitEmptyPasswords no|PermitEmptyPasswords no|" \
# -e "s|^#Port 22|Port 2222|" \
# -e "s|^#LoginGraceTime 2m|LoginGraceTime 2m|" \
# -e "s|^#MaxAuthTries 6|MaxAuthTries 6|" \
# -e "s|^#MaxSessions 10|MaxSessions 10|" /etc/ssh/sshd_config

# Configure Swapfile
bash "$REPO_BIN_PATH"'/configure_swapfile.sh'

# Configure dconf
bash "$REPO_BIN_PATH"'/configure_dconf.sh'

# Change power mode to "Performance"
powerprofilesctl set performance

# Change processor governors to "Performance"
# https://askubuntu.com/questions/604720/setting-to-high-performance
#   View available:
#     cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors 
#   View current:
#     cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
#   Change setting:
# echo performance | sudo # tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

# Disable bluetooth
# https://unix.stackexchange.com/questions/387502/disable-bluetooth-at-boot
#   Modify the file located at /etc/bluetooth/main.conf
sed 's|AutoEnable=true|AutoEnable=false|' -i /etc/bluetooth/main.conf

apt-get autoremove -y

# Clear Temporary Files
clear_tmp
