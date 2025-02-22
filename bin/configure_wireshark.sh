#!/bin/bash -e

function exit_with_failure () { echo 'Failed to configure Wireshark.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

echo '~~~ Configuring Wireshark'

# Allow non-root users to capture packets
echo "wireshark-common wireshark-common/install-setuid boolean true" | sudo debconf-set-selections

echo 'Wireshark configured successfully.'
