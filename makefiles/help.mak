################################################################################
# Targets
#
#
.PHONY: help

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
help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  help			Show this help message (default)"
	@echo "  clean			Unstow all files from ${HOME}"
	@echo "   				+ save vim's config, data and cache"
	@echo "  install		Install GNU stow using the system package manager"
	@echo "  install-stow		see \"install\"-target"
	@echo "  reset			Unstow all files from ${HOME}"
	@echo "  				+ delete all of vim's config, data and cache"
	@echo "  stow			Stow all files to ${HOME}"
	@echo "  simulate		Simulate stow command from "stow"-target"
	@echo ""
	@echo "Detected OS: $(OS)"

