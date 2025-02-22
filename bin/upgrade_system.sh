#!/bin/bash -e

function exit_with_failure () { echo 'Failed to install System Upgrades.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

echo '+++ System Upgrades'

(sudo apt-get update && sudo apt-get install needrestart -y) \
    || exit_with_failure

(sudo apt-get update \
    && sudo NEEDRESTART_MODE=a apt-get dist-upgrade -y \
    && sudo apt-get autoremove -y \
    && sudo apt-get autoclean
) || exit_with_failure

sudo snap refresh || exit_with_failure

echo 'System Upgraded successfully.'
