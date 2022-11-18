#!/usr/bin/env python

"""
Sublime Text syncronization. Useful for updating changes made to Sublime config files in this directory.
"""

import glob
import os
import shutil
import sys

SOURCE_DIR = "~/.dotfiles/sublime"
DESTINATION_DIR = "~/Library/Application Support/Sublime Text/Packages/User"
IGNORE = [
    ".DS_Store",
    "readme.md",
    "Package Control.sublime-package",
    "sublimetext-4-orange.icns",
    "sync_sublime.py",
]


def main():
    print(f"Starting syncronization at {SOURCE_DIR}...\n")
    os.chdir(os.path.expanduser(SOURCE_DIR))
    for filename in [file for file in glob.glob("*") if file not in IGNORE]:
        source = os.path.join(os.path.expanduser(SOURCE_DIR), filename)
        destination = os.path.join(os.path.expanduser(DESTINATION_DIR), filename)

        # Check that we aren't automatically overwriting anything
        if os.path.exists(destination):
            response = input(f"Overwrite current '{filename}'? [y/N] ")

            if not response.lower().startswith("y"):
                continue

        try:
            shutil.copy(source, destination)
        except IOError:
            print(f"Error copying {filename}. Destination not writable.")
            sys.exit()


if __name__ == "__main__":
    main()
