################################################################################
# Targets
#
#
.PHONY: clean
.DEFAULT_GOAL := help

################################################################################
# Variables
#
#
ROOT_DIR        := $(shell cd -P $(dir $(lastword $(MAKEFILE_LIST))) && pwd)

TODAY=$(shell date +%Y%m%d_%H%M%S)
HOST_NAME=$(shell hostname)

HLB_DIR="${HOME}/.local/bin"

XDG_CACHE_HOME  ?= $(HOME)/.cache
XDG_CONFIG_HOME ?= $(HOME)/.config
XDG_DATA_HOME   ?= $(HOME)/.local/share
XDG_SEARCH_DIRS := $(XDG_CACHE_HOME) $(XDG_CONFIG_HOME) $(XDG_DATA_HOME) $(HLB_DIR)

################################################################################
# Includes
#   - Include after setting variables so that they can be used in other *.mak
#     files
#   - Be careful about include order, e.g.
#       - "debug" must be at the end to display all variables from all *.mak
#         files
#
#
# Help output
include makefiles/help.mak
# Debug output
include makefiles/debug.mak

################################################################################
# Targets
#
#
#-------------------------------------------------------------------------------
bootstrap:
	@echo "################################################################################"
	@echo "# Bootstrap chezmoi on \"$(HOST_NAME)\" using ${ROOT_DIR}/bootstrap.sh ..."
	@echo "#"
	@${ROOT_DIR}/bootstrap.sh

#-------------------------------------------------------------------------------
clean: clean-chezmoi

#-------------------------------------------------------------------------------
clean-chezmoi:
	@echo "#==============================================================================="
	@echo "# Cleanup ..."

	@echo "# Delete $(XDG_CACHE_HOME)/chezmoi ..."
	@rm -rf $(XDG_CACHE_HOME)/chezmoi

	@echo "# Delete $(XDG_CONFIG_HOME)/chezmoi ..."
	@rm -rf $(XDG_CONFIG_HOME)/chezmoi

	@echo "# Delete $(XDG_DATA_HOME)/chezmoi ..."
	@rm -rf $(XDG_DATA_HOME)/chezmoi

	@echo "# Delete $(HLB_DIR)/chezmoi ..."
	@rm -rf $(HLB_DIR)/chezmoi
