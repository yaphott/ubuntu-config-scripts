#!/bin/bash -e

VBOX_VERSION='7.1.4'
tmp_dir="$(mktemp -d)"

echo "~~~ Configuring Oracle VirtualBox ${VBOX_VERSION}"

#### Install Extension Pack

# Download
ext_pack_url="https://download.virtualbox.org/virtualbox/${VBOX_VERSION}/Oracle_VirtualBox_Extension_Pack-${VBOX_VERSION}.vbox-extpack"
ext_pack_file_name="$( echo "$ext_pack_url" | sed -E 's|^.+/([^/]+)$|\1|' )"
curl -fsLS --proto '=https' --tlsv1.2 "$ext_pack_url" -o "${tmp_dir}/${ext_pack_file_name}"

# Verify download
if [[ ! -f "${tmp_dir}/${ext_pack_file_name}" ]]; then
    echo "Missing file ${ext_pack_file_name} from ${ext_pack_url}"
    exit 1
fi

# Install
yes | sudo VBoxManage extpack install --replace "${tmp_dir}/${ext_pack_file_name}"

# Verify installation
if ! sudo VBoxManage list extpacks | grep -q 'Oracle VirtualBox Extension Pack'; then
    echo 'Extension Pack not found.'
    exit 1
fi

# Clean up
sudo VBoxManage extpack cleanup \
    && rm -r "$tmp_dir"

echo 'Oracle VirtualBox configured successfully.'
