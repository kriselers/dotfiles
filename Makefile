# ─── Variables ───────────────────────────────────────────────────────────────
DOTFILES_DIR  := $(CURDIR)
BREW_SCRIPT   := $(DOTFILES_DIR)/homebrew/brew.sh
SUBLIME_DIR   := $(DOTFILES_DIR)/sublime
ITERM_PLIST   := $(DOTFILES_DIR)/iterm2/com.googlecode.iterm2.plist
SYNC_DIR      := $(DOTFILES_DIR)/dots
SYNC_SCRIPT   := $(DOTFILES_DIR)/sync.py
DRY_RUN       ?= 0

# ─── Phony targets ────────────────────────────────────────────────────────────
.DEFAULT_GOAL := install
.PHONY: help install symlink brew iterm2 sublime clean

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  install   Run all setup steps (default)"
	@echo "  symlink   Create symlinks for files in dots/ (set DRY_RUN=1 to preview)"
	@echo "  brew      Run Homebrew bundle script"
	@echo "  iterm2    Configure iTerm2 preferences"
	@echo "  sublime   Configure Sublime Text"
	@echo "  clean     Remove symlinks created in home directory"
	@echo ""
	@echo "Note: install.sh is deprecated; use \`make install\`."

# default target
install: symlink brew iterm2 sublime
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
	@if [ -x "$(BREW_SCRIPT)" ]; then \
		cd $(DOTFILES_DIR)/homebrew && ./brew.sh; \
	else \
		echo "⚠️ homebrew/brew.sh not found or not executable, skipping"; \
	fi

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
	@if [ -d "$(SUBLIME_DIR)" ]; then \
		cd $(SUBLIME_DIR) && ./sublime.sh; \
	else \
		echo "⚠️ sublime/ directory not found, skipping"; \
	fi

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
