if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/zen.toml)"
fi

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
if which pyenv-virtualenv-init > /dev/null; then
  eval "$(pyenv virtualenv-init -)"
fi

# Path to oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Use another custom folder than $ZSH/custom
ZSH_CUSTOM="$HOME/.config/oh-my-zsh/custom"

# Created by `pipx` on 2025-06-12 04:45:20
export PATH="$PATH:/Users/kriselers/.local/bin"

# Set name of the theme to load.
# I'd like to convert my theme to a Zsh theme and get away from oh-my-posh, but
# I'm not sure how to do that yet.
# ZSH_THEME="zen"

# Don't use case-sensitive completion.
# CASE_SENSITIVE="true"

# Use hyphen-insensitive completion. _ and - will be interchangeable.
# Case-sensitive completion must be off.
HYPHEN_INSENSITIVE="true"

# Set the auto-update behavior
# Options are disabled, auto, and reminder
zstyle ':omz:update' mode auto

# Set how often to auto-update (in days).
zstyle ':omz:update' frequency 7

# Apply iTerm2 Shell Integration
zstyle :omz:plugins:iterm2 shell-integration yes

# Enable command auto-correction.
ENABLE_CORRECTION="false"

# Disable marking untracked files under VSC as dirty.
# This makes repository status checks for large repositories much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Load plugins
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  # alias-finder
  brew
  copypath
  iterm2
  macos
  web-search
)

zstyle ':omz:plugins:alias-finder' autoload yes
zstyle ':omz:plugins:alias-finder' longer yes
zstyle ':omz:plugins:alias-finder' exact yes
zstyle ':omz:plugins:alias-finder' cheaper yes

# Source a bunch of files
source $ZSH/oh-my-zsh.sh
for file in ~/.config/zsh/.{aliases,exports,functions,extra}; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
