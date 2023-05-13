#!/bin/bash -e

function exit_with_failure () { echo 'Failed to configure Bluetooth.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

# Configure Bluetooth
echo '~~~ Configuring Bluetooth'

#### Disable auto-enabling bluetooth at boot
# TODO: Check that line was actually changed instead of command being successful
# TODO: Disable bluetooth while running (not just on boot)

# https://unix.stackexchange.com/questions/387502/disable-bluetooth-at-boot
#   Modify the file located at /etc/bluetooth/main.conf
sudo sed 's|AutoEnable=true|AutoEnable=false|' -i /etc/bluetooth/main.conf \
    || exit_with_failure
