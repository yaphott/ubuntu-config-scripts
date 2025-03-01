#!/bin/bash -e

echo '~~~ Configuring DNS'

# Validate input parameters
if [[ $# -ne 4 ]]; then
    echo 'Missing expected input parameters.'
    echo ''
    echo 'Usage:'
    echo '    configure_dns.sh <primary_dns> <primary_dns> <fallback_dns> <fallback_dns>'
    exit 1
fi

primary_nameservers=("$1" "$2")
fallback_nameservers=("$3" "$4")

# Configure DNS
primary_dns_repl="${primary_nameservers[*]}"
fallback_dns_repl="${fallback_nameservers[*]}"
echo 'Primary DNS servers:'"$primary_dns_repl"
echo 'Fallback DNS servers:'"$fallback_dns_repl"
sudo sed -E -e "s/^#?[ \t]*DNS[ \t]*=.*$/DNS=$primary_dns_repl/" \
         -E -e "s/^#?[ \t]*FallbackDNS[ \t]*=.*$/FallbackDNS=$fallback_dns_repl/" \
         -E -e "s/^#?[ \t]*DNSSEC[ \t]*=.*$/DNSSEC=yes/" \
         -E -e "s/^#?[ \t]*DNSOverTLS[ \t]*=.*$/DNSOverTLS=opportunistic/" \
         -i.bak /etc/systemd/resolved.conf

# Verify
primary_dns_expr=$(echo "$primary_dns_repl" | sed 's/\./\\./g')
fallback_dns_expr=$(echo "$fallback_dns_repl" | sed 's/\./\\./g')
if [[ $(grep -c "^DNS=$primary_dns_expr$" /etc/systemd/resolved.conf) -ne 1 ]] \
    || [[ $(grep -c "^FallbackDNS=$fallback_dns_expr$" /etc/systemd/resolved.conf) -ne 1 ]] \
    || [[ $(grep -c '^DNSSEC=yes$' /etc/systemd/resolved.conf) -ne 1 ]] \
    || [[ $(grep -c '^DNSOverTLS=opportunistic$' /etc/systemd/resolved.conf) -ne 1 ]]; then
    echo 'Failed to configure DNS.'
    exit 1
fi

echo 'Restarting systemd-resolved service...'
sudo systemctl restart systemd-resolved

# TODO: Verify DNS configuration is in use.

echo 'DNS configured successfully.'
