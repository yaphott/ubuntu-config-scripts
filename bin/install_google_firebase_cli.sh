
#!/bin/bash -e

function exit_with_failure () { echo 'Failed to install Google Firebase CLI.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

# Install Google Firebase CLI
echo '+++ Google Firebase CLI'

# Run install script
curl -sL https://firebase.tools | bash \
   || exit_with_failure
