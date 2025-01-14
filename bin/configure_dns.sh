#!/bin/bash -e

function exit_with_failure () { echo 'Failed to configure DNS.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

echo '~~~ Configuring DNS'

# Validate input parameters
if [[ ! "$1" ]]; then
    echo 'Missing expected input parameters.'
    echo ''
    echo 'Usage:'
    echo '    configure_dns.sh <dns 1> <dns 2> ... <dns N>'
    exit 1
fi

if [[ -s /etc/resolv.conf ]]; then
    echo 'Backing up /etc/resolv.conf...'
    sudo cp /etc/resolv.conf /etc/resolv.conf.bak || exit_with_failure
fi

sudo truncate -s 0 /etc/resolv.conf || exit_with_failure
for dns in "$@"; do
    echo "nameserver $dns" | sudo tee -a /etc/resolv.conf > /dev/null || exit_with_failure
    if [[ $( grep -c "^nameserver $dns$" /etc/resolv.conf ) -ne 1 ]]; then
        echo "Failed to add nameserver $dns to /etc/resolv.conf."
        exit_with_failure
    fi
done

echo 'DNS configured successfully.'
