#!/bin/bash -e

echo '~~~ Configuring Bluetooth'

#### Disable auto-enabling bluetooth at boot
# TODO: Check that line was actually changed instead of command being successful
# TODO: Disable bluetooth while running (not just on boot)

# https://unix.stackexchange.com/questions/387502/disable-bluetooth-at-boot
if grep -q '^AutoEnable=true$' /etc/bluetooth/main.conf; then
    sudo sed 's|^AutoEnable=true$|AutoEnable=false|' -i=.bak /etc/bluetooth/main.conf
elif ! grep -q '^AutoEnable=false$' /etc/bluetooth/main.conf; then
    echo 'AutoEnable=false' | sudo tee -a /etc/bluetooth/main.conf > /dev/null
fi
if [[ $(grep -c '^AutoEnable=false$' /etc/bluetooth/main.conf) -ne 1 ]]; then
    echo 'Failed to configure Bluetooth.'
    exit 1
fi

echo 'Bluetooth configured successfully.'
