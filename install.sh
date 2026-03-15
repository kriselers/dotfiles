#!/usr/bin/env bash

# Legacy compatibility wrapper.
# Prefer `make install` directly.

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v make >/dev/null 2>&1; then
    echo "Error: 'make' is required but was not found in PATH."
    exit 1
fi

if [ "$#" -gt 1 ]; then
    echo "Usage: ./install.sh [home_directory]"
    exit 1
fi

TARGET_HOME="${1:-$HOME}"

echo "[WARNING]: install.sh is deprecated. Please use: make install"
echo "==> Running: make install HOME=${TARGET_HOME}"

cd "$DOTFILES_DIR"
exec make install HOME="$TARGET_HOME"
