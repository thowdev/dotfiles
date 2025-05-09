################################################################################
# Targets
#
#
.PHONY: clean reset simulate stow unstow
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

################################################################################
# Includes
#   - Include after setting variables so that they can be used in other *.mak files
#
#
include makefiles/help.mak
include makefiles/install.mak
include makefiles/vim.mak
include makefiles/debug.mak

################################################################################
# Cleanup
#
#
clean: clean_vim unstow

reset: stow clean_all_vim unstow

unstow:
	stow -v --dir=$(ROOT_DIR) --dotfiles -t $(HOME) -D .

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
