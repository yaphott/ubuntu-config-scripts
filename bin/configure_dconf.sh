#!/bin/bash -xe

if [[ ! $INSIDE_SCRIPT ]]; then
    echo 'Please run with the installer script. Exiting ...'
    exit
fi

# Configure dconf
echo '~~~ Configuring dconf'

# https://www.freedesktop.org/software/gstreamer-sdk/data/docs/2012.5/glib/gvariant-text.html
# 
# To monitor changes in dconf, run command:
#   dconf watch /
# 
# GVariant is the encoding that dconf will expect.
# Example of fetching original values:
#   Command:
#     dconf read /org/gnome/shell/favorite-apps
#   Output:
#     ['org.gnome.Nautilus.desktop', 'snap-store_ubuntu-software.desktop', 'yelp.desktop', 'firefox_firefox.desktop']

# Parse IDs of profiles
# NOTE: The last two items are the word 'list' and a newline, so we skip them
# terminal_profile_ids=($( dconf list '/org/gnome/terminal/legacy/profiles:/' ))
# for (( i=0; i<=${#terminal_profile_ids[@]}-2; i++ )); do
#      echo "${terminal_profile_ids[$i]}"
# done

#### Dock

# Favorites
dconf write /org/gnome/shell/favorite-apps "['org.gnome.Nautilus.desktop', 'google-chrome.desktop', 'firefox_firefox.desktop', 'code.desktop', 'sublime_text.desktop', 'org.gnome.Terminal.desktop', 'gnome-system-monitor.desktop', 'signal-desktop.desktop', 'gparted.desktop', 'synaptic.desktop', 'gnome-control-center.desktop']"
# Fixed (does not auto-hide)
# dconf write /org/gnome/shell/extensions/dash-to-dock/dock-fixed 'false'
# Show on all displays
dconf write /org/gnome/shell/extensions/dash-to-dock/multi-monitor 'true'
# Icon size
dconf write /org/gnome/shell/extensions/dash-to-dock/dash-max-icon-size '36'

#### Color Scheme

# Dark/light mode
#   'prefer-light' is light, 'prefer-dark' is dark
dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
#   'Yaru' is light, 'Yaru-dark' is dark
dconf write /org/gnome/desktop/interface/gtk-theme "'Yaru-dark'"
# Gedit
#   'Yaru' is light, 'Yaru-dark' is dark
dconf write /org/gnome/gedit/preferences/editor/scheme "'Yaru-dark'"

#### UI

# List view in file browser
dconf write /org/gnome/nautilus/preferences/default-folder-viewer "'list-view'"
# Smallest list in file browser
dconf write /org/gnome/nautilus/list-view/default-zoom-level "'small'"
# Location of new desktop icons
dconf write /org/gnome/shell/extensions/ding/start-corner "'top-left'"
# Show battery percentage
dconf write /org/gnome/desktop/interface/show-battery-percentage 'true'

#### Hardware

# Disable tap-to-click
dconf write /org/gnome/desktop/peripherals/touchpad/tap-to-click 'false'

#### Sleep/Inactivity

# Period (seconds) of inactivity after which the screen will go blank
#   '0' is "Never"
dconf write /org/gnome/desktop/session/idle-delay '900'
# Suspend after inactivity (on battery)
#   'suspend' is Enabled, 'nothing' is Disabled
dconf write /org/gnome/settings-daemon/plugins/power/sleep-inactive-battery-type "'suspend'"

# Period (seconds) of inactivity (on battery) before suspending
#   '0' is "Never"
dconf write /org/gnome/settings-daemon/plugins/power/sleep-inactive-battery-timeout '2700'
# Suspend after inactivity (plugged-in) before suspending
#   'suspend' is Enabled, 'nothing' is Disabled
dconf write /org/gnome/settings-daemon/plugins/power/sleep-inactive-ac-type "'nothing'"

#### Gedit

gsettings set 'org.gnome.gedit.preferences.editor' 'tabs-size' '4'
# Display right margin column
gsettings set 'org.gnome.gedit.preferences.editor' 'display-right-margin' 'true'
# Set right margin column
gsettings set 'org.gnome.gedit.preferences.editor' 'right-margin-position' '80'
# Background pattern
gsettings set 'org.gnome.gedit.preferences.editor' 'background-pattern' "'grid'"
# Indent size
gsettings set 'org.gnome.gedit.preferences.editor' 'tabs-size' '4'
# Indent using spaces
gsettings set 'org.gnome.gedit.preferences.editor' 'insert-spaces' 'true'
# Use default font
gsettings set 'org.gnome.gedit.preferences.editor' 'use-default-font' 'false'
# Custom font and size
gsettings set 'org.gnome.gedit.preferences.editor' 'editor-font' "'Fira Code 10'"

#### Terminal

# # TODO: Need to parse profile ID
# # Enable using custom font
# dconf write /org/gnome/terminal/legacy/profiles:/:<ID_IS_HERE>/use-system-font 'false'
# # Name of custom font
# dconf write /org/gnome/terminal/legacy/profiles:/:<ID_IS_HERE>/font "'Fira Code 12'"
# # Cursor shape
# dconf write /org/gnome/terminal/legacy/profiles:/:<ID_IS_HERE>/cursor-shape 'ibeam'
# # Number of rows
# /org/gnome/terminal/legacy/profiles:/:<ID_IS_HERE>/default-size-rows '12'
# # Dark theme
# # NOTE: Might want to move to other dark-mode changes
# dconf write /org/gnome/terminal/legacy/theme-variant 'dark'
