#!/bin/bash -e

function exit_with_failure () { echo 'Failed to configure HTop.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

# Configure HTop
echo '~~~ Configuring HTop'

# Local variables
configuration_path="$HOME"'/.config/htop/htoprc'

#### Prepare configuration

# Run HTop for a moment (generates configurations)
if [[ ! -f "$configuration_path" ]]; then
    # Run htop for 5 seconds to generate config
    echo 'Generating htop configuration'
    echo 'NOTICE: htop will run for 5 seconds. Install will resume immediately after.'
    timeout 5 htop
    status=$?
    if [[ ! $status -eq 124 ]]; then
        exit_with_failure
    fi

    # Verify that config file was created
    if [[ ! -f "$configuration_path" ]]; then
        exit_with_failure
    fi
fi


#### Modify Configuration
# TODO: Check that line was actually changed instead of command being successful

sed -i -e "s|^tree_view=0$|tree_view=1|" \
    -e "s|^detailed_cpu_time=0$|detailed_cpu_time=1|" \
    -e "s|^show_cpu_frequency=0$|show_cpu_frequency=1|" \
    -e "s|^show_cpu_temperature=0$|show_cpu_temperature=1|" \
    -e "s|^degree_fahrenheit=0$|degree_fahrenheit=1|" \
    "$configuration_path" \
    || exit_with_failure
