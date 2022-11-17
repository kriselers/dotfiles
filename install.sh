#!/bin/zsh
##############################
# This script creates symlinks from the home directory to any desired dotfiles
# in ${homedir}/dotfiles. It also installs Homebrew packages.
##############################

if [ "$#" -ne 1 ]; then
    echo "Please specify the home directory of your machine!"
    echo "Usage: ./install.sh <home_directory>"
    exit 1
fi

homedir=$1

# dotfiles directory
dotfilesdir=${homedir}/dotfiles

# list of files/folders to symlink in ${homedir}
files="zprofile zshrc aliases p10k.zsh"

# change to the dotfiles directory
echo "Changing to the ${dotfilesdir} directory"
cd ${dotfilesdir}
echo "...done"

# create symlinks (will overwrite existing dotfiles)
for file in ${files}; do
    echo "Creating symlink to $file in home directory."
    ln -sf ${dotfilesdir}/.${file} ${homedir}/.${file}
done
echo "...done"

# Run the Homebrew script
echo "Running Homebrew script..."
./brew.sh
echo "...done"

echo "Mac setup complete! 🤙🏼"
