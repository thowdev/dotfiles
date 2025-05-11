################################################################################
# Targets
#
#
.PHONY: help help-main

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
# Help
#
#
help-main:
	@echo "################################################################################"
	@echo "# Usage: make [target]"
	@echo "# Detected OS: $(OS)"
	@echo "# ========================================"
	@echo "# Main targets: "
	@printf "#  %-15s %s\n" "help:" 		"Show this help message"
	@printf "#  %-15s %s\n" "clean:" 		"Unstow all files from ${HOME}"
	@printf "#  %-15s %s\n" "      " 		"  + save vim's config, data and cache"
	@printf "#  %-15s %s\n" "reset"			"Unstow all files from ${HOME}"
	@printf "#  %-15s %s\n" "     " 		"  + delete all of vim's config, data and cache"
	@printf "#  %-15s %s\n" "simulate"		"Simulate stow command from \"stow\"-target"
	@printf "#  %-15s %s\n" "stow"			"Stow all files to ${HOME}"

help: help-main help-python help-stow
