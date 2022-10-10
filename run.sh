#!/bin/bash -xe

# TODO: Change DNS servers

# Prevent running with sudo
if [ "$EUID" -eq 0 ]; then
    echo 'Please run without sudo. Exiting ...'
    exit
fi

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
    echo 'Restart is needed to continue'
    echo 'IMPORTANT: Re-run the program from the same directory after restarting!'
    echo -n 'Press any key to restart now'
    read
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
sudo apt-get install -y git        synaptic    htop             tmux               awscli \
                        net-tools  nmap        whois            ssh-askpass        filezilla \
                        nomacs     gimp        imagemagick      vlc                handbrake \
                        bzip2      unzip       zstd             file-roller        jq \
                        gparted    exfatprogs  usb-creator-gtk  protobuf-compiler  libreoffice

# Flag stating the script is running
export INSIDE_SCRIPT=true

# User-defined variables (if not set prior to executing)
while [ ! "$LIVEPATCH_KEY" ]; do
    echo 'Visit https://ubuntu.com/advantage and create a key'
    echo -n 'Enter your Canonical Livepatch key: '
    read LIVEPATCH_KEY
done

# TODO: Check for exported user variables before overriding
# NOTE: Could add prompt for user input?
SWAPFILE_PATH='/swapfile'
echo 'Using swapfile path: '"$SWAPFILE_PATH"
SWAPFILE_SIZE='12g'
echo 'Using swapfile size: '"$SWAPFILE_SIZE"
SWAPFILE_SWAPINESS='10'
echo 'Using system swappiness: '"$SWAPFILE_SWAPINESS"

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

# Configure HTop
bash ./bin/configure_htop.sh

# Install Python 3.x
bash ./bin/install_python3.sh
# Configure Python 3.x
bash ./bin/configure_python3.sh

# TODO: Install CmdStan
#       ~/.cmdstan/cmdstan-2.29.1
# bash ./bin/install_cmdstan.sh

# TODO: Install Mujoco
#       ~/.mujoco/mujoco210
# bash ./bin/install_mujoco.sh

# TODO: Configure Streamlit (e.g. disable watchdog)
#       ~/.streamlit/config.toml
# bash ./bin/configure_streamlit

# Install Node.js
bash ./bin/install_nodejs.sh

# Install Yarn
bash ./bin/install_yarn.sh

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

# Install Bitwarden
sudo snap install bitwarden

# Install Telegram Desktop
sudo snap install telegram-desktop

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

# TODO: Configure Mozilla Firefox
# bash ./bin/configure_mozilla_firefox.sh

# Install Google Chrome
bash ./bin/install_google_chrome.sh
# TODO: Configure Google Chrome
# bash ./bin/configure_google_chrome.sh

# TODO: Install Geckdriver
# bash ./bin/install_geckodriver.sh

# TODO: Install Chromedriver
# bash ./bin/install_chromedriver.sh

# Configure Canonical Livepatch
sudo ua attach "$LIVEPATCH_KEY"

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
# View available:
#   cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors
# View current:
#   cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
# Change setting:
#   echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

# Configure bluetooth
bash ./bin/configure_bluetooth.sh

# TODO: Install Anaconda
# bash ./bin/install_anaconda.sh

# Uninstall packages that are no longer dependencies (previously installed automatically)
sudo apt-get autoremove -y
# Remove retrieved packages that have a newer version
sudo apt-get autoclean

# Delete startpoint file, signaling the script has ended
echo 'Removing startpoint'
rm './tmp/startpoint.temp'

# Delete waypoint file from last run
echo 'Removing waypoint'
rm './tmp/waypoint.temp'

echo 'Done!'
