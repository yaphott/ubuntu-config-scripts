#!/bin/bash -e

export VM_WARM_BOX='ucs-base'
export VM_USERNAME='vagrant'

VAGRANT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
echo 'Vagrant directory: '"$VAGRANT_DIR"

cd "$VAGRANT_DIR"

echo 'Halting any running instance...'
vagrant halt || true
echo 'Destroying any existing instance...'
vagrant destroy -f || true

echo 'Provisioning the new box...'
vagrant up
echo 'Reloading the new box...'
vagrant reload
