#!/bin/bash -xe

if [[ ! $INSIDE_SCRIPT ]]; then
    echo 'Please run with the installer script. Exiting ...'
    exit
fi

# Configure Bluetooth
# NOTE: THIS IS INCOMPLETE
echo 'Configuring Bluetooth'

#### Disable auto-enabling bluetooth at boot

# https://unix.stackexchange.com/questions/387502/disable-bluetooth-at-boot
#   Modify the file located at /etc/bluetooth/main.conf
sudo sed 's|AutoEnable=true|AutoEnable=false|' -i /etc/bluetooth/main.conf
