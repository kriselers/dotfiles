# Update Brewfile
update_brewfile() {
    brew bundle dump \
        --describe \
        --force \
        --file=$HOME/Projects/dotfiles/homebrew/Brewfile
}

# Get macOS software updates, and update Homebrew and its installed packages
update_system () {
    brew update
    brew upgrade
    brew cu -y --cleanup --include-mas
    softwareupdate -i -a
}

# Update Spicetify and the marketplace
update_spicetify() {
    echo "🎧 Backing up current Spicetify config..."
    spicetify backup > /dev/null

    echo "⬆️  Upgrading Spicetify..."
    spicetify upgrade > /dev/null

    echo "♻️  Restoring backup and applying..."
    spicetify restore backup apply > /dev/null

    echo "🛍 Installing/updating Spicetify Marketplace..."
    curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-marketplace/main/resources/install.sh \
        | sh \
        > /dev/null 2>&1

    echo "🎨 Reapplying theme with Marketplace..."
    spicetify apply

    echo "🧹 Cleaning up leftover markdown files..."
    rm -f "$HOME/.config/spicetify/CustomApps/marketplace/"*.md 2>/dev/null

    echo "✅ Spicetify updated and Marketplace refreshed!"
}

# Echo PATH and split with newlines
path ()
{
    echo $PATH | tr ':' '\n'
}

# Creates a tar file of a provided directory and optionally places in a specific
# location
tarit ()
{
    if [ $# -lt 1 ]; then
        echo "Usage: tarit <directory> [output_directory]"
        return 1
    fi

    if [ $# -lt 2 ]; then
        output_dir="."
    else
        output_dir="${2}"
        shift 2
    fi

    if [ ! -d "$1" ]; then
        echo "Directory does not exist: $1"
        return 1
    fi

    local timestamp=$(date "+%Y-%m-%d_%H%M")
    local dirname=$(basename "$1")
    local dir_to_tar="$1"
    # Shift to handle any additional options to tar
    shift

    tar -czvf "${output_dir}/${dirname}_${timestamp}.tgz" "$dir_to_tar" "$@"
}

# Searches for text in all files in the current folder
ftext ()
{
    # -i case-insensitive
    # -I ignore binary files
    # -H causes filename to be printed
    # -r recursive search
    # -n causes line number to be printed
    # optional: -F treat search term as a literal, not a regular expression
    # optional: -l only print filenames and not the matching lines
    #           ex. grep -irl "$1" *
    grep -iIHrn --color=always "$1" . | less -r
}

# Copy and go to the directory
cpg ()
{
    local src="$1"
    local dest="$2"

    if [ -d "$dest" ]; then
        cp "$src" "$dest" && cd "$dest"
    else
        cp "$src" "$dest"
    fi
}

# Move and go to the directory
mvg ()
{
    local src="$1"
    local dest="$2"

    if [ -d "$dest" ]; then
        mv "$src" "$dest" && cd "$dest"
    else
        mv "$src" "$dest"
    fi
}

# Goes up a specified number of directories (i.e., up 4)
up ()
{
    local d=""
    limit=$1
    for ((i=1 ; i <= limit ; i++))
        do
            d=$d/..
        done
    d=$(echo $d | sed 's/^\///')
    if [ -z "$d" ]; then
        d=..
    fi
    cd $d
}

# Returns the last 2 fields of the working directory
pwdtail ()
{
    pwd | awk -F/ '{nlast = NF -1;print $nlast"/"$NF}'
}

mkvenv() {
  if [ -z "$1" ]; then
    echo "Usage: mkvenv <env-name> [python-version] [--lock] [--devtools] [--requirements=<file>]"
    return 1
  fi

  local ENV_NAME="$1"
  shift

  local PY_VERSION=""
  local LOCK_ENV=false
  local INSTALL_DEVTOOLS=false
  local REQUIREMENTS_FILE=""

  for arg in "$@"; do
    case $arg in
      --lock)
        LOCK_ENV=true
        ;;
      --devtools)
        INSTALL_DEVTOOLS=true
        ;;
      --requirements=*)
        REQUIREMENTS_FILE="${arg#*=}"
        ;;
      *)
        # Assume any non-flag arg is a Python version
        PY_VERSION="$arg"
        ;;
    esac
  done

  PY_VERSION="${PY_VERSION:-$(pyenv global | head -n 1)}"

  echo "🚀 Creating virtualenv '$ENV_NAME' with Python $PY_VERSION..."
  pyenv virtualenv "$PY_VERSION" "$ENV_NAME"

  echo "🔁 Activating '$ENV_NAME'..."
  pyenv activate "$ENV_NAME"

  echo "📦 Upgrading pip and wheel..."
  pip install --upgrade pip wheel

  if [ "$INSTALL_DEVTOOLS" = true ]; then
    echo "🧰 Installing dev tools..."
    pip install ipython rich pytest pdbpp coverage tqdm
  fi

  if [ -n "$REQUIREMENTS_FILE" ]; then
    if [ -f "$REQUIREMENTS_FILE" ]; then
      echo "📄 Installing from $REQUIREMENTS_FILE..."
      pip install -r "$REQUIREMENTS_FILE"
    else
      echo "❌ Requirements file '$REQUIREMENTS_FILE' not found."
    fi
  fi

  if [ "$LOCK_ENV" = true ]; then
    echo "🔒 Writing .python-version..."
    echo "$ENV_NAME" > .python-version
  fi

  echo "✅ Virtualenv '$ENV_NAME' is ready to go!"
}
