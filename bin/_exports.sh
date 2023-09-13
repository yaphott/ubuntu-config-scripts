#!/usr/bin/env bash

# Resolve name of current user
if [ $SUDO_USER ]; then
    export USER=$SUDO_USER;
else
    export USER=$LOGNAME;
fi

function create_marker () {
    # TODO: Validate function parameter
    marker_path='./tmp/'"$1"'.temp'
    if [[ -f $marker_path ]]; then
        echo 'Marker already exists: '"$marker_path"
        echo exit 1
    else
        echo 'Creating marker: '"$marker_path"
        touch "$marker_path"
        return
    fi
}

function delete_marker () {
    # TODO: Validate function parameter
    marker_path='./tmp/'"$1"'.temp'
    if [[ ! -f $marker_path ]]; then
        echo 'Missing marker: '"$marker_path"
        echo exit 1
    else
        echo 'Deleting marker: '"$marker_path"
        rm "$marker_path"
        return
    fi
}


function yes_or_no () {
    # Prompt a user with a message until a yes or no answer is provided.
    while [ true ]; do
        # Display message
        echo -n "$1"' (y/n) '
        # Receive and validate user input
        read y_or_n_input
        case "$y_or_n_input" in
            y | yes | Y | YES)
                # Valid input. User answered yes.
                return 0
                ;;
            n | no | N | NO)
                # Valid input. User answered no.
                return 1
                ;;
            *)
                # Invalid input (loop)
                ;;
        esac
    done
}

function on_yes_or_no () {
    # Prompt the user with a message for a yes or no response and then
    #   execute one of two callables depending on the user response to yes_or_no.
    # 
    # Parameters
    #   Message to display during yes or no prompt.
    #   Command to run if user answers with yes.
    #   Command to run if user answers with no.
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
    (yes_or_no "$1" && $2) || $3
}

function prompt_to_exit () {
    # Prompt the user for if they would like to continue.
    # If not continuing, exit with the provided status code.
    # 
    # Parameters
    #   Exit code to use if user chooses to exit.
    # 
    # Example:
    #   Exit with 1 if users chooses not to continue
    #   prompt_to_exit 1
    on_yes_or_no 'Would you like to continue?' \
                 "echo Continuing..." \
                 "exit $1"
}
