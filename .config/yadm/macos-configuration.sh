#!/usr/bin/env bash

echo "Configuring MacOS..."
# https://mths.be/macos
# https://github.com/mathiasbynens/dotfiles/blob/main/.macos
# https://robservatory.com/speed-up-your-mac-via-hidden-prefs/

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Set fast key repeat rate
defaults write NSGlobalDomain KeyRepeat -int 2

# Allow fast user switching (icon style, in the menu bar)
defaults write NSGlobalDomain userMenuExtraStyle -int 2

# Show the Develop menu in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true

# Enable scroll gesture (with modifier) to zoom
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true

# Allow tap to click for Apple trackpad devices
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool false

# Set hiding effect to scale
defaults write com.apple.Dock mineffect scale

# Set time to show date and day of the week
defaults write com.apple.menuextra.clock "DateFormat" "EEE MMM d  h:mm"

# Disable automatic capitalization as it’s annoying when typing code
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable smart dashes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable automatic period substitution as it’s annoying when typing code
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable smart quotes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

## Finder

# Finder: disable window animations and Get Info animations
defaults write com.apple.finder DisableAllAnimations -bool true

# New Finder windows points to home
defaults write com.apple.finder NewWindowTarget -string "PfHm"

# Use previous scope as default search scope in Finder
defaults write com.apple.finder FXDefaultSearchScope -string "SCsp"

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Show the ~/Library folder
chflags nohidden ~/Library && xattr -d com.apple.FinderInfo ~/Library

## Dock, Dashboard

# Increase window resize speed for Cocoa applications
defaults write NSGlobalDomain NSWindowResizeTime -float 0.01

# Don’t animate opening applications from the Dock
defaults write com.apple.dock launchanim -bool false

# Speed up Mission Control animations
defaults write com.apple.dock expose-animation-duration -float 0.1

# Don’t group windows by application in Mission Control
# (i.e. use the old Exposé behavior instead)
defaults write com.apple.dock expose-group-by-app -bool false

# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Remove the auto-hiding Dock delay
defaults write com.apple.dock autohide-delay -float 0.2

# Remove the animation when hiding/showing the Dock
defaults write com.apple.dock autohide-time-modifier -float 0.1

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true
