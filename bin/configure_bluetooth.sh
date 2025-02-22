#!/bin/bash -e

function exit_with_failure () { echo 'Failed to configure Bluetooth.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

echo '~~~ Configuring Bluetooth'

#### Disable auto-enabling bluetooth at boot
# TODO: Check that line was actually changed instead of command being successful
# TODO: Disable bluetooth while running (not just on boot)

# https://unix.stackexchange.com/questions/387502/disable-bluetooth-at-boot
if grep -q '^AutoEnable=true$' /etc/bluetooth/main.conf; then
    sudo sed 's|^AutoEnable=true$|AutoEnable=false|' -i=.bak /etc/bluetooth/main.conf || exit_with_failure
elif ! grep -q '^AutoEnable=false$' /etc/bluetooth/main.conf; then
    echo 'AutoEnable=false' | sudo tee -a /etc/bluetooth/main.conf > /dev/null || exit_with_failure
fi
if [[ $(grep -c '^AutoEnable=false$' /etc/bluetooth/main.conf) -ne 1 ]]; then
    exit_with_failure
fi

echo 'Bluetooth configured successfully.'
