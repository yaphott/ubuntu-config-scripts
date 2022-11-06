#!/bin/bash -e

# Helpful file/config watching commands (requires inotify-tools)
#   inotifywatch -e modify,create,delete -r ~/.config
#   inotifywatch -e modify,create,delete -r ~/snap/firefox/common/.mozilla
#   inotifywatch -e modify,create,delete -r ~/.local
#   inotifywatch -e modify,create,delete -r /etc/default
#   dconf watch /
# 
# TODO:
#   - Add user to specify which installations/configurations will be run 
#   - Related to the previous; iterate functions or their exit codes instead of hardcoding '|| prompt_to_exit' after each task.

# Prevent running with sudo
if [ "$EUID" -eq 0 ]; then
    echo 'Please run without sudo.'
    exit 1
fi

# Prevent running as root user
if [[ $USER == 'root' ]]; then
    echo 'Please run as non-root user.'
    exit 1
fi

# Flag stating the script is running
export INSIDE_SCRIPT=true

# Add variables and functions used throughout
source ./bin/_exports.sh

# Check if the script started previously but failed, then rompt user to try again
# NOTE: The startpoint.temp file, located in temp/, is deleted upon expected exit behavior
if [[ -f './tmp/startpoint.temp' ]]; then #############################################
    echo 'Previously failed to configure Ubuntu.'
    prompt_to_exit 0
else
    # Create startpoint file to signal script has started
    create_marker 'startpoint' || prompt_to_exit 1
fi

# Check if this is the first run (skip if second run)
# NOTE: The waypoint.temp file, located in temp/, is created after the first run
if [[ ! -f './tmp/waypoint.temp' ]]; then ##########################
    # 1. Update package database and upgrade packages (resolving dependencies)
    bash ./bin/upgrade_system.sh || prompt_to_exit 1

    # 2. Delete startpoint file for next run (signaling expected exit procedure)
    delete_marker 'startpoint' || prompt_to_exit 1

    # 3. Create waypoint file for next run (signaling to skip system/core updates)
    create_marker 'waypoint' || prompt_to_exit 1

    # Instruct user for reboot
    echo 'Restart is needed to continue.'
    echo 'IMPORTANT: Re-run the program from the same directory after restarting!'
    echo -n 'Press any key to restart now ...'
    read
    sudo shutdown -r now
fi

# Update package database and install required packages
#   linux-generic - building software.
#   build-essential - APT with HTTPS.
#   apt-transport-https - fetching files and installing keys.
#   gpg, wget, and curl - release codename.
bash ./bin/install_dependencies.sh || prompt_to_exit 1

# Install General Packages
bash ./bin/install_general.sh || prompt_to_exit 1

# User-defined variables (if not set prior to executing)
while [ ! "$LIVEPATCH_KEY" ]; do
    echo 'Visit https://ubuntu.com/advantage for a key'
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

# function run_script () {
#     bash "$1" || prompt_to_exit "$2"
# }
# 
# 
# tasks=()
# function add_task () {
#     # Length is the next index, since index starts at 0
#     TASK_NAMES[${#TASK_NAMES[@]}]="$1"
#     TASK_TYPES[${#TASK_TYPES[@]}]="$2"
#     TASK_CMDS[${#TASK_CMDS[@]}]="$3"
# }
# 
# function execute_tasks () {
#     for i in "${!TASK_NAMES[@]}"; do
#         task_label='[ '"${TASK_NAMES[$i]}"' : '"${TASK_NAMES[$i]}"' ]'
#         echo 'Starting '"$task_label"
#         # Run the task and prompt to exit if it fails
#         ( ${TASK_CMDS[$i]} \
#           && echo 'Finished [ '"${TASK_NAMES[$i]}"' : '"${TASK_NAMES[$i]}"' ]' \
#         ) || ( \
#           echo 'Failed [ '"${TASK_NAMES[$i]}"' : '"${TASK_NAMES[$i]}"' ]' \
#           && prompt_to_exit 1 \
#         )
#     done
# }
# function unregister_tasks () {
#     unset TASK_NAMES
#     unset TASK_TYPES
#     unset TASK_CMDS
#     declare -a TASK_NAMES
#     declare -a TASK_TYPES
#     declare -a TASK_CMDS
# }
# function testit () {
#     echo 'THIS IS THE TEST'
# }
# unregister_tasks
# add_task 'HTop' 'install' 'testit'
# execute_tasks

# Configure HTop
bash ./bin/configure_htop.sh

