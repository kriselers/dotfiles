# ─── Variables ───────────────────────────────────────────────────────────────
DOTFILES_DIR  := $(CURDIR)
ITERM_PLIST   := $(DOTFILES_DIR)/iterm2/com.googlecode.iterm2.plist
SYNC_DIR      := $(DOTFILES_DIR)/dots
SYNC_SCRIPT   := $(DOTFILES_DIR)/sync.py
SUBLIME_USER_DIR := $(HOME)/Library/Application Support/Sublime Text/Packages/User
SUBLIME_INSTALLED_DIR := $(HOME)/Library/Application Support/Sublime Text/Installed Packages
DRY_RUN       ?= 0

# ─── Phony targets ────────────────────────────────────────────────────────────
.DEFAULT_GOAL := install
.PHONY: help doctor install symlink brew iterm2 sublime clean

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  doctor    Validate required local tooling (make, python3, brew)"
	@echo "  install   Run all setup steps (default)"
	@echo "  symlink   Create symlinks for files in dots/ (set DRY_RUN=1 to preview)"
	@echo "  brew      Run Homebrew bundle script"
	@echo "  iterm2    Configure iTerm2 preferences"
	@echo "  sublime   Configure Sublime Text"
	@echo "  clean     Remove symlinks created in home directory"

# prerequisite checks
doctor:
	@echo "🩺 Checking local toolchain"
	@command -v make >/dev/null 2>&1 || (echo "❌ make not found in PATH" && exit 1)
	@command -v python3 >/dev/null 2>&1 || (echo "❌ python3 not found in PATH" && exit 1)
	@if ! command -v brew >/dev/null 2>&1; then \
		echo "⚠️ brew not found in PATH (brew target may fail)"; \
	else \
		echo "✅ brew found"; \
	fi
	@echo "✅ Toolchain looks good"

# default target
install: doctor symlink brew iterm2 sublime
	@echo "🎉 Dotfiles setup complete!"

# Create symlinks for all dotfiles
symlink:
	@echo "🔗 Creating symlinks from $(SYNC_DIR) to $(HOME)"
	@if [ "$(DRY_RUN)" = "1" ]; then \
		python3 $(SYNC_SCRIPT) --source-dir "$(SYNC_DIR)" --target-dir "$(HOME)" --force --dry-run; \
	else \
		python3 $(SYNC_SCRIPT) --source-dir "$(SYNC_DIR)" --target-dir "$(HOME)" --force; \
	fi

# Run Homebrew bundle
brew:
	@echo "🍺 Running Homebrew bundle"
	@if ! command -v brew >/dev/null 2>&1; then \
		echo "⚠️ brew not found in PATH, skipping"; \
		exit 0; \
	fi
	@brew update
	@brew upgrade
	@brew bundle --file="$(DOTFILES_DIR)/homebrew/Brewfile"

# Configure iTerm2
iterm2:
	@echo "💻 Configuring iTerm2 preferences"
	@curl -fsSL https://iterm2.com/shell_integration/zsh -o ~/.iterm2_shell_integration.zsh
	@mkdir -p ~/Library/Preferences
	@cp -f $(ITERM_PLIST) ~/Library/Preferences/
	@defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
	@defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$(DOTFILES_DIR)/iterm2/"

# Configure Sublime Text
sublime:
	@echo "📝 Configuring Sublime Text"
	@if [ ! -d "$(SUBLIME_DIR)" ]; then \
		echo "⚠️ sublime/ directory not found, skipping"; \
		exit 0; \
	fi
	@mkdir -p "$(SUBLIME_INSTALLED_DIR)"
	@mkdir -p "$(SUBLIME_USER_DIR)"
	@echo "Installing Package Control..."
	@curl -fsSL "https://packagecontrol.io/Package%20Control.sublime-package" \
		-o "$(SUBLIME_INSTALLED_DIR)/Package Control.sublime-package"
	@cp -f "$(SUBLIME_DIR)/Package Control.sublime-settings" \
		"$(SUBLIME_DIR)/Package Control.sublime-settings"
	@cp -f "$(SUBLIME_DIR)/Preferences.sublime-settings" \
		"$(SUBLIME_DIR)/Preferences.sublime-settings"
	@cp -f "$(SUBLIME_DIR)/Material-Theme-Darker.sublime-color-scheme" \
		"$(SUBLIME_DIR)/Material-Theme-Darker.sublime-color-scheme"

# Remove symlinks created by this Makefile
clean:
	@echo "🧹 Removing symlinks created in home directory"
	@find $(SYNC_DIR) -type f ! -name ".DS_Store" | while read -r file; do \
		rel=$${file#$(SYNC_DIR)/}; \
		dlink=$(HOME)/$${rel}; \
		if [ -L "$$dlink" ] && [ "$$(readlink "$$dlink")" = "$$file" ]; then \
			rm "$$dlink" && echo "Removed $$dlink"; \
		fi; \
	done
