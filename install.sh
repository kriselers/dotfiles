#!/bin/zsh
##############################
# This script creates symlinks from the home directory to any desired dotfiles
# in ${homedir}/.dotfiles. 
# Installs Homebrew packages.
# Configures iTerm2.
# Configures Sublime Text.
##############################

echo "Starting Mac setup script...\n"

if [ "$#" -ne 1 ]; then
    echo "Please specify the home directory of your machine!"
    echo "Usage: ./install.sh <home_directory>\n"
    exit 1
fi

homedir=$1

# dotfiles directory
dotfilesdir=${homedir}/.dotfiles

# list of files/folders to symlink in ${homedir}
files="zprofile zshrc aliases p10k.zsh"

# change to the dotfiles directory
echo "Changing to the ${dotfilesdir} directory..."
cd ${dotfilesdir}

# create symlinks (will overwrite existing dotfiles)
for file in ${files}; do
    echo "Creating symlink to $file in home directory."
    ln -sf ${dotfilesdir}/.${file} ${homedir}/.${file}
done

# Run the Homebrew script
echo "\nRunning Homebrew script..."
./homebrew/brew.sh
echo "Done!\n"

echo "Moving iTerm2 settings .plist to ~/Library/Preferences/"
# Configure iTerm2 settings
cp settings/iterm2/com.googlecode.iterm2.plist ~/Library/Preferences/
echo "Done!\n"

echo "Mac setup complete! 🤙🏼"
