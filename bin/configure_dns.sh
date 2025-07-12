#!/bin/bash -e

function extract_multiline_values () {
    local start_text="$1"
    if [[ -z "$start_text" ]]; then
        echo 'Missing required parameter: start_text'
        return 1
    fi
    start_text="$(echo "$start_text" | sed -E 's/\./\\./g')"
    local input="$2"
    if [[ -z "$input" ]]; then
        echo 'Missing required parameter: input'
        return 1
    fi
    echo "$input" | awk '
    BEGIN {
        found = 0;
        done = 0;
        values = "";
        first_expr = "^ *'"$start_text"' *";
        subsequent_expr = "^ +";
    }
    found == 0 && done == 0 && $0 ~ first_expr {
        # Found first line
        found = 1;
        sub(first_expr, "");
        values = $0;
        next;
    }
    found == 1 && done == 0 && $0 ~ subsequent_expr {
        # Found subsequent line
        values = values " " $0;
        next;
    }
    found == 1 && done == 0 && !($0 ~ subsequent_expr) {
        # Nothing to do
        found = 0;
        done = 1;
    }
    END {
        # Normalize spaces
        gsub(/ {2,}/, " ", values);
        # Remove trailing spaces
        sub(/ +$/, "", values);
        # Done
        print values;
    }'
}

function normalize_zero_compression () {
    local addresses="$1"
    if [[ -z "$addresses" ]]; then
        echo 'Missing required parameter: addresses'
        return 1
    fi
    echo "$addresses" | sed -E -e 's/:0+/:/g' -E -e 's/:{2,}/::/g'
}

echo '~~~ Configuring DNS'

# Validate input parameters
if [[ $# -ne 2 ]]; then
    echo 'Missing expected input parameters:'
    echo '    primary_nameservers: Primary nameservers (space-delimited, e.g. "1.1.1.1 2606:4700:4700::1111").'
    echo '    fallback_nameservers: Fallback nameservers (space-delimited, e.g. "1.0.0.1 2606:4700:4700::1001").'
    echo ''
    echo 'Usage: configure_dns.sh <primary_nameservers> <fallback_nameservers>'
    exit 1
fi

primary_dns="$1"
fallback_nameservers="$2"

primary_dns_repl="${primary_dns[*]}"
fallback_dns_repl="${fallback_dns[*]}"

echo "Primary DNS: ${primary_dns_repl}"
echo "Fallback DNS: ${fallback_dns_repl}"
sudo sed -E -e "s/^#?[ \t]*DNS[ \t]*=.*$/DNS=$primary_dns_repl/" \
         -E -e "s/^#?[ \t]*FallbackDNS[ \t]*=.*$/FallbackDNS=$fallback_dns_repl/" \
         -E -e "s/^#?[ \t]*DNSSEC[ \t]*=.*$/DNSSEC=yes/" \
         -E -e "s/^#?[ \t]*DNSOverTLS[ \t]*=.*$/DNSOverTLS=opportunistic/" \
         -i.bak /etc/systemd/resolved.conf

# Verify configuration has been modified
primary_dns_expr="${primary_dns_repl//./\\.}"
fallback_dns_expr="${fallback_dns_repl//./\\.}"
if [[ $(grep -c "^DNS=$primary_dns_expr$" /etc/systemd/resolved.conf) -ne 1 ]] \
    || [[ $(grep -c "^FallbackDNS=$fallback_dns_expr$" /etc/systemd/resolved.conf) -ne 1 ]] \
    || [[ $(grep -c '^DNSSEC=yes$' /etc/systemd/resolved.conf) -ne 1 ]] \
    || [[ $(grep -c '^DNSOverTLS=opportunistic$' /etc/systemd/resolved.conf) -ne 1 ]]; then
    echo 'Failed to configure DNS.'
    exit 1
fi

echo 'Restarting systemd-resolved service...'
sudo systemctl restart systemd-resolved

# Verify configuration is active
resolved_status="$(resolvectl status --no-pager)"
primary_dns_actual=$(extract_multiline_values 'DNS Servers:' "$resolved_status")
fallback_dns_actual=$(extract_multiline_values 'Fallback DNS Servers:' "$resolved_status")
protocols_actual=$(extract_multiline_values 'Protocols:' "$resolved_status")
if [[ $(normalize_zero_compression "$primary_dns_actual") != $(normalize_zero_compression "$primary_dns_repl") ]] \
    || [[ $(normalize_zero_compression "$fallback_dns_actual") != $(normalize_zero_compression "$fallback_dns_repl") ]]; then
    echo 'Failed to configure DNS nameservers:'
    echo "    Expected: ${primary_dns_repl}"
    echo "    Found: ${primary_dns_actual}"
    exit 1
fi
if [[ ! "$protocols_actual" =~ (^|[[:space:]])DNSOverTLS=opportunistic([[:space:]]|$) ]] \
    || [[ ! "$protocols_actual" =~ (^|[[:space:]])DNSSEC=yes/supported([[:space:]]|$) ]]; then
    echo 'Failed to verify DNS protocols.'
    echo "    Expected: DNSOverTLS=opportunistic, DNSSEC=yes/supported"
    echo "    Actual: $protocols_actual"
    exit 1
fi

echo 'DNS configured successfully.'
