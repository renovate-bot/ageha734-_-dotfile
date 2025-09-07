#!/bin/bash

set -eufo pipefail

DIR=$(pwd)

osascript -e 'tell application "System Preferences" to quit'

# Set timezone
sudo systemsetup -settimezone Asia/Tokyo

# System Preferences
defaults import com.apple.systempreferences $DIR/config/systempreferences_settings.plist
killall SystemPreferences

# Desktop Services
defaults import com.apple.desktopservices $DIR/config/desktopservices_settings.plist
killall Dock

# Dock
defaults import com.apple.dock $DIR/config/dock_settings.plist
killall Dock

# Launch Services
defaults import com.apple.LaunchServices $DIR/config/launchservices_settings.plist
killall Dock

# Finder
defaults import com.apple.finder $DIR/config/finder_settings.plist
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
killall Finder

# Keyboard
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write -g ApplePressAndHoldEnabled -bool false

# Mouse & Trackpad
defaults import com.apple.AppleMultitouchTrackpad $DIR/config/trackpad_settings.plist

# Disable chime on boot
sudo nvram StartupMute=%01

# Disable the crash reporter
defaults write com.apple.CrashReporter DialogType none
defaults write -g AppleShowScrollBars -string Always

open -a "Arc" --args --make-default-browser

# Import settings for com.1password.1password
defaults import com.1password.1password $DIR/config/com.1password.1password_settings.plist
killall com.1password.1password

# Import settings for bobko.aerospace
defaults import bobko.aerospace $DIR/config/bobko.aerospace_settings.plist
killall bobko.aerospace

# Import settings for dev.aerolite.Applite
defaults import dev.aerolite.Applite $DIR/config/dev.aerolite.Applite_settings.plist
killall dev.aerolite.Applite

# Import settings for company.thebrowser.Browser
defaults import company.thebrowser.Browser $DIR/config/company.thebrowser.Browser_settings.plist
killall company.thebrowser.Browser

# Import settings for com.globaldelight.Boom3D
defaults import com.globaldelight.Boom3D $DIR/config/com.globaldelight.Boom3D_settings.plist
killall com.globaldelight.Boom3D

# Import settings for pl.maketheweb.cleanshotx
defaults import pl.maketheweb.cleanshotx $DIR/config/pl.maketheweb.cleanshotx_settings.plist
killall pl.maketheweb.cleanshotx

# Import settings for com.hnc.Discord
defaults import com.hnc.Discord $DIR/config/com.hnc.Discord_settings.plist
killall com.hnc.Discord

# Import settings for com.ethanbills.DockDoor
defaults import com.ethanbills.DockDoor $DIR/config/com.ethanbills.DockDoor_settings.plist
killall com.ethanbills.DockDoor

# Import settings for com.docker.docker
defaults import com.docker.docker $DIR/config/com.docker.docker_settings.plist
killall com.docker.docker

# Import settings for com.aviorrok.DynamicLakePro.DynamicLakePro
defaults import com.aviorrok.DynamicLakePro.DynamicLakePro $DIR/config/com.aviorrok.DynamicLakePro.DynamicLakePro_settings.plist
killall com.aviorrok.DynamicLakePro.DynamicLakePro

# Import settings for com.figma.Desktop
defaults import com.figma.Desktop $DIR/config/com.figma.Desktop_settings.plist
killall com.figma.Desktop

# Import settings for com.mitchellh.ghostty
defaults import com.mitchellh.ghostty $DIR/config/com.mitchellh.ghostty_settings.plist
killall com.mitchellh.ghostty

# Import settings for com.google.Chrome
defaults import com.google.Chrome $DIR/config/com.google.Chrome_settings.plist
killall com.google.Chrome

# Import settings for com.google.drivefs
defaults import com.google.drivefs $DIR/config/com.google.drivefs_settings.plist
killall com.google.drivefs

# Import settings for com.superultra.Homerow
defaults import com.superultra.Homerow $DIR/config/com.superultra.Homerow_settings.plist
killall com.superultra.Homerow

# Import settings for org.pqrs.Karabiner-Elements.Settings
defaults import org.pqrs.Karabiner-Elements.Settings $DIR/config/org.pqrs.Karabiner-Elements.Settings_settings.plist
killall org.pqrs.Karabiner-Elements.Settings

# Import settings for org.pqrs.Karabiner-EventViewer
defaults import org.pqrs.Karabiner-EventViewer $DIR/config/org.pqrs.Karabiner-EventViewer_settings.plist
killall org.pqrs.Karabiner-EventViewer

# Import settings for leits.MeetingBar
defaults import leits.MeetingBar $DIR/config/leits.MeetingBar_settings.plist
killall leits.MeetingBar

# Import settings for md.obsidian
defaults import md.obsidian $DIR/config/md.obsidian_settings.plist
killall md.obsidian

# Import settings for com.electron.open-lens
defaults import com.electron.open-lens $DIR/config/com.electron.open-lens_settings.plist
killall com.electron.open-lens

# Import settings for com.postmanlabs.mac
defaults import com.postmanlabs.mac $DIR/config/com.postmanlabs.mac_settings.plist
killall com.postmanlabs.mac

# Import settings for com.raycast.macos
defaults import com.raycast.macos $DIR/config/com.raycast.macos_settings.plist
killall com.raycast.macos

# Import settings for com.apple.Safari
defaults import com.apple.Safari $DIR/config/com.apple.Safari_settings.plist
killall com.apple.Safari

# Import settings for com.apple.SFSymbols
defaults import com.apple.SFSymbols $DIR/config/com.apple.SFSymbols_settings.plist
killall com.apple.SFSymbols

# Import settings for com.tinyspeck.slackmacgap
defaults import com.tinyspeck.slackmacgap $DIR/config/com.tinyspeck.slackmacgap_settings.plist
killall com.tinyspeck.slackmacgap

# Import settings for com.streamlabs.slobs
defaults import com.streamlabs.slobs $DIR/config/com.streamlabs.slobs_settings.plist
killall com.streamlabs.slobs

# Import settings for com.TickTick.task.mac
defaults import com.TickTick.task.mac $DIR/config/com.TickTick.task.mac_settings.plist
killall com.TickTick.task.mac

# Import settings for com.github.th-ch.youtube-music
defaults import com.github.th-ch.youtube-music $DIR/config/com.github.th-ch.youtube-music_settings.plist
killall com.github.th-ch.youtube-music

# Import settings for us.zoom.xos
defaults import us.zoom.xos $DIR/config/us.zoom.xos_settings.plist
killall us.zoom.xos
