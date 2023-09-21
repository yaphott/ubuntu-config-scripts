#!/bin/bash -e

function exit_with_failure () { echo 'Failed to configure Dconf.'; exit 1; }
[[ $INSIDE_SCRIPT ]] || (echo 'Please run with the installer script.'; exit_with_failure)

echo '~~~ Configuring Dconf'

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
gsettings set  org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'google-chrome.desktop', 'firefox_firefox.desktop', 'code.desktop', 'sublime_text.desktop', 'org.gnome.Terminal.desktop', 'gnome-system-monitor.desktop', 'signal-desktop.desktop', 'gparted.desktop', 'synaptic.desktop', 'gnome-control-center.desktop']" \
    || exit_with_failure
# Fixed (does not auto-hide)
# gsettings set  org.gnome.shell.extensions.dash-to-dock.dock-fixed false \
#     || exit_with_failure
# Show on all displays
gsettings set  org.gnome.shell.extensions.dash-to-dock multi-monitor true \
    || exit_with_failure
# Icon size
gsettings set  org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 36 \
    || exit_with_failure

#### Dark/light mode

# Icons
#   'Yaru' is light, 'Yaru-dark' is dark
gsettings set  org.gnome.desktop.interface icon-theme Yaru-dark \
    || exit_with_failure
# UI
#   'prefer-light' is light, 'prefer-dark' is dark
gsettings set  org.gnome.desktop.interface color-scheme prefer-dark \
    || exit_with_failure
# Applications
#   'Yaru' is light, 'Yaru-dark' is dark
gsettings set  org.gnome.desktop.interface gtk-theme Yaru-dark \
    || exit_with_failure
# Gedit
#   'Yaru' is light, 'Yaru-dark' is dark
gsettings set  org.gnome.gedit.preferences.editor scheme Yaru-dark \
    || exit_with_failure

#### UI

# List view in file browser
gsettings set  org.gnome.nautilus.preferences default-folder-viewer list-view \
    || exit_with_failure
# Smallest list in file browser
gsettings set  org.gnome.nautilus.list-view default-zoom-level small \
    || exit_with_failure
# Location of new desktop icons
gsettings set  org.gnome.shell.extensions.ding start-corner top-left \
    || exit_with_failure
# Show battery percentage
gsettings set  org.gnome.desktop.interface show-battery-percentage true \
    || exit_with_failure

#### Image View

# Smooth images when zoomed in
gsettings set  org.gnome.eog.view extrapolate false \
    || exit_with_failure

#### Hardware

# Disable middle-click paste
gsettings set  org.gnome.desktop.interface gtk-enable-primary-paste false \
    || exit_with_failure
# Disable tap-to-click
gsettings set  org.gnome.desktop.peripherals.touchpad tap-to-click false \
    || exit_with_failure

#### Sleep/Inactivity

# Period (seconds) of inactivity after which the screen will go blank
#   '0' is "Never"
gsettings set  org.gnome.desktop.session idle-delay 900 \
    || exit_with_failure
# Suspend after inactivity (on battery)
#   'suspend' is Enabled, 'nothing' is Disabled
gsettings set  org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type suspend \
    || exit_with_failure
# Period (seconds) of inactivity (on battery) before suspending
#   '0' is "Never"
gsettings set  org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout 2700 \
    || exit_with_failure
# Suspend after inactivity (plugged-in) before suspending
#   'suspend' is Enabled, 'nothing' is Disabled
gsettings set  org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type nothing \
    || exit_with_failure

#### Gedit

gsettings set  org.gnome.gedit.preferences.editor tabs-size 4 \
    || exit_with_failure
# Display right margin column
gsettings set  org.gnome.gedit.preferences.editor display-right-margin true \
    || exit_with_failure
# Set right margin column
gsettings set  org.gnome.gedit.preferences.editor right-margin-position 80 \
    || exit_with_failure
# Background pattern
gsettings set  org.gnome.gedit.preferences.editor background-pattern grid \
    || exit_with_failure
# Indent size
gsettings set  org.gnome.gedit.preferences.editor tabs-size 4 \
    || exit_with_failure
# Indent using spaces
gsettings set  org.gnome.gedit.preferences.editor insert-spaces true \
    || exit_with_failure
# Use default font
gsettings set  org.gnome.gedit.preferences.editor use-default-font false \
    || exit_with_failure
# Custom font and size
gsettings set  org.gnome.gedit.preferences.editor editor-font 'Fira Code 10' \
    || exit_with_failure

#### Terminal

# TODO: Parse profile ID of the current user
# NOTE: The last two items are the word 'list' and a newline, so we skip them
# terminal_profile_ids=($( dconf list '/org/gnome/terminal/legacy/profiles:/' ))
# for (( i=0; i<=${#terminal_profile_ids[@]}-2; i++ )); do
#      echo "${terminal_profile_ids[$i]}"
# done
# Enable using custom font
# gsettings set  org.gnome.terminal.legacy.profiles:.:<ID_IS_HERE>.use-system-font false \
#     || exit_with_failure
# Name of custom font
# gsettings set  org.gnome.terminal.legacy.profiles:.:<ID_IS_HERE>.font Fira Code 12 \
#     || exit_with_failure
# Cursor shape
# gsettings set  org.gnome.terminal.legacy.profiles:.:<ID_IS_HERE>.cursor-shape ibeam \
#     || exit_with_failure
# # Number of rows
# org.gnome.terminal.legacy.profiles:.:<ID_IS_HERE>.default-size-rows 12
# Dark theme
# NOTE: Might want to move to other dark-mode changes
# gsettings set  org.gnome.terminal.legacy.theme-variant dark \
#     || exit_with_failure

echo 'Dconf configured successfully.'
