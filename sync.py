#!/usr/bin/env python

"""
Dotfiles synchronization. Useful for updating existing dotfiles if everything
else is already installed on the system.

Makes symlinks for all files: ~/Projects/dotfiles/dots/.zshrc => ~/.zshrc
"""

import logging

from argparse import ArgumentParser
from shutil import rmtree, copy2
from pathlib import Path

logger = logging.getLogger(__name__)


def force_remove(path: Path) -> None:
    """
    Forcefully remove a file or directory.

    Parameters:
        path (Path): The path to the file or directory to be removed.
    """
    if path.is_dir() and not path.is_symlink():
        logger.debug("Removing directory '%s'", path)
        rmtree(path, False)
    else:
        logger.debug("Removing '%s'", path.name)
        path.unlink()


def is_link_to(link: Path, dest: Path) -> bool:
    """
    Check if a symbolic link points to a specific destination.

    Parameters:
        link (Path): The path to the symbolic link.
        dest (Path): The destination the link should point to.

    Returns:
        bool: True if the link points to the destination; otherwise, False.
    """
    is_link = link.is_symlink()
    is_link = is_link and link.resolve().as_posix().rstrip(
        "/"
    ) == dest.resolve().as_posix().rstrip("/")
    return is_link


def synchronize_dotfiles(source_dir: Path, target_dir: Path, force: bool) -> None:
    """
    Main function to synchronize dotfiles from SOURCE_DIR to the home directory.

    Parameters:
        source_dir (Path): The source directory containing dotfiles.
        target_dir (Path): The target directory where dotfiles will be synchronized.
        force (bool): If True, forcefully update all files without prompting.
    """
    for path in source_dir.rglob("*"):
        if path.name == ".DS_Store" or not path.is_file():
            continue

        target_path = target_dir / path.relative_to(source_dir)

        # Check that we aren't overwriting anything
        if target_path.exists() or target_path.is_symlink():
            if is_link_to(target_path, path):
                logger.info(
                    "Symlink to '%s' already exists in '%s'",
                    path.name,
                    target_path.parent,
                )
                continue

            if not force:
                response = input(f"Overwrite file {str(target_path)!r}? [y/N] ")
                if not response.lower().startswith("y"):
                    continue
        else:
            # Check if target directory exists
            if not target_path.parent.exists():
                logger.debug(
                    "Creating directory '%s' before copying file.",
                    target_path.parent,
                )
                target_path.parent.mkdir(parents=True)

            # Copy file to target path if it doesn't exist
            logger.debug(
                "'%s' doesn't exist! Copying to '%s' before creating symlink.",
                path.name,
                target_path.parent,
            )
            copy2(path, target_path)

        logger.debug("Creating symlink to '%s' in '%s'", target_path, target_dir)
        force_remove(target_path)

        target_path.symlink_to(path)
        logger.info("%s => %s", target_path, path)


if __name__ == "__main__":
    logging.basicConfig(format="%(message)s", level=logging.INFO)

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

    if args.verbose:
        logging.getLogger().setLevel(logging.DEBUG)

    SOURCE_DIR = Path.cwd() / "dots"
    TARGET_DIR = Path.home()

    logger.info("Synchronizing dotfiles from '%s' to '%s'", SOURCE_DIR, TARGET_DIR)
    synchronize_dotfiles(SOURCE_DIR, TARGET_DIR, args.force)
    logger.info("\nSynchronization complete.")
