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

# Must run from the same directory as the script to ensure relative paths work
script_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
cd "$script_dir"

tmp_dir="${script_dir}/tmp"
startpoint_file_path="${tmp_dir}/startpoint.state"
waypoint_file_path="${tmp_dir}/waypoint.state"

# Flag stating the script is running
export INSIDE_SCRIPT=true

# Add variables and functions used throughout
source "${script_dir}/bin/_exports.sh"

# Ensure temp directory exists
[[ ! -d "$tmp_dir" ]] && (mkdir "$tmp_dir" || prompt_to_exit || exit 1)

# Prompt user if the script started previously but failed
#     NOTE: ./tmp/startpoint.temp is deleted upon expected exit behavior.
if [[ -f "${startpoint_file_path}" ]]; then
    echo 'Previously failed to configure Ubuntu.'
    prompt_to_exit || exit 1
else
    # Create startpoint file to signal script has started
    create_marker startpoint || prompt_to_exit || exit 1
fi

# Set points if this is the first run (skip if second run)
#     NOTE: ./tmp/waypoint.temp is created after the first run.
if [[ ! -f "${script_dir}/tmp/waypoint.temp" ]]; then
    # 1. Update package database and upgrade packages (resolving dependencies)
    bash "${script_dir}/bin/upgrade_system.sh" || prompt_to_exit || exit 1
    # 2. Delete startpoint file for next run (signaling expected exit procedure)
    delete_marker startpoint || prompt_to_exit || exit 1
    # 3. Create waypoint file for next run (signaling to skip system/core updates)
    create_marker waypoint || prompt_to_exit || exit 1

    # Instruct user for reboot when not testing
    if [[ "$INSIDE_TEST" != 'true' ]]; then
        echo -e "\n$(style_text bold 'System restart is required.')"
        read -r -n1 -s -p 'Press any key to restart now...'
    fi
    sudo shutdown -r now
fi

# Initialize the task variables
reset_tasks

# Register tasks
register_task 'Disable Telemetry'    configure  'bash ./bin/disable_telemetry.sh' true
# # # ~/.cmdstan/cmdstan-2.29.1
# # register_task 'CmdStan'              install  'bash ./bin/install_cmdstan.sh' true
# # # ~/.mujoco/mujoco210
# # register_task 'MuJoCo'               install  'bash ./bin/install_mujoco.sh' true
# # # ~/.streamlit/config.toml
# # register_task 'Streamlit'            configure  'bash ./bin/configure_streamlit.sh' true
# register_task 'DNS'                  configure  "bash ./bin/configure_dns.sh $DNS1 $DNS2 $DNS3 $DNS4" true
# register_task 'Firewall (UFW)'       configure  'bash ./bin/configure_ufw.sh' true
# # register_task 'Canonical Livepatch'  configure  "bash ./bin/configure_livepatch.sh '$LIVEPATCH_KEY'" false
# register_task 'Bluetooth'            configure  'bash ./bin/configure_bluetooth.sh' true
# # register_task 'NVIDIA CUDA'          install    "bash ./bin/install_nvidia_cuda.sh '$NVIDIA_CUDA_VERSION'" true
# register_task 'Dependencies'         install    'bash ./bin/install_dependencies.sh' true
# # NOTE: Must come before General Packages
# register_task 'Wireshark'            configure  'bash ./bin/configure_wireshark.sh' true
# register_task 'General Packages'     install    'bash ./bin/install_general.sh' true
# # register_task 'SSH'                  configure  'bash ./bin/configure_ssh.sh' true
# register_task 'Python 3'             install    'bash ./bin/install_python3.sh' true
# register_task 'Python 3'             configure  'bash ./bin/configure_python3.sh' true
# register_task 'Anaconda'             install    'bash ./bin/install_anaconda.sh' true
# register_task 'Go'                   install    'bash ./bin/install_go.sh' true
# # register_task 'Node Version Manager' install    'bash ./bin/install_nvm.sh' true
# # register_task 'Node JS'              install    'bash ./bin/install_nodejs.sh' true
# # register_task 'Yarn'                 install    'bash ./bin/install_yarn.sh' true
# register_task 'SDKMAN'               install    'bash ./bin/install_sdkman.sh' true
# register_task 'Java'                 install    'bash ./bin/install_java.sh' true
# # register_task 'Scala'                install    'bash ./bin/install_scala.sh' true
# # register_task 'Rust'                 install    'bash ./bin/install_rust.sh' true
# register_task 'FiraCode Font'        install    'bash ./bin/install_firacode_font.sh' true
# register_task 'Sublime Text'         install    'bash ./bin/install_sublime_text.sh' true
# register_task 'Visual Studio Code'   install    'bash ./bin/install_visual_studio_code.sh' true
# # register_task 'Google Cloud CLI'     install    'bash ./bin/install_google_cloud_cli.sh' true
# register_task 'Google Firebase CLI'  install    'bash ./bin/install_google_firebase_cli.sh' true
# register_task 'Signal Desktop'       install    'bash ./bin/install_signal_desktop.sh' true
# register_task 'Bitwarden'            install    'bash ./bin/install_bitwarden.sh' true
# register_task 'Telegram Desktop'     install    'bash ./bin/install_telegram_desktop.sh' true
# register_task 'Spotify'              install    'bash ./bin/install_spotify.sh' true
# register_task 'Oracle VirtualBox'    install    'bash ./bin/install_oracle_virtualbox.sh' true
# register_task 'Oracle VirtualBox'    configure  'bash ./bin/configure_oracle_virtualbox.sh' true
# # register_task 'Docker'               install    'bash ./bin/install_docker.sh' true
# register_task 'Vagrant'              install    'bash ./bin/install_vagrant.sh' true
# register_task 'Vagrant'              configure  'bash ./bin/configure_vagrant.sh' true
# register_task 'Google Chrome'        install    'bash ./bin/install_google_chrome.sh' true
# # register_task 'Mozilla Firefox'      configure 'bash ./bin/configure_mozilla_firefox.sh' true
# # register_task 'Google Chrome'        configure  'bash ./bin/configure_google_chrome.sh' true
# # register_task 'Geckodriver'          install  'bash ./bin/install_geckodriver.sh' true
# # register_task 'Chromedriver'         install  'bash ./bin/install_chromedriver.sh' true
# 
# register_task 'dconf'                configure  'bash ./bin/configure_dconf.sh' true
# register_task 'Swapfile'             configure  "bash ./bin/configure_swapfile.sh '$SWAPFILE_PATH' '$SWAPFILE_SIZE' '$SWAPFILE_SWAPPINESS'" true
# register_task 'Power Mode'           configure  'bash ./bin/configure_power_profile.sh' true

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
echo "$(style_text bold,green 'Done!')"
echo "$(style_text bold 'System restart is recommended.')"
read -r -n1 -s -p 'Press any key to exit...'
exit 0

