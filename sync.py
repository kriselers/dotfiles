#!/usr/bin/env python

"""
Dotfiles syncronization. Useful for updating existing dotfiles if everything
else is already installed on the system.
Makes symlinks for all files: ~/.dotfiles/.zshrc => ~/.zshrc
"""

import glob
import os
import shutil

SOURCE_DIR = os.getcwd() + "/dots"
IGNORE = [".DS_Store"]


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
    for filename in [file for file in glob.glob(".*") if file not in IGNORE]:
        dotfile = os.path.join(os.path.expanduser("~"), filename)
        source = os.path.join(SOURCE_DIR, filename).replace("~", ".")

        # Check that we aren't overwriting anything
        if os.path.lexists(dotfile):
            if is_link_to(dotfile, source):
                print(f"Symlink to {source} already exists in {dotfile}")
                continue

            response = input(f"Overwrite file '{dotfile}'? [y/N] ")
            if not response.lower().startswith("y"):
                continue

            print(f"Creating symlink to {dotfile} in home directory")
            force_remove(dotfile)

        os.symlink(source, dotfile)
        print(f"{dotfile} => {source}")
    print("\nProcess completed!")


if __name__ == "__main__":
    main()
