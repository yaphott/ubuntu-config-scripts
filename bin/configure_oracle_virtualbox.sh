#!/usr/bin/env bash -e

function exit_with_failure () { echo 'Failed to configure Oracle VirtualBox.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

# Configure Oracle VirtualBox
echo '~~~ Configuring Oracle VirtualBox'

#### Install Extension Pack

# Fetch the latest release
# TODO: Validate response code/content in response
ext_page_source="$( curl -S https://www.virtualbox.org/wiki/Downloads )"
ext_pack_url="$( echo $ext_page_source | sed -E 's|.+href="(https:\/\/download\.virtualbox\.org\/virtualbox/[0-9\.]+/Oracle_VM_VirtualBox_Extension_Pack-[0-9\.]+\.vbox-extpack).+|\1|' )"
ext_pack_filename="$( echo $ext_pack_url | sed -E 's|^.+/([^/]+)$|\1|' )"
wget "$ext_pack_url" -O './tmp/'"$ext_pack_filename" \
    || exit_with_failure

# Verify download
if [[ ! -f './tmp/'"$ext_pack_filename" ]]; then
    echo 'Failed to download '"$ext_pack_filename"' from '"$ext_pack_url"'.'
    exit 1
fi

# Install
echo 'y' | sudo VBoxManage extpack install --replace './tmp/'"$ext_pack_filename"

# Clean up
( sudo VBoxManage extpack cleanup \
    && rm './tmp/'"$ext_pack_filename"
) || exit_with_failure
