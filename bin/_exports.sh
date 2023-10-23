#!/bin/bash

# Resolve name of current user
if [ $SUDO_USER ]; then
    export USER=$SUDO_USER;
else
    export USER=$LOGNAME;
fi

# Resolve distro codename
export DIST_CODENAME="$( lsb_release -cs )"

function create_marker () {
    # TODO:
    # - Validate function parameter
    # - Consider passing in the full path, or using a set_path function
    marker_path='./tmp/'"$1"'.temp'
    if [[ -f $marker_path ]]; then
        echo 'Marker already exists: '"$marker_path"
        return 1
    else
        echo 'Creating marker: '"$marker_path"
        touch "$marker_path"
        return 0
    fi
}

function delete_marker () {
    # TODO:
    # - Validate function parameter
    # - Consider passing in the full path, or using a set_path function
    marker_path='./tmp/'"$1"'.temp'
    if [[ ! -f $marker_path ]]; then
        echo 'Missing marker: '"$marker_path"
        return 1
    else
        echo 'Deleting marker: '"$marker_path"
        rm "$marker_path"
        return 0
    fi
}

function yes_or_no () {
    # Prompt a user with a message until a yes or no answer is provided.
    #
    # Parameters
    #   prompt_msg: Message to display during yes or no prompt.
    #
    # Example:
    #   (yes_or_no 'Would you like to play basketball tonight?' && echo 'User answered yes!') || echo 'User answered no!'
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

function on_yes_or_no () {
    # Prompt the user with a message for a yes or no response and then
    #   execute one of two callables depending on the user response to yes_or_no.
    #
    # Parameters
    #   prompt_msg: Message to display during yes or no prompt.
    #   yes_callable: Command to run if user answers with yes.
    #   no_callable: Command to run if user answers with no.
    #
    # Example 1:
    #   on_yes_or_no 'Will this work?' "echo Testing A" "echo Testing B"
    #
    # Example 2:
    #   function test_it_a () {
    #       echo 'Testing A'
    #   }
    #   function test_it_b () {
    #       echo 'Testing B'
    #   }
    #   on_yes_or_no 'Will this work?' "test_it_a" "test_it_b"
    #
    # Equivalent to:
    #   (yes_or_no 'Would you like to play basketball tonight?' && echo 'User answered yes!') || echo 'User answered no!'
    local prompt_msg="$1"
    local yes_callable="$2"
    local no_callable="$3"
    (yes_or_no "$prompt_msg" && $yes_callable) || $no_callable
}

function prompt_to_exit () {
    # Prompt the user for if they would like to continue.
    # If not continuing, exit with the provided status code.
    #
    # Parameters
    #   exit_code: Exit code to use if user chooses to exit.
    #
    # Example:
    #   prompt_to_exit 1
    local exit_code="$1"
    on_yes_or_no 'Would you like to continue?' \
        "echo 'Continuing ...'" \
        'exit '"$exit_code"
}

declare -A TEXT_STYLES
TEXT_STYLES['bold']='\e[1m'
TEXT_STYLES['dim']='\e[2m'
TEXT_STYLES['red']='\e[31m'
TEXT_STYLES['green']='\e[32m'
TEXT_STYLES['reset']='\e[0m'

function style_text () {
    # Style text with the provided styles.
    #
    # Parameters
    #   styles: Comma separated list of styles to apply to the text.
    #   text: Text to style.
    #
    # Example:
    #   stylized_text=$( style_text 'bold,red' 'This is bold red text!' )
    local styles="$1"
    local text="$2"
    local style
    local style_string=''
    for style in ${styles//,/ }; do
        style_string+="${TEXT_STYLES[$style]}"
    done
    echo -e "${style_string}${text}${TEXT_STYLES['reset']}"
}

function echo_with_style () {
    # Echo text with the provided styles.
    #
    # Parameters
    #   styles: Comma separated list of styles to apply to the text.
    #   text: Text to echo.
    #
    # Example:
    #   echo_with_style 'bold,red' 'This is bold red text!'
    local styles="$1"
    local text="$2"
    echo $( style_text "${styles}" "${text}" )
}
