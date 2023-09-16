#!/bin/bash -e

# Helpful file/config watching commands (requires inotify-tools):
#   inotifywatch -e modify,create,delete -r ~/.config
#   inotifywatch -e modify,create,delete -r ~/snap/firefox/common/.mozilla
#   inotifywatch -e modify,create,delete -r ~/.local
#   inotifywatch -e modify,create,delete -r /etc/default
#   dconf watch /
# 
# TODO:
# - Place a hidden file in the home directory after the entire install finishes sucessfully?
# - Add user to specify which installations/configurations will be run.
# - Related to the previous; iterate functions or their exit codes instead of hardcoding '|| prompt_to_exit' after each task.

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

# Ensure temp directory exists
[[ ! -d './tmp' ]] && (mkdir './tmp' || prompt_to_exit 1)

# Prompt user if the script started previously but failed
#     NOTE: ./tmp/startpoint.temp is deleted upon expected exit behavior.
if [[ -f './tmp/startpoint.temp' ]]; then
    echo 'Previously failed to configure Ubuntu.'
    prompt_to_exit 0
else
    # Create startpoint file to signal script has started
    create_marker 'startpoint' || prompt_to_exit 1
fi

# Set points if this is the first run (skip if second run)
#     NOTE: ./tmp/waypoint.temp is created after the first run.
if [[ ! -f './tmp/waypoint.temp' ]]; then
    # 1. Update package database and upgrade packages (resolving dependencies)
    bash ./bin/upgrade_system.sh || prompt_to_exit 1
    # 2. Delete startpoint file for next run (signaling expected exit procedure)
    delete_marker 'startpoint' || prompt_to_exit 1
    # 3. Create waypoint file for next run (signaling to skip system/core updates)
    create_marker 'waypoint' || prompt_to_exit 1

    # Instruct user for reboot
    echo ''
    echo 'Restart is needed to continue.'
    echo 'IMPORTANT: Re-run the program from the same directory after restarting!'
    echo -n 'Press any key to restart now ...'
    read
    sudo shutdown -r now
fi


# User-defined variables (if not set prior to executing)
# TODO:
# - Check for exported user variables before overriding.
# - Could add prompt for user input.
while [ ! "$LIVEPATCH_KEY" ]; do
    echo 'Visit https://ubuntu.com/advantage for a key'
    echo -n 'Enter your Canonical Livepatch key: '
    read LIVEPATCH_KEY
done
echo 'LIVEPATCH_KEY: '"$LIVEPATCH_KEY"
[[ ! $SWAPFILE_PATH ]] && SWAPFILE_PATH='/swapfile'
echo 'SWAPFILE_PATH: '"$SWAPFILE_PATH"
[[ ! $SWAPFILE_SIZE ]] && SWAPFILE_SIZE='12G'
echo 'SWAPFILE_SIZE: '"$SWAPFILE_SIZE"
[[ ! $SWAPFILE_SWAPPINESS ]] && SWAPFILE_SWAPPINESS='10'
echo 'SWAPFILE_SWAPPINESS: '"$SWAPFILE_SWAPPINESS"
[[ ! $NVIDIA_CUDA_VERSION ]] && NVIDIA_CUDA_VERSION='11.3'
echo 'NVIDIA_CUDA_VERSION: '"$NVIDIA_CUDA_VERSION"
[[ ! $NODE_MAJOR_VERSION ]] && NODE_MAJOR_VERSION='20'
echo 'NODE_MAJOR_VERSION: '"$NODE_MAJOR_VERSION"

function reset_tasks () {
    unset TASK_NAMES
    unset TASK_TYPES
    unset TASK_CMDS
    unset TASK_SHOULD_EXIT
    declare -a TASK_NAMES
    declare -a TASK_TYPES
    declare -a TASK_CMDS
    declare -a TASK_SHOULD_EXIT
}

