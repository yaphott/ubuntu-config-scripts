#!/bin/bash

# Resolve name of current user
if [ $SUDO_USER ]; then
    export USER=$SUDO_USER;
else
    export USER=$LOGNAME;
fi

# Resolve distro codename
[[ -z $DIST_CODENAME ]] && export DIST_CODENAME=$( lsb_release -cs )
# Resolve architecture
[[ -z $ARCHITECTURE ]] && export ARCHITECTURE=$( dpkg --print-architecture )

# User-defined variables (if not set prior to executing)
# TODO:
# - Check for exported user variables before overriding.
# - Could add prompt for user input.
while [[ -z "$LIVEPATCH_KEY" ]]; do
    echo 'Visit https://ubuntu.com/advantage for a key'
    echo -n 'Enter your Canonical Livepatch key: '
    read LIVEPATCH_KEY
done
[[ -z $SWAPFILE_PATH ]]       && export SWAPFILE_PATH='/swapfile'  && echo 'SWAPFILE_PATH: '"$SWAPFILE_PATH"
[[ -z $SWAPFILE_SIZE ]]       && export SWAPFILE_SIZE='12G'        && echo 'SWAPFILE_SIZE: '"$SWAPFILE_SIZE"
[[ -z $SWAPFILE_SWAPPINESS ]] && export SWAPFILE_SWAPPINESS='10'   && echo 'SWAPFILE_SWAPPINESS: '"$SWAPFILE_SWAPPINESS"
[[ -z $NVIDIA_CUDA_VERSION ]] && export NVIDIA_CUDA_VERSION='11.3' && echo 'NVIDIA_CUDA_VERSION: '"$NVIDIA_CUDA_VERSION"
[[ -z $NODE_MAJOR_VERSION ]]  && export NODE_MAJOR_VERSION='20'    && echo 'NODE_MAJOR_VERSION: '"$NODE_MAJOR_VERSION"

# Create a marker file to set a persistent state to 1.
# States are persistent across runs and reboots.
#
# Usage:
#     create_marker <marker_name>
#
# Example:
#     create_marker startpoint
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
    local marker_name="$1"
    local marker_path='./tmp/'"$marker_name"'.temp'
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
#
# Returns 0 if the marker was deleted successfully.
# Returns 1 if the marker does not exist.
# Returns 1 if the marker could not be deleted.
#
# Todo:
# - Validate the `marker_name` parameter.
# - Consider using a different file extension (e..g. .marker).
function delete_marker () {
    local marker_name="$1"
    local marker_path='./tmp/'"$marker_name"'.temp'
    if [[ ! -f $marker_path ]]; then
        echo 'Missing marker: '"$marker_path"
        return 1
    else
        echo 'Deleting marker: '"$marker_path"
        rm "$marker_path"
        if [[ -f $marker_path ]]; then
            echo 'Failed to delete marker: '"$marker_path"
            return 1
        fi
        return 0
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
    local prompt_msg="$1"
    local y_or_n_input
    while [ true ]; do
        read -p "$prompt_msg"' (y/n) ' y_or_n_input
        case "$y_or_n_input" in
            y | Y | yes | YES)
                # Valid - Yes
                return 0
                ;;
            n | N | no | NO)
                # Valid - No
                return 1
                ;;
            *)
                # Invalid
                ;;
        esac
    done
}

# Prompt the user for input until a yes or no answer is provided.
# If the user answers with yes, run the `yes_callable` (first) command.
# If the user answers with no, run the `no_callable` (second) command.
#
# Usage:
#     on_yes_or_no <prompt_msg> <yes_callable> <no_callable>
#
# Example:
#     on_yes_or_no 'Do you want food?' 'echo "User is hungry"' 'echo "User is not hungry"'
#
#     Input of 'y' will echo 'User is hungry'
#     Input of 'n' will echo 'User is not hungry'
#
# Parameters:
#     prompt_msg: Message to display during yes or no prompt.
#     yes_callable: Command to run if user answers with yes.
#     no_callable: Command to run if user answers with no.
function on_yes_or_no () {
    local prompt_msg="$1"
    local yes_callable="$2"
    local no_callable="$3"

    ( yes_or_no "$prompt_msg" && $yes_callable ) || $no_callable
}

# Prompt the user continue or exit with the provided status code.
#
# Usage:
#     prompt_to_exit <exit_code>
#
# Example:
#     prompt_to_exit 1
#
# Parameters
#     exit_code: Exit code to exit with if the user chooses to exit.
function prompt_to_exit () {
    local exit_code="$1"
    on_yes_or_no 'Would you like to continue?' \
        "echo 'Continuing ...'" \
        "echo 'Exiting ...'; exit $exit_code"
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
    reset_params
    register_param styles true
    register_param text true
    validate_params "$@" || exit 1
    local styles="$1"
    local text="$2"

    local style
    local style_string=''
    for style in ${styles//,/ }; do
        style_string+="${TEXT_STYLES[$style]}"
    done
    echo -e "${style_string}${text}${TEXT_STYLES['reset']}"
}

