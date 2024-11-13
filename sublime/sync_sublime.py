#!/usr/bin/env python

"""
Sublime Text synchronization.
Makes symlinks for all necessary Sublime Text config files:
    ~/.dotfiles/sublime/Preferences.sublime-settings
    =>
    ~/Library/Application Support/Sublime Text/Packages/User/Preferences.sublime-settings
"""

import glob
import os
import shutil

SOURCE_DIR = os.getcwd()
DESTINATION_DIR = os.path.expanduser(
    "~/Library/Application Support/Sublime Text/Packages/User"
)
IGNORE = [
    ".DS_Store",
    "README.md",
    "Package Control.sublime-package",
    "sublimetext-4-orange.icns",
    "sync_sublime.py",
]


def force_remove(path: str):
    """
    Forcefully remove a file or directory.

    Parameters:
        path (str): The path to the file or directory to be removed.
    """
    if os.path.isdir(path) and not os.path.islink(path):
        shutil.rmtree(path, False)
    else:
        os.unlink(path)


def is_link_to(link: str, dest: str) -> bool:
    """
    Check if a symbolic link points to a specific destination.

    Parameters:
        line (str): The path to the symbolic link.
        dest (str): The destination the link should point to.

    Returns:
        bool: True if the link points to a destination; otherwise, False.
    """
    return os.path.islink(link) and os.readlink(link).rstrip("/") == dest.rstrip("/")


def main():
    """
    Main function to synchronize dotfiles from SOURCE_DIR to the destination directory.
    """
    print(f"Starting synchronization at {SOURCE_DIR}...\n")
    os.chdir(os.path.expanduser(SOURCE_DIR))

    for filename in [file for file in glob.glob("*") if file not in IGNORE]:
        original = os.path.join(os.path.expanduser(SOURCE_DIR), filename)
        link = os.path.join(os.path.expanduser(DESTINATION_DIR), filename)

        # Check that we aren't automatically overwriting anything
        if os.path.lexists(link):
            if is_link_to(link, original):
                print(f"Symlink to {filename} already exists!")
                continue

            response = input(f"Overwrite file '{filename}'? [y/N] ")
            if not response.lower().startswith("y"):
                continue

            print(f"Creating symlink to {filename} in Sublime Text directory.")
            force_remove(link)

        os.symlink(original, link)
        print(f"{link} => {original}\n")

    print("\nProcess completed!")


if __name__ == "__main__":
    main()
