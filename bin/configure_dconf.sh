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
#   or
#     gsettings get org.gnome.shell favorite-apps
#   Output:
#     ['org.gnome.Nautilus.desktop', 'snap-store_ubuntu-software.desktop', 'yelp.desktop', 'firefox_firefox.desktop']

#### Dock

# Favorites
gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'google-chrome.desktop', 'firefox_firefox.desktop', 'code.desktop', 'sublime_text.desktop', 'org.gnome.Terminal.desktop', 'gnome-system-monitor.desktop', 'signal-desktop.desktop', 'gparted.desktop', 'synaptic.desktop', 'gnome-control-center.desktop']"
# Fixed (does not auto-hide)
# gsettings set org.gnome.shell.extensions.dash-to-dock.dock-fixed false
# Show on all displays
gsettings set org.gnome.shell.extensions.dash-to-dock multi-monitor true
# Icon size
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 36

#### Dark/light mode

# Icons
#   'Yaru' is light, 'Yaru-dark' is dark
gsettings set org.gnome.desktop.interface icon-theme Yaru-dark
# UI
#   'prefer-light' is light, 'prefer-dark' is dark
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
# Applications
#   'Yaru' is light, 'Yaru-dark' is dark
gsettings set org.gnome.desktop.interface gtk-theme Yaru-dark
# Gedit
#   'Yaru' is light, 'Yaru-dark' is dark
gsettings set org.gnome.gedit.preferences.editor scheme Yaru-dark
# Favorites
gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'google-chrome.desktop', 'firefox_firefox.desktop', 'code.desktop', 'sublime_text.desktop', 'org.gnome.Terminal.desktop', 'gnome-system-monitor.desktop', 'signal-desktop.desktop', 'gparted.desktop', 'synaptic.desktop', 'gnome-control-center.desktop']"
# Fixed (does not auto-hide)
# gsettings set org.gnome.shell.extensions.dash-to-dock.dock-fixed false
# Show on all displays
gsettings set org.gnome.shell.extensions.dash-to-dock multi-monitor true
# Icon size
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 36

#### UI

# List view in file browser
gsettings set org.gnome.nautilus.preferences default-folder-viewer list-view
# Smallest list in file browser
gsettings set org.gnome.nautilus.list-view default-zoom-level small
# Location of new desktop icons
gsettings set org.gnome.shell.extensions.ding start-corner top-left
# Show battery percentage
gsettings set org.gnome.desktop.interface show-battery-percentage true

#### Image View

# Smooth images when zoomed in
gsettings set org.gnome.eog.view extrapolate false

#### Hardware

# Disable middle-click paste
gsettings set org.gnome.desktop.interface gtk-enable-primary-paste false
# Disable tap-to-click
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click false

#### Sleep/Inactivity

# Period (seconds) of inactivity after which the screen will go blank
#   '0' is "Never"
gsettings set org.gnome.desktop.session idle-delay 900
# Suspend after inactivity (on battery)
#   'suspend' is Enabled, 'nothing' is Disabled
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type suspend
# Period (seconds) of inactivity (on battery) before suspending
#   '0' is "Never"
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout 2700
# Suspend after inactivity (plugged-in) before suspending
#   'suspend' is Enabled, 'nothing' is Disabled
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type nothing

#### Gedit

gsettings set org.gnome.gedit.preferences.editor tabs-size 4
# Display right margin column
gsettings set org.gnome.gedit.preferences.editor display-right-margin true
# Set right margin column
gsettings set org.gnome.gedit.preferences.editor right-margin-position 80
# Background pattern
gsettings set org.gnome.gedit.preferences.editor background-pattern grid
# Indent size
gsettings set org.gnome.gedit.preferences.editor tabs-size 4
# Indent using spaces
gsettings set org.gnome.gedit.preferences.editor insert-spaces true
# Use default font
gsettings set org.gnome.gedit.preferences.editor use-default-font false
# Custom font and size
gsettings set org.gnome.gedit.preferences.editor editor-font 'Fira Code 10'

#### Terminal

# # TODO: Parse profile ID of the current user
# NOTE: The last two items are the word 'list' and a newline, so we skip them
# terminal_profile_ids=($( dconf list '/org/gnome/terminal/legacy/profiles:/' ))
# for (( i=0; i<=${#terminal_profile_ids[@]}-2; i++ )); do
#      echo "${terminal_profile_ids[$i]}"
# done
# # Enable using custom font
# gsettings set org.gnome.terminal.legacy.profiles:.:<ID_IS_HERE>.use-system-font false
# # Name of custom font
# gsettings set org.gnome.terminal.legacy.profiles:.:<ID_IS_HERE>.font Fira Code 12
# # Cursor shape
# gsettings set org.gnome.terminal.legacy.profiles:.:<ID_IS_HERE>.cursor-shape ibeam
# # Number of rows
# org.gnome.terminal.legacy.profiles:.:<ID_IS_HERE>.default-size-rows 12
# # Dark theme
# # NOTE: Might want to move to other dark-mode changes
# gsettings set org.gnome.terminal.legacy.theme-variant dark
