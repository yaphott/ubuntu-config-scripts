#!/bin/bash -e

export VM_COLD_BOX='ubuntu/jammy64'
export VM_WARM_BOX='ucs-base'
export VM_USERNAME='vagrant'

vagrant_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
echo 'Vagrant directory: '"$vagrant_dir"
box_file_path="/tmp/${VM_WARM_BOX}.box"
echo "Temporary Base VM path: ${box_file_path}"

cd "$vagrant_dir"

echo 'Halting any running instance...'
vagrant halt || true
echo 'Destroying any existing instance...'
vagrant destroy -f || true
echo 'Removing any existing box...'
vagrant box remove "$VM_WARM_BOX" -f || true

echo 'Provisioning the new box...'
vagrant up
echo 'Stopping the new box...'
vagrant halt
echo "Packaging the new box to ${box_file_path}..."
vagrant package --output "$box_file_path"
echo "Adding box ${VM_WARM_BOX} to Vagrant..."
vagrant box add "$VM_WARM_BOX" "$box_file_path"
echo 'Destroying the new box...'
vagrant destroy -f
echo 'Removing the temporary box...'
rm -f "$box_file_path"
