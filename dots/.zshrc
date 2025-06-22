export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
if which pyenv-virtualenv-init > /dev/null; then
  eval "$(pyenv virtualenv-init -)"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_CUSTOM="$HOME/.config/oh-my-zsh"

# Set the auto-update behavior
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 7
# Apply iTerm2 Shell Integration
zstyle :omz:plugins:iterm2 shell-integration yes

# Load plugins
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  brew
  copypath
  git-commit
  iterm2
  macos
  poetry
  web-search
)

# Use hyphen-insensitive completion. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"
# Disable command auto-correction.
ENABLE_CORRECTION="false"
# Disable marking untracked files under VSC as dirty.
DISABLE_UNTRACKED_FILES_DIRTY="true"
# Show timestamps for each command in history outpt.
HIST_STAMPS="yyyy-mm-dd"

# Load the Pure pompt
autoload -U promptinit; promptinit
prompt pure

source $ZSH/oh-my-zsh.sh
source $ZSH_CUSTOM/aliases.zsh
source $ZSH_CUSTOM/exports.zsh
source $ZSH_CUSTOM/functions.zsh
if [ -r "$ZSH_CUSTOM/extra.zsh" ] && [ -f "$ZSH_CUSTOM/extra.zsh" ]; then
  source $ZSH_CUSTOM/extra.zsh
fi
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
