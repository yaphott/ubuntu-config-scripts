#!/bin/bash -e

vagrant_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
echo 'Vagrant directory: '"$vagrant_dir"

source "$vagrant_dir/_exports.sh"

box_file_path="/tmp/${VM_WARM_BOX}.box"
echo "Temporary Base VM path: ${box_file_path}"

cd "$vagrant_dir"

echo 'Destroying any existing instance...'
vagrant destroy -f 2>/dev/null
echo 'Removing any existing box...'
vagrant box remove "$VM_WARM_BOX" -f 2>/dev/null || true

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
