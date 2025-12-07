#!/bin/bash -e

blacklisted_domains=(
    # 'geo.ubuntu.com'
    'popcon.ubuntu.com'
    # 'popcon.canonical.com'
    'metrics.ubuntu.com'
    'www.metrics.ubuntu.com'
    'www.popcon.ubuntu.com'
)
package_names=(
    'apport'
    'popularity-contest'
    'ubuntu-report'
    'whoopsie'
)
service_base_names=(
    'apport'
    'apport-autoreport'
    'apport-forward'
    'apport-symptoms'
    'motd-news'
    'popularity-contest'
    'ubuntu-report'
    'whoopsie'
)
hosts_path='/etc/hosts'

echo '~~~ Disabling telemetry'

# TODO
# sudo apt-get remove --purge -y ubuntu-advantage-tools
#
# https://gist.github.com/CodeSigils/974abb61becf435c857b55e925f12780
# apt-mark hold ubuntu-report popularity-contest apport whoopsie apport-symptoms

#### Opt-out of telemetry

echo 'Sending telemetry opt-out...'
ubuntu-report -f send no 2>/dev/null || true

#### Blacklist domains

if [[ -s "$hosts_path" ]]; then
    backup_hosts_path="${hosts_path}.bak"
    echo "Backing up existing file ${hosts_path} to ${backup_hosts_path}"
    sudo cp "$hosts_path" "$backup_hosts_path"
fi

needs_any_blacklist=false
for domain in "${blacklisted_domains[@]}"; do
    if grep -q -E "^127.0.0.1 +$domain *$" "$hosts_path"; then
        needs_any_blacklist=true
        break
    fi
done
if $needs_any_blacklist; then
    echo '' | sudo tee -a "$hosts_path" > /dev/null
    for domain in "${blacklisted_domains[@]}"; do
        if grep -q -E "^127.0.0.1 +$domain *$" "$hosts_path"; then
            echo "Domain already blacklisted: $domain"
        else
            echo "Blacklisting domain: $domain"
            echo "127.0.0.1 $domain" | sudo tee -a "$hosts_path" > /dev/null
        fi
    done
    echo '' | sudo tee -a "$hosts_path" > /dev/null
fi

#### Stop and disable telemetry services

function list_units () { systemctl list-units --all --full --type=service --no-pager --plain --no-legend | awk '{print $1}' | grep -E '^'"$1"'(\.\S+)?$'; }
function check_active () { systemctl is-active "$1" 2>/dev/null; }
function check_enabled () { systemctl is-enabled "$1" 2>/dev/null; }

discovered_services=()
for base_name in "${service_base_names[@]}"; do
    service_units="$(list_units "$base_name")"
    if [[ -z "$service_units" ]]; then
        echo "No service units found for $base_name"
        continue
    fi
    for service_unit in $service_units; do
        discovered_services+=("$service_unit")
    done
    echo "Discovered service units for $base_name: ${discovered_services[*]}"
done

for service_unit in "${discovered_services[@]}"; do
    active_status="$(check_active "$service_unit" || true)"
    if [[ "$active_status" == 'active' ]]; then
        echo "Stopping service: $service_unit"
        sudo systemctl stop "$service_unit" 2>/dev/null
        active_status="$(check_active "$service_unit" || true)"
        if [[ "$active_status" != 'inactive' ]]; then
            echo "Failed to stop service: $service_unit (is-active: $active_status)"
        fi
    elif [[ "$active_status" == 'inactive' ]]; then
        echo "Service already stopped: $service_unit"
    elif [[ -n "$active_status" ]]; then
        echo "Unexpected status for service: $service_unit (is-active: $active_status)"
        exit 1
    fi

    enabled_status="$(check_enabled "$service_unit" || true)"
    if [[ "$enabled_status" == 'enabled' ]]; then
        echo "Disabling service: $service_unit"
        sudo systemctl disable "$service_unit" 2>/dev/null
        enabled_status="$(check_enabled "$service_unit" || true)"
        if [[ "$enabled_status" != 'disabled' ]]; then
            echo "Failed to disable service: $service_unit (is-enabled: $enabled_status)"
        fi
    elif [[ "$enabled_status" == 'disabled' || "$enabled_status" == 'masked' ]]; then
        echo "Service already disabled: $service_unit"
    elif [[ "$enabled_status" == 'static' ]]; then
        echo "Service is static: $service_unit"
    elif [[ -n "$enabled_status" ]]; then
        echo "Unexpected status for service: $service_unit (is-enabled: $enabled_status)"
        exit 1
    fi

    enabled_status="$(check_enabled "$service_unit" || true)"
    if [[ "$enabled_status" != 'masked' ]]; then
        echo "Masking service: $service_unit"
        sudo systemctl mask "$service_unit" 2>/dev/null
        enabled_status="$(check_enabled "$service_unit" || true)"
        if [[ "$enabled_status" != 'masked' ]]; then
            echo "Failed to mask service: $service_unit (is-enabled: $enabled_status)"
        fi
    elif [[ "$enabled_status" == 'masked' ]]; then
        echo "Service already masked: $service_unit"
    elif [[ -n "$enabled_status" ]]; then
        echo "Unexpected status for service: $service_unit (is-enabled: $enabled_status)"
        exit 1
    fi
done

echo "Removing packages: ${package_names[*]}"
sudo apt-get remove -y "${package_names[@]}"
sudo apt-get purge -y "${package_names[@]}"
sudo apt-get autoremove -y
sudo apt-get autoclean

#### Disable motd-news

echo 'Disabling motd-news...'

# Make motd-news script is unable to execute
if [[ -f /etc/update-motd.d/50-motd-news ]]; then
    sudo chmod -x /etc/update-motd.d/50-motd-news
fi

# Configure motd-news to not run
if [[ -s /etc/default/motd-news ]]; then
    sudo sed -E 's|^#?[ \t]*ENABLED[ \t]*=.+$|ENABLED=0|g' -i=.bak /etc/default/motd-news
elif ! grep -q '^ENABLED=0$' /etc/default/motd-news; then
    echo 'ENABLED=0' | sudo tee /etc/default/motd-news > /dev/null
fi
if ! grep -q '^ENABLED=0$' /etc/default/motd-news; then
    echo 'Failed to disable motd-news.'
    exit 1
fi

# Let OpenSSH handle the motd (place inside /etc/motd yourself)
motd_base_expr='session[ \t]+optional[ \t]+pam_motd.so[ \t]+.+'
sudo sed -E "s|^(${motd_base_expr})$|# \1|g" -i=.bak /etc/pam.d/sshd
if grep -E "^${motd_base_expr}[ \t]*$" /etc/pam.d/sshd; then
    echo 'Unexpected value for pam_motd.so in /etc/pam.d/sshd.'
    exit 1
fi

echo 'Telemetry disabled successfully.'
