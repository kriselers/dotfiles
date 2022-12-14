# .files

These are my dotfiles. Take anything you want but at your own risk.

It mainly targets macOS systems.

# Installation

1. Run these three commands first, assuming you're starting on a sparkling fresh installation of macOS:

```bash
sudo softwareupdate -i -a
xcode-select --install
sudo xcodebuild -license accept
```

The Xcode Command Line Tools include `git` and `make` (not available on stock MacOS).

2. Sign-in to the Mac AppStore and iCloud (and wait until synced)

3. Install [Homebrew](https://brew.sh/). Generally:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

4. Clone this repository into the desired location:

```bash
git clone https://github.com/kriselers/dotfiles.git ~/.dotfiles
```

5. `cd` to the `~/.dotfiles` directory and run `install.sh` supplying your home directory:

```bash
cd .dotfiles
./install.sh <home_directory>
```

# Post-Installation

- `./dock.sh` (set Dock items)
- `./defaults.sh` (set macOS defaults)
- Install Python versions using `pyenv`
```bash
pyenv install 3.10
pyenv global 3.10.x