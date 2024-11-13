if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  # eval "$(oh-my-posh init zsh --config https://raw.githubusercontent.com/dreamsofautonomy/zen-omp/main/zen.toml)"
  eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/zen.toml)"
fi

# pyenv related things
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
if which pyenv-virtualenv-init > /dev/null; then
  eval "$(pyenv virtualenv-init -)"
fi

# rbenv related things
eval "$(rbenv init -)"

# Path to oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

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
ENABLE_CORRECTION="true"

# Disable marking untracked files under VSC as dirty.
# This makes repository status checks for large repositories much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Use another custom folder than $ZSH/custom
# ZSH_CUSTOM=/path/to/new-custom-folder

# Load plugins
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Add wisely, as too many plugins slow down shell startup.
plugins=(copypath macos iterm2 web-search)

# Source a bunch of files
for file in ~/.config/oh-my-zsh/.{aliases,exports,functions,extra}; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(dirname $(gem which colorls))/tab_complete.sh