function register_task () {
    # Length is the next index, since index starts at 0
    TASK_NAMES[${#TASK_NAMES[@]}]="$1"
    TASK_TYPES[${#TASK_TYPES[@]}]="$2"
    TASK_CMDS[${#TASK_CMDS[@]}]="$3"
    TASK_SHOULD_EXIT[${#TASK_SHOULD_EXIT[@]}]="$4"
}

function execute_tasks () {
    for i in "${!TASK_NAMES[@]}"; do
        local task_name="${TASK_NAMES[$i]}"
        local task_type="${TASK_TYPES[$i]}"
        local task_should_exit="${TASK_SHOULD_EXIT[$i]}"
        echo_with_style bold 'Executing task [ '"$task_name"' : '"$task_type"' ]'
        echo_with_style dim '... with command: '"${TASK_CMDS[$i]}"
        # Run the task and prompt to exit if it fails
        ( eval "${TASK_CMDS[$i]}" && echo_with_style green 'Success [ '"$task_name"' : '"$task_type"' ]' ) \
            || ( \
                echo_with_style red 'Failed [ '"$task_name"' : '"$task_type"' ]' \
                    && ( [[ $task_should_exit == true ]] && prompt_to_exit 1 )
            )
    done
}

# TODO: Could change processor governors to "Performance"
# https://askubuntu.com/questions/604720/setting-to-high-performance
# View available:
#   cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors
# View current:
#   cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
# Change setting:
#   echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
# Register tasks

register_task 'DNS'                  configure  'bash ./bin/configure_dns.sh' true
register_task 'Firewall (UFW)'       configure  'bash ./bin/configure_ufw.sh' true
register_task 'Canonical Livepatch'  configure  "bash ./bin/configure_livepatch.sh '$LIVEPATCH_KEY'" false
register_task 'Bluetooth'            configure  'bash ./bin/configure_bluetooth.sh' true
register_task 'NVIDIA CUDA'          install    "bash ./bin/install_nvidia_cuda.sh '$NVIDIA_CUDA_VERSION'" true
register_task 'Dependencies'         install    'bash ./bin/install_dependencies.sh' true
register_task 'General Packages'     install    'bash ./bin/install_general.sh' true
register_task 'SSH'                  configure  'bash ./bin/configure_ssh.sh' true
register_task 'HTop'                 configure  'bash ./bin/configure_htop.sh' false
register_task 'Python'               install    'bash ./bin/install_python3.sh' true
register_task 'Python'               configure  'bash ./bin/configure_python3.sh' true
register_task 'Node.js'              install    "bash ./bin/install_nodejs.sh '$NODE_MAJOR_VERSION'" true
register_task 'Yarn'                 install    'bash ./bin/install_yarn.sh' true
register_task 'Scala'                install    'bash ./bin/install_scala.sh' true
register_task 'Rust'                 install    'bash ./bin/install_rust.sh' true
register_task 'FiraCode Font'        install    'bash ./bin/install_firacode_font.sh' true
register_task 'Sublime Text'         install    'bash ./bin/install_sublime_text.sh' true
register_task 'Visual Studio Code'   install    'bash ./bin/install_visual_studio_code.sh' true
register_task 'Google Cloud CLI'     install    'bash ./bin/install_google_cloud_cli.sh' true
register_task 'Google Firebase CLI'  install    'bash ./bin/install_google_firebase_cli.sh' true
register_task 'Signal Desktop'       install    'bash ./bin/install_signal_desktop.sh' true
register_task 'Bitwarden'            install    'sudo snap install bitwarden' true
register_task 'Telegram Desktop'     install    'sudo snap install telegram-desktop' true
register_task 'Spotify'              install    'sudo snap install spotify' true
register_task 'Oracle VirtualBox'    install    'bash ./bin/install_oracle_virtualbox.sh' true
register_task 'Oracle VirtualBox'    configure  'bash ./bin/configure_oracle_virtualbox.sh' true
register_task 'Docker'               install    'bash ./bin/install_docker.sh' true
register_task 'Vagrant'              install    'bash ./bin/install_vagrant.sh' true
register_task 'Vagrant'              configure  'bash ./bin/configure_vagrant.sh' true
register_task 'Google Chrome'        install    'bash ./bin/install_google_chrome.sh' true
register_task 'dconf'                configure  'bash ./bin/configure_dconf.sh' true
register_task 'Swapfile'             configure  "bash ./bin/configure_swapfile.sh '$SWAPFILE_PATH' '$SWAPFILE_SIZE' '$SWAPFILE_SWAPPINESS'" true
register_task 'Power Mode'           configure  'powerprofilesctl set performance' true

# Execute tasks
execute_tasks

# Uninstall packages that are no longer dependencies (previously installed automatically)
sudo apt-get autoremove -y
# Remove retrieved packages that have a newer version
sudo apt-get autoclean

# Delete startpoint file, signaling the script has ended (signaling expected exit procedure)
delete_marker 'startpoint'

# Delete waypoint file from last run (signaling expected exit procedure)
delete_marker 'waypoint'

echo ''
echo 'Done!'
echo ''
echo 'Notice:'
echo '  To configure GCloud, run '"'"'gcloud init'"'"' in a new window'
echo '  To update GCloud, run '"'"'gcloud components update'"'"' in a new window'
echo ''
echo -n 'Press any key to exit ...'
read
exit 0
