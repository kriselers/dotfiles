# Settings for the applications that I have installed on my Mac

- PyCharm settings are saved in the cloud
- VSCode settings are saved in the cloud
- iTerm2 contains the color settings I use along with prefered settings. Additionally, running these commands in iTerm can be helpful.

```bash
# Specify the preferences directory
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "~/.dotfiles/System/iTerm/settings"

# Tell iTerm2 to use the custom preferences in the directory
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
```
