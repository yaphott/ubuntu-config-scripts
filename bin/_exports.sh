#!/bin/bash -e

# Resolve name of current user
if [ "$SUDO_USER" ]; then
    export USER=$SUDO_USER;
else
    export USER=$LOGNAME;
fi

# User-defined variables (if not set prior to executing)
while ! echo "$LIVEPATCH_KEY" | grep -q -E '\S+'; do
    echo 'Visit https://ubuntu.com/advantage for a key'
    IFS= read -r -p 'Enter your Canonical Livepatch key: ' LIVEPATCH_KEY
done
[[ -z $SWAPFILE_PATH ]] && export SWAPFILE_PATH='/swapfile'
echo "SWAPFILE_PATH: ${SWAPFILE_PATH}"
[[ -z $SWAPFILE_SIZE ]] && export SWAPFILE_SIZE='12G'
echo "SWAPFILE_SIZE: ${SWAPFILE_SIZE}"
[[ -z $SWAPFILE_SWAPPINESS ]] && export SWAPFILE_SWAPPINESS='10'
echo "SWAPFILE_SWAPPINESS: ${SWAPFILE_SWAPPINESS}"
[[ -z $DNS1 ]] && export DNS1='1.1.1.1'
echo "DNS1: ${DNS1}"
[[ -z $DNS2 ]] && export DNS2='8.8.8.8'
echo "DNS2: ${DNS2}"
[[ -z $DNS3 ]] && export DNS3='1.0.0.1'
echo "DNS3: ${DNS3}"
[[ -z $DNS4 ]] && export DNS4='8.4.4.8'
echo "DNS4: ${DNS4}"
[[ -z $NVIDIA_CUDA_VERSION ]] && export NVIDIA_CUDA_VERSION='12.6'
echo "NVIDIA_CUDA_VERSION: ${NVIDIA_CUDA_VERSION}"

# Create a marker file to set a persistent state.
#
# Usage:
#     create_marker <marker_name>
#
# Parameters:
#     marker_name: Name of the marker to create.
#
# Returns 0 if the marker was created successfully.
# Returns 1 if the marker already exists.
# Returns 1 if the marker could not be created.
#
# Todo:
# - Validate the `marker_name` parameter.
# - Consider using a different file extension (e..g. .marker).
function create_marker () {
    register_param marker_name true
    verify_params "$@" || exit 1
    local marker_name="$1"

    local marker_path='./tmp/'"$marker_name"'.state'
    if [[ -f $marker_path ]]; then
        echo 'Marker already exists: '"$marker_path"
        return 1
    else
        echo 'Creating marker: '"$marker_path"
        touch "$marker_path"
        if [[ ! -f $marker_path ]]; then
            echo 'Failed to create marker: '"$marker_path"
            return 1
        fi
        return 0
    fi
}

# Delete a marker file to change a persistent state.
#
# Usage:
#     delete_marker <marker_name>
#
# Example:
#     delete_marker startpoint
#
# Parameters
#     marker_name: Name of the marker to delete.
function delete_marker () {
    register_param marker_name true
    verify_params "$@" || exit 1
    local marker_name="$1"

    local marker_path='./tmp/'"$marker_name"'.state'
    if [[ ! -f $marker_path ]]; then
        echo 'Missing marker: '"$marker_path"
        exit 1
    else
        echo 'Deleting marker: '"$marker_path"
        rm "$marker_path"
        if [[ -f $marker_path ]]; then
            echo 'Failed to delete marker: '"$marker_path"
            exit 1
        fi
    fi
}

# Check if a marker file exists.
#
# Usage:
#     marker_exists <marker_name>
#
# Example:
#     marker_exists startpoint || exit 1
#
# Parameters:
#     marker_name: Name of the marker to check.
#
# Returns:
#     0: Marker exists.
#     1: Marker does not exist.
function marker_exists () {
    register_param marker_name true
    verify_params "$@" || exit 1
    local marker_name="$1"

    local marker_path='./tmp/'"$marker_name"'.state'
    if [[ -f $marker_path ]]; then
        return 0
    else
        return 1
    fi
}

# Prompt the user for input until yes or no is provided.
#
# Usage:
#     yes_or_no <prompt_msg>
#
# Example:
#     yes_or_no 'Do you want food?' && echo 'User is hungry' || echo 'User is not hungry'
#
#     Input of 'y' will echo 'User is hungry'.
#     Input of 'n' will echo 'User is not hungry'.
#
# Parameters:
#     prompt_msg: Message to display during yes or no prompt.
#
# Returns:
#     0: User answered with yes.
#     1: User answered with no.
function yes_or_no () {
    register_param prompt_msg true
    verify_params "$@" || exit 1
    local prompt_msg="$1"

    local y_or_n_input
    while true; do
        IFS= read -r -p "$prompt_msg"' (y/n) ' y_or_n_input
        case "$y_or_n_input" in
            y | Y | yes | YES) return 0;;
            n | N | no | NO) return 1;;
            *);;
        esac
    done
}

