#!/bin/bash -xe

# Prevent running with sudo
if [ "$EUID" -eq 0 ]
    then echo 'Please run without sudo. Exiting ...'
    exit
fi

# User-defined variables (if not set prior to executing)
while [ ! "$LIVEPATCH_KEY" ]; do
    echo -n 'Enter your Canonical Livepatch key: '
    read LIVEPATCH_KEY
done
echo 'Using Canonical Livepatch key: '"$LIVEPATCH_KEY"
# TODO: Check for exported user variables before overriding
# NOTE: Could add prompt for user input?
SWAPFILE_PATH='/swapfile'
echo 'Using swapfile path: '"$SWAPFILE_PATH"
SWAPFILE_SIZE='12g'
echo 'Using swapfile size: '"$SWAPFILE_SIZE"
SWAPFILE_SWAPINESS='90'
echo 'Using system swappiness: '"$SWAPFILE_SWAPINESS"

# Helpful file/config watching commands
# (Requires inotify-tools)
#   inotifywatch -e modify,create,delete -r ~/.config
#   inotifywatch -e modify,create,delete -r ~/snap/firefox/common/.mozilla
#   inotifywatch -e modify,create,delete -r ~/.local
#   inotifywatch -e modify,create,delete -r /etc/default
#   dconf watch /

# Check if the script started previously, but failed
# NOTE: The startpoint.temp file, located in temp/, is deleted upon expected exit behavior
if [[ -f './tmp/startpoint.temp' ]]; then
    echo 'Previously failed to configure Ubuntu'
    # Prompt user to try again
    while [ true ]; do
        echo -n 'Would you like to try again? (y/n)'
        read Y_OR_N
        case "$Y_OR_N" in
            y | Y)
                # Continue using the current startpoint file
                break
                ;;
            n | N)
                echo 'Exiting ...'
                exit
                ;;
            *)
                # Invalid input (loop)
                ;;
        esac
    done
else
    # Create startpoint file to signal script has started
    echo 'Creating startpoint'
    touch './tmp/startpoint.temp'
fi

# Check if this is the first run (skip if second run)
# NOTE: The waypoint.temp file, located in temp/, is created after the first run
if [[ ! -f './tmp/waypoint.temp' ]]; then
    # Update package database and upgrade packages (resolving dependencies)
    sudo apt-get update
    sudo apt-get dist-upgrade -y

    # Delete startpoint file for next run
    echo 'Deleting waypoint'
    rm './tmp/startpoint.temp'

    # Create waypoint file for next run
    echo 'Creating waypoint'
    touch './tmp/waypoint.temp'

    # Instruct user for reboot
    echo 'Restart is needed to continue. RE-RUN THIS INSTALLER AFTER PC RESTARTS!'
    echo -n 'Press any key to restart now'
    pause
    sudo shutdown -r now
fi

# Update package database
sudo apt-get update
# Required for building software
sudo apt-get install -y linux-generic
sudo apt-get install -y build-essential
# Required for APT with HTTPS
sudo apt-get install -y apt-transport-https
# Required for fetching files and installing keys
sudo apt-get install -y gpg wget curl
# Required for release codename
sudo apt-get install -y lsb-core
# Install General Packages
sudo apt-get install -y git        synaptic    htop             tmux         awscli \
                        net-tools  nmap        whois            ssh-askpass  filezilla \
                        nomacs     gimp        imagemagick      vlc          handbrake \
                        bzip2      unzip       zstd             jq           protobuf-compiler \
                        gparted    exfatprogs  usb-creator-gtk

# Flag stating the script is running
export INSIDE_SCRIPT=true

# Resolve name of current user
if [ $SUDO_USER ]; then
    export USER=$SUDO_USER;
else
    export USER=$LOGNAME;
fi

# Prevent running as root user
if [[ $USER == 'root' ]]; then
    echo 'Please run as non-root user. Exiting ...'
    exit
fi

# Install Python 3.x
bash ./bin/install_python3.sh
# Configure Python 3.x
bash ./bin/configure_python3.sh

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

# Install Bitwarden
sudo snap install bitwarden

# Install Telegram Desktop
sudo snap install telegram-desktop

# Install Signal Desktop
bash ./bin/install_signal_desktop.sh

# Install Spotify
sudo snap install spotify

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
bash ./bin/configure_livepatch.sh "$LIVEPATCH_KEY"

# Configure Firewall (UFW)
bash ./bin/configure_ufw.sh

# Configure SSH
bash ./bin/configure_ssh.sh

# Configure Swapfile
bash ./bin/configure_swapfile.sh "$SWAPFILE_PATH" "$SWAPFILE_SIZE" "$SWAPFILE_SWAPINESS"

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

# Configure bluetooth
bash ./bin/configure_bluetooth.sh

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

# Remove retrieved packages that have a newer version
sudo apt-get autoclean
# Uninstall packages that are no longer dependencies (previously installed automatically)
sudo apt-get autoremove

# Delete startpoint file, signaling the script has ended
echo 'Removing startpoint'
rm './tmp/startpoint.temp'

# Delete waypoint file from last run
echo 'Removing waypoint'
rm './tmp/waypoint.temp'
