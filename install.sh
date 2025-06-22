#!/bin/bash

##############################
# This script creates symlinks from the home directory to the dotfiles in dots/
# in ${home_dir}.
# Installs Homebrew packages and casks.
# Configures iTerm2.
# Configures Sublime Text.
# Installs Vim Vundle and plugins.
#
# WARNING: This script will overwrite existing dotfiles in your home directory.
##############################

create_symlink() {
    local src="$1"
    local dest="$2"

    # Remove existing file or symlink
    if [[ -e "$dest" || -L "$dest" ]]; then
        rm -f "$dest"
    fi

    # Ensure parent directory exists
    mkdir -p "$(dirname "$dest")"

    # Create symlink
    ln -s "$src" "$dest"
}

echo "Starting Mac setup script..." && echo

if [ "$#" -ne 1 ]; then
    echo "Please specify the home directory of your machine!"
    echo "\tUsage: ./install.sh <home_directory>"
    echo
    exit 1
fi

home_dir=$1
dotfiles_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Creating symlinks for dotfiles..." && echo
find "$dotfiles_dir/dots" -type f ! -name ".DS_Store" | while read -r file; do
    # Get relative path of file
    relative_path="${file#$dotfiles_dir/dots/}"
    target_item="${home_dir}/${relative_path}"

    create_symlink "$file" "$target_item"
done

echo "Running Homebrew script..." && echo
cd homebrew && ./brew.sh && cd -

echo "Configuring iTerm2..."
echo "Downloading Shell Integration..."
curl -L https://iterm2.com/shell_integration/zsh \
    -o ~/.iterm2_shell_integration.zsh
echo "Moving iTerm2 settings file to ~/Library/Preferences/..."
cp -r iterm2/com.googlecode.iterm2.plist ~/Library/Preferences/
echo "Telling iTerm2 to use the custom preferences in the directory..."
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
echo "Telling iTerm2 to use dotfiles directory as preferences location..." && echo
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "${dotfiles_dir}/iterm2/"

echo "Configuring Sublime Text..." && echo
cd sublime && ./sublime.sh && cd -

echo "Installing Vim Vundle..."
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

echo "Installing Vim Vundle plugins..." && echo && echo
vim +PluginInstall +qall

echo "Mac setup complete! 🤙🏼"
