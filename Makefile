################################################################################
# Targets
#
#
.PHONY: clean install reset simulate stow unstow
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
#   - Include after setting variables so that they can be used in other *.mak
#     files
#   - Be careful about include order, e.g.
#       - "debug" must be at the end to display all variables from all *.mak
#         files
#       - "git" must be after "python" because of the j2 rendering which is done
#         by python scripts
#
#
# Install stow
include makefiles/stow.mak

# Manage vim config
include makefiles/vim.mak

# Manage python
include makefiles/python.mak

# Help output
include makefiles/help.mak
# Debug output
include makefiles/debug.mak

################################################################################
# Cleanup
#
#
clean: clean-python clean-vim unstow

reset: clean-python clean-all-vim unstow

unstow:
	@echo "################################################################################"
	stow -v --dir=$(ROOT_DIR) --dotfiles -t $(HOME) -D .

###############################################################################
# Simulate stow command from "stow"-target
#
#
simulate:
	@echo "################################################################################"
	stow -v -n --dir=$(ROOT_DIR) --dotfiles -t $(HOME) -R .

###############################################################################
# Run stow for the current directory
#
#
install stow:
	@echo "################################################################################"
	stow -v --dir=$(ROOT_DIR) --dotfiles -t $(HOME) -R .
