!#!/bin/zsh
##############################
# This script will install all the Homebrew packages from Brewfile
##############################

# Make sure we're using the latest Homebrew
brew update

# Upgrading any already-installed formulae
brew upgrade

# Installs Brew Bundle to access Brewfile
brew bundle

# Install everything from /homebrew/Brewfile
brew bundle --file=~/.dotfiles/homebrew/Brewfile
