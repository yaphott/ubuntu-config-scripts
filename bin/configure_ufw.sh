#!/bin/bash -e

echo '~~~ Configuring Universal Firewall (UFW)'

# https://wiki.ubuntu.com/UncomplicatedFirewall
# The user may achieve a more advanced configuration by editing the following files:
#   /etc/default/ufw: high level configuration, such as default policies, IPv6 support and kernel modules to use
#   /etc/ufw/before[6].rules: rules in these files are evaluated before any rules added via the ufw command
#   /etc/ufw/after[6].rules: rules in these files are evaluated after any rules added via the ufw command
#   /etc/ufw/sysctl.conf: kernel network tunables
#   /var/lib/ufw/user[6].rules or /lib/ufw/user[6].rules (0.28 and later): rules added via the ufw command (should not normally be edited by hand)
#   /etc/ufw/ufw.conf: sets whether or not ufw is enabled on boot, sets the LOGLEVEL
#   /etc/ufw/after.init: initialization customization script run after ufw is initialized
#   /etc/ufw/before.init: initialization customization script run before ufw is initialized
# After modifying any of the above files, activate the new settings with:
#   sudo ufw disable
#   sudo ufw enable

# View current firewall status and rules
# sudo ufw status
# cat /etc/default/ufw

# Configure
sudo ufw disable
sudo ufw default deny incoming -y
sudo ufw default allow outgoing -y
yes | sudo ufw reset
sudo ufw enable
sudo ufw reload

# Allow specific ports
# sudo ufw allow 2222/tcp comment 'SSH access'
# sudo ufw allow 25565/tcp comment 'Minecraft server'

# Verify configuration
if [[
    $(sudo ufw status | grep -c '^Status: active$') -ne 1
    || $(sudo ufw status numbered | grep -c '\[ *[0-9]\]') -ne 0
]]; then
    echo 'Unexpected rules for UFW.'
    exit 1
fi

echo 'Universal Firewall (UFW) configured successfully.'