declare -A TEXT_STYLES
TEXT_STYLES['bold']='\e[1m'
TEXT_STYLES['dim']='\e[2m'
TEXT_STYLES['red']='\e[31m'
TEXT_STYLES['green']='\e[32m'
TEXT_STYLES['reset']='\e[0m'

# Style text with the provided styles.
#
# Usage:
#     style_text <styles> <text>
#
# Example:
#     stylized_text=$( style_text bold,red 'This is bold red text!' )
#
# Parameters
#     styles: Comma separated list of styles to apply to the text.
#     text: Text to style.
#
# Output:
#     Stylized text.
function style_text () {
    register_param styles true
    register_param text true
    verify_params "$@" || exit 1
    local styles="$1"
    local text="$2"

    local style
    local style_string=''
    for style in ${styles//,/ }; do
        style_string+="${TEXT_STYLES[$style]}"
    done
    echo -e "${style_string}${text}${TEXT_STYLES['reset']}"
}

# Clear the queue of tasks.
function reset_tasks () {
    unset TASK_NAMES
    unset TASK_TYPES
    unset TASK_CMDS
    unset TASK_MUST_SUCCEED
    declare -a TASK_NAMES
    declare -a TASK_TYPES
    declare -a TASK_CMDS
    declare -a TASK_MUST_SUCCEED
}

# Register a task to be executed.
#
# Usage:
#     register_task <task_name> <task_type> <task_cmd> <task_must_succeed>
#
# Example:
#     register_task Sublime install 'bash ./bin/install_sublime.sh' true
function register_task () {
    register_param task_name true
    register_param task_type true
    register_param task_cmd true
    register_param task_must_succeed true
    verify_params "$@" || exit 1
    local task_name="$1"
    local task_type="$2"
    local task_cmd="$3"
    local task_must_succeed="$4"

    TASK_NAMES+=("$task_name")
    TASK_TYPES+=("$task_type")
    TASK_CMDS+=("$task_cmd")
    TASK_MUST_SUCCEED+=("$task_must_succeed")
}

# Execute all registered tasks.
function execute_tasks () {
    local task_count="${#TASK_NAMES[@]}"
    if [[ $task_count -eq 0 ]]; then
        echo 'No tasks to execute.'
        return
    fi
    for i in $(seq 0 $((task_count - 1))); do
        local task_msg="[ ${TASK_NAMES[$i]} : ${TASK_TYPES[$i]} : ${TASK_MUST_SUCCEED[$i]} ]"
        local task_cmd="${TASK_CMDS[$i]}"
        style_text bold "Executing task $task_msg"
        style_text dim "... with command: $task_cmd"
        if eval "$task_cmd"; then
            style_text green "Success $task_msg"
        else
            style_text red "Failed $task_msg"
            if ${TASK_MUST_SUCCEED[$i]}; then
                if ! yes_or_no 'Would you like to continue?'; then
                    echo 'Exiting...'
                    exit 1
                fi
            fi
        fi
        i=$((i + 1))
    done
}

# Clear the known parameters.
function reset_params () {
    unset PARAM_NAMES
    unset PARAM_REQUIRED
    declare -a PARAM_NAMES
    declare -a PARAM_REQUIRED
}

# Register a parameter to be verified.
#
# Usage:
#     register_param <param_name> <param_is_required>
#
# Example:
#     register_param param1 true
#     register_param param2 false
#
# Parameters:
#     param_name: Name of the parameter to register.
#     param_is_required: Whether or not the parameter is required.
function register_param () {
    local param_name="$1"
    if [[ -z $param_name ]]; then
        echo 'Missing required parameter: param_name'
        exit 1
    fi
    local param_is_required="$2"
    if [[ -z $param_is_required ]]; then
        echo 'Missing required parameter: param_is_required'
        exit 1
    fi

    # Length is the next index, since index starts at 0
    PARAM_NAMES+=("$param_name")
    PARAM_REQUIRED+=("$param_is_required")
}

# Validate that the required parameters exist and are valid, resetting registered parameters.
#
# Usage:
#     verify_params <params...>
#
# Parameters:
#     $@: All parameters to verify.
function verify_params () {
    local param_names=("${PARAM_NAMES[@]}")
    local param_required=("${PARAM_REQUIRED[@]}")
    reset_params

    local params=("$@")
    for i in "${!param_required[@]}"; do
        local param_is_required=${param_required[$i]}
        local param_name=${param_names[$i]}
        local param_value=${params[$i]}
        if [[ $param_is_required == true ]]; then
            if [[ -z $param_value ]]; then
                echo 'Missing required parameter: '"$param_name"
                exit 1
            fi
        fi
    done
}

# Signal to the system that a reboot is needed.
#
# Usage:
#     require_reboot
function require_reboot () {
    sudo touch /run/reboot-required
    if [[ ! -f /etc/reboot-required.pkgs ]]; then
        echo 'ubuntu-config-scripts' | sudo tee /etc/reboot-required.pkgs
    elif ! grep -q '^ubuntu-config-scripts$' /etc/reboot-required.pkgs; then
        echo 'ubuntu-config-scripts' | sudo tee -a /etc/reboot-required.pkgs
    fi
}
