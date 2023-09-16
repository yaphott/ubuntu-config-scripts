#!/bin/bash -e

################ TODO: Check if evaluating the success of a command is the same if piping e.g. echo 'y' | mycommand
function exit_with_failure () { echo 'Failed to configure Universal Firewall (UFW).'; exit 1; }

if [[ ! $INSIDE_SCRIPT ]]; then
    echo 'Please run with the installer script.'
    exit 1
fi

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

# Disable and reset
# NOTE: Disabling and resetting should not be necessary
sudo ufw disable || exit_with_failure

( echo 'y' | sudo ufw reset ) || exit_with_failure

# Configure
( sudo ufw default allow outgoing \
    && sudo ufw default deny incoming
) || exit_with_failure
# && sudo ufw allow 2222/tcp comment 'SSH access'

# Enable
sudo ufw enable || exit_with_failure

# TODO: Verify successful firewall configuration using UFW status
