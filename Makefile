################################################################################
# Targets
#
#
.PHONY: clean debug debug-main install install-stow reset simulate stow unstow help
.DEFAULT_GOAL := help

################################################################################
# Variables
#
#
ROOT_DIR		:= $(shell cd -P $(dir $(lastword $(MAKEFILE_LIST))) && pwd)
DOT_CONFIG_DIR	:= $(ROOT_DIR)/dot-config
DOT_THOWDEV_DIR	:= $(ROOT_DIR)/dot-thowdev
TODAY=$(shell date +%Y%m%d_%H%M%S)
XDG_CACHE_HOME	?= $(HOME)/.cache
XDG_CONFIG_HOME ?= $(HOME)/.config
XDG_DATA_HOME	?= $(HOME)/.local/share
XDG_SEARCH_DIRS	:= $(XDG_CACHE_HOME) $(XDG_CONFIG_HOME) $(XDG_DATA_HOME)

debug-main:
	@echo "################################################################################"
	@echo "# Makefile variables:"
	@echo "# ======================================="
	@echo "#   ROOT_DIR:		$(ROOT_DIR)"
	@echo "#   DOT_CONFIG_DIR:	$(DOT_CONFIG_DIR)"
	@echo "#   DOT_THOWDEV_DIR:	$(DOT_THOWDEV_DIR)"
	@echo "#   TODAY:		$(TODAY)"
	@echo "#   HOME:		$(HOME)"
	@echo "#   XDG_CACHE_HOME:	$(XDG_CACHE_HOME)"
	@echo "#   XDG_CONFIG_HOME:	$(XDG_CONFIG_HOME)"
	@echo "#   XDG_DATA_HOME:	$(XDG_DATA_HOME)"

debug: debug-main debug-vim

################################################################################
# Includes
#   - Include after setting variables so that they can be used in other *.mak files
#
include vimconfig.mak

################################################################################
# Detect OS
#
#
UNAME := $(shell uname)
ifeq ($(UNAME), Darwin)
	OS := macos
else
	OS := $(shell cat /etc/os-release | grep ^ID= | cut -d= -f2 | tr -d '"')
endif

################################################################################
# Cleanup
#
#
clean: clean_vim unstow

reset: stow clean_all_vim unstow

unstow:
	stow -v --dir=$(ROOT_DIR) --dotfiles -t $(HOME) -D .


################################################################################
# Help
#
#
help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  help			Show this help message"
	@echo "  clean			Unstow all files from ${HOME}"
	@echo "   				+ save vim's config, data and cache"
	@echo "  install		Install GNU stow using the system package manager"
	@echo "  install-stow		see \"install\"-target"
	@echo "  reset			Unstow all files from ${HOME}"
	@echo "  				+ delete all of vim's config, data and cache"
	@echo "  stow			Stow all files to ${HOME}"
	@echo "  simulate		Simulate stow command from "stow"-target"
	@echo "  uninstall		see \"clean\"-target"
	@echo ""
	@echo "Detected OS: $(OS)"

################################################################################
# Install GNU stow with OS specific install manager
#
#
install install-stow:
ifeq ($(OS), macos)
	brew install stow
else ifeq ($(OS), fedora)
	sudo dnf install -y stow
else ifeq ($(OS), rhel)
	sudo yum install -y epel-release
	sudo yum install -y stow
else ifeq ($(OS), sles)
	sudo zypper install -y stow
else ifeq ($(OS), ubuntu)
	sudo apt update
	sudo apt install -y stow
else
	@echo "Unsupported operating system"
	@exit 1
endif

###############################################################################
# Simulate stow command from "stow"-target
#
#
simulate:
	stow -v -n --dir=$(ROOT_DIR) --dotfiles -t $(HOME) -R .

###############################################################################
# Run stow for the current directory
#
#
stow:
	stow -v --dir=$(ROOT_DIR) --dotfiles -t $(HOME) -R .
