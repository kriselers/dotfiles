# To temporarily bypass an alias, we precede the command with a \
# EG: the ls command is aliased, but to use the normal ls command you would type
# \ls

# Edit the .zshrc file
alias ezrc='nvim $HOME/Projects/dotfiles/dots/.zshrc'

# Clear the .zsh_history file
alias zshclear='echo "" > $HOME/.zsh_history'

# Reload the .zshrc file
alias gg='exec zsh'

# Alias to show the date
alias da='date "+%Y-%m-%d %A %T %Z"'

# Intuitive map command
# For example, to list all directories that contain a certain file:
# find . -name <file> | map dirname
alias map='xargs -n1'

# Aliases to modified commands
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -iv'
alias mkdir='mkdir -p'
alias ps='ps au'
alias less='less -R'
alias cls='clear'
alias vis='vim "+set si"'
alias vim='nvim'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Change directory aliases
alias root='cd /'
alias home='cd ~'
alias dev='cd ~/Projects'
alias cd..='cd ..'

# cd into the old directory
alias bd='cd "$OLDPWD"'

# Use color output and show file type extensions
alias ls='\ls -AlFhog --color=auto'
# Show hidden files
alias la='\ls -alH --color=auto'
# Sort by extension
alias lx='\ls -lXBh --color=auto'
# Sort by size
alias lk='\ls -lSrh --color=auto'
# Sort by change time
alias lc='\ls -lcrh --color=auto'
# Sort by access time
alias lu='\ls -lurh --color=auto'
# Recursive listing
alias lr='\ls -lRh --color=auto'
# Sort by date (recent last)
alias lt='\ls -ltrh --color=auto'
# Wide listing format
alias lw='\ls -xAh --color=auto'
# Long listing format with file sizes
alias ll='\ls -Fls --color=auto'
# Files only
alias lf="\ls -l | egrep -v '^d'"
# Directories only
alias ldir="\ls -l | egrep '^d'"

# Aliased chmod commands
alias mx='chmod a+x'
alias 000='chmod -R 000'
alias 644='chmod -R 644'
alias 666='chmod -R 666'
alias 755='chmod -R 755'
alias 777='chmod -R 777'

# Search command line history
alias h="history | grep "

# Search running processes
alias p="\ps aux | grep "

# Search files in the current folder
alias f="find . | grep "

# Aliases to show space used in a folder
alias folders='du -h -d 1'
alias foldersort='find . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn'

# Git aliases
alias ga='git add'
alias gaa='git add --all'
alias gap='git add --patch'
alias gb='git branch'
alias gc='git commit'
alias gd="git diff --output-indicator-new=' ' --output-indicator-old=' '"
alias gnb='git switch -c'
alias glast='git log -1 HEAD --stat'
alias glog="git log --all --graph --pretty=format:'%C(magenta)%h %C(white) %an %ar%C(auto) %D%n%s%n'"
ginit() { git init "$@"; git add .; git commit -m "Initial commit"; }
alias gm='git merge'
alias gpo='git push origin'
alias gs='git status --short'
alias gcl='git clone'
alias gp='git push'
alias gu='git pull'
alias gpop='git stash pop'

# Python aliases
alias py="python"
alias pi="pip"
alias pipup="python -m pip install --upgrade pip"
alias pipfreeze="pip freeze | grep -v 'pkg-resources==' > requirements.txt"
alias pipls="pip list --not-required --format=columns"
pipwhy() { pip show "$1" | grep -i "required-by"; }
alias pyls="pyenv versions"
alias venvls="pyenv virtualenvs"
alias px="pipx"
alias pxup="pipx upgrade-all"
alias pxls="pipx list"
