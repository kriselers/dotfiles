# Create Sublime Text directories as they don't exist until Sublime is launched
mkdir -p ~/Library/Application\ Support/Sublime\ Text/Installed\ Packages/Package\
mkdir -p ~/Library/Application\ Support/Sublime\ Text/Packages/User/

# Install Package Control
echo "Installing Package Control..."
curl "https://packagecontrol.io/Package%20Control.sublime-package" > sublime/Package\ Control.sublime-package
cp -r sublime/Package\ Control.sublime-package ~/Library/Application\ Support/Sublime\ Text/Installed\ Packages/Package\ Control.sublime-package
cp -r sublime/Package\ Control.sublime-settings ~/Library/Application\ Support/Sublime\ Text/Packages/User/Package\ Control.sublime-settings

# Install Custom Sublime Text settings
cp -r sublime/Preferences.sublime-settings ~/Library/Application\ Support/Sublime\ Text/Packages/User/Preferences.sublime-settings

# Custom Settings for Theme
cp -r sublime/Material-Theme-Darker.sublime-color-scheme ~/Library/Application\ Support/Sublime\ Text/Packages/User/Material-Theme-Darker.sublime-color-scheme
