SHELL = /bin/bash
DOTFILES_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
OS := $(shell bin/is-supported bin/is-macos macos linux)
PATH := $(DOTFILES_DIR)/bin:$(PATH)
NVM_DIR := $(HOME)/.nvm
export XDG_CONFIG_HOME = $(HOME)/.config
export STOW_DIR = $(DOTFILES_DIR)
export ACCEPT_EULA=Y

.PHONY: all macos linux core-macos core-linux stow-macos stow-linux sudo packages link unlink brew bash git npm ruby brew-packages cask-apps vscode-extensions test help

all: $(OS)

macos: sudo core-macos packages link

linux: core-linux link

core-macos: brew bash git npm ruby

core-linux:
	apt-get update
	apt-get upgrade -y
	apt-get dist-upgrade -f

stow-macos: brew
	is-executable stow || brew install stow

stow-linux: core-linux
	is-executable stow || apt-get -y install stow

sudo:
ifndef GITHUB_ACTION
	sudo -v
	while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
endif

packages: brew-packages cask-apps vscode-extensions

link: stow-$(OS)
	@echo "Creating backup of existing dotfiles..."
	@for FILE in $$(\ls -A runcom); do \
		if [ -f $(HOME)/$$FILE -a ! -h $(HOME)/$$FILE ]; then \
			mv -v $(HOME)/$$FILE{,.bak}; \
		fi \
	done
	@mkdir -p $(XDG_CONFIG_HOME)
	@echo "Linking dotfiles..."
	@stow -t $(HOME) runcom
	@stow -t $(XDG_CONFIG_HOME) config
	@echo "Dotfiles linked successfully!"

unlink: stow-$(OS)
	@echo "Unlinking dotfiles..."
	@stow --delete -t $(HOME) runcom
	@stow --delete -t $(XDG_CONFIG_HOME) config
	@for FILE in $$(\ls -A runcom); do \
		if [ -f $(HOME)/$$FILE.bak ]; then \
			mv -v $(HOME)/$$FILE.bak $(HOME)/$${FILE%%.bak}; \
		fi \
	done
	@echo "Dotfiles unlinked successfully!"

brew:
	is-executable brew || curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash

bash: BASH=/usr/local/bin/bash
bash: SHELLS=/private/etc/shells
bash: brew
ifdef GITHUB_ACTION
	if ! grep -q $(BASH) $(SHELLS); then \
		brew install bash bash-completion@2 pcre && \
		sudo append $(BASH) $(SHELLS) && \
		sudo chsh -s $(BASH); \
	fi
else
	if ! grep -q $(BASH) $(SHELLS); then \
		brew install bash bash-completion@2 pcre && \
		sudo append $(BASH) $(SHELLS) && \
		chsh -s $(BASH); \
	fi
endif

git: brew
	brew install git git-extras

npm:
	if ! [ -d $(NVM_DIR)/.git ]; then git clone https://github.com/creationix/nvm.git $(NVM_DIR); fi
	. $(NVM_DIR)/nvm.sh; nvm install --lts

ruby: brew
	brew install ruby

brew-packages: brew
	brew bundle --file=$(DOTFILES_DIR)/install/Brewfile

cask-apps: brew
	brew bundle --file=$(DOTFILES_DIR)/install/Caskfile || true
	defaults write org.hammerspoon.Hammerspoon MJConfigFile "~/.config/hammerspoon/init.lua"

vscode-extensions:
	@echo "Installing VS Code extensions..."
	@if [ -f "$(DOTFILES_DIR)/install/Codefile" ]; then \
		while read -r extension; do \
			if [[ ! "$$extension" =~ ^#.*$ ]]; then \
				code --install-extension "$$extension" || true; \
			fi \
		done < "$(DOTFILES_DIR)/install/Codefile"; \
	fi
	@echo "VS Code extensions installed successfully!"

test:
	. $(NVM_DIR)/nvm.sh; bats test

# Help
help:
	@echo "Available commands:"
	@echo "  make all        - Install everything for your OS"
	@echo "  make macos      - Install everything for macOS"
	@echo "  make linux      - Install everything for Linux"
	@echo "  make link       - Link dotfiles to home directory"
	@echo "  make unlink     - Unlink dotfiles from home directory"
	@echo "  make packages   - Install all packages"
	@echo "  make brew       - Install Homebrew"
	@echo "  make git        - Install Git and Git extras"
	@echo "  make npm        - Install NVM and latest LTS Node.js"
	@echo "  make ruby       - Install Ruby"
	@echo "  make test       - Run tests"
	@echo "  make help       - Show this help message"
