#!/usr/bin/env python

"""
Sublime Text syncronization. Useful for updating changes made to Sublime remotely.
"""

import glob
import os
import shutil

SOURCE_DIR = "~/.dotfiles/sublime"
DESTINATION_DIR = "~/Library/Application\ Support/Sublime\ Text/Packages/User"
IGNORE = [
    ".DS_Store",
    "readme.md",
    "Package Control.sublime-package",
    "sublimetext-4-orange.icns",
    "sync_sublime.py",
]


def force_remove(path):
    if os.path.isdir(path) and not os.path.islink(path):
        shutil.rmtree(path, False)
    else:
        os.unlink(path)


def is_link_to(link, dest):
    is_link = os.path.islink(link)
    is_link = is_link and os.readlink(link).rstrip("/") == dest.rstrip("/")
    return is_link


def main():
    print(f"Starting syncronization at {SOURCE_DIR}...\n")
    os.chdir(os.path.expanduser(SOURCE_DIR))
    for filename in [file for file in glob.glob(".sublime*") if file not in IGNORE]:
        current_file = os.path.join(os.path.expanduser("~"), filename)
        print(current_file)
        source = os.path.join(SOURCE_DIR, filename).replace("~", ".")
        print(source)

        # Check that we aren't overwriting anything
        if os.path.lexists(current_file):
            if is_link_to(current_file, source):
                print(f"Symlink to {source} already exists in {current_file}")
                continue

            response = input(f"Overwrite file '{current_file}'? [y/N] ")
            if not response.lower().startswith("y"):
                continue

            print(f"Creating symlink to {current_file} in home directory")
            # force_remove(current_file)

        # os.symlink(source, current_file)
        print(f"{current_file} => {source}")
    print("\nProcess completed!")


if __name__ == "__main__":
    main()
