#!/bin/bash -xe

if [[ ! $INSIDE_SCRIPT ]]; then
    echo "Please run with the installer script"
    exit
fi

# NOTE: THIS IS INCOMPLETE

# Configure Mozilla Firefox
# TODO: Add value check onto user input
echo 'Configuring Mozilla Firefox'

# Initialize Firefox if not done already
if ![[ -d '/home/'"$USER"'/snap/firefox' ]]; then
    # Start Firefox in thread
    firefox &
    # TODO: Add loop that checks for process, and then a add a pause
    sleep 10 && skill --command firefox
fi

# inotifywatch -e modify,create,delete -r ~/snap/firefox/common/.mozilla
for file_dir in '/home/'"$USER"'/snap/firefox/common/.mozilla/firefox/'*'.default'
do
    [ -d "$file_dir" ] || break
    echo "$file_dir"
done


