#!/bin/bash -e

vagrant_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
echo 'Vagrant directory: '"$vagrant_dir"

source "$vagrant_dir/_exports.sh"

cd "$vagrant_dir"

echo 'Destroying any existing instance...'
vagrant destroy -f || true

echo 'Provisioning the new box...'
vagrant up
echo 'Reloading the new box...'
vagrant reload
