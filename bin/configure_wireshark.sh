#!/bin/bash -e

echo '~~~ Configuring Wireshark'

# Allow non-root users to capture packets
echo "wireshark-common wireshark-common/install-setuid boolean true" | sudo debconf-set-selections

echo 'Wireshark configured successfully.'
