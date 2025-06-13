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
	@printf "#  %-15s %s\n" "bootstrap:" 	"Run ${PWD}/boostrap.sh"
	@printf "#  %-15s %s\n" "clean:" 		"Delete:"
	@printf "#  %-15s %s\n" "      " 		"  - ${XDG_CACHE_HOME}/chezmoi"
	@printf "#  %-15s %s\n" "      " 		"  - ${XDG_CONFIG_HOME}/chezmoi"
	@printf "#  %-15s %s\n" "      " 		"  - ${XDG_DATA_HOME}/chezmoi"
	@printf "#  %-15s %s\n" "      " 		"  - ${HLB_DIR}/chezmoi"

help: help-main