# Install Latest Python
bash ./bin/install_python3.sh || prompt_to_exit 1
# Configure Latest Python
bash ./bin/configure_python3.sh || prompt_to_exit 1

# TODO: Install Python 3.9
# bash ./bin/install_python39.sh || prompt_to_exit 1
# TODO: Configure Python 3.9
# bash ./bin/configure_python39.sh || prompt_to_exit 1

# TODO: Install CmdStan
#       ~/.cmdstan/cmdstan-2.29.1
# bash ./bin/install_cmdstan.sh || prompt_to_exit 1

# TODO: Install Mujoco
#       ~/.mujoco/mujoco210
# bash ./bin/install_mujoco.sh || prompt_to_exit 1

# TODO: Configure Streamlit (e.g. disable watchdog)
#       ~/.streamlit/config.toml
# bash ./bin/configure_streamlit || prompt_to_exit 1

# Install Node.js
bash ./bin/install_nodejs.sh || prompt_to_exit 1

# Install Yarn
bash ./bin/install_yarn.sh || prompt_to_exit 1

# Install FiraCode Font
bash ./bin/install_firacode_font.sh || prompt_to_exit 1

# Install Sublime Text
bash ./bin/install_sublime_text.sh || prompt_to_exit 1

# Install Visual Studio Code
bash ./bin/install_visual_studio_code.sh || prompt_to_exit 1

# TODO: Install GCloud
# bash ./bin/install_gcloud.sh || prompt_to_exit 1

# Install Signal Desktop
bash ./bin/install_signal_desktop.sh || prompt_to_exit 1

# Install Bitwarden
sudo snap install bitwarden || prompt_to_exit 1

# Install Telegram Desktop
sudo snap install telegram-desktop || prompt_to_exit 1

# Install Spotify
sudo snap install spotify || prompt_to_exit 1

# Install Oracle VirtualBox
bash ./bin/install_oracle_virtualbox.sh || prompt_to_exit 1
# Configure Oracle VirtualBox
bash ./bin/configure_oracle_virtualbox.sh || prompt_to_exit 1

# Install Vagrant
bash ./bin/install_vagrant.sh || prompt_to_exit 1
# Configure Vagrant
bash ./bin/configure_vagrant.sh || prompt_to_exit 1

# TODO: Configure Mozilla Firefox
# bash ./bin/configure_mozilla_firefox.sh || prompt_to_exit 1

# Install Google Chrome
bash ./bin/install_google_chrome.sh || prompt_to_exit 1
# TODO: Configure Google Chrome
# bash ./bin/configure_google_chrome.sh || prompt_to_exit 1

# TODO: Install Geckdriver
# bash ./bin/install_geckodriver.sh || prompt_to_exit 1

# TODO: Install Chromedriver
# bash ./bin/install_chromedriver.sh || prompt_to_exit 1

# Configure Canonical Livepatch
bash ./bin/configure_livepatch.sh

# Configure Firewall (UFW)
bash ./bin/configure_ufw.sh || prompt_to_exit 1

# Configure SSH
bash ./bin/configure_ssh.sh || prompt_to_exit 1

# Configure Swapfile
bash ./bin/configure_swapfile.sh "$SWAPFILE_PATH" "$SWAPFILE_SIZE" "$SWAPFILE_SWAPINESS" || prompt_to_exit 1

# Configure dconf
bash ./bin/configure_dconf.sh || prompt_to_exit 1

# Change power mode to "performance"
powerprofilesctl set performance || prompt_to_exit 1

# Change processor governors to "Performance"
# https://askubuntu.com/questions/604720/setting-to-high-performance
# View available:
#   cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors
# View current:
#   cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
# Change setting:
#   echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

# Configure bluetooth
bash ./bin/configure_bluetooth.sh || prompt_to_exit 1

# TODO: Install Anaconda
# bash ./bin/install_anaconda.sh || prompt_to_exit 1

# TODO: Install NVIDIA CUDA 11.6
# (check comment in install script for 11.3)
# bash ./bin/install_nvidia_cuda.sh || prompt_to_exit 1

# Uninstall packages that are no longer dependencies (previously installed automatically)
sudo apt-get autoremove -y
# Remove retrieved packages that have a newer version
sudo apt-get autoclean

# Delete startpoint file, signaling the script has ended (signaling expected exit procedure)
delete_marker 'startpoint'

# Delete waypoint file from last run (signaling expected exit procedure)
delete_marker 'waypoint'

echo 'Done!'
exit 0
