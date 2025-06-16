# .dotfiles

These are my dotfiles. This repository contains a random collection of things to
help me feel comfortable working in the terminal. Take anything you want but at
your own risk. This mainly targets macOS systems.

I'll be the first to admit that this wasn't created by me from scratch. Most of
it is "leveraged" from the Internet, and I've customized it to fit my
development workflow.

## Installation

**Warning: If you want to give these dotfiles a try, you should first fork/clone
this repository, review the code, and remove things you don't want or need.
Don't blindly use my settings unless you know what that entails. Use at your own
risk!**

1. Run these three commands first, assuming you're starting on a sparkling fresh
   installation of macOS:

   ```bash
   sudo softwareupdate -i -a
   xcode-select --install
   sudo xcodebuild -license accept
   ```

   The Xcode Command Line Tools include `git` and `make` (not available on stock
   MacOS).

2. Sign-in to the Mac AppStore and iCloud (and wait until synced)

3. Install [Homebrew](https://brew.sh/). Generally:

   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

4. Clone this repository into the desired location (I like to keep it in
   `~/Projects/dotfiles`):

   ```bash
   git clone https://github.com/kriselers/dotfiles.git ~/Projects/dotfiles
   ```

5. `cd` to the `dotfiles` directory and run `install.sh` supplying your home
   directory:

   ```bash
   cd ~/Projects/dotfiles
   ./install.sh <home_directory>
   ```

## Add custom commands without creating a new fork

If `~/.config/zsh/.extra` exists, it will be sourced along with the other files.
You can use this to add a few custom commands without the need to fork this
entire repository, or to add commands you don't want to commit to a public
repository.

My `.extra` looks something like this:

```bash
# Git credentials
# Not in the repository, to prevent people from accidentally committing under my
# name
GIT_AUTHOR_NAME="Kristopher Elers"
GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
git config --global user.name "$GIT_AUTHOR_NAME"
GIT_AUTHOR_EMAIL="kristopherelers@gmail.com"
GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
git config --global user.email "$GIT_AUTHOR_EMAIL"
```

You could also use `.extra` to override settings, functions and aliases from my
dotfiles repository. It's probably better to fork this repository instead,
though.

## Using the sync script

The `sync.py` script is designed to streamline the management of these dotfiles
by creating symbolic links from the files within the `dots/` directory to the
home directory. This makes it very easy to keep things up to date by just
pulling from `main`.

## Post-Installation

- Configure what wasn't configured during this process (i.e. dock items, MacOS
  defaults, etc.)
- Install desired Python versions using `pyenv`

```bash
pyenv install 3.10
pyenv global 3.10.x
```

- Set up virtual environments using pyenv-virtualenv.

## Contributing

These dotfiles are by no means perfect, or as optimized as they could be. Due to
this, contributions are welcome! Please submit a pull request or open an issue
to discuss any changes or improvements.
