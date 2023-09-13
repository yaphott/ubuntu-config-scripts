#!/usr/bin/env bash -e

function exit_with_failure () { echo 'Failed to configure Firefox.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

# NOTE: THIS IS INCOMPLETE
echo '~~~ Configuring Mozilla Firefox'

function ensure_param () {
    if [[ ! $2 ]]; then
        echo 'Missing expected parameter: '"$1"
    fi
}

# TODO: Change this match HTop configuration script
# Run Firefox for a brief moment (generates configurations)
if [[ ! -d "$HOME"'/snap/firefox' ]]; then
    # Start Firefox in thread
    firefox &
    # TODO: Add loop that checks for process, and then a add a pause
    sleep 10 && skill --command firefox
fi

# inotifywatch -e modify,create,delete -r ~/snap/firefox/common/.mozilla
# TODO: Resolve the user directory prior to this to ensure it is correct
for file_dir in "$HOME"'/snap/firefox/common/.mozilla/firefox/'*'.default'
do
    [ -d "$file_dir" ] || break
    echo "$file_dir"
done
