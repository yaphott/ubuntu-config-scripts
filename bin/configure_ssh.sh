#!/bin/bash -e

echo '~~~ Configuring SSH'

# Change the port and limit outside access
sudo sed -E -e "s|^#[ \t]*PermitRootLogin[ \t]+.+$|PermitRootLogin no|" \
         -E -e "s|^#[ \t]*PasswordAuthentication[ \t]+.+$|PasswordAuthentication no|" \
         -E -e "s|^#[ \t]*PermitEmptyPasswords[ \t]+.+$|PermitEmptyPasswords no|" \
         -E -e "s|^#[ \t]*Port[ \t]+.+$|Port 2222|" \
         -E -e "s|^#[ \t]*LoginGraceTime[ \t]+.+$|LoginGraceTime 2m|" \
         -E -e "s|^#[ \t]*MaxAuthTries[ \t]+.+$|MaxAuthTries 6|" \
         -E -e "s|^#[ \t]*MaxSessions[ \t]+.+$|MaxSessions 10|" \
         -i=.bak /etc/ssh/sshd_config

# Restart SSH
echo 'Restarting service: sshd'
sudo systemctl restart sshd

# Verify
if ! grep -q '^PermitRootLogin no$' /etc/ssh/sshd_config \
    || ! grep -q '^PasswordAuthentication no$' /etc/ssh/sshd_config \
    || ! grep -q '^PermitEmptyPasswords no$' /etc/ssh/sshd_config \
    || ! grep -q '^Port 2222$' /etc/ssh/sshd_config \
    || ! grep -q '^LoginGraceTime 2m$' /etc/ssh/sshd_config \
    || ! grep -q '^MaxAuthTries 6$' /etc/ssh/sshd_config \
    || ! grep -q '^MaxSessions 10$' /etc/ssh/sshd_config; then
    echo 'Failed to configure SSH.'
    exit 1
fi

echo 'SSH configured successfully.'
