#!/bin/bash -e


function exit_with_failure () { echo 'Failed to disable telemetry.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

echo '~~~ Disabling telemetry'


# TODO
# sudo apt-get remove --purge -y ubuntu-advantage-tools || exit_with_failure
#
# https://gist.github.com/CodeSigils/974abb61becf435c857b55e925f12780
# apt-mark hold ubuntu-report popularity-contest apport whoopsie apport-symptoms

#### Opt-out of telemetry

echo 'Sending telemetry opt-out...'
ubuntu-report -f send no

#### Blacklist domains

BLACKLISTED_DOMAINS=(
    # 'geo.ubuntu.com'
    'popcon.ubuntu.com'
    # 'popcon.canonical.com'
    'metrics.ubuntu.com'
    'www.metrics.ubuntu.com'
    'www.popcon.ubuntu.com'
)

if [[ -s /etc/hosts ]]; then
    echo 'Backing up /etc/hosts...'
    sudo cp /etc/hosts /etc/hosts.bak || exit_with_failure
fi

needs_any_blacklist=false
for domain in "${BLACKLISTED_DOMAINS[@]}"; do
    if grep -q -E '^127.0.0.1[ \t]+'"$domain"'[ \t]*$' /etc/hosts; then
        needs_any_blacklist=true
        break
    fi
done
if $needs_any_blacklist; then
    echo '' | sudo tee -a /etc/hosts > /dev/null || exit_with_failure
    for domain in "${BLACKLISTED_DOMAINS[@]}"; do
        if grep -q -E '^127.0.0.1[ \t]+'"$domain"'[ \t]*$' /etc/hosts; then
            echo "Domain already blacklisted: $domain"
        else
            echo "Blacklisting domain: $domain"
            echo "127.0.0.1 $domain" | sudo tee -a /etc/hosts > /dev/null || exit_with_failure
        fi
    done
    echo '' | sudo tee -a /etc/hosts > /dev/null || exit_with_failure
fi

echo ''

#### Stop and disable telemetry services

PACKAGE_NAMES=(
    'apport'
    'popularity-contest'
    'ubuntu-report'
    'whoopsie'
)
SERVICE_BASE_NAMES=(
    'apport'
    'apport-autoreport'
    'apport-forward'
    'apport-symptoms'
    'motd-news'
    'popularity-contest'
    'ubuntu-report'
    'whoopsie'
)

function list_units () { systemctl list-units --all --full --type=service --no-pager --plain --no-legend | awk '{print $1}' | grep -E '^'"$1"'(\.\S+)?$'; }
function check_active () { systemctl is-active "$1" 2>/dev/null; }
function check_enabled () { systemctl is-enabled "$1" 2>/dev/null; }


DISCOVERED_SERVICES=()
for base_name in "${SERVICE_BASE_NAMES[@]}"; do
    service_units="$(list_units "$base_name")"
    if [[ -z "$service_units" ]]; then
        echo "No service units found for $base_name"
        continue
    fi
    for service_unit in $service_units; do
        DISCOVERED_SERVICES+=("$service_unit")
    done
done

for service_unit in $DISCOVERED_SERVICES; do
    active_status="$(check_active "$service_unit")"
    if [[ "$active_status" == 'active' ]]; then
        echo "Stopping service: $service_unit"
        sudo systemctl stop "$service_unit" 2>/dev/null || exit_with_failure
        active_status="$(check_active "$service_unit")"
        if [[ "$active_status" != 'inactive' ]]; then
            echo "Failed to stop service: $service_unit (is-active: $active_status)"
        fi
    elif [[ "$active_status" == 'inactive' ]]; then
        echo "Service already stopped: $service_unit"
    else
        echo "Unexpected status for service: $service_unit (is-active: $active_status)"
        exit_with_failure
    fi
done
echo ''

for service_unit in $DISCOVERED_SERVICES; do
    enabled_status="$(check_enabled "$service_unit")"
    if [[ "$enabled_status" == 'enabled' ]]; then
        echo "Disabling service: $service_unit"
        sudo systemctl disable "$service_unit" 2>/dev/null || exit_with_failure
        enabled_status="$(check_enabled "$service_unit")"
        if [[ "$enabled_status" != 'disabled' ]]; then
            echo "Failed to disable service: $service_unit (is-enabled: $enabled_status)"
        fi
    elif [[ "$enabled_status" == 'disabled' || "$enabled_status" == 'masked' ]]; then
        echo "Service already disabled: $service_unit"
    elif [[ "$enabled_status" == 'static' ]]; then
        echo "Service is static: $service_unit"
    else
        echo "Unexpected status for service: $service_unit (is-enabled: $enabled_status)"
        exit_with_failure
    fi
done
echo ''

for service_unit in $DISCOVERED_SERVICES; do
    enabled_status="$(check_enabled "$service_unit")"
    if [[ "$enabled_status" != 'masked' ]]; then
        echo "Masking service: $service_unit"
        sudo systemctl mask "$service_unit" 2>/dev/null || exit_with_failure
        enabled_status="$(check_enabled "$service_unit")"
        if [[ "$enabled_status" != 'masked' ]]; then
            echo "Failed to mask service: $service_unit (is-enabled: $enabled_status)"
        fi
    elif [[ "$enabled_status" == 'masked' ]]; then
        echo "Service already masked: $service_unit"
    else
        echo "Unexpected status for service: $service_unit (is-enabled: $enabled_status)"
        exit_with_failure
    fi
done
echo ''

# for package_name in "${PACKAGE_NAMES[@]}"; do
#     echo "Removing package: $package_name"
#     sudo apt-get remove -y "$package_name" || exit_with_failure
#     sudo apt-get purge -y "$package_name" || exit_with_failure
# done
echo "Removing packages: ${PACKAGE_NAMES[*]}"
(sudo apt-get remove -q -y "${PACKAGE_NAMES[@]}" \
    && sudo apt-get purge -q -y "${PACKAGE_NAMES[@]}" \
    && sudo apt-get autoremove -q -y \
    && sudo apt-get autoclean -q
) || exit_with_failure
echo ''

#### Disable motd-news

# Make motd-news script is unable to execute
if [[ -f /etc/update-motd.d/50-motd-news ]]; then
    sudo chmod -x /etc/update-motd.d/50-motd-news || exit_with_failure
fi

# Configure motd-news to not run
if [[ -s /etc/default/motd-news ]]; then
    echo 'Backing up /etc/default/motd-news...'
    sudo cp /etc/default/motd-news /etc/default/motd-news.bak || exit_with_failure

    echo 'Disabling motd-news...'
    sudo sed 's|^ENABLED=1$|ENABLED=0|g' -i /etc/default/motd-news || exit_with_failure

    echo ''
elif ! grep -q '^ENABLED=0$' /etc/default/motd-news; then
    echo 'ENABLED=0' | sudo tee /etc/default/motd-news > /dev/null || exit_with_failure
fi


# Let OpenSSH handle the motd (place inside /etc/motd yourself)
motd_base_expr='session[ \t]+optional[ \t]+pam_motd.so[ \t]+.+'
sudo sed -E "s|^(${motd_base_expr})$|# \1|g" -i /etc/pam.d/sshd || exit_with_failure
if grep -E "^${motd_base_expr}[ \t]*$" /etc/pam.d/sshd; then
    echo 'Unexpected value for pam_motd.so in /etc/pam.d/sshd.'
    exit_with_failure
fi

echo 'Telemetry disabled successfully.'
