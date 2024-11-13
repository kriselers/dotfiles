#!/usr/bin/env python

"""
Dotfiles synchronization. Useful for updating existing dotfiles if everything
else is already installed on the system.

Makes symlinks for all files: ~/Projects/dotfiles/dots/.zshrc => ~/.zshrc
"""

import shutil
from argparse import ArgumentParser
from pathlib import Path


def force_remove(path: Path) -> None:
    """
    Forcefully remove a file or directory.

    Parameters:
        path (Path): The path to the file or directory to be removed.
    """
    if path.is_dir() and not path.is_symlink():
        shutil.rmtree(path, False)
    else:
        path.unlink()


def is_link_to(link: Path, dest: Path) -> bool:
    """
    Check if a symbolic link points to a specific destination.

    Parameters:
        link (Path): The path to the symbolic link.
        dest (Path): The destination the link should point to.

    Return:
        bool: True if the link points to the destination; otherwise, False.
    """
    is_link = link.is_symlink()
    is_link = is_link and link.resolve().as_posix().rstrip(
        "/"
    ) == dest.resolve().as_posix().rstrip("/")
    return is_link


def synchronize_dotfiles(
    source_dir: Path, target_dir: Path, force: bool, verbose: bool
) -> None:
    """
    Main function to synchronize dotfiles from SOURCE_DIR to the home directory.

    Parameters:
        source_dir (Path): The source directory containing dotfiles.
        target_dir (Path): The target directory where dotfiles will be synchronized.
        force (bool): If True, forcefully update all files without prompting.
    """
    for path in source_dir.rglob("*"):
        if path.name == ".DS_Store":
            continue

        if path.is_file():
            target_path = target_dir / path.relative_to(source_dir)

            # Check that we aren't overwriting anything
            if target_path.exists() or target_path.is_symlink():
                if is_link_to(target_path, path):
                    print(
                        f"Symlink to {str(path)!r} already exists in {str(target_path)!r}"
                    )
                    continue

                if not force:
                    response = input(f"Overwrite file {str(target_path)!r}? [y/N] ")
                    if not response.lower().startswith("y"):
                        continue
            else:
                # Copy file to target path if it doesn't exist
                if verbose:
                    print(
                        f"{str(path.name)!r} doesn't exist! Copying to {str(path.parent)!r} before creating symlink."
                    )
                shutil.copy2(path, target_path)

            if verbose:
                print(
                    f"Creating symlink to {str(target_path)!r} in {str(target_dir)!r}"
                )
            force_remove(target_path)

            target_path.symlink_to(path)
            print(f"{str(target_path)!r} => {str(path)!r}")

    print("\nProcess completed successfully")


if __name__ == "__main__":
    parser = ArgumentParser(
        description="Synchronize dotfiles from the ./dots directory to the home directory."
    )
    parser.add_argument(
        "-f",
        "--force",
        action="store_true",
        help="Forcefully update all files without prompting",
    )
    parser.add_argument(
        "-v", "--verbose", action="store_true", help="Print more verbose output"
    )
    args = parser.parse_args()

    SOURCE_DIR = Path.cwd() / "dots"
    TARGET_DIR = Path.home()

    synchronize_dotfiles(SOURCE_DIR, TARGET_DIR, args.force, args.verbose)
