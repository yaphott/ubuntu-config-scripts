#!/bin/bash -xe

if [[ ! $INSIDE_SCRIPT ]]; then
    echo 'Please run with the installer script. Exiting ...'
    exit
fi

# Configure HTop
echo '~~~ Configuring HTop'

configuration_path="$HOME"'/.config/htop/htoprc'

#### Prepare configuration

# Run HTop for a moment (generates configurations)
if [[ ! -f "$configuration_path" ]]; then
    # Start HTop in thread
    # TODO: Add loop that checks for process, and then a add a pause
    htop &
    sleep 3
    # Find PID of htop process
    htop_pid=$( ps -ef | awk '$8=="htop" {print $2}' )
    # Send SIGTERM
    kill -15 "$htop_pid"
    # Same as:
    # kill -s SIGTERM "$htop_pid"
fi

# Verify that config file was created
if [[ ! -f "$configuration_path" ]]; then
    echo 'Failed to configure HTop. Exiting ...'
    exit
fi

#### Modify Configuration

sed -i -e "s|^tree_view=0$|tree_view=1|" \
            -e "s|^detailed_cpu_time=0$|detailed_cpu_time=1|" \
            -e "s|^show_cpu_frequency=0$|show_cpu_frequency=1|" \
            -e "s|^show_cpu_temperature=0$|show_cpu_temperature=1|" \
            -e "s|^degree_fahrenheit=0$|degree_fahrenheit=1|" \
            "$configuration_path"
