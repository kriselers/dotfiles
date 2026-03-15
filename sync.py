"""
Dotfiles synchronization. Useful for updating existing dotfiles if everything
else is already installed on the system.

Makes symlinks for all files: e.g., ~/Projects/dotfiles/dots/.zshrc => ~/.zshrc
"""

import logging
from argparse import ArgumentParser, Namespace
from pathlib import Path
from shutil import copy2, rmtree

logger = logging.getLogger(__name__)

IGNORE = [".DS_STORE"]


class SyncArgs(Namespace):
    force: bool = False
    verbose: bool = False
    dry_run: bool = False
    source_dir: Path
    target_dir: Path


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


def synchronize_dotfiles(
    source_dir: Path, target_dir: Path, force: bool, dry_run: bool
) -> None:
    """
    Main function to synchronize dotfiles from `source_dir` to `target_dir`.

    Parameters:
        source_dir (Path): The source directory containing dotfiles.
        target_dir (Path): The target directory where dotfiles will be synchronized.
        force (bool): If True, forcefully update all files without prompting.
        dry_run (bool): If True, log planned changes without modifying files.
    """
    for path in source_dir.rglob("*"):
        if path.name in IGNORE or not path.is_file():
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
            if not target_path.parent.exists():
                logger.debug(
                    "Creating directory '%s' before copying file.",
                    target_path.parent,
                )
                if not dry_run:
                    target_path.parent.mkdir(parents=True)

            logger.debug(
                "'%s' doesn't exist! Copying to '%s' before creating symlink.",
                path.name,
                target_path.parent,
            )
            if not dry_run:
                _ = copy2(path, target_path)

        logger.debug("Creating symlink to '%s' in '%s'", target_path, target_dir)

        if dry_run:
            logger.info("[dry-run] %s => %s", target_path, path)
            continue

        force_remove(target_path)
        target_path.symlink_to(path)
        logger.info("%s => %s", target_path, path)


if __name__ == "__main__":
    logging.basicConfig(format="%(message)s", level=logging.INFO)

    parser = ArgumentParser(
        description="Synchronize dotfiles from a source directory to a target directory."
    )
    _ = parser.add_argument(
        "-f",
        "--force",
        action="store_true",
        help="Forcefully update all files without prompting",
    )
    _ = parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Show what would change without touching files",
    )
    _ = parser.add_argument(
        "-v", "--verbose", action="store_true", help="Print more verbose output"
    )
    _ = parser.add_argument(
        "--source-dir",
        type=Path,
        default=Path.cwd() / "dots",
        help="Directory containing the dotfiles to link (default: ./dots)",
    )
    _ = parser.add_argument(
        "--target-dir",
        type=Path,
        default=Path.home(),
        help="Directory where symlinks are created (default: $HOME",
    )
    args = parser.parse_args(namespace=SyncArgs())

    if args.verbose:
        logging.getLogger().setLevel(logging.DEBUG)

    source_dir = args.source_dir.expanduser().resolve()
    target_dir = args.target_dir.expanduser().resolve()

    logger.info("Synchronizing dotfiles from '%s' to '%s'", source_dir, target_dir)
    synchronize_dotfiles(source_dir, target_dir, args.force, args.dry_run)
    logger.info("\nSynchronization complete.")
