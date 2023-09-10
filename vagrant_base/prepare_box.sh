VAGRANT_BOX_NAME="ubuntu_config_scripts_base"

# Remove old box
vagrant destroy -f
rm -f "$VAGRANT_BOX_NAME.box"

# Create new box
vagrant up
vagrant halt
vagrant package --output "$VAGRANT_BOX_NAME.box"

# Add new box
vagrant box remove "$VAGRANT_BOX_NAME" --force
vagrant box add "$VAGRANT_BOX_NAME" "$VAGRANT_BOX_NAME.box"

# Clean up
vagrant destroy -f
rm -f "$VAGRANT_BOX_NAME.box"
