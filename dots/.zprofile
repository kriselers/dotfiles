# Set PATH, MANPATH, etc., for Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"

# Source global definitions
if [ -f $HOME/.zshrc ]; then
    . $HOME/.zshrc
fi
