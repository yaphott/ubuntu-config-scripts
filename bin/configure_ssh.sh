#!/usr/bin/env bash -e

function exit_with_failure () { echo 'Failed to configure SSH.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

# Configure SSH
# NOTE: THIS IS INCOMPLETE
echo '~~~ Configuring SSH'

#### Add github to known hosts - Needs sudo?

ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts \
    || exit_with_failure

#### Limit outside access and change port
# TODO: Check that line was actually changed instead of command being successful

# sudo sed -i -e "s|^#PermitRootLogin yes|PermitRootLogin no|" \
# -e "s|^#PasswordAuthentication yes|PasswordAuthentication no|" \
# -e "s|^#PermitEmptyPasswords no|PermitEmptyPasswords no|" \
# -e "s|^#Port 22|Port 2222|" \
# -e "s|^#LoginGraceTime 2m|LoginGraceTime 2m|" \
# -e "s|^#MaxAuthTries 6|MaxAuthTries 6|" \
# -e "s|^#MaxSessions 10|MaxSessions 10|" /etc/ssh/sshd_config \
# || exit_with_failure
