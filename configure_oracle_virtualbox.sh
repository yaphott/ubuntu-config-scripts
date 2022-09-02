#!/bin/bash -xe

# Configure Oracle VirtualBox

#### Install Extension Pack
# Fetch the latest release
ext_page_source="$( curl -S https://www.virtualbox.org/wiki/Downloads )"
ext_pack_url="$( echo $ext_page_source | sed -E 's|.+href="(https:\/\/download\.virtualbox\.org\/virtualbox/[0-9\.]+/Oracle_VM_VirtualBox_Extension_Pack-[0-9\.]+\.vbox-extpack).+|\1|' )"
ext_pack_filename="$( echo $ext_pack_url | sed -E 's|^.+/([^/]+)$|\1|' )"
wget "$ext_pack_url"

# Install
echo 'y' | sudo VBoxManage extpack install --replace "$ext_pack_filename"

# Clean up
sudo VBoxManage extpack cleanup
rm -f "$ext_pack_filename"
