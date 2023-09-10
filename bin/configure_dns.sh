#!/bin/bash -e

function exit_with_failure () { echo 'Failed to configure DNS.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

# Configure DNS
echo '~~~ Configuring DNS'

# TODO: Accept user input for DNS servers
echo "\
nameserver 1.1.1.1
nameserver 8.8.8.8
nameserver 8.4.4.8
nameserver 1.0.0.1
" | sudo tee /etc/resolv.conf > /dev/null \
    || exit_with_failure
