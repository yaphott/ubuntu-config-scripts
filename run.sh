#!/bin/bash -e

# Helpful file/config watching commands (requires inotify-tools):
#   inotifywatch -e modify,create,delete -r ~/.config
#   inotifywatch -e modify,create,delete -r ~/snap/firefox/common/.mozilla
#   inotifywatch -e modify,create,delete -r ~/.local
#   inotifywatch -e modify,create,delete -r /etc/default
#   dconf watch /

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

# Must run from the root of the project directory
project_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
cd "$project_dir"

# Add variables and functions used throughout
source "$project_dir/bin/_exports.sh"


# Prompt user if the script started previously but failed
# NOTE: startpoint marker must be deleted upon expected exit behavior.
if ! marker_exists startpoint; then
    create_marker startpoint
else
    echo 'Previously failed to configure Ubuntu.'
    yes_or_no 'Would you like to continue?' || exit 1
fi

if ! marker_exists waypoint1; then
    reset_tasks
    register_task 'System' upgrade "bash -e '$project_dir/bin/upgrade_system.sh'" true
    execute_tasks

    require_reboot
    delete_marker startpoint
    create_marker waypoint1
    if [[ "$INSIDE_TEST" != 'true' ]]; then
        echo -e "\n$(style_text bold 'System restart is required.')"
        read -r -n1 -s -p 'Press any key to restart now...'
    fi
    sudo shutdown -r now
fi

if ! marker_exists waypoint2; then
    reset_tasks
    register_task 'Dependencies'      install   "bash -e '$project_dir/bin/install_dependencies.sh'" true
    register_task 'Disable Telemetry' configure "bash -e '$project_dir/bin/disable_telemetry.sh'" true
    execute_tasks

    require_reboot
    delete_marker startpoint
    create_marker waypoint2
    if [[ "$INSIDE_TEST" != 'true' ]]; then
        echo -e "\n$(style_text bold 'System restart is required.')"
        read -r -n1 -s -p 'Press any key to restart now...'
    fi
    sudo shutdown -r now
fi

reset_tasks
register_task 'DNS'                  configure  "bash -e '$project_dir/bin/configure_dns.sh' '$PRIMARY_DNS' '$FALLBACK_DNS'" true
register_task 'Firewall (UFW)'       configure  "bash -e '$project_dir/bin/configure_ufw.sh'" true
# register_task 'Canonical Livepatch'  configure  "bash -e ./bin/configure_livepatch.sh '$LIVEPATCH_KEY'" false
register_task 'Bluetooth'            configure  "bash -e '$project_dir/bin/configure_bluetooth.sh'" true
register_task 'NVIDIA CUDA'          install    "bash -e '$project_dir/bin/install_nvidia_cuda.sh' '$NVIDIA_CUDA_VERSION'" true
register_task 'SSH'                  configure  "bash -e '$project_dir/bin/configure_ssh.sh'" true
register_task 'Wireshark'            configure  "bash -e '$project_dir/bin/configure_wireshark.sh'" true
register_task 'General Packages'     install    "bash -e '$project_dir/bin/install_general.sh'" true
register_task 'Python 3'             install    "bash -e '$project_dir/bin/install_python3.sh'" true
register_task 'Python 3'             configure  "bash -e '$project_dir/bin/configure_python3.sh'" true
register_task 'Anaconda'             install    "bash -e '$project_dir/bin/install_anaconda.sh'" true
register_task 'Go'                   install    "bash -e '$project_dir/bin/install_go.sh'" true
register_task 'Node Version Manager' install    "bash -e '$project_dir/bin/install_nvm.sh'" true
register_task 'Node JS'              install    "bash -e '$project_dir/bin/install_nodejs.sh'" true
register_task 'Yarn'                 install    "bash -e '$project_dir/bin/install_yarn.sh'" true
register_task 'SDKMAN'               install    "bash -e '$project_dir/bin/install_sdkman.sh'" true
register_task 'Java'                 install    "bash -e '$project_dir/bin/install_java.sh'" true
register_task 'Scala'                install    "bash -e '$project_dir/bin/install_scala.sh'" true
register_task 'Vulkan SDK'           install    "bash -e '$project_dir/bin/install_vulkan_sdk.sh'" true
register_task 'Rust'                 install    "bash -e '$project_dir/bin/install_rust.sh'" true
register_task 'FiraCode Font'        install    "bash -e '$project_dir/bin/install_firacode_font.sh'" true
register_task 'Sublime Text'         install    "bash -e '$project_dir/bin/install_sublime_text.sh'" true
register_task 'Visual Studio Code'   install    "bash -e '$project_dir/bin/install_visual_studio_code.sh'" true
register_task 'Google Cloud CLI'     install    "bash -e '$project_dir/bin/install_google_cloud_cli.sh'" true
register_task 'Google Firebase CLI'  install    "bash -e '$project_dir/bin/install_google_firebase_cli.sh'" true
register_task 'Signal Desktop'       install    "bash -e '$project_dir/bin/install_signal_desktop.sh'" true
register_task 'Bitwarden'            install    "bash -e '$project_dir/bin/install_bitwarden.sh'" true
register_task 'Telegram Desktop'     install    "bash -e '$project_dir/bin/install_telegram_desktop.sh'" true
register_task 'Spotify'              install    "bash -e '$project_dir/bin/install_spotify.sh'" true
register_task 'Oracle VirtualBox'    install    "bash -e '$project_dir/bin/install_oracle_virtualbox.sh'" true
register_task 'Oracle VirtualBox'    configure  "bash -e '$project_dir/bin/configure_oracle_virtualbox.sh'" true
register_task 'Docker'               install    "bash -e '$project_dir/bin/install_docker.sh'" true
register_task 'Vagrant'              install    "bash -e '$project_dir/bin/install_vagrant.sh'" true
register_task 'Vagrant'              configure  "bash -e '$project_dir/bin/configure_vagrant.sh'" true
register_task 'Terraform'            install    "bash -e '$project_dir/bin/install_terraform.sh'" true
register_task 'Google Chrome'        install    "bash -e '$project_dir/bin/install_google_chrome.sh'" true
register_task 'dconf'                configure  "bash -e '$project_dir/bin/configure_dconf.sh'" true
register_task 'Swapfile'             configure  "bash -e '$project_dir/bin/configure_swapfile.sh' '$SWAPFILE_PATH' '$SWAPFILE_SIZE' '$SWAPFILE_SWAPPINESS'" true
register_task 'Power Mode'           configure  "bash -e '$project_dir/bin/configure_power_profile.sh'" true
execute_tasks

# Uninstall packages that are no longer dependencies (previously installed automatically)
sudo apt-get autoremove -y
# Remove retrieved packages that have a newer version
sudo apt-get autoclean

# Delete startpoint file, signaling the script has ended (signaling expected exit procedure)
delete_marker startpoint

# Delete waypoint files from last run (signaling expected exit procedure)
delete_marker waypoint1
delete_marker waypoint2

require_reboot
echo ''
echo "$(style_text bold,green 'Done!')"
echo "$(style_text bold 'System restart is highly recommended.')"
read -r -n1 -s -p 'Press any key to exit...'
exit 0
