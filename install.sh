#!/bin/zsh

##############################
# This script creates symlinks from the home directory to any desired dotfiles
# in ${homedir}/.dotfiles.
# Installs Homebrew packages and casks.
# Configures iTerm2.
# Installs colorls
# Configures Sublime Text.
##############################

echo "Starting Mac setup script...\n"

if [ "$#" -ne 1 ]; then
    echo "Please specify the home directory of your machine!"
    echo "\tUsage: ./install.sh <home_directory>\n"
    exit 1
fi

homedir=$1

# dotfiles directory
dotfilesdir=${homedir}/.dotfiles/dots

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
cd /homebrew && sh ./brew.sh && cd ${dotfilesdir}

# Configure iTerm2
echo "Configuring iTerm2..."
echo "Downloading Shell Integration..."
curl -L https://iterm2.com/shell_integration/zsh \
-o ~/.iterm2_shell_integration.zsh

echo "Moving iTerm2 settings .plist to ~/Library/Preferences/..."
cp -r iterm2/com.googlecode.iterm2.plist ~/Library/Preferences/

echo "Telling iTerm2 to use the custom preferences in the directory..."
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true

echo "Specifying the preferences directory..."
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "~/Projects/dotfiles/iterm2/"

# Install lscolors
rbenv install 3.3.5
rbenv global 3.3.5
rbenv rehash
rehash
gem install colorls

# Configure Sublime Text
echo "\nConfiguring Sublime Text..."
cd sublime && sh ./sublime.sh && cd ${dotfilesdir}

# Install Vim plugins
echo "\nInstalling Vim Vundle..."
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

echo "\nInstalling Vim Vundle plugins..."
vim +PluginInstall +qall

echo "\n\nMac setup complete! 🤙🏼"
echo "Don't forget to install Python versions using pyenv.\n"
echo "i.e.:"
echo "\tpyenv install 3.1x"
echo "\tpyenv global 3.1x.x"
