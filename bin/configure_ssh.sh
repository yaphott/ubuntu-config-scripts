#!/bin/bash -e

function exit_with_failure () { echo 'Failed to configure SSH.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

# NOTE: THIS IS INCOMPLETE
echo '~~~ Configuring SSH'

#### Add github to known hosts - Needs sudo?

ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts \
    || exit_with_failure

#### Limit outside access and change port

sudo sed -e "s|^# *PermitRootLogin +.+$|PermitRootLogin no|" \
         -e "s|^# *PasswordAuthentication +.+$|PasswordAuthentication no|" \
         -e "s|^# *PermitEmptyPasswords +.+$|PermitEmptyPasswords no|" \
         -e "s|^# *Port +[0-9]+$|Port 2222|" \
         -e "s|^# *LoginGraceTime +.+$|LoginGraceTime 2m|" \
         -e "s|^# *MaxAuthTries +[0-9]+$|MaxAuthTries 6|" \
         -e "s|^# *MaxSessions +[0-9]+$|MaxSessions 10|" \
         -i /etc/ssh/sshd_config \
    || exit_with_failure

#### Restart SSH

sudo systemctl restart sshd \
    || exit_with_failure

echo 'SSH configured successfully.'
